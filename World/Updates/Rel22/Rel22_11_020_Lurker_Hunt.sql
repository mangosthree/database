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
    SET @cOldContent = '019';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '020';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Lurker_Hunt';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Krennan ride: remove 35383+35385 lurker markers never seen in retail; add 35463 Bloodfang Lurkers at capture positions to reach retail density';

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

        -- Bloodfang Lurkers: remove the old packs and stage 21 hunt spots.


        -- ---- from Gilneas_Ride_Lurkers ----
        -- Save Krennan Aranas ride corridor, from the 18019 capture:
        -- 35383 Bloodfang Lurker (roof) x32 and 35385 Lurker Jump-to x32 never
        -- appear in ANY retail phase window - imported scenery with no retail
        -- counterpart. Removed (no script references; addons/waypoints too).
        DELETE `cm` FROM `creature_movement` `cm` JOIN `creature` `c` ON `c`.`guid`=`cm`.`id` WHERE `c`.`map`=654 AND `c`.`id` IN (35383,35385);
        DELETE `ca` FROM `creature_addon` `ca` JOIN `creature` `c` ON `c`.`guid`=`ca`.`guid` WHERE `c`.`map`=654 AND `c`.`id` IN (35383,35385);
        DELETE FROM `creature` WHERE `map`=654 AND `id` IN (35383,35385);
        -- Retail populates the ride with 35463 Bloodfang Lurker: 41 concurrent
        -- world spawns (zero summoned) around Greymane Court; we had 7. The
        -- capture positions below raise us to retail density. Wander 5yd.
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES
        (400075,35463,654,1,4,0,0,-1790.9609,1454.9902,19.4708,2.5177,50,5,0,83,104,0,1),
        (400076,35463,654,1,4,0,0,-1790.5254,1455.5029,19.4708,1.8023,50,5,0,83,104,0,1),
        (400077,35463,654,1,4,0,0,-1807.2795,1445.7205,19.1603,4.4506,50,5,0,83,104,0,1),
        (400078,35463,654,1,4,0,0,-1756.4490,1438.8403,21.2065,2.0509,50,5,0,83,104,0,1),
        (400079,35463,654,1,4,0,0,-1763.8574,1459.3965,20.5323,1.8922,50,5,0,83,104,0,1),
        (400080,35463,654,1,4,0,0,-1757.8125,1480.0397,23.8200,4.7124,50,5,0,83,104,0,1),
        (400081,35463,654,1,4,0,0,-1761.0756,1500.0487,26.2957,3.3655,50,5,0,83,104,0,1),
        (400082,35463,654,1,4,0,0,-1763.4188,1513.9240,26.3238,1.2144,50,5,0,83,104,0,1),
        (400083,35463,654,1,4,0,0,-1740.6007,1513.7045,26.3238,0.2607,50,5,0,83,104,0,1),
        (400084,35463,654,1,4,0,0,-1729.9974,1506.1024,26.3238,3.6014,50,5,0,83,104,0,1),
        (400085,35463,654,1,4,0,0,-1728.6919,1506.8157,26.3238,0.4998,50,5,0,83,104,0,1),
        (400086,35463,654,1,4,0,0,-1738.8668,1496.9695,26.1215,2.2874,50,5,0,83,104,0,1),
        (400087,35463,654,1,4,0,0,-1739.7389,1492.9678,25.2281,1.4248,50,5,0,83,104,0,1),
        (400088,35463,654,1,4,0,0,-1730.1504,1478.3289,24.3238,4.6398,50,5,0,83,104,0,1),
        (400089,35463,654,1,4,0,0,-1715.6250,1480.2090,22.1988,3.3300,50,5,0,83,104,0,1),
        (400090,35463,654,1,4,0,0,-1715.8159,1482.1520,22.2244,4.1440,50,5,0,83,104,0,1),
        (400091,35463,654,1,4,0,0,-1803.1250,1477.2926,19.5899,1.5708,50,5,0,83,104,0,1),
        (400092,35463,654,1,4,0,0,-1808.8535,1444.2715,19.2119,1.1041,50,5,0,83,104,0,1),
        (400093,35463,654,1,4,0,0,-1788.8385,1453.4618,19.4424,4.4506,50,5,0,83,104,0,1),
        (400094,35463,654,1,4,0,0,-1756.6649,1482.3420,25.2164,4.4506,50,5,0,83,104,0,1),
        (400095,35463,654,1,4,0,0,-1762.8455,1460.2223,20.5612,4.4506,50,5,0,83,104,0,1),
        (400096,35463,654,1,4,0,0,-1762.6302,1513.9861,26.3063,4.4506,50,5,0,83,104,0,1),
        (400097,35463,654,1,4,0,0,-1791.5650,1454.6964,19.4708,3.4074,50,5,0,83,104,0,1),
        (400098,35463,654,1,4,0,0,-1763.0215,1515.1035,26.3238,1.0612,50,5,0,83,104,0,1),
        (400099,35463,654,1,4,0,0,-1741.6962,1512.9375,26.3063,4.4506,50,5,0,83,104,0,1),
        (400100,35463,654,1,4,0,0,-1761.8038,1496.2692,26.3063,4.4506,50,5,0,83,104,0,1),
        (400101,35463,654,1,4,0,0,-1805.5222,1524.3975,19.8119,1.4773,50,5,0,83,104,0,1),
        (400102,35463,654,1,4,0,0,-1744.3126,1511.6950,26.3238,3.3987,50,5,0,83,104,0,1),
        (400103,35463,654,1,4,0,0,-1795.0735,1515.3682,19.9547,3.9778,50,5,0,83,104,0,1),
        (400104,35463,654,1,4,0,0,-1729.2039,1508.9126,26.3238,2.3367,50,5,0,83,104,0,1),
        (400105,35463,654,1,4,0,0,-1761.8969,1498.1450,26.2355,2.2715,50,5,0,83,104,0,1),
        (400106,35463,654,1,4,0,0,-1730.4127,1476.9435,24.3238,4.6191,50,5,0,83,104,0,1),
        (400107,35463,654,1,4,0,0,-1805.0126,1478.9021,19.5078,2.9946,50,5,0,83,104,0,1),
        (400108,35463,654,1,4,0,0,-1760.4346,1497.1056,26.2355,5.3424,50,5,0,83,104,0,1),
        (400109,35463,654,1,4,0,0,-1789.2703,1452.3213,19.4708,0.0549,50,5,0,83,104,0,1),
        (400110,35463,654,1,4,0,0,-1796.5933,1485.7717,20.0302,2.8814,50,5,0,83,104,0,1),
        (400111,35463,654,1,4,0,0,-1806.9048,1496.6349,19.7661,4.8759,50,5,0,83,104,0,1),
        (400112,35463,654,1,4,0,0,-1806.5157,1442.9872,19.3283,5.0407,50,5,0,83,104,0,1),
        (400113,35463,654,1,4,0,0,-1806.7335,1450.2183,18.9619,1.6924,50,5,0,83,104,0,1);

        -- ---- from Lurkers_21_Distinct_Spots ----
        -- The capture s 91 lurker creates cluster (7 yd) to exactly 21 distinct
        -- spots - the same hidden worgen surfaces repeatedly as the player
        -- re-crosses its detection radius. Our 46-row set, built from the raw
        -- surfacing points, stacked near-duplicates that ganged up on contact.
        -- One stealthed lurker per retail spot, static at its lurk (captured
        -- movement was combat pursuit, not wander); stealth + creep pose ride
        -- the template addon. Spot spacing alone restores the one-by-one hunt.
        DELETE FROM `creature_movement` WHERE `id` IN (SELECT guid FROM (SELECT guid FROM `creature` WHERE `map`=654 AND `id`=35463) t);
        DELETE FROM `creature_addon` WHERE `guid` IN (SELECT guid FROM (SELECT guid FROM `creature` WHERE `map`=654 AND `id`=35463) t);
        DELETE FROM `creature` WHERE `map`=654 AND `id`=35463;
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES
        (400115,35463,654,1,4,0,0,-1789.9203,1454.1749,19.4601,2.5177,60,0,0,83,104,0,0),
        (400116,35463,654,1,4,0,0,-1788.7739,1483.9015,20.2792,4.4506,60,0,0,83,104,0,0),
        (400117,35463,654,1,4,0,0,-1806.4994,1445.4385,19.1808,4.4506,60,0,0,83,104,0,0),
        (400118,35463,654,1,4,0,0,-1800.8829,1486.2332,19.8307,4.4506,60,0,0,83,104,0,0),
        (400119,35463,654,1,4,0,0,-1756.6291,1438.5253,21.2066,2.0509,60,0,0,83,104,0,0),
        (400120,35463,654,1,4,0,0,-1763.2386,1459.8497,20.5467,1.8922,60,0,0,83,104,0,0),
        (400121,35463,654,1,4,0,0,-1756.9802,1481.5768,24.7349,4.7124,60,0,0,83,104,0,0),
        (400122,35463,654,1,4,0,0,-1761.4029,1497.5675,26.2759,3.3655,60,0,0,83,104,0,0),
        (400123,35463,654,1,4,0,0,-1807.5975,1504.8651,19.8532,4.4506,60,0,0,83,104,0,0),
        (400124,35463,654,1,4,0,0,-1763.1106,1514.267,26.3194,1.2144,60,0,0,83,104,0,0),
        (400125,35463,654,1,4,0,0,-1742.2032,1512.779,26.3179,0.2607,60,0,0,83,104,0,0),
        (400126,35463,654,1,4,0,0,-1729.5629,1506.4375,26.3173,3.6014,60,0,0,83,104,0,0),
        (400127,35463,654,1,4,0,0,-1738.9794,1495.6761,25.8002,2.2874,60,0,0,83,104,0,0),
        (400128,35463,654,1,4,0,0,-1730.2415,1477.6315,24.352,4.6398,60,0,0,83,104,0,0),
        (400129,35463,654,1,4,0,0,-1715.7205,1481.1805,22.2116,3.33,60,0,0,83,104,0,0),
        (400130,35463,654,1,4,0,0,-1790.665,1510.23,19.8961,3.2442,60,0,0,83,104,0,0),
        (400131,35463,654,1,4,0,0,-1788.848,1523.4147,20.3283,4.409,60,0,0,83,104,0,0),
        (400132,35463,654,1,4,0,0,-1802.0455,1476.3662,19.9389,1.5708,60,0,0,83,104,0,0),
        (400133,35463,654,1,4,0,0,-1805.5222,1524.3975,19.8119,1.4773,60,0,0,83,104,0,0),
        (400134,35463,654,1,4,0,0,-1795.0735,1515.3682,19.9547,3.9778,60,0,0,83,104,0,0),
        (400135,35463,654,1,4,0,0,-1806.9048,1496.6349,19.7661,4.8759,60,0,0,83,104,0,0);

        -- ---- from Lurker_Hunt_Window ----
        -- The capture opens the hunt at the 14159 turn-in (a Lurker jumps the
        -- player 36 s before 14204 is even accepted) and shuts it at the 14204
        -- turn-in (the Krennan ride crosses a lurk spot at 0.2 yd, same phase,
        -- and the server sends nothing). npc_bloodfang_lurker gates aggro on
        -- that window; npc_lorna_crowley sweeps the spots on the reward. The
        -- ten-minute respawn restages the hunt for the next character.
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (0,'npc_bloodfang_lurker',35463,0);
        UPDATE `creature` SET `spawntimesecs`=600 WHERE `map`=654 AND `id`=35463;

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
