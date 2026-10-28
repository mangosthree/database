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
    SET @cOldContent = '009';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '010';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Spell_Practice_Proc';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Let the Spell Practice proc fire for the class quest abilities, which deal no damage and span several damage classes';

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

        -- Wire the Spell Practice proc for the class quests.


        -- The starting zone "practice your new ability" quests all credit NPC 44175
        -- `Spell Practice Credit`, which has no spawn. The credit comes from proc aura
        -- 83470, worn by the practice targets - the Gilneas Bloodfang Worgen (35118),
        -- the Tiki Target and every Training Dummy. 83470 has EffectTriggerSpell = 0,
        -- so the core resolves it as a custom case and awards the credit directly.
        --
        -- Two things stop that proc ever reaching the handler, both fixed here.
        --
        -- 1. The abilities deal no damage. `Aura::CanProcFrom` requires
        --    `active` (damage or healing present) whenever the aura has no
        --    `spell_proc_event` row:
        --        if (((procEx & (PROC_EX_NORMAL_HIT | PROC_EX_CRITICAL_HIT)) && active)
        --    Charge (100) applies a root and generates rage but deals 0 damage, so the
        --    proc was discarded before the handler ran. PROC_EX_EX_TRIGGER_ALWAYS
        --    (0x10000) is checked one level above that test and skips it outright.
        --
        -- 2. 83470's own ProcTypeMask is only PROC_FLAG_TAKEN_NEGATIVE_SPELL_HIT
        --    (0x20000). MaNGOS picks the victim proc flag from the spell's damage
        --    class (`SpellTargetList.cpp`), and the seven abilities do not agree:
        --        Charge 100        DmgClass NONE,  negative -> 0x20000
        --        Immolate 348      DmgClass MAGIC, negative -> 0x20000
        --        Arcane Missiles 5143 DmgClass NONE, negative -> 0x20000
        --        Eviscerate 2098   DmgClass MELEE           -> 0x00020 TAKEN_MELEE_SPELL_HIT
        --        Steady Shot 56641 DmgClass RANGED          -> 0x00200 TAKEN_RANGED_SPELL_HIT
        --        Flash Heal 2061   DmgClass MAGIC, positive -> 0x08000 TAKEN_POSITIVE_SPELL
        --        Rejuvenation 774  DmgClass MAGIC, positive -> 0x08000 TAKEN_POSITIVE_SPELL
        --    Only three of the seven matched. `spell_proc_event.procFlags` replaces the
        --    DBC mask outright (`EventProcFlag = spellProcEvent->procFlags`), so the
        --    union 0x28220 = 164384 covers all of them.
        --
        -- Cooldown stays 0: Steady Shot and Flash Heal need two credits, and an
        -- internal cooldown would swallow the second.
        DELETE FROM `spell_proc_event` WHERE `entry` = 83470;
        INSERT INTO `spell_proc_event`
            (`entry`, `SchoolMask`, `SpellFamilyName`,
             `SpellFamilyMaskA0`, `SpellFamilyMaskA1`, `SpellFamilyMaskA2`,
             `SpellFamilyMaskB0`, `SpellFamilyMaskB1`, `SpellFamilyMaskB2`,
             `SpellFamilyMaskC0`, `SpellFamilyMaskC1`, `SpellFamilyMaskC2`,
             `procFlags`, `procEx`, `ppmRate`, `CustomChance`, `Cooldown`) VALUES
        (83470, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 164384, 65536, 0, 0, 0);

        -- Priest and Druid practise on a `Wounded Guard` (47091) rather than the
        -- worgen, and that creature carried no auras at all - so 83470 was never on
        -- the one target their heals can legally land on. It already has an addon row
        -- (bytes1 = 8 for the wounded pose), so only `auras` needs filling in.
        UPDATE `creature_template_addon` SET `auras` = '83470' WHERE `entry` = 47091;

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
