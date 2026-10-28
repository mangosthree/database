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
    SET @cOldStructure = '12';
    SET @cOldContent = '022';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '023';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Battle_Muster_Layout';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Battle muster: Liam mounted (2409) at the formation head, 57 militia at capture ranks facing him, mastiffs at heel - all from the capture create';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @oldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @oldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- The battle muster column at its final width.


        -- ---- from Battle_Muster_Layout ----
        -- Prince Liam: the capture musters him MOUNTED (display 2409) at the
        -- head of the formation by the Livery; our row had his late-battle
        -- post 350 yards into the city.
        UPDATE `creature` SET `position_x` = -1408.70, `position_y` = 1260.00, `position_z` = 36.50, `orientation` = 4.85 WHERE `guid` = 222317;
        DELETE FROM `creature_addon` WHERE `guid` = 222317;
        INSERT INTO `creature_addon` (`guid`, `mount`, `bytes1`, `b2_0_sheath`, `b2_1_pvp_state`, `emote`, `moveflags`, `auras`) VALUES (222317, 2409, 0, 1, 0, 0, 0, NULL);

        -- The muster: 57 capture positions for the militia ranks (the rest of
        -- our 74 keep their mid-city posts for the later stages), each facing
        -- the prince.
        UPDATE `creature` SET `position_x` = -1396.21, `position_y` = 1228.23, `position_z` = 35.64, `orientation` = 1.945, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222291;
        UPDATE `creature` SET `position_x` = -1395.05, `position_y` = 1230.22, `position_z` = 35.64, `orientation` = 2.001, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222292;
        UPDATE `creature` SET `position_x` = -1399.33, `position_y` = 1225.06, `position_z` = 35.64, `orientation` = 1.833, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222293;
        UPDATE `creature` SET `position_x` = -1400.49, `position_y` = 1223.07, `position_z` = 35.64, `orientation` = 1.790, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222294;
        UPDATE `creature` SET `position_x` = -1399.75, `position_y` = 1229.02, `position_z` = 35.64, `orientation` = 1.852, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222295;
        UPDATE `creature` SET `position_x` = -1400.90, `position_y` = 1227.03, `position_z` = 35.64, `orientation` = 1.803, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222296;
        UPDATE `creature` SET `position_x` = -1398.56, `position_y` = 1231.17, `position_z` = 35.64, `orientation` = 1.909, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222297;
        UPDATE `creature` SET `position_x` = -1397.41, `position_y` = 1233.16, `position_z` = 35.64, `orientation` = 1.969, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222298;
        UPDATE `creature` SET `position_x` = -1402.87, `position_y` = 1227.86, `position_z` = 35.64, `orientation` = 1.750, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222299;
        UPDATE `creature` SET `position_x` = -1396.73, `position_y` = 1237.27, `position_z` = 35.64, `orientation` = 2.056, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222318;
        UPDATE `creature` SET `position_x` = -1404.02, `position_y` = 1225.87, `position_z` = 35.64, `orientation` = 1.707, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222319;
        UPDATE `creature` SET `position_x` = -1401.30, `position_y` = 1231.27, `position_z` = 35.64, `orientation` = 1.823, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222320;
        UPDATE `creature` SET `position_x` = -1403.24, `position_y` = 1230.06, `position_z` = 35.64, `orientation` = 1.751, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222321;
        UPDATE `creature` SET `position_x` = -1404.40, `position_y` = 1228.07, `position_z` = 35.64, `orientation` = 1.705, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222322;
        UPDATE `creature` SET `position_x` = -1400.84, `position_y` = 1234.70, `position_z` = 35.64, `orientation` = 1.872, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222323;
        UPDATE `creature` SET `position_x` = -1402.16, `position_y` = 1232.82, `position_z` = 35.64, `orientation` = 1.807, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222324;
        UPDATE `creature` SET `position_x` = -1399.23, `position_y` = 1237.05, `position_z` = 35.64, `orientation` = 1.962, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222325;
        UPDATE `creature` SET `position_x` = -1406.05, `position_y` = 1226.87, `position_z` = 35.64, `orientation` = 1.651, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222326;
        UPDATE `creature` SET `position_x` = -1407.21, `position_y` = 1224.88, `position_z` = 35.43, `orientation` = 1.613, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222327;
        UPDATE `creature` SET `position_x` = -1404.10, `position_y` = 1231.50, `position_z` = 35.64, `orientation` = 1.731, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222328;
        UPDATE `creature` SET `position_x` = -1398.85, `position_y` = 1239.30, `position_z` = 35.64, `orientation` = 2.015, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222329;
        UPDATE `creature` SET `position_x` = -1402.03, `position_y` = 1236.74, `position_z` = 35.64, `orientation` = 1.850, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222330;
        UPDATE `creature` SET `position_x` = -1404.40, `position_y` = 1233.74, `position_z` = 35.64, `orientation` = 1.733, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222331;
        UPDATE `creature` SET `position_x` = -1403.25, `position_y` = 1235.73, `position_z` = 35.64, `orientation` = 1.792, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222332;
        UPDATE `creature` SET `position_x` = -1406.71, `position_y` = 1230.29, `position_z` = 35.64, `orientation` = 1.638, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222333;
        UPDATE `creature` SET `position_x` = -1407.86, `position_y` = 1228.30, `position_z` = 35.62, `orientation` = 1.597, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222334;
        UPDATE `creature` SET `position_x` = -1399.30, `position_y` = 1241.37, `position_z` = 35.64, `orientation` = 2.038, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222335;
        UPDATE `creature` SET `position_x` = -1406.21, `position_y` = 1232.23, `position_z` = 35.64, `orientation` = 1.660, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222336;
        UPDATE `creature` SET `position_x` = -1401.26, `position_y` = 1239.94, `position_z` = 35.64, `orientation` = 1.926, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222337;
        UPDATE `creature` SET `position_x` = -1402.53, `position_y` = 1238.53, `position_z` = 35.64, `orientation` = 1.851, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222338;
        UPDATE `creature` SET `position_x` = -1398.25, `position_y` = 1243.69, `position_z` = 36.12, `orientation` = 2.141, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222339;
        UPDATE `creature` SET `position_x` = -1408.33, `position_y` = 1230.89, `position_z` = 35.64, `orientation` = 1.584, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222340;
        UPDATE `creature` SET `position_x` = -1406.70, `position_y` = 1234.23, `position_z` = 35.64, `orientation` = 1.648, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222341;
        UPDATE `creature` SET `position_x` = -1405.12, `position_y` = 1238.07, `position_z` = 35.64, `orientation` = 1.733, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222342;
        UPDATE `creature` SET `position_x` = -1403.97, `position_y` = 1240.07, `position_z` = 35.64, `orientation` = 1.804, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222343;
        UPDATE `creature` SET `position_x` = -1402.94, `position_y` = 1242.49, `position_z` = 36.11, `orientation` = 1.889, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222344;
        UPDATE `creature` SET `position_x` = -1412.06, `position_y` = 1229.05, `position_z` = 35.36, `orientation` = 1.463, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222345;
        UPDATE `creature` SET `position_x` = -1400.60, `position_y` = 1246.62, `position_z` = 36.51, `orientation` = 2.115, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222346;
        UPDATE `creature` SET `position_x` = -1408.00, `position_y` = 1238.71, `position_z` = 35.59, `orientation` = 1.604, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222347;
        UPDATE `creature` SET `position_x` = -1406.07, `position_y` = 1241.32, `position_z` = 36.00, `orientation` = 1.711, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222348;
        UPDATE `creature` SET `position_x` = -1407.67, `position_y` = 1240.97, `position_z` = 36.02, `orientation` = 1.625, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222349;
        UPDATE `creature` SET `position_x` = -1411.20, `position_y` = 1235.85, `position_z` = 35.64, `orientation` = 1.468, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222350;
        UPDATE `creature` SET `position_x` = -1410.05, `position_y` = 1237.84, `position_z` = 35.61, `orientation` = 1.510, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222351;
        UPDATE `creature` SET `position_x` = -1406.44, `position_y` = 1243.52, `position_z` = 36.51, `orientation` = 1.707, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222352;
        UPDATE `creature` SET `position_x` = -1409.25, `position_y` = 1240.34, `position_z` = 35.95, `orientation` = 1.543, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222353;
        UPDATE `creature` SET `position_x` = -1405.36, `position_y` = 1246.28, `position_z` = 36.51, `orientation` = 1.810, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222354;
        UPDATE `creature` SET `position_x` = -1404.03, `position_y` = 1248.17, `position_z` = 36.51, `orientation` = 1.947, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222355;
        UPDATE `creature` SET `position_x` = -1402.42, `position_y` = 1250.51, `position_z` = 36.51, `orientation` = 2.155, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222356;
        UPDATE `creature` SET `position_x` = -1409.90, `position_y` = 1243.75, `position_z` = 36.51, `orientation` = 1.497, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222357;
        UPDATE `creature` SET `position_x` = -1406.45, `position_y` = 1249.19, `position_z` = 36.51, `orientation` = 1.776, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222954;
        UPDATE `creature` SET `position_x` = -1408.26, `position_y` = 1247.68, `position_z` = 36.51, `orientation` = 1.606, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222955;
        UPDATE `creature` SET `position_x` = -1409.05, `position_y` = 1246.82, `position_z` = 36.51, `orientation` = 1.544, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222956;
        UPDATE `creature` SET `position_x` = -1402.50, `position_y` = 1254.84, `position_z` = 36.51, `orientation` = 2.447, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222957;
        UPDATE `creature` SET `position_x` = -1404.93, `position_y` = 1252.91, `position_z` = 36.51, `orientation` = 2.060, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222958;
        UPDATE `creature` SET `position_x` = -1407.16, `position_y` = 1253.53, `position_z` = 36.51, `orientation` = 1.804, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222959;
        UPDATE `creature` SET `position_x` = -1410.04, `position_y` = 1254.17, `position_z` = 36.51, `orientation` = 1.345, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222960;
        UPDATE `creature` SET `position_x` = -1413.24, `position_y` = 1251.31, `position_z` = 36.51, `orientation` = 1.089, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222961;

        -- The mastiffs hold at heel behind the ranks - capture spots, no wander.
        UPDATE `creature` SET `position_x` = -1387.90, `position_y` = 1228.10, `position_z` = 35.64, `orientation` = 2.149, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222285;
        UPDATE `creature` SET `position_x` = -1393.24, `position_y` = 1223.16, `position_z` = 35.64, `orientation` = 1.968, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222812;
        UPDATE `creature` SET `position_x` = -1391.36, `position_y` = 1226.65, `position_z` = 35.64, `orientation` = 2.050, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222813;
        UPDATE `creature` SET `position_x` = -1397.73, `position_y` = 1222.29, `position_z` = 35.64, `orientation` = 1.854, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222814;
        UPDATE `creature` SET `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 222815;

        -- ---- from Liam_Muster_Position ----
        -- Liam's muster spot sits on a platform ABOVE WATER (FloorZ 36.43,
        -- GroundZ -18.61): the rounded capture point put him a hair off the
        -- floor edge and he spawned swimming below the ranks. In-game survey:
        UPDATE `creature` SET `position_x` = -1409.30, `position_y` = 1262.44,
            `position_z` = 36.43, `orientation` = 1.789 WHERE `guid` = 222317;

        -- ---- from Liam_Stand_Still ----
        -- Liam carried MovementType 2 - a TDB waypoint march that, anchored at
        -- the muster, walked him straight off the bridge on spawn. He stands
        -- for the speech; the battle stages script the march themselves.
        UPDATE `creature` SET `MovementType` = 0 WHERE `guid` = 222317;

        -- ---- from Muster_Column_Narrowed ----
        -- The muster stood 20 yards wide (-1413..-1393): soldiers on the very
        -- edges of the bridge. The column narrows to a 9-yard band, edge rows
        -- pulled just inside it with a guid-staggered offset so the clamped
        -- men form ranks instead of a perfect line.
        UPDATE `creature` SET `position_x` = -1408.0 + MOD(`guid`, 5) * 0.4
            WHERE `id`=38221 AND `map`=654
              AND `position_y` BETWEEN 1215 AND 1260 AND `position_x` < -1408.0;
        UPDATE `creature` SET `position_x` = -1399.0 - MOD(`guid`, 5) * 0.4
            WHERE `id`=38221 AND `map`=654
              AND `position_y` BETWEEN 1215 AND 1260 AND `position_x` > -1399.0;

        -- ---- from Muster_Column_Widened ----
        -- The 9-yard clamp packed the muster too tight. The edge ranks step
        -- 2.5 yards back outward: a ~14-yard formation (-1410.5..-1396.5),
        -- still well inside the old 20-yard spread that stood men on the
        -- bridge edges.
        UPDATE `creature` SET `position_x` = `position_x` - 2.5
            WHERE `id`=38221 AND `map`=654
              AND `position_y` BETWEEN 1215 AND 1260
              AND `position_x` BETWEEN -1408.0 AND -1406.0;
        UPDATE `creature` SET `position_x` = `position_x` + 2.5
            WHERE `id`=38221 AND `map`=654
              AND `position_y` BETWEEN 1215 AND 1260
              AND `position_x` BETWEEN -1401.0 AND -1399.0;

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
            SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@newResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @newResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@oldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @oldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
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
