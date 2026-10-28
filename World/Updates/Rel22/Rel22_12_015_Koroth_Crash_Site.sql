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
    SET @cOldContent = '014';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '015';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Koroth_Crash_Site';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Koroth the Hillbreaker (37808) stood 65 yd uphill of where the capture stations him - the marching Forsaken column (paths pass 9 yd from the retail';

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

        -- Koroth and the crash site theatre, on the march line.


        -- ---- from Koroth_At_The_Choke ----
        -- The capture opens this theatre at the 24472 turn-in: Koroth holds
        -- (-2183.8, 1807.4) at the choke, the Forsaken column marches into him
        -- (soldier swings x38 on Koroth, an 18-19 exchange with the catapult,
        -- Asther joining, Cleave and Hillbreaker AoE from Koroth). Our Koroth
        -- spawned 65 yd uphill; the column''s waypoints - which already pass
        -- nine yards from the retail spot - could never reach him, and factions
        -- 959/960 are explicit mutual enemies, so placement was the only gap.
        UPDATE `creature` SET `position_x`=-2183.8, `position_y`=1807.36, `position_z`=12.59, `orientation`=0.29 WHERE `guid`=221965;

        -- ---- from Koroth_Staged_Brawl ----
        -- The crash-site theatre cannot self-ignite from data: the Forsaken
        -- column carries UNIT_FLAG_OOC_NOT_ATTACKABLE (Koroth cannot open on
        -- them) and no-aggro-on-sight (they cannot open on him). The capture
        -- shows the very same flags with the column ALREADY combat-flagged at
        -- first sighting - retail staged the fight server-side. The new
        -- npc_koroth_crash_site does the staging: drags marchers into the
        -- scrum, Cleave / Hillbreaker AoE / Demoralizing Shout at capture
        -- cadence.
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (0,'npc_koroth_crash_site',37808,0);

        -- ---- from Crash_Site_Marcher_Theatre ----
        -- The column answers back and nobody falls: npc_crash_site_marcher
        -- gives 37805/37806/37807 a counter-attacking AI with the sparring
        -- floor (NPC blows land at zero both ways, players stay real), and the
        -- march never opens a fight on its own - the ettin does the pulling.
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES
        (0,'npc_crash_site_marcher',37805,0),
        (0,'npc_crash_site_marcher',37806,0),
        (0,'npc_crash_site_marcher',37807,0);

        -- ---- from Koroth_On_The_March_Line ----
        -- Tester's call: the ettin stands where the column actually is. The
        -- catapult's path ends at (-2151, 1814) and the soldier paths run right
        -- through (-2156.9, 1812.3); the old spot sat 33 yd past them. He now
        -- plants directly on the march line, facing up the road at the oncoming
        -- column.
        UPDATE `creature` SET `position_x`=-2156.0, `position_y`=1812.5, `position_z`=17.2, `orientation`=0.52 WHERE `guid`=221965;

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
