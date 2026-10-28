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
    SET @cOldContent = '036';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '037';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Duskhaven_Flood_Terrain';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Duskhaven destruction terrain - swap in GilneasPhase1 (map 655) once Invasion (14321) is rewarded; capture shows 655 active through these chapters';

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

        -- The Duskhaven flood terrain arc and its condition tree.


        -- ---- from Duskhaven_Terrain_Swap ----
        -- The Duskhaven destruction chapters render a DIFFERENT TERRAIN on retail:
        -- the 18019 capture carries `Active Terrain swap: 655` (Map.dbc 655 =
        -- GilneasPhase1, the collapsed Duskhaven) from the Invasion chapter onward.
        -- Our server never sent any swap there. From Invasion (14321) rewarded on,
        -- the client now renders map 655's ground over base Gilneas.
        DELETE FROM `conditions` WHERE `condition_entry` = 57907;
        INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
        (57907, 8, 14321, 0, 'Invasion (14321) has been rewarded');

        DELETE FROM `phase_definitions` WHERE `zoneId` = 4714 AND `entry` = 2;
        INSERT INTO `phase_definitions` (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
        (4714, 2, 0, 0, 655, 0, 57907, 'Gilneas: collapsed Duskhaven terrain once the invasion has struck');

        -- ---- from Terrain_Swap_After_LotP ----
        -- The 655 terrain swap fired too early. Retail runs the beach-assault
        -- chapter on its own spawn set inside the swapped terrain; OUR world keeps
        -- Thyala, the catapults and the whole assault on the BASE beach - which
        -- map 655 sinks into the sea. A mid-chapter player was left mid-air over
        -- water. The collapsed terrain now arrives only when Leader of the Pack
        -- (14386) is rewarded, together with the phase the destroyed-town spawns
        -- already use.
        UPDATE `conditions` SET `value1` = 14386,
            `comments` = 'Leader of the Pack (14386) has been rewarded'
        WHERE `condition_entry` = 57907;

        UPDATE `phase_definitions` SET `comment` = 'Gilneas: collapsed Duskhaven terrain once Leader of the Pack is rewarded'
        WHERE `zoneId` = 4714 AND `entry` = 2;

        -- ---- from Flooded_Gilneas_Terrain ----
        -- The Alas, Gilneas! cinematic films the world as loaded - and the capture
        -- swaps the terrain FOUR SECONDS before triggering it: map 655 out, map
        -- 656 in (GilneasPhase2, the flooded city). Add the third terrain stage:
        -- 655 runs from Leader of the Pack until Alas, Gilneas! is rewarded; 656
        -- takes over from there.
        DELETE FROM `conditions` WHERE `condition_entry` IN (57908, 57909, 57910);
        INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
        (57908, 8, 14467, 0, 'Alas, Gilneas! (14467) has been rewarded'),
        (57909, -3, 57908, 0, 'NOT: Alas, Gilneas! not yet rewarded'),
        (57910, -1, 57907, 57909, 'Leader of the Pack done AND Alas Gilneas not yet');

        UPDATE `phase_definitions` SET `condition_id` = 57910,
            `comment` = 'Gilneas: collapsed Duskhaven terrain from Leader of the Pack until Alas, Gilneas!'
        WHERE `zoneId` = 4714 AND `entry` = 2;

        DELETE FROM `phase_definitions` WHERE `zoneId` = 4714 AND `entry` = 3;
        INSERT INTO `phase_definitions` (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES
        (4714, 3, 0, 0, 656, 0, 57908, 'Gilneas: flooded city terrain once the king has shown you Alas, Gilneas!');

        -- ---- from Flood_At_Observatory ----
        -- Phase-timeline audit, P1. The capture places the 655 -> 656 flood swap
        -- at THE KING'S OBSERVATORY (14466) completion, four seconds before the
        -- Alas, Gilneas! cinematic - not at 14467 as first read. Under the 14467
        -- gate a fresh character could still film the dry city. One condition
        -- moves the boundary; the NOT/AND wrappers (57909/57910) follow along.
        UPDATE `conditions` SET `value1` = 14466,
            `comments` = 'The Kings Observatory (14466) has been rewarded'
        WHERE `condition_entry` = 57908;

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
