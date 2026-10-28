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
    SET @cOldContent = '017';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '018';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Cathedral_Fight_Staging';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Capture stages 12 fighting Northgate Rebels at the Cathedral Quarter cannon battery - 5 along the upper terrace, 7 fanned across the ground; ours had';

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

        -- The cathedral fight staging after 14221.


        -- ---- from Northgate_Rebels_Battery_Fan ----
        -- The capture's phase-8 battle at the cannon battery stages twelve
        -- Northgate Rebels, every one locked in a fight: five along the upper
        -- cannon terrace (z 26.6), seven fanned across the ground below
        -- (z 20.6). Our eleven had only the three terrace spots right - the
        -- other eight sat in a knot on the staircase, three of them stacked on
        -- a single point. Re-seated on the capture's exact spots (positions
        -- and orientations to the decimal); the twelfth is new. The rebels
        -- stay stationary as captured - the surrounding Bloodfang Stalkers
        -- already wander, and drift into the fights on their own.
        UPDATE `creature` SET `position_x`=-1543.22, `position_y`=1593.94, `position_z`=26.622, `orientation`=0.253 WHERE `guid`=220014;
        UPDATE `creature` SET `position_x`=-1536.83, `position_y`=1591.83, `position_z`=26.622, `orientation`=1.29 WHERE `guid`=219672;
        UPDATE `creature` SET `position_x`=-1526.02, `position_y`=1585.35, `position_z`=26.621, `orientation`=2.418 WHERE `guid`=220013;
        UPDATE `creature` SET `position_x`=-1521.9, `position_y`=1579.77, `position_z`=26.62, `orientation`=1.164 WHERE `guid`=219668;
        UPDATE `creature` SET `position_x`=-1523.64, `position_y`=1567.74, `position_z`=26.622, `orientation`=6.186 WHERE `guid`=219670;
        UPDATE `creature` SET `position_x`=-1537.35, `position_y`=1610.78, `position_z`=20.569, `orientation`=3.39 WHERE `guid`=219667;
        UPDATE `creature` SET `position_x`=-1546.76, `position_y`=1610.11, `position_z`=20.569, `orientation`=6.246 WHERE `guid`=219673;
        UPDATE `creature` SET `position_x`=-1524.17, `position_y`=1605.84, `position_z`=20.569, `orientation`=0.888 WHERE `guid`=219665;
        UPDATE `creature` SET `position_x`=-1513.15, `position_y`=1597.8, `position_z`=20.569, `orientation`=5.271 WHERE `guid`=219669;
        UPDATE `creature` SET `position_x`=-1509.04, `position_y`=1588.5, `position_z`=20.569, `orientation`=1.861 WHERE `guid`=220015;
        UPDATE `creature` SET `position_x`=-1505.91, `position_y`=1578.25, `position_z`=20.602, `orientation`=2.82 WHERE `guid`=219671;
        INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`DeathState`,`MovementType`) VALUES
        (400136,36057,654,1,8,30275,0,-1506.04,1563.99,20.569,1.571,300,0,0,249,104,0,0);

        -- ---- from Cathedral_Fight_Post_14221 ----
        -- The cathedral battle staging opens with the 14221 turn-in, not
        -- before. The 41015 rebels and 35627 Frenzied Stalkers already sit in
        -- phase 1024 (the post-14221 chapter); these two 36057 rebels were
        -- left in phase 8 at the cathedral steps, and the plaza's wandering
        -- stalkers drifted in and started the fight a chapter early.
        UPDATE `creature` SET `phaseMask`=1024 WHERE `guid` IN (219666,219674);

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
