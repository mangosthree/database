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
    SET @cOldContent = '002';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '01';
    SET @cNewContent = '003';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'EventAI startup errors Pt.1';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'EventAI startup errors Pt.1';

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

    UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 54501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 57301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 64501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 105102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 105201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 105307;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 105407;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 155901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 167402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 167502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 175302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 177202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 185410;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 185412;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 193906;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 194002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 194102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 194203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 194301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 224701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 225702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 227604;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 227605;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 252101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 254901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 255002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 260601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 262402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 275501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 277601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 279303;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 323402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 323601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 324901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 326001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 326602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 341601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 341701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 342401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 343610;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 345201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 383501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 409501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 412001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 437002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 437003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 611801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 652307;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 704109;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 735601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 760602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 766402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 766605;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 772802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 799903;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 852410;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 866701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 871802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 892702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 901601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 902602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 926303;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1007809;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1022002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0, `action2_param2` = 0, `action3_param2` = 0 WHERE `id` = 1044005;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0, `action2_param2` = 0, `action3_param2` = 0 WHERE `id` = 1044006;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1055902;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1073701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1114305;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1135003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1135203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1144703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1147202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1148711;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1149706;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1149804;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1165710;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1166102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1166309;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1168801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1174601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1183001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1194601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1220602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1220702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1289901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1292102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1360105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1384102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1423201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1442801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1448701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1512603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1512703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1520501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1520502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1523301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1524901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1527301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1527302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1527401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1527402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527704;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527712;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527716;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527720;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527724;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527728;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1527732;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1529401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1529402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1529801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 1529802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1533402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1534105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1539206;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1566801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1597903;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1597904;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1602501;

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


