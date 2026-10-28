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
    SET @cOldContent = '018';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '019';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'From_The_Shadows';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Summon the mastiff on accept and take it back on turn-in, stashing any class pet, and let the player see the stealthed Lurkers';

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

        -- From The Shadows: the mastiff, its pet stats and targets.


        -- ---- from From_The_Shadows_Mastiff ----
        -- `From the Shadows` (14204) gave the player a collar and left them to it. The
        -- dog is not a convenience: the six Bloodfang Lurkers it asks for wear 5916
        -- `Shadowstalker Stealth` (SPELL_AURA_MOD_STEALTH), so without help they
        -- cannot be seen at all.
        --
        -- Blizzard left every piece in place and nothing joining them. The collar
        -- 48707 casts 67807 `Summon Gilnean Mastiff` on use - which is why the dog
        -- could be called by hand - and 68234 `Forcecast Mastiff` exists to do it on
        -- accept, while the quest's RewSpellCast 43511 `Force Dismiss Plaguehound`
        -- takes it away again. Both are SPELL_EFFECT_FORCE_CAST, which this core
        -- stubs, so neither end ever fired.
        --
        -- `npc_lorna_crowley` joins them up on her quest hooks, which is also the only
        -- place a hunter's or warlock's pet can be set aside for the duration and
        -- handed back afterwards.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_lorna_crowley';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_lorna_crowley', 35378, 0);

        -- ---- from Mastiff_Pet_Levelstats ----
        -- The mastiff came out with 1 hit point. Its template is fine - 86 health at
        -- level 4 - but SummonProperties 2161 makes it a pet rather than a plain
        -- creature, so `Pet::InitStatsForLevel` takes over and reads `pet_levelstats`
        -- keyed on creature_entry. There was no row for 35631, and the miss is not
        -- silent about it:
        --     SUMMON_PET levelstats missing in DB! 'Weakifying' pet and giving it mana
        --     to make it obvious
        -- which is exactly what the server logged on both summons.
        --
        -- The generic set on creature_entry 1 already holds the right numbers - its
        -- level 4 row is 86 health, the same figure as the mastiff's own template - so
        -- the rows are copied from it rather than invented. The full 1 to 85 range is
        -- mirrored, not just the levels a Gilneas character will see: a summoned pet
        -- takes its level from its owner, so the miss would come back for anyone
        -- running the quest above the starting range. Mana is forced to 0, matching
        -- the mastiff's template; a dog has no use for the point the generic rows
        -- carry.
        DELETE FROM `pet_levelstats` WHERE `creature_entry` = 35631;
        INSERT INTO `pet_levelstats` (`creature_entry`, `level`, `hp`, `mana`, `armor`, `str`, `agi`, `sta`, `inte`, `spi`)
        SELECT 35631, `level`, `hp`, 0, `armor`, `str`, `agi`, `sta`, `inte`, `spi`
        FROM `pet_levelstats` WHERE `creature_entry` = 1;

        -- ---- from Attack_Lurker_Script_Target ----
        -- Rel22_07_034 gave the player 81426 `Detect Stealth` on accept so the six
        -- Bloodfang Lurkers could be seen. That was wrong on both counts.
        --
        -- Retail puts no aura on the player for this quest, and it does not need one.
        -- The Lurkers wear 5916 `Shadowstalker Stealth`, whose EffectBasePoints is 1,
        -- and `Unit::IsVisibleForOrDetect` works that out as
        --     visibleDistance = 10.5 - GetTotalAuraModifier(MOD_STEALTH) / 100
        -- which is 10.49 yards, level difference nil at the tier this quest is done
        -- at. They simply surface as the player walks up to them, in front of them.
        -- 81426 is MOD_STEALTH_DETECT with amount 300, adding 300/5 = 60 yards, so it
        -- did not reveal something otherwise hidden - it revealed the whole alley at
        -- once, and left a buff icon retail never shows.
        --
        -- What the dog is for is 67805 `Attack Lurker`, already on the mastiff through
        -- `creature_template_spells`. It is a single SPELL_EFFECT_JUMP at range index
        -- 4 - 30 yards, matching the ability's documented range - aimed at implicit
        -- target 38, TARGET_SCRIPT, which resolves through this table. The search it
        -- ends up in is `NearestCreatureEntryWithLiveStateInObjectRangeCheck`, which
        -- tests entry, alive and range and nothing else: no visibility test, so it
        -- finds a stealthed Lurker where a normal target search could not. That is the
        -- dog sniffing them out, done the way the data intends.
        --
        -- The row that was here pointed at gameobject 176210 `Command Tent`, which is
        -- not spawned anywhere in this database, so the cast could never resolve a
        -- target. It is not specific to this spell: 1642 rows of `spell_script_target`
        -- carry that same entry, against 13 for the next most common, so it is bulk
        -- filler in the shipped data rather than anything deliberate. Only 67805 is
        -- corrected here; the rest are left alone.
        DELETE FROM `spell_script_target` WHERE `entry` = 67805;
        INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`, `inverseEffectMask`) VALUES
        (67805, 1, 35463, 0);

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
