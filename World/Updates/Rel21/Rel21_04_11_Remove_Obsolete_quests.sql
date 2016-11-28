-- ----------------------------------------
-- Added to prevent timeout's while loading
-- ----------------------------------------
SET GLOBAL net_read_timeout=30;
SET GLOBAL net_write_timeout=60;
SET GLOBAL net_buffer_length=1000000; 
SET GLOBAL max_allowed_packet=1000000000;
SET GLOBAL connect_timeout=10000000;

-- --------------------------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update (v1.3)
-- --------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT structure FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurContent := (SELECT content FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '04'; 
    SET @cOldContent = '10';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '04';
    SET @cNewContent = '11';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Remove_Obsolete_quests';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Remove_Obsolete_quests';

    -- Evaluate all settings
    SET @cCurResult := (SELECT description FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cOldResult := (SELECT description FROM db_version WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;

        -- UPDATE THE DB VERSION
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
        SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

-- Obsolete quests
DELETE FROM `quest_template` WHERE `entry` IN (8427, 8428, 8429, 8434, 8438, 8439, 8440, 8441, 7875, 8384, 8386, 8387, 8388, 8391, 8393, 8394, 8398, 8399, 8400, 8401, 8403, 8404, 8405, 8291, 8297, 8367, 8368, 8372, 8369, 8383, 8392, 8407, 8431, 8432, 8426, 10535, 10532, 8433, 8442, 8375, 8395, 8156, 7873, 8397, 8437, 7872, 8430, 8160, 8371, 8435, 8389, 7876, 8299, 8162, 8161, 8123, 8155, 8154, 8390, 8374, 8436, 7788, 8080, 8408, 8443, 8370, 8406, 8402, 7789, 7874, 8294, 7871, 8385, 13475, 8290, 8295, 13478, 13476, 13477, 9583);
DELETE FROM `quest_poi_points` WHERE `questId` IN (8427, 8428, 8429, 8434, 8438, 8439, 8440, 8441, 7875, 8384, 8386, 8387, 8388, 8391, 8393, 8394, 8398, 8399, 8400, 8401, 8403, 8404, 8405, 8291, 8297, 8367, 8368, 8372, 8369, 8383, 8392, 8407, 8431, 8432, 8426, 10535, 10532, 8433, 8442, 8375, 8395, 8156, 7873, 8397, 8437, 7872, 8430, 8160, 8371, 8435, 8389, 7876, 8299, 8162, 8161, 8123, 8155, 8154, 8390, 8374, 8436, 7788, 8080, 8408, 8443, 8370, 8406, 8402, 7789, 7874, 8294, 7871, 8385, 13475, 8290, 8295, 13478, 13476, 13477, 9583);
DELETE FROM `quest_poi` WHERE `questId` IN (8427, 8428, 8429, 8434, 8438, 8439, 8440, 8441, 7875,8384, 8386, 8387, 8388, 8391, 8393, 8394, 8398, 8399, 8400, 8401, 8403, 8404, 8405, 8291, 8297, 8367, 8368, 8372, 8369, 8383, 8392, 8407, 8431, 8432, 8426, 10535, 10532, 8433, 8442, 8375, 8395, 8156, 7873, 8397, 8437, 7872, 8430, 8160, 8371, 8435, 8389, 7876, 8299, 8162, 8161, 8123, 8155, 8154, 8390, 8374, 8436, 7788, 8080, 8408, 8443, 8370, 8406, 8402, 7789, 7874, 8294, 7871, 8385, 13475, 8290, 8295, 13478, 13476, 13477, 9583);

DELETE FROM `dbdocsprogressquests` WHERE `QuestID` IN (7788, 7789, 7874, 7875, 7876, 8080, 8123, 8155, 8294, 8368, 8370, 8399, 8400, 8401, 8402, 8426, 8428, 8429, 8430, 8435, 8436, 8439);
DELETE FROM `locales_quest` WHERE `entry` IN (8427, 8428, 8429, 8434, 8438, 8439, 8440, 8441, 7875, 8384, 8386, 8387, 8388, 8391, 8393, 8394, 8398, 8399, 8400, 8401, 8403, 8404, 8405, 8291, 8297, 8367, 8368, 8372, 8369, 8383, 8392, 8407, 8431, 8432, 8426, 10535, 10532, 8433, 8442, 8375, 8395, 8156, 7873, 8397, 8437, 7872, 8430, 8160, 8371, 8435, 8389, 7876, 8299, 8162, 8161, 8123, 8155, 8154, 8390, 8374, 8436, 7788, 8080, 8408, 8443, 8370, 8406, 8402, 7789, 7874, 8294, 7871, 8385, 13475, 8290, 8295, 13478, 13476, 13477, 9583);

DELETE FROM `creature_questrelation` WHERE `quest` IN (8123, 8160, 8161, 8162, 8299);
DELETE FROM `creature_involvedrelation` WHERE `quest` IN (5148, 25363, 25364, 25366, 25367, 25369, 3503, 8250, 3421, 8151, 8153, 8231, 8232, 8254, 8255, 8256, 27984, 8080, 8154, 8156, 8297, 8123, 8160, 8161, 8162, 8299, 8155); 
    

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
		    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurStructure := (SELECT `STRUCTURE` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurContent := (SELECT `Content` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
		ELSE
		    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurStructure := (SELECT `STRUCTURE` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurContent := (SELECT `Content` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
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

