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
    SET @cOldContent = '019';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '020';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Flood_Phase_Scrub';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'The Exodus-era flooded city (phase 131072) still showed rats, doors, gathering nodes and the whole Battle-for-Gilneas cast standing in the water';

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

        -- Scrub the flooded-city and sunken-Duskhaven phases.
        --
        -- The last two files are surgical corrections to the first three, not
        -- reversals, so all five statement groups run in their original order.


        -- ---- from Flooded_City_Phase_Scrub ----
        -- During Exodus the city terrain swaps to the flooded version (phase
        -- 131072) but broad-mask spawns swam on: 51 all-phase rats, the
        -- Merchant Square doors and gathering nodes, and the entire Battle for
        -- Gilneas City cast (mask 393216 = 262144|131072) standing on the
        -- seabed. Strip ONLY the flood bit, only inside the city box; the
        -- battle chapters (262144+) keep their staging, spirit healers and
        -- invisible script triggers stay all-phase, and rows set to exactly
        -- 131072 are deliberate flood content and untouched.
        UPDATE `creature` SET `phaseMask` = `phaseMask` & ~131072
          WHERE `map`=654 AND `position_x` BETWEEN -1950 AND -1250 AND `position_y` BETWEEN 1150 AND 1720
            AND (`phaseMask` & 131072) AND `phaseMask` != 131072
            AND `id` NOT IN (39660, 35374);
        UPDATE `gameobject` SET `phaseMask` = `phaseMask` & ~131072
          WHERE `map`=654 AND `position_x` BETWEEN -1950 AND -1250 AND `position_y` BETWEEN 1150 AND 1720
            AND (`phaseMask` & 131072) AND `phaseMask` != 131072;

        -- ---- from Sunken_Duskhaven_Phase_Scrub ----
        -- Duskhaven is swallowed by the sea at the cataclysm (phase 131072)
        -- and stays sunk through every later chapter (262144..4194304). The
        -- town''s all-phase props - stoves, fires, cookpot, forge, anvil, the
        -- Wahl Cottage / Allen Farmstead / Hayward Fishery / Crowley Orchard /
        -- Duskhaven / Greymane Manor / Queen''s Gate signposts - plus rats,
        -- squirrels and deer with composite masks all floated over the crater.
        -- Strip every post-sinking bit (131072|262144|524288|1048576|2097152|
        -- 4194304 = 8257536) inside the town box; spirit healers and invisible
        -- script triggers stay all-phase.
        UPDATE `gameobject` SET `phaseMask` = `phaseMask` & ~8257536
          WHERE `map`=654 AND `position_x` BETWEEN -2110 AND -1780 AND `position_y` BETWEEN 2150 AND 2460
            AND (`phaseMask` & 8257536) AND (`phaseMask` & ~8257536) != 0;
        UPDATE `creature` SET `phaseMask` = `phaseMask` & ~8257536
          WHERE `map`=654 AND `position_x` BETWEEN -2110 AND -1780 AND `position_y` BETWEEN 2150 AND 2460
            AND (`phaseMask` & 8257536) AND (`phaseMask` & ~8257536) != 0
            AND `id` NOT IN (39660, 35374, 36198);

        -- ---- from Sunken_Duskhaven_Deer ----
        -- Two deer at (-2018, 2206) and (-2028, 2315) exist ONLY in the
        -- post-sinking phases (1179648 = flood | Livery era) - inside the
        -- drowned crater in both. The 179 scrub protects rows from being
        -- zeroed out; for these the right answer is removal.
        DELETE FROM `creature` WHERE `guid` IN (219269, 219833);

        -- ---- from Flank_Rally_Cast_Restored ----
        -- Correction to 178. The 393216 cast at the city's southeastern shore
        -- is not battle-only: 131072|262144 is deliberate - the flank arc
        -- (Flank the Forsaken, 24677, and the rally quests 24575/24674/24675/
        -- 24676) plays in the 131072 window, Lord Hewell's horse taxi lands at
        -- this camp, and Lorna 37783 there is 24677's ender. The 178 strip
        -- emptied the camp for flank-arc players. Rats, doors and gathering
        -- nodes stay stripped - those were the real floaters.
        UPDATE `creature` SET `phaseMask`=393216
          WHERE `map`=654 AND `position_x` BETWEEN -1950 AND -1250 AND `position_y` BETWEEN 1150 AND 1720
            AND `phaseMask`=262144
            AND `id` IN (37784,38468,38796,38798,42853,37783,44463,38793,38553,38797,38799,37803,38143);

        -- ---- from Shore_Ambience_Restored ----
        -- The rest of the 178 audit. The deer and brown stags graze SOUTH of
        -- the city walls (y 1168-1191) and three gathering nodes sit on the
        -- dry southeastern shore by the rally camp - all outside the water,
        -- all wrongly caught by the flood scrub. Restored. Everything else the
        -- scrubs touched has been verified to stand in the drowned bowl or the
        -- Duskhaven crater and stays stripped.
        UPDATE `creature` SET `phaseMask`=1179648
          WHERE `map`=654 AND `id` IN (883, 37786) AND `phaseMask`=1048576
            AND `position_y` < 1200 AND `position_x` BETWEEN -1600 AND -1400;
        UPDATE `gameobject` SET `phaseMask`=4294967295
          WHERE `map`=654 AND `phaseMask`=4294836223
            AND `id` IN (1617, 1619, 1731) AND `position_y` < 1230;

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
