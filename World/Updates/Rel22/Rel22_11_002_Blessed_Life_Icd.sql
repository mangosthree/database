-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '22';
    SET @cOldStructure = '11';
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '002';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Blessed_Life_Icd';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Define serverside spell 32733 and give Blessed Life its 8 second internal cooldown, silencing an EffectTriggerSpell error on every hit taken';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @oldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @oldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- Give Blessed Life an internal cooldown.


        -- Blessed Life (talent 31828 / 31829) applies a proc-trigger aura that fires
        -- 89023 whenever the paladin takes direct damage. 89023 effect 0 grants the
        -- Holy Power; effect 1 triggers 32733, which Blizzard ships serverside only,
        -- so it is absent from Spell.dbc and `Spell::EffectTriggerSpell` logged
        --     EffectTriggerSpell of spell 89023: triggering unknown spell id 32733
        -- on every single hit taken - 11,954 lines from one level 85 paladin bot in
        -- roughly two hours.
        --
        -- 32733 is the Holy Power talent marker: while it is on the paladin the talent
        -- may not proc again. Its duration is the talent's own internal cooldown, and
        -- the client states that value - 31828's description reads "This effect cannot
        -- occur more than once every $s2 seconds", where $s2 is effect 1's base points,
        -- a dummy aura carrying 8. SpellDuration.dbc index 31 is exactly 8000 ms.
        --
        -- `ObjectMgr::LoadSpellTemplate` inserts these rows straight into sSpellStore,
        -- so defining it here is all that is needed for the trigger to resolve. It is
        -- marked passive so `SpellAuraHolder::IsNeedVisibleSlot` gives it no aura slot
        -- and it is never sent to a client that has no Spell.dbc row for it; a passive
        -- holder still expires normally because it only becomes permanent when its
        -- DurationIndex is 0.
        DELETE FROM `spell_template` WHERE `id` = 32733;
        INSERT INTO `spell_template`
            (`id`, `attr`, `attr_ex`, `attr_ex2`, `attr_ex3`, `proc_flags`, `proc_chance`,
             `duration_index`, `effect0`, `effect0_implicit_target_a`, `effect0_implicit_target_b`,
             `effect0_radius_idx`, `effect0_apply_aura_name`, `effect0_misc_value`,
             `effect0_misc_value_b`, `effect0_trigger_spell`, `comments`)
        VALUES
            (32733, 64, 0, 0, 0, 0, 101, 31, 6, 1, 0, 0, 4, 0, 0, 0,
             'Holy Power talent marker (DND) - Blessed Life internal cooldown');

        -- Defining the marker stops the error, but nothing in the core reads it, so on
        -- its own the talent would still proc on every hit. MaNGOS implements a proc
        -- internal cooldown natively through `spell_proc_event`.`Cooldown` (seconds),
        -- which `Unit::ProcDamageAndSpellFor` applies to the triggered spell for
        -- players. A row of zeroes elsewhere is safe: a zero `procFlags` falls back to
        -- the flags in Spell.dbc rather than replacing them.
        --
        -- Only rank 1 is listed. `SpellRankHelper::FillHigherRanks` copies the first
        -- rank's entry onto every higher rank that has none, so a row for 31829 would
        -- be redundant - and the loader reports a redundant rank as an errorDb line on
        -- every boot, which is the sort of noise this migration exists to remove.
        DELETE FROM `spell_proc_event` WHERE `entry` IN (31828, 31829);
        INSERT INTO `spell_proc_event`
            (`entry`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMaskA0`, `SpellFamilyMaskA1`,
             `SpellFamilyMaskA2`, `SpellFamilyMaskB0`, `SpellFamilyMaskB1`, `SpellFamilyMaskB2`,
             `SpellFamilyMaskC0`, `SpellFamilyMaskC1`, `SpellFamilyMaskC2`, `procFlags`, `procEx`,
             `ppmRate`, `CustomChance`, `Cooldown`)
        VALUES
            (31828, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8);

        -- -- PLACE UPDATE SQL ABOVE -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- If we get here ok, commit the changes
        IF bRollback = TRUE THEN
            ROLLBACK;
            SHOW ERRORS;
            SELECT '* UPDATE FAILED *' AS `===== Status =====`,@cCurResult AS `===== DB is on Version: =====`;
        ELSE
            COMMIT;
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            -- UPDATE THE DB VERSION
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
            SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@newResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @newResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@oldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @oldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                END IF;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;
