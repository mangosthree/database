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
    SET @cOldStructure = '11';
    SET @cOldContent = '043';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '044';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Duskhaven_Hill_Defense';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Tester-specified staging for the Duskhaven hill: Liam back at his hilltop spot, three even groups of 2 planted watchmen vs 4 milling invaders fanned';

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

        -- The Duskhaven hill defense: three groups at their final spots.


        -- ---- from Duskhaven_Hill_Three_Groups ----
        -- Tester-directed staging. Liam holds the hilltop; three fight groups
        -- of two planted watchmen against four milling invaders fan out evenly
        -- along his facing at eighteen yards; three marksmen (36653, same gun)
        -- hold a line eight yards out and shoot into the field. Invaders keep
        -- a short wander so the fights self-ignite (static hostile pairs never
        -- engage on this core).
        UPDATE `creature` SET `position_x`=-1925.44, `position_y`=2329.39, `position_z`=37.6, `orientation`=1.739, `MovementType`=0, `spawndist`=0 WHERE `guid`=219399;
        UPDATE `creature` SET `position_x`=-1923.27, `position_y`=2329.76, `position_z`=37.6, `orientation`=1.739, `MovementType`=0, `spawndist`=0 WHERE `guid`=219400;
        UPDATE `creature` SET `position_x`=-1935.79, `position_y`=2322.62, `position_z`=36.5, `orientation`=2.439, `MovementType`=0, `spawndist`=0 WHERE `guid`=219401;
        UPDATE `creature` SET `position_x`=-1934.37, `position_y`=2324.30, `position_z`=36.5, `orientation`=2.439, `MovementType`=0, `spawndist`=0 WHERE `guid`=219402;
        UPDATE `creature` SET `position_x`=-1939.35, `position_y`=2310.78, `position_z`=36.9, `orientation`=3.139, `MovementType`=0, `spawndist`=0 WHERE `guid`=219403;
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400137,36211,654,1,4096,29317,0,-1939.34,2312.98,36.9,3.139,300,0,0,102,0,0,0);
        UPDATE `creature` SET `position_x`=-1926.23, `position_y`=2330.91, `position_z`=37.6, `orientation`=5.666, `MovementType`=1, `spawndist`=3 WHERE `guid`=221727;
        UPDATE `creature` SET `position_x`=-1925.69, `position_y`=2327.70, `position_z`=37.6, `orientation`=0.953, `MovementType`=1, `spawndist`=3 WHERE `guid`=221361;
        UPDATE `creature` SET `position_x`=-1922.48, `position_y`=2328.24, `position_z`=37.6, `orientation`=2.524, `MovementType`=1, `spawndist`=3 WHERE `guid`=221736;
        UPDATE `creature` SET `position_x`=-1923.03, `position_y`=2331.45, `position_z`=37.6, `orientation`=4.095, `MovementType`=1, `spawndist`=3 WHERE `guid`=221357;
        UPDATE `creature` SET `position_x`=-1937.37, `position_y`=2323.27, `position_z`=36.5, `orientation`=0.083, `MovementType`=1, `spawndist`=3 WHERE `guid`=221177;
        UPDATE `creature` SET `position_x`=-1934.89, `position_y`=2321.17, `position_z`=36.5, `orientation`=1.653, `MovementType`=1, `spawndist`=3 WHERE `guid`=221175;
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400138,34511,654,1,4096,30056,0,-1932.79,2323.65,36.5,3.224,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400139,34511,654,1,4096,30056,0,-1935.27,2325.76,36.5,4.795,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400140,34511,654,1,4096,30056,0,-1940.98,2310.26,36.9,0.783,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400141,34511,654,1,4096,30056,0,-1937.73,2310.25,36.9,2.353,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400142,34511,654,1,4096,30056,0,-1937.72,2313.50,36.9,3.924,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400143,34511,654,1,4096,30056,0,-1940.97,2313.51,36.9,5.495,60,3,0,102,0,0,1);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400144,36653,654,1,4096,30275,0,-1922.69,2319.72,38.8,1.739,300,0,0,102,0,0,0);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400145,36653,654,1,4096,30275,0,-1927.45,2317.00,38.6,2.439,300,0,0,102,0,0,0);
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES (400146,36653,654,1,4096,30275,0,-1929.35,2311.85,38.5,3.139,300,0,0,102,0,0,0);
        UPDATE `creature` SET `position_x`=-1921.347412, `position_y`=2311.82959, `position_z`=39.753643, `orientation`=2.438854 WHERE `map`=654 AND `id`=36140;
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (0,'npc_duskhaven_watchman_marksman',36653,0);

        -- ---- from Duskhaven_Hill_Groups_At_Tester_Spots ----
        -- The three fight groups move onto the spots the tester walked out
        -- (13-18 yd in front of Liam, inside his view arc), each still two
        -- planted watchmen against four milling invaders. The marksman line
        -- pulls back to flank Liam on the hilltop - the covering fire now
        -- visibly comes from far, one lane each.
        UPDATE `creature` SET `position_x`=-1934.15, `position_y`=2308.99, `position_z`=37.789, `orientation`=-3.007, `MovementType`=0, `spawndist`=0 WHERE `guid`=219399;
        UPDATE `creature` SET `position_x`=-1934.45, `position_y`=2311.17, `position_z`=37.789, `orientation`=-3.007, `MovementType`=0, `spawndist`=0 WHERE `guid`=219400;
        UPDATE `creature` SET `position_x`=-1935.70, `position_y`=2308.25, `position_z`=37.789, `orientation`=0.920, `MovementType`=1, `spawndist`=3 WHERE `guid`=221727;
        UPDATE `creature` SET `position_x`=-1932.47, `position_y`=2308.68, `position_z`=37.789, `orientation`=2.491, `MovementType`=1, `spawndist`=3 WHERE `guid`=221361;
        UPDATE `creature` SET `position_x`=-1932.91, `position_y`=2311.91, `position_z`=37.789, `orientation`=4.061, `MovementType`=1, `spawndist`=3 WHERE `guid`=221736;
        UPDATE `creature` SET `position_x`=-1936.13, `position_y`=2311.47, `position_z`=37.789, `orientation`=5.632, `MovementType`=1, `spawndist`=3 WHERE `guid`=221357;
        UPDATE `creature` SET `position_x`=-1935.50, `position_y`=2323.15, `position_z`=35.899, `orientation`=2.406, `MovementType`=0, `spawndist`=0 WHERE `guid`=219401;
        UPDATE `creature` SET `position_x`=-1934.03, `position_y`=2324.78, `position_z`=35.899, `orientation`=2.406, `MovementType`=0, `spawndist`=0 WHERE `guid`=219402;
        UPDATE `creature` SET `position_x`=-1937.06, `position_y`=2323.85, `position_z`=35.899, `orientation`=0.050, `MovementType`=1, `spawndist`=3 WHERE `guid`=221177;
        UPDATE `creature` SET `position_x`=-1934.65, `position_y`=2321.67, `position_z`=35.899, `orientation`=1.621, `MovementType`=1, `spawndist`=3 WHERE `guid`=221175;
        UPDATE `creature` SET `position_x`=-1932.47, `position_y`=2324.08, `position_z`=35.899, `orientation`=3.192, `MovementType`=1, `spawndist`=3 WHERE `guid`=400138;
        UPDATE `creature` SET `position_x`=-1934.88, `position_y`=2326.27, `position_z`=35.899, `orientation`=4.762, `MovementType`=1, `spawndist`=3 WHERE `guid`=400139;
        UPDATE `creature` SET `position_x`=-1928.68, `position_y`=2328.96, `position_z`=36.756, `orientation`=1.916, `MovementType`=0, `spawndist`=0 WHERE `guid`=219403;
        UPDATE `creature` SET `position_x`=-1926.61, `position_y`=2329.71, `position_z`=36.756, `orientation`=1.916, `MovementType`=0, `spawndist`=0 WHERE `guid`=400137;
        UPDATE `creature` SET `position_x`=-1929.73, `position_y`=2330.32, `position_z`=36.756, `orientation`=5.843, `MovementType`=1, `spawndist`=3 WHERE `guid`=400140;
        UPDATE `creature` SET `position_x`=-1928.63, `position_y`=2327.26, `position_z`=36.756, `orientation`=1.131, `MovementType`=1, `spawndist`=3 WHERE `guid`=400141;
        UPDATE `creature` SET `position_x`=-1925.57, `position_y`=2328.36, `position_z`=36.756, `orientation`=2.702, `MovementType`=1, `spawndist`=3 WHERE `guid`=400142;
        UPDATE `creature` SET `position_x`=-1926.67, `position_y`=2331.42, `position_z`=36.756, `orientation`=4.272, `MovementType`=1, `spawndist`=3 WHERE `guid`=400143;
        UPDATE `creature` SET `position_x`=-1926.23, `position_y`=2310.76, `position_z`=39.0, `orientation`=3.357 WHERE `guid`=400144;
        UPDATE `creature` SET `position_x`=-1925.16, `position_y`=2315.06, `position_z`=39.0, `orientation`=2.439 WHERE `guid`=400145;
        UPDATE `creature` SET `position_x`=-1921.35, `position_y`=2316.83, `position_z`=39.2, `orientation`=1.571 WHERE `guid`=400146;

        -- ---- from Hill_Marksmen_Stand_Groups_Pinned ----
        -- Two fixes. The marksmen knelt because entry 36653s template addon
        -- carries bytes1=8 (its original spawn is a kneeling camp watchman);
        -- per-guid addons put these three upright with the rifle drawn.
        -- The groups piled up because NPC-vs-NPC aggro reaches ~20 yd and
        -- wounded fighters call assistance - with centers 9 yd apart every
        -- fight locked across groups. Rings tighten to 2 yd with a 1 yd
        -- wander, and npc_duskhaven_hill_brawler (bound to the hill pair of
        -- entries) gates creature aggro to 3.5 yd and mutes assist calls;
        -- players are aggroed normally.
        INSERT INTO `creature_addon` (`guid`,`mount`,`bytes1`,`b2_0_sheath`,`b2_1_pvp_state`,`emote`,`moveflags`,`auras`) VALUES (400144,0,0,2,0,0,0,NULL);
        INSERT INTO `creature_addon` (`guid`,`mount`,`bytes1`,`b2_0_sheath`,`b2_1_pvp_state`,`emote`,`moveflags`,`auras`) VALUES (400145,0,0,2,0,0,0,NULL);
        INSERT INTO `creature_addon` (`guid`,`mount`,`bytes1`,`b2_0_sheath`,`b2_1_pvp_state`,`emote`,`moveflags`,`auras`) VALUES (400146,0,0,2,0,0,0,NULL);
        UPDATE `creature` SET `position_x`=-1935.51, `position_y`=2308.49, `position_z`=37.789, `orientation`=0.920, `spawndist`=1 WHERE `guid`=221727;
        UPDATE `creature` SET `position_x`=-1932.71, `position_y`=2308.87, `position_z`=37.789, `orientation`=2.491, `spawndist`=1 WHERE `guid`=221361;
        UPDATE `creature` SET `position_x`=-1933.09, `position_y`=2311.67, `position_z`=37.789, `orientation`=4.061, `spawndist`=1 WHERE `guid`=221736;
        UPDATE `creature` SET `position_x`=-1935.89, `position_y`=2311.29, `position_z`=37.789, `orientation`=5.632, `spawndist`=1 WHERE `guid`=221357;
        UPDATE `creature` SET `position_x`=-1936.76, `position_y`=2323.87, `position_z`=35.899, `orientation`=0.050, `spawndist`=1 WHERE `guid`=221177;
        UPDATE `creature` SET `position_x`=-1934.67, `position_y`=2321.97, `position_z`=35.899, `orientation`=1.621, `spawndist`=1 WHERE `guid`=221175;
        UPDATE `creature` SET `position_x`=-1932.77, `position_y`=2324.07, `position_z`=35.899, `orientation`=3.192, `spawndist`=1 WHERE `guid`=400138;
        UPDATE `creature` SET `position_x`=-1934.87, `position_y`=2325.97, `position_z`=35.899, `orientation`=4.762, `spawndist`=1 WHERE `guid`=400139;
        UPDATE `creature` SET `position_x`=-1929.46, `position_y`=2330.19, `position_z`=36.756, `orientation`=5.843, `spawndist`=1 WHERE `guid`=400140;
        UPDATE `creature` SET `position_x`=-1928.50, `position_y`=2327.53, `position_z`=36.756, `orientation`=1.131, `spawndist`=1 WHERE `guid`=400141;
        UPDATE `creature` SET `position_x`=-1925.84, `position_y`=2328.49, `position_z`=36.756, `orientation`=2.702, `spawndist`=1 WHERE `guid`=400142;
        UPDATE `creature` SET `position_x`=-1926.80, `position_y`=2331.15, `position_z`=36.756, `orientation`=4.272, `spawndist`=1 WHERE `guid`=400143;
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (0,'npc_duskhaven_hill_brawler',36211,0);
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (0,'npc_duskhaven_hill_brawler',34511,0);

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
