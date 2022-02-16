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
    SET @cOldStructure = '06'; 
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '06';
    SET @cNewContent = '002';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Fix_some_startup_errors';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix_some_startup_errors';

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
		
 delete from instance_reset where mapid=33 and difficulty=2;
 delete from instance_reset where mapid=249 and difficulty=3;
 delete from instance_reset where mapid=249 and difficulty=4;
 delete from instance_reset where mapid=269 and difficulty=2;
 delete from instance_reset where mapid=409 and difficulty=9;
 delete from instance_reset where mapid=469 and difficulty=9;
 delete from instance_reset where mapid=531 and difficulty=9;
 delete from instance_reset where mapid=532 and difficulty=3;
 delete from instance_reset where mapid=533 and difficulty=3;
 delete from instance_reset where mapid=533 and difficulty=4;
 delete from instance_reset where mapid=534 and difficulty=4;
 delete from instance_reset where mapid=540 and difficulty=2;
 delete from instance_reset where mapid=542 and difficulty=2;
 delete from instance_reset where mapid=543 and difficulty=2;
 delete from instance_reset where mapid=544 and difficulty=4;
 delete from instance_reset where mapid=545 and difficulty=2;
 delete from instance_reset where mapid=546 and difficulty=2;
 delete from instance_reset where mapid=547 and difficulty=2;
 delete from instance_reset where mapid=548 and difficulty=4;
 delete from instance_reset where mapid=550 and difficulty=4;
 delete from instance_reset where mapid=552 and difficulty=2;
 delete from instance_reset where mapid=553 and difficulty=2;
 delete from instance_reset where mapid=554 and difficulty=2;
 delete from instance_reset where mapid=555 and difficulty=2;
 delete from instance_reset where mapid=556 and difficulty=2;
 delete from instance_reset where mapid=557 and difficulty=2;
 delete from instance_reset where mapid=558 and difficulty=2;
 delete from instance_reset where mapid=560 and difficulty=2;
 delete from instance_reset where mapid=564 and difficulty=4;
 delete from instance_reset where mapid=565 and difficulty=4;
 delete from instance_reset where mapid=568 and difficulty=2;
 delete from instance_reset where mapid=574 and difficulty=2;
 delete from instance_reset where mapid=575 and difficulty=2;
 delete from instance_reset where mapid=576 and difficulty=2;
 delete from instance_reset where mapid=578 and difficulty=2;
 delete from instance_reset where mapid=580 and difficulty=4;
 delete from instance_reset where mapid=585 and difficulty=2;
 delete from instance_reset where mapid=595 and difficulty=2;
 delete from instance_reset where mapid=598 and difficulty=2;
 delete from instance_reset where mapid=599 and difficulty=2;
 delete from instance_reset where mapid=600 and difficulty=2;
 delete from instance_reset where mapid=601 and difficulty=2;
 delete from instance_reset where mapid=602 and difficulty=2;
 delete from instance_reset where mapid=603 and difficulty=3;
 delete from instance_reset where mapid=603 and difficulty=4;
 delete from instance_reset where mapid=604 and difficulty=2;
 delete from instance_reset where mapid=608 and difficulty=2;
 delete from instance_reset where mapid=615 and difficulty=3;
 delete from instance_reset where mapid=615 and difficulty=4;
 delete from instance_reset where mapid=616 and difficulty=3;
 delete from instance_reset where mapid=616 and difficulty=4;
 delete from instance_reset where mapid=619 and difficulty=2;
 delete from instance_reset where mapid=624 and difficulty=3;
 delete from instance_reset where mapid=624 and difficulty=4;
 delete from instance_reset where mapid=631 and difficulty=4;
 delete from instance_reset where mapid=631 and difficulty=5;
 delete from instance_reset where mapid=631 and difficulty=6;
 delete from instance_reset where mapid=632 and difficulty=2;
 delete from instance_reset where mapid=643 and difficulty=2;
 delete from instance_reset where mapid=644 and difficulty=2;
 delete from instance_reset where mapid=645 and difficulty=2;
 delete from instance_reset where mapid=649 and difficulty=4;
 delete from instance_reset where mapid=649 and difficulty=5;
 delete from instance_reset where mapid=649 and difficulty=6;
 delete from instance_reset where mapid=650 and difficulty=2;
 delete from instance_reset where mapid=657 and difficulty=2;
 delete from instance_reset where mapid=658 and difficulty=2;
 delete from instance_reset where mapid=668 and difficulty=2;
 delete from instance_reset where mapid=669 and difficulty=4;
 delete from instance_reset where mapid=669 and difficulty=5;
 delete from instance_reset where mapid=669 and difficulty=6;
 delete from instance_reset where mapid=670 and difficulty=2;
 delete from instance_reset where mapid=671 and difficulty=4;
 delete from instance_reset where mapid=671 and difficulty=5;
 delete from instance_reset where mapid=671 and difficulty=6;
 delete from instance_reset where mapid=720 and difficulty=4;
 delete from instance_reset where mapid=720 and difficulty=5;
 delete from instance_reset where mapid=720 and difficulty=6;
 delete from instance_reset where mapid=724 and difficulty=4;
 delete from instance_reset where mapid=724 and difficulty=5;
 delete from instance_reset where mapid=724 and difficulty=6;
 delete from instance_reset where mapid=725 and difficulty=2;
 delete from instance_reset where mapid=754 and difficulty=4;
 delete from instance_reset where mapid=754 and difficulty=5;
 delete from instance_reset where mapid=754 and difficulty=6;
 delete from instance_reset where mapid=757 and difficulty=4;
 delete from instance_reset where mapid=757 and difficulty=5;
 delete from instance_reset where mapid=757 and difficulty=6;
 delete from instance_reset where mapid=859 and difficulty=2;
 delete from instance_reset where mapid=938 and difficulty=2;
 delete from instance_reset where mapid=939 and difficulty=2;
 delete from instance_reset where mapid=940 and difficulty=2;
 delete from instance_reset where mapid=959 and difficulty=2;
 delete from instance_reset where mapid=960 and difficulty=2;
 delete from instance_reset where mapid=961 and difficulty=2;
 delete from instance_reset where mapid=962 and difficulty=2;
 delete from instance_reset where mapid=967 and difficulty=4;
 delete from instance_reset where mapid=967 and difficulty=5;
 delete from instance_reset where mapid=967 and difficulty=6;
 delete from instance_reset where mapid=994 and difficulty=2;
 delete from instance_reset where mapid=996 and difficulty=3;
 delete from instance_reset where mapid=996 and difficulty=4;
 delete from instance_reset where mapid=996 and difficulty=5;
 delete from instance_reset where mapid=996 and difficulty=6;
 delete from instance_reset where mapid=1001 and difficulty=2;
 delete from instance_reset where mapid=1004 and difficulty=2;
 delete from instance_reset where mapid=1007 and difficulty=2;
 delete from instance_reset where mapid=1008 and difficulty=3;
 delete from instance_reset where mapid=1008 and difficulty=4;
 delete from instance_reset where mapid=1008 and difficulty=5;
 delete from instance_reset where mapid=1008 and difficulty=6;
 delete from instance_reset where mapid=1009 and difficulty=3;
 delete from instance_reset where mapid=1009 and difficulty=4;
 delete from instance_reset where mapid=1009 and difficulty=5;
 delete from instance_reset where mapid=1009 and difficulty=6;
 delete from instance_reset where mapid=1011 and difficulty=2;
 delete from instance_reset where mapid=1098 and difficulty=3;
 delete from instance_reset where mapid=1098 and difficulty=4;
 delete from instance_reset where mapid=1098 and difficulty=5;
 delete from instance_reset where mapid=1098 and difficulty=6;
 delete from instance_reset where mapid=1136 and difficulty=3;
 delete from instance_reset where mapid=1136 and difficulty=4;
 delete from instance_reset where mapid=1136 and difficulty=5;
 delete from instance_reset where mapid=1136 and difficulty=6;        
	
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


