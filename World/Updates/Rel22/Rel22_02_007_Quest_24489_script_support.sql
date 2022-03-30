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
    SET @cOldStructure = '02'; 
    SET @cOldContent = '006';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '02';
    SET @cNewContent = '007';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Quest 24489 script support';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Quest 24489 script support';

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

	-- Set EventAI
	UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` = 37108;
	UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` = 37173;
	UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` = 37174;

	SET @ai_texts := (SELECT min(`entry`) FROM `creature_ai_texts`);
	-- Soothsayer Shi'kala ai text
	INSERT INTO `creature_ai_texts` (`entry`, `content_default`, `comment`) VALUES
	(@ai_texts-1, 'What we gon\' do now, you ask? We wait.', 'Soothsayer Shi\'kala - Say 1'),
	(@ai_texts-2, 'Grik\'nir says he gon\' talk to the elemental, get it to fight on our side.', 'Soothsayer Shi\'kala - Say 2'),
	(@ai_texts-3, 'Soon enough we take over dis valley. Soon enough.', 'Soothsayer Shi\'kala - Say 3');

	-- Soothsayer Rikkari ai text
	INSERT INTO `creature_ai_texts` (`entry`, `content_default`, `comment`) VALUES
	(@ai_texts-4, 'Da spirits be angry with us.', 'Soothsayer Rikkari - Say 1'),
	(@ai_texts-5, 'I don\' know why the spirits be rejectin\' us so.', 'Soothsayer Rikkari - Say 2'),
	(@ai_texts-6, 'Don\' worry, child. Grik\'nir gonna help us get through this.', 'Soothsayer Rikkari - Say 3');

	-- Soothsayer Mirim'koa ai text
	INSERT INTO `creature_ai_texts` (`entry`, `content_default`, `comment`) VALUES
	(@ai_texts-7, 'Our land be a land of ice an\' snow.', 'Soothsayer Mirim\'koa - Say 1'),
	(@ai_texts-8, 'But beneath the earth, child, there always be fire.', 'Soothsayer Mirim\'koa - Say 2'),
	(@ai_texts-9, 'De spirit come from deep down to talk with Grik\'nir.', 'Soothsayer Mirim\'koa - Say 3');

	-- Soothsayer Shi'kala script.
	DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 37108;
	INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`,`event_flags`, `event_param1`,  `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`,`comment`) VALUES
	(3710801,37108,10,1,1,10,15000,15000,1,@ai_texts-1,0,'Soothsayer Shi\'kala - Say 1'),
	(3710802,37108,10,1,1,10,15003,15003,1,@ai_texts-2,0,'Soothsayer Shi\'kala - Say 2'),
	(3710803,37108,10,1,1,10,15006,15006,1,@ai_texts-3,0,'Soothsayer Shi\'kala - Say 3'),
	(3710804,37108,10,1,1,10,15007,15007,33,37109,6,'Soothsayer Shi\'kala - Quest 24489 credit');

	-- Soothsayer Rikkari script.
	DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 37173;
	INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`,`event_flags`, `event_param1`,  `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`,`comment`) VALUES
	(3717301,37173,10,1,1,10,15000,15000,1,@ai_texts-4,0,'Soothsayer Rikkari - Say 1'),
	(3717302,37173,10,1,1,10,15003,15003,1,@ai_texts-5,0,'Soothsayer Rikkari - Say 2'),
	(3717303,37173,10,1,1,10,15006,15006,1,@ai_texts-6,0,'Soothsayer Rikkari - Say 3'),
	(3717304,37173,10,1,1,10,15007,15007,33,37110,6,'Soothsayer Rikkari - Quest 24489 credit');

	-- Soothsayer Mirim'koa script.
	DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 37174;
	INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`,`event_flags`, `event_param1`,  `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`,`comment`) VALUES
	(3717401,37174,10,1,1,10,15000,15000,1,@ai_texts-7,0,'Soothsayer Mirim\'koa - Say 1'),
	(3717402,37174,10,1,1,10,15003,15003,1,@ai_texts-8,0,'Soothsayer Mirim\'koa - Say 2'),
	(3717403,37174,10,1,1,10,15006,15006,1,@ai_texts-9,0,'Soothsayer Mirim\'koa - Say 3'),
	(3717404,37174,10,1,1,10,15007,15007,33,37111,6,'Soothsayer Mirim\'koa - Quest 24489 credit');    

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


