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
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '002';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Manor_Gate_Stagecoach';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Manor road: the estate gate (196863) and the Stagecoach Carriage (44928) were stuck in phase 1 - invisible for the whole ride chapter';

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

        -- The manor gate stagecoach and its full crew.


        -- ---- from Manor_Gate_Stagecoach ----
        -- The manor road set-dressing was phase-stranded: the estate gate GO
        -- (196863, astride the first bend of the horse ride) and the Stagecoach
        -- Carriage (44928, the other half of the harness+carriage pair at the
        -- gate) both spawned with phaseMask 1 - invisible in every ride chapter.
        -- The harness (38755) already spans 180224; align its carriage, and give
        -- the gate the all-phases mask. The ride script now swings the gate open
        -- as the horse bears down on it.
        UPDATE `gameobject` SET `phaseMask` = 4294967295 WHERE `guid` = 166783;
        UPDATE `creature` SET `phaseMask` = 180224 WHERE `guid` = 219213;

        -- ---- from Upper_Gate_Carriage_Seat ----
        -- The upper manor gate is a door+button pair (196401/196864) stranded in
        -- phases 7 and 1 - invisible through the ride chapters; promote both. And
        -- the Stagecoach Carriage is not floor scenery: the capture seats it as
        -- the ACCESSORY of the Stagecoach Harness vehicle (seat 2, transport
        -- offset zero). Delete the standalone carriage spawn and let the vehicle
        -- system assemble the coach.
        UPDATE `gameobject` SET `phaseMask` = 4294967295 WHERE `id` IN (196401, 196864) AND `map` = 654 AND ABS(`position_x` - -1682) < 5;

        DELETE FROM `creature` WHERE `guid` = 219213;
        DELETE FROM `vehicle_accessory` WHERE `vehicle_entry` = 38755;
        INSERT INTO `vehicle_accessory` (`vehicle_entry`, `seat`, `accessory_entry`, `comment`) VALUES
        (38755, 2, 44928, 'Stagecoach Harness carries the Stagecoach Carriage (capture: seat 2, zero offset)');

        -- ---- from Stagecoach_Full_Crew ----
        -- The evacuation stagecoach, fully assembled per the capture: the harness
        -- (38755) pulls with two Stagecoach Horses (43338, seats 0 and 1) and
        -- carries the carriage (44928, seat 2 - Rel22_07_098); the carriage in
        -- turn seats the survivors of Duskhaven - Marie Allen, Gwen Armstead,
        -- Krennan Aranas, two Duskhaven Watchmen and Lorna Crowley (seats 1-6).
        DELETE FROM `vehicle_accessory` WHERE `vehicle_entry` IN (38755, 44928);
        INSERT INTO `vehicle_accessory` (`vehicle_entry`, `seat`, `accessory_entry`, `comment`) VALUES
        (38755, 0, 43338, 'Stagecoach Harness - left horse'),
        (38755, 1, 43338, 'Stagecoach Harness - right horse'),
        (38755, 2, 44928, 'Stagecoach Harness carries the Stagecoach Carriage'),
        (44928, 1, 38853, 'Stagecoach Carriage - Marie Allen'),
        (44928, 2, 44460, 'Stagecoach Carriage - Gwen Armstead'),
        (44928, 3, 36138, 'Stagecoach Carriage - Krennan Aranas'),
        (44928, 4, 43907, 'Stagecoach Carriage - Duskhaven Watchman'),
        (44928, 5, 37946, 'Stagecoach Carriage - Duskhaven Watchman'),
        (44928, 6, 51409, 'Stagecoach Carriage - Lorna Crowley');

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
