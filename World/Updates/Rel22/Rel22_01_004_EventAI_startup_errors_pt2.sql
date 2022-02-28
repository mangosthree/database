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
    SET @cOldContent = '003';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '01';
    SET @cNewContent = '004';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'EventAI startup errors Pt.2';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'EventAI startup errors Pt.2';

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

	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1604209;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1614602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1614603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1616802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1617501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1618002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1635401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1641002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1646002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1646102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1648502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1650402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1687316;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1690101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1695102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1703501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1705803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1715009;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1742902;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1754801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1761213;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1776702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1777137;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1780304;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1780803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1784205;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1787102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1788203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1789212;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1789213;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1789223;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1789224;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1796010;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1799402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0, `action1_param3` = 0 WHERE `id` = 1806401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 6, `action1_param3` = 0 WHERE `id` = 1806402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1809603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1811601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1811809;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1812401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1815902;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1825902;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1826001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1828202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1833806;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1839851;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1840151;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1840158;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1842105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1849315;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1870205;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1870206;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1882903;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1882905;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1882906;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1887701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1930503;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1940201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1942212;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1973801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 1973802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 1994602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2003403;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2003705;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2004502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2028002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2032401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2033201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2033202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2044302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2045501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2050201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2055702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2072305;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2077801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2086401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2088302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2092501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2110410;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2110411;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2118103;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2129910;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2149701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2149702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2149703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2164909;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2169703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2173009;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2183805;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2185201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2207402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2214001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2218002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2224101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2230701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2234202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2234203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 2288211;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2293001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2295402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2296402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2316204;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2319603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2324702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2339103;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2354203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2358003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2358201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 2397701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2417302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2424701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2456601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2468701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2468702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2468703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2468704;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2469801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2477001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2477002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 2497901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2525604;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2536303;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2537002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2537003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2537004;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2544803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2548303;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2550702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2550803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2558501;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2572801;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2610102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2612701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 2641408;
	UPDATE `creature_ai_scripts` SET `action2_param2` = 7 WHERE `id` = 2647201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2652905;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2652906;
	UPDATE `creature_ai_scripts` SET `action2_param2` = 0 WHERE `id` = 2653003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653009;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653205;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653303;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653304;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653307;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2653308;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2661602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2663606;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2663607;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2665402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672711;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672715;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672716;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672717;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672718;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672723;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672724;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2672725;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2694601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2696503;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 2717711;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2720210;

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


