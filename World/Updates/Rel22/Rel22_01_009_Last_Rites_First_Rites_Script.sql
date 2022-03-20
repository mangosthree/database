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
    SET @cOldStructure = '01'; 
    SET @cOldContent = '008';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '01';
    SET @cNewContent = '009';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Last Rites First Rites Script';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Last Rites First Rites Script';

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

	-- Add a few extra spawn locations.
	SET @maxGOguid := (SELECT max(`guid`) FROM `gameobject`);
	DELETE FROM `gameobject` where `id` = 202138;
	INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
	(175038,202138,1,1,1,-2906.09,-250.825,59.7349,5.58025,0,0,0.344276,-0.938868,120,255,1),
	(@maxGOguid+1,202138,1,1,1,-2907.25,-258.362,59.7768,2.83534,0,0,0.988299,0.152529,120,255,1),
	(@maxGOguid+2,202138,1,1,1,-2905.04,-257.382,59.7344,1.73494,0,0,0.762695,0.646758,120,255,1),
	(@maxGOguid+3,202138,1,1,1,-2906.27,-257.509,59.735,0.91634,0,0,0.442308,0.896863,120,255,1);

	-- Add a few extra spawn locations, correct original spawn.
	SET @maxcreatureguid := (SELECT max(`guid`) FROM `creature`);
	DELETE FROM `creature` where `id` = 38438;
	INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES
	(260133,38438,1,1,1,11686,0,-2904.75,-254.352,59.8172,0,10,0,0,42,0,0,0),
	(@maxcreatureguid+1 ,38438,1,1,1,11686,0,-2908.51,-254.653,59.7197,0.00811386,10,0,0,42,0,0,0),
	(@maxcreatureguid+2 ,38438,1,1,1,11686,0,-2904.63,-251.373,59.7333,4.7912,10,0,0,42,0,0,0),
	(@maxcreatureguid+3 ,38438,1,1,1,11686,0,-2900.55,-254.208,59.7336,3.00049,10,0,0,42,0,0,0),
	(@maxcreatureguid+4 ,38438,1,1,1,11686,0,-2904.54,-257.812,59.734,1.56714,10,0,0,42,0,0,0),
	(@maxcreatureguid+5 ,38438,1,1,1,11686,0,-2908.77,-250.873,59.7178,5.55675,10,0,0,42,0,0,0),
	(@maxcreatureguid+6 ,38438,1,1,1,11686,0,-2900.61,-250.584,59.7352,3.93098,10,0,0,42,0,0,0),
	(@maxcreatureguid+7 ,38438,1,1,1,11686,0,-2901.27,-257.317,59.7337,2.25808,10,0,0,42,0,0,0),
	(@maxcreatureguid+8 ,38438,1,1,1,11686,0,-2907.55,-258.655,60.0311,0.993593,10,0,0,42,0,0,0);

	-- Spell targeting.
	DELETE FROM `spell_script_target` WHERE `entry` = 71898;
	INSERT INTO `spell_script_target` (`entry`,`type`,`targetEntry`) VALUES (71898,0,202138);
	INSERT INTO `spell_script_target` (`entry`,`type`,`targetEntry`) VALUES (71898,1,38438);

	-- Set kill credit trigger.
	UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` = 38438;
	DELETE FROM `creature_ai_scripts` where `creature_id` = 38438;
	INSERT INTO `creature_ai_scripts` (`id`,`creature_id`,`event_type`,`event_inverse_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action1_type`,`action1_param1`,`action1_param2`,`action1_param3`,`action2_type`,`action2_param1`,`action2_param2`,`action2_param3`,`action3_type`,`action3_param1`,`action3_param2`,`action3_param3`,`comment`) VALUES
	(3843801,38438,8,0,100,1,71898,-1,0,0,33,38438,6,0,0,0,0,0,0,0,0,0,'q.24861 kill credit.');


	-- Chief Hawkwind db_Scripts and text Strings.
	SET @maxDbScriptStrings := (SELECT max(`entry`) FROM `db_script_string`);
	INSERT INTO `db_script_string` (`entry`, `content_default`,`content_loc1`,`content_loc2`,`content_loc3`,`content_loc4`,`content_loc5`,`content_loc6`,`content_loc7`,`content_loc8`,`sound`,`type`,`language`,`emote`,`comment`) VALUES
	(@maxDbScriptStrings+1,'Earth Mother, into your arms we give one of our own. She is Unaya Hawkwind, my mother, and Greatmother to us all; the wisest of our tribe.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,1,'Chief Hawkwind'),
	(@maxDbScriptStrings+2,'May her spirit fly to you swiftly; may the winds carry her gently, and the grass whisper her name.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,1,'Chief Hawkwind'),
	(@maxDbScriptStrings+3,'Watch over her as she has watched over us; let her look down on us with joy, through the eternal gaze of An\'she and Mu\'sha, until we too join her in death.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,1,'Chief Hawkwind'),
	(@maxDbScriptStrings+4,'For we are all born of you, and shall all return to you.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,0,0,1,'Chief Hawkwind');

	DELETE FROM `db_scripts` where `id` = 24861;
	INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES
	(0,24861,0,0,0,0,2981,20,4,@maxDbScriptStrings+1,0,0,0,0,0,0,0,'Q.24861 Start - Chief Hawkwind Say - 1'),
	(0,24861,5,0,0,0,2981,20,4,@maxDbScriptStrings+2,0,0,0,0,0,0,0,'Q.24861 Start - Chief Hawkwind Say - 2'),
	(0,24861,10,0,0,0,2981,20,4,@maxDbScriptStrings+3,0,0,0,0,0,0,0,'Q.24861 Start - Chief Hawkwind Say - 3'),
	(0,24861,15,0,0,0,2981,20,4,@maxDbScriptStrings+4,0,0,0,0,0,0,0,'Q.24861 Start - Chief Hawkwind Say - 4');
	
	-- Update quest template for scrip support.
	UPDATE `quest_template` SET `StartScript` = 24861 WHERE `entry` = 24861;    

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


