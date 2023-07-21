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
    SET @cOldContent = '016';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '017';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Valiance Keep Updates';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Valiance Keep Updates';

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

	-- Remove extra chair.
	DELETE FROM `gameobject` WHERE `guid` = 27360;

	-- MovementType 2 added.
	UPDATE `creature` SET `position_x` = 2125.58, `position_y` = 5355.01, `position_z` = 21.1216, `orientation` = 3.95688, `MovementType` = 2 WHERE `guid` = 103697;
	UPDATE `creature` SET `position_x` = 2279.51, `position_y` = 5153.01, `position_z` = 1.28274, `orientation` = 4.35353, `MovementType` = 2  WHERE `guid` = 103698;
	UPDATE `creature` SET `position_x` = 2136.45, `position_y` = 5350.42, `position_z` = 21.6257, `orientation` = -2.21656, `MovementType` = 2  WHERE `guid` = 103699;
	UPDATE `creature` SET `position_x` = 2125.58, `position_y` = 2252.5, `position_z` = 1.76104, `orientation` = 2.57248, `MovementType` = 2  WHERE `guid` = 103700;

	-- Remove extra spawns.
	DELETE FROM `creature` WHERE `guid` IN (103701,103702,103703);

	-- Waypoints added.
	DELETE FROM `creature_movement` WHERE `id` IN (103697,103698,103699,103700);
	INSERT INTO `creature_movement` (`id`,`point`,`position_x`,`position_y`,`position_z`,`waittime`,`script_id`,`textid1`,`textid2`,`textid3`,`textid4`,`textid5`,`emote`,`spell`,`orientation`,`model1`,`model2`) VALUES
	(103697,1,2125.58,5355.01,21.1216,0,0,0,0,0,0,0,0,0,3.95688,0,0),
	(103697,2,2125.58,5355.01,21.1216,15000,0,0,0,0,0,0,0,0,3.95688,0,0),
	(103697,3,2113.21,5349.92,19.4718,0,0,0,0,0,0,0,0,0,4.03601,0,0),
	(103697,4,2094.73,5322.24,19.4514,0,0,0,0,0,0,0,0,0,6.04269,0,0),
	(103697,5,2094.73,5322.24,19.4514,20000,0,0,0,0,0,0,0,0,6.04269,0,0),
	(103697,6,2113.21,5349.92,19.4718,0,0,0,0,0,0,0,0,0,0.383895,0,0),
	(103698,1,2279.51,5153.01,1.28274,0,0,0,0,0,0,0,0,0,4.35353,0,0),
	(103698,2,2278.44,5150.56,1.28274,15000,0,0,0,0,0,0,0,0,4.3025,0,0),
	(103698,3,2279.51,5153.01,1.28274,0,0,0,0,0,0,0,0,0,3.28761,0,0),
	(103698,4,2279.51,5153.01,1.28274,0,0,0,0,0,0,0,0,0,1.28274,0,0),
	(103698,5,2288.49,5149.72,1.5795,0,0,0,0,0,0,0,0,0,4.95046,0,0),
	(103698,6,2289.4,5143.92,1.54364,0,0,0,0,0,0,0,0,0,3.75665,0,0),
	(103698,7,2283.86,5140.04,2.56753,20000,0,0,0,0,0,0,0,0,3.59957,0,0),
	(103698,8,2288.27,5145.62,1.58856,0,0,0,0,0,0,0,0,0,1.58856,0,0),
	(103698,9,2286.02,5151.39,1.33697,0,0,0,0,0,0,0,0,0,2.73564,0,0),
	(103699,1,2136.45,5350.42,21.6257,0,0,0,0,0,0,0,0,0,-2.21656,0,0),
	(103699,2,2136.45,5350.42,21.6257,15000,0,0,0,0,0,0,0,0,-2.21656,0,0),
	(103699,3,2182.19,5337.33,21.5434,0,0,0,0,0,0,0,0,0,4.68341,0,0),
	(103699,4,2182.19,5337.33,21.5434,20000,0,0,0,0,0,0,0,0,0.109535,0,0),
	(103699,5,2136.45,5350.42,21.6257,0,0,0,0,0,0,0,0,0,0.109535,0,0),
	(103700,1,2252.5,5398.59,1.76104,20000,0,0,0,0,0,0,0,0,2.57248,0,0),
	(103700,2,2258,5395.76,1.65933,0,0,0,0,0,0,0,0,0,4.3946,0,0),
	(103700,3,2242.3,5348.04,3.74707,0,0,0,0,0,0,0,0,0,4.25715,0,0),
	(103700,4,2237.52,5336.35,10.2301,0,0,0,0,0,0,0,0,0,4.42994,0,0),
	(103700,5,2231.19,5322.25,10.4882,0,0,0,0,0,0,0,0,0,3.42463,0,0),
	(103700,6,2224.28,5319.16,10.5747,0,0,0,0,0,0,0,0,0,1.88918,0,0),
	(103700,7,2224.28,5319.16,10.5747,25000,0,0,0,0,0,0,0,0,1.88918,0,0),
	(103700,8,2224.28,5319.16,10.5747,0,0,0,0,0,0,0,0,0,5.56133,0,0),
	(103700,9,2231.19,5322.25,10.4882,0,0,0,0,0,0,0,0,0,0.495508,0,0),
	(103700,10,2237.52,5336.35,10.2301,0,0,0,0,0,0,0,0,0,1.23771,0,0),
	(103700,11,2242.3,5348.04,3.74707,0,0,0,0,0,0,0,0,0,1.23771,0,0),
	(103700,12,2258,5395.76,1.65933,0,0,0,0,0,0,0,0,0,2.62786,0,0);

	-- Delete incorrect Spirit Healer.
	DELETE FROM `creature` WHERE `guid` = 91358;

	-- Correct Spirit Healer position.
	UPDATE `creature` SET `position_x` = 2484.58, `position_y` = 5288.94, `position_z` = 32.6711, `orientation` = 3.08923 WHERE `guid` = 71839;

	-- Durgan Thunderbeak position corrected.
	UPDATE `creature` SET `position_x` = 2280.9, `position_y` = 5177.21, `position_z` = 11.423, `orientation` = 3.28122 WHERE `id` = 35131;

	-- Maigra Keenfeather position corrected.
	UPDATE `creature` SET `position_x` = 2277.37, `position_y` = 5172.91, `position_z` = 11.423, `orientation` = 2.58309 WHERE `id` = 35133;

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


