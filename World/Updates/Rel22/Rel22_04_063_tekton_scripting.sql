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
    SET @cOldStructure = '04'; 
    SET @cOldContent = '062';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '063';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'tekton_scripting';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'tekton_scripting';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

-- Remove any pre-existing strings/scripts related to Tekton and Agee Tyler.
DELETE FROM `db_script_string` WHERE `content_default` IN ('HEY! What the heck, guy?', 'Of all the slimy, inconsiderate, bullheaded...');
DELETE FROM `db_scripts` WHERE `id` = 48873;

-- Remove GUIDs in creature table between 400,050 and 400,073.
DELETE FROM `creature` WHERE `guid` IN (400050, 400051, 400052, 400053, 400054, 400055, 400056, 400057, 400058, 400059, 400060, 400061, 400062, 400063, 400064, 400065, 400066, 400067, 400068, 400069, 400070, 400071, 400072, 400073);

-- Add in necessary strings for the Tekton/Agee Tyler event.
    SET @db_script_string_entry := (SELECT MAX(`entry`) FROM `db_script_string`);
INSERT INTO `db_script_string` (`entry`, `content_default`, `content_loc1`, `content_loc2`, `content_loc3`, `content_loc4`, `content_loc5`, `content_loc6`, `content_loc7`, `content_loc8`, `content_loc9`, `content_loc10`, `content_loc11`, `sound`, `type`, `language`, `emote`, `comment`) VALUES(@db_script_string_entry+1, 'HEY! What the heck, guy?', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 7, 0, 'Agee Tyler on Tekton Death - 1');
INSERT INTO `db_script_string` (`entry`, `content_default`, `content_loc1`, `content_loc2`, `content_loc3`, `content_loc4`, `content_loc5`, `content_loc6`, `content_loc7`, `content_loc8`, `content_loc9`, `content_loc10`, `content_loc11`, `sound`, `type`, `language`, `emote`, `comment`) VALUES(@db_script_string_entry+2, 'Of all the slimy, inconsiderate, bullheaded...', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 7, 0, 'Agee Tyler on Tekton Death - 2');

-- Add in scripting for the event - refer to the comments for the line by line description.
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 0, 15, 91121, 0, 0, 0, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 'Tekton cast Tektonic Boom');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 0, 28, 0, 0, 48875, 100, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 'Agee Tyler STATE_STAND');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 0, 0, 0, 0, 48875, 100, 0, @db_script_string_entry+1, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 'Agee Tyler yell on Tekton Death');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 0, 3, 0, 0, 48875, 100, 0, 0, 0, 0, 0, -8260.11, -221.442, 267.439, 2.38291, 'Agee Tyler move');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 10, 0, 0, 0, 48875, 100, 0, @db_script_string_entry+2, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 'Agee Tyler say on Tekton Death');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 10, 3, 0, 0, 48875, 100, 0, 0, 0, 0, 0, -8249.95, -228.792, 268.261, 5.92287, 'Agee Tyler move back');
INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES(4, 48873, 16, 28, 1, 0, 48875, 100, 0, 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0, 'Agee Tyler STATE_SIT');

-- Spawn Sheep in the area.
INSERT INTO `creature` (`guid`,`id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `DeathState`, `MovementType`) VALUES
    (400050,47194, 0, 1, 1, 0, 0, -8262.87, -207.283, 268.565, 0.802734, 25, 5.0, 0, 14, 0, 0, 1), 
    (400051,47194, 0, 1, 1, 0, 0, -8262.25, -207.882, 268.458, 0.802734, 25, 5.0, 0, 14, 0, 0, 1),
    (400052,47194, 0, 1, 1, 0, 0, -8257.38, -202.847, 268.399, 0.802734, 25, 5.0, 0, 14, 0, 0, 1),
    (400053,47194, 0, 1, 1, 0, 0, -8250.71, -198.915, 267.639, 0.269484, 25, 5.0, 0, 14, 0, 0, 1),
    (400054,47194, 0, 1, 1, 0, 0, -8244.16, -200.273, 267.398, 4.49054, 25, 5.0, 0, 14, 0, 0, 1),
    (400055,47194, 0, 1, 1, 0, 0, -8245.7, -207.101, 267.398, 4.49054, 25, 5.0, 0, 14, 0, 0, 1),
    (400056,47194, 0, 1, 1, 0, 0, -8242.69, -212.581, 267.396, 1.34611, 25, 5.0, 0, 14, 0, 0, 1),
    (400057,47194, 0, 1, 1, 0, 0, -8241.13, -205.757, 267.425, 1.34611, 25, 5.0, 0, 14, 0, 0, 1),
    (400058,47194, 0, 1, 1, 0, 0, -8238.52, -200.239, 267.683, 1.34611, 25, 5.0, 0, 14, 0, 0, 1),
    (400059,47194, 0, 1, 1, 0, 0, -8238.84, -200.166, 267.658, 1.34611, 25, 5.0, 0, 14, 0, 0, 1),
    (400060,47194, 0, 1, 1, 0, 0, -8235.62, -194.072, 267.802, 1.34611, 25, 5.0, 0, 14, 0, 0, 1),
    (400061,47194, 0, 1, 1, 0, 0, -8234.79, -187.178, 267.501, 1.74773, 25, 5.0, 0, 14, 0, 0, 1),
    (400062,47194, 0, 1, 1, 0, 0, -8236.93, -180.948, 267.379, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400063,47194, 0, 1, 1, 0, 0, -8238.62, -177.882, 267.365, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400064,47194, 0, 1, 1, 0, 0, -8240.31, -174.815, 267.334, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400065,47194, 0, 1, 1, 0, 0, -8243.86, -173.675, 267.396, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400066,47194, 0, 1, 1, 0, 0, -8244.84, -177.036, 267.397, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400067,47194, 0, 1, 1, 0, 0, -8252.63, -178.074, 267.857, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400068,47194, 0, 1, 1, 0, 0, -8259.35, -176.122, 268.512, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400069,47194, 0, 1, 1, 0, 0, -8260.96, -176.077, 268.633, 3.64448, 25, 5.0, 0, 14, 0, 0, 1),
    (400070,47194, 0, 1, 1, 0, 0, -8261.59, -183.509, 268.984, 5.32186, 25, 5.0, 0, 14, 0, 0, 1),
    (400071,47194, 0, 1, 1, 0, 0, -8262.29, -187.424, 269.106, 5.32186, 25, 5.0, 0, 14, 0, 0, 1),
    (400072,47194, 0, 1, 1, 0, 0, -8268.03, -191.431, 269.288, 5.32186, 25, 5.0, 0, 14, 0, 0, 1),
    (400073,47194, 0, 1, 1, 0, 0, -8271.32, -195.999, 269.268, 5.91248, 25, 5.0, 0, 14, 0, 0, 1);

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
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
            SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@cOldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
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


