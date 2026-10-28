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
    SET @cOldStructure = '12';
    SET @cOldContent = '003';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '004';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'City_Phase_Windows';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Phase-timeline audit P2+P3: restore the three missing city phase windows (post-14159/14293/14221) and the post-24681 finale phase; spawn-verified';

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

        -- The city finale phase windows.
        --
        -- Two of the four windows were provably unwinnable - DBC AreaGroup locks
        -- 69812 and 68770 onto Kalimdor - so they are not carried.


        -- ---- from City_Finale_Phases ----
        -- Phase-timeline audit, P2 + P3 (report: GILNEAS_PHASE_TIMELINE.md).
        -- P2: three city phase windows retail applies that our spell_area never
        -- did - their populations (144 spawns mask 4, 516 mask 8, 24 mask 1024)
        -- have sat invisible. Regression-verify with a fresh character.
        DELETE FROM `spell_area` WHERE `spell` IN (69812, 68770, 67789) AND `area` IN (4714, 4755);
        INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_start_active`, `quest_end`, `condition_id`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
        (69812, 4714, 14159, 0, 14293, 0, 0, 0, 2, 1),
        (69812, 4755, 14159, 0, 14293, 0, 0, 0, 2, 1),
        (68770, 4714, 14293, 0, 14221, 0, 0, 0, 2, 1),
        (68770, 4755, 14293, 0, 14221, 0, 0, 0, 2, 1),
        (67789, 4714, 14221, 0, 14222, 0, 0, 0, 2, 1),
        (67789, 4755, 14221, 0, 14222, 0, 0, 0, 2, 1);

        -- P3: the finale phase after 24681; gate passed (508 creatures + 252
        -- gameobjects on map 654 carry mask 4194304).
        DELETE FROM `spell_area` WHERE `spell` = 74093 AND `area` IN (4714, 4755);
        INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_start_active`, `quest_end`, `condition_id`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
        (74093, 4714, 24681, 0, 0, 0, 0, 0, 2, 1),
        (74093, 4755, 24681, 0, 0, 0, 0, 0, 2, 1);

        -- ---- from Remove_Unwinnable_Death_Spell_Area ----
        -- 69812 "Death?" carries a client-DBC AreaGroup lock (2103 -> area 1224,
        -- map 1 Kalimdor); the spell_area autocast fired on rewarding 14159 fails
        -- SPELL_FAILED_INCORRECT_AREA by construction on map 654, flashing red
        -- "You are in the wrong zone." at the player. The aura has never applied
        -- once in this core; the rows are inert except for the error flash. The
        -- bite scene continues to ride 72870''s spell_area row + DBS_ON_SPELL.
        DELETE FROM `spell_area` WHERE `spell`=69812 AND `area` IN (4714,4755);

        -- ---- from Remove_Unwinnable_68770_Spell_Area ----
        -- 68770 "Death to Agogridon Complete" carries a client-DBC AreaGroup
        -- lock (creq 4897 -> AreaGroup 1 -> area 2198, map 1 Kalimdor). Its
        -- spell_area autocast opens on rewarding 14293 and fails
        -- SPELL_FAILED_INCORRECT_AREA by construction on map 654 - and since
        -- the aura never applies, EVERY re-evaluation (each area crossing,
        -- each quest event) retries and flashes red. Live ZONETRACE caught it
        -- three times in seventeen seconds. Same disease as 69812 (mig 162);
        -- no other reference to the spell exists in the world DB.
        DELETE FROM `spell_area` WHERE `spell`=68770 AND `area` IN (4714,4755);

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
