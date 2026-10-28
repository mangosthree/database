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
    SET @cOldContent = '018';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '019';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Gilneas_Phase_Audit';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Phase audit vs 18019 captures: late-chapter casts spawned at mask 1 moved to their retail chapters (plague op, gunship fleet, war wolves, battle)';

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

        -- Re-phase the Gilneas spawns per the phase audit.


        -- ---- from Gilneas_Mask1_Rephase ----
        -- Phase-alignment audit vs the 18019 retail captures: these spawns sit
        -- at phaseMask 1 (or a city mask) but belong to late chapters. A normal
        -- player saw them haunting the pre-Lockdown city and missed them in
        -- their own chapter; GM mode (PHASEMASK_ANYWHERE) masked the bug.
        -- Chapter 11 plague operation (retail phase 188).
        UPDATE `creature` SET `phaseMask`=524288 WHERE `map`=654 AND `id` IN (38364,38344,38389,38365,37892) AND `phaseMask`=1;
        -- Chapter 9 battle support cast (retail 187).
        UPDATE `creature` SET `phaseMask`=262144 WHERE `map`=654 AND `id` IN (38425,38192,38467,38465) AND `phaseMask`=1;
        -- Chapter 13 gunship and harbor fleet (retail 191).
        UPDATE `creature` SET `phaseMask`=4194304 WHERE `map`=654 AND `id` IN (42141,43566,43651,43703,43764,43767,43791,43793,43718,40350) AND `phaseMask`=1;
        -- Chapter 12 Horde cavalry (retail 189; the capture shows 101 concurrent).
        UPDATE `creature` SET `phaseMask`=1048576 WHERE `map`=654 AND `id`=37939 AND `phaseMask`=1;
        -- Duskhaven-era strays (retail 181-183).
        UPDATE `creature` SET `phaseMask`=20480 WHERE `map`=654 AND `id`=36200 AND `phaseMask`=1;
        UPDATE `creature` SET `phaseMask`=16384 WHERE `map`=654 AND `id`=36528 AND `phaseMask`=1;
        UPDATE `creature` SET `phaseMask`=4096 WHERE `map`=654 AND `id`=51589 AND `phaseMask`=1;
        -- Chapter 8 Blackwald ambient wildlife and Benjamin Sykes (retail 186).
        UPDATE `creature` SET `phaseMask`=131072 WHERE `map`=654 AND `id` IN (17467,36882,6827,42953) AND `phaseMask`=1;
        -- The parked crash-site tableau (Cataclysm scene 184 + chapter 8):
        -- position-scoped so the city twins of Marie and Gwen stay untouched.
        UPDATE `creature` SET `phaseMask`=163840 WHERE `map`=654 AND `id` IN (36138,51409) AND `phaseMask`=1;
        UPDATE `creature` SET `phaseMask`=163840 WHERE `map`=654 AND `id` IN (38853,44460) AND `position_y`>2000;

        -- ---- from Gilneas_Allmask_Rephase ----
        -- The phaseMask 4294967295 (all-phase) roster vs retail sightings.
        -- KEPT all-phase deliberately: 4075 Rat (seen in 13 of 15 retail
        -- windows), 39660 Spirit Healer (dead-only visibility), 35374/36198/
        -- 36286 multiphase triggers, 37953 Dark Scout (our ambush script).
        -- Ambient critters get the chapters the captures actually show them in.
        UPDATE `creature` SET `phaseMask`=1101824 WHERE `map`=654 AND `id`=385   AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=1048576 WHERE `map`=654 AND `id`=620   AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=1179648 WHERE `map`=654 AND `id` IN (883,1933) AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=147456  WHERE `map`=654 AND `id`=1412  AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=131072  WHERE `map`=654 AND `id` IN (1420,2914) AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=53248   WHERE `map`=654 AND `id`=36714 AND `phaseMask`=4294967295;
        UPDATE `creature` SET `phaseMask`=4096    WHERE `map`=654 AND `id`=38881 AND `phaseMask`=4294967295;
        -- Gilnean Crows: city and Duskhaven chapters; gone after the Cataclysm.
        UPDATE `creature` SET `phaseMask`=54287   WHERE `map`=654 AND `id`=50260 AND `phaseMask`=4294967295;
        -- Evacuation facing markers: chapter 0-1 only (the evac script searches
        -- them from phase 2, so both bits stay).
        UPDATE `creature` SET `phaseMask`=3       WHERE `map`=654 AND `id` IN (35010,35011,35830) AND `phaseMask`=4294967295;

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
