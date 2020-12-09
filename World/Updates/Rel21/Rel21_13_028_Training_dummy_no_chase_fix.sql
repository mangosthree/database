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
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '13'; 
    SET @cOldContent = '027';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '13';
    SET @cNewContent = '028';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Training dummy no chase fix';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Training dummy no chase fix';

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

    
UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` IN (44171,44389,44548,44614,44703,44794,44820,44848,44937,46647,48304);

DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (44171,44389,44548,44614,44703,44794,44820,44848,44937,46647,48304);
INSERT INTO `creature_ai_scripts` (`id`,`creature_id`,`event_type`,`event_inverse_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action1_type`,`action1_param1`,`action1_param2`,`action1_param3`,`action2_type`,`action2_param1`,`action2_param2`,`action2_param3`,`action3_type`,`action3_param1`,`action3_param2`,`action3_param3`,`comment`) VALUES
(4417101,44171,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4417102,44171,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4438901,44389,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4438902,44389,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4454801,44548,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4454802,44548,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4461401,44614,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4461402,44614,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4470301,44703,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4470302,44703,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4479401,44794,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4479402,44794,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4482001,44820,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4482002,44820,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4484801,44848,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4484802,44848,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4493701,44937,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4493702,44937,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4664701,46647,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4664702,46647,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4830401,48304,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4830402,48304,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy');

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


