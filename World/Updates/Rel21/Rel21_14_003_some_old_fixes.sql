-- --------------------------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update (v1.4)
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
    SET @cOldStructure = '14'; 
    SET @cOldContent = '002';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '14'; -- If The Update contains any 'ALTER DATABASE' statements, increment this and set cNewContent to 001
    SET @cNewContent = '003';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Some Old fixes';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Some Old Fixes';

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


-- cata zone portals (alliance)
UPDATE `gameobject_template` SET `data0` = '85040' , `data5` = '0' WHERE `entry` = '207691'; -- teleport to vashj'ir

-- Human start zone - Stormwind Infantry attack blackrock battle worgs
INSERT INTO `db_scripts` (`script_type`,`id`,`delay`,`command`,`datalong`,`datalong2`,`buddy_entry`,`search_radius`,`data_flags`,`dataint`,`dataint2`,`dataint3`,`dataint4`,`x`,`y`,`z`,`o`,`comments`) 
VALUES (3,49869,0,26,1,0,49871,8,0,0,0,0,0,0,0,0,0,'Stormwind Infantry - Looking for Blackrock Battle Worg to Attack');

DELETE FROM creature_movement WHERE id IN (177935,177936,177937,177938,177939,177940,177941,177942,177943,177944) AND POINT=1;
DELETE FROM creature_movement WHERE id IN (177961,177962,177963,177964,177965) AND POINT=1;

INSERT INTO creature_movement VALUES 
(177935,1,-8821.14,-143.156,81.0599,500,49869,0,0,0,0,0,0,0,0,1.16937,0,0),
(177936,1,-8962.33,-233.414,76.6618,500,49869,0,0,0,0,0,0,0,0,-2.18532,0,0),
(177937,1,-8983.45,-148.417,81.5943,500,49869,0,0,0,0,0,0,0,0,3.76991,0,0),
(177938,1,-8857.78,-134.865,81.3496,500,49869,0,0,0,0,0,0,0,0,0.893835,0,0),
(177939,1,-8972.67,-82.4306,86.9969,500,49869,0,0,0,0,0,0,0,0,0.767945,0,0),
(177940,1,-8907.56,-78.8308,87.3481,500,49869,0,0,0,0,0,0,0,0,1.39788,0,0),
(177941,1,-8807.43,-163.302,81.7143,500,49869,0,0,0,0,0,0,0,0,6.00393,0,0),
(177942,1,-8983,-53.6076,91.4949,500,49869,0,0,0,0,0,0,0,0,0.17645,0,0),
(177943,1,-8872.65,-120.501,81.2425,500,49869,0,0,0,0,0,0,0,0,0.498396,0,0),
(177944,1,-8981.61,-66.4004,89.9789,500,49869,0,0,0,0,0,0,0,0,0.634094,0,0),

(177961,1,-9018.34,-115.545,88.0175,500,49869,0,0,0,0,0,0,0,0,4.62992,0,0),
(177962,1,-8811.47,-151.259,82.6853,500,49869,0,0,0,0,0,0,0,0,0.296706,0,0),
(177963,1,-8950.66,-86.0417,87.7749,500,49869,0,0,0,0,0,0,0,0,1.3439,0,0),
(177964,1,-9004.6,-126.356,84.7341,500,49869,0,0,0,0,0,0,0,0,-2.75209,0,0),
(177965,1,-8835.9,-147.991,80.9152,500,49869,0,0,0,0,0,0,0,0,0.71315,0,0);

UPDATE creature SET MovementType = 2 WHERE id = 49869;

-- Training dummy fix for humans
DELETE FROM creature_ai_scripts WHERE id IN (4454801,4454802,4454803,4454804,4454805,4454806);
INSERT INTO creature_ai_scripts VALUES (4454801,44548,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454802,44548,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454803,44548,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454804,44548,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454805,44548,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454806,44548,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

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

