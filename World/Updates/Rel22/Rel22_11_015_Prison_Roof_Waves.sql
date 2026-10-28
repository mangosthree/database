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
    SET @cOldContent = '014';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '015';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Prison_Roof_Waves';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Bind the prison roof wave worgen so the summoned copies leap the gap onto Crowleys roof instead of idling where they land';

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

        -- Stage the prison roof waves on retail timing.


        -- ---- from Prison_Roof_Worgen_Leap ----
        -- Rel22_07_022 fixed the timer and the credit for `By the Skin of His Teeth`
        -- (14154), but the waves still only stood where they were put. The quest's
        -- summon script stages them on the neighbouring rooftops, 53 to 67 yards from
        -- Lord Darius Crowley, which is far outside any aggro radius - a server trace
        -- of a full run showed all 54 summons firing without error and not one of them
        -- ever entering combat.
        --
        -- Pathing cannot bring them in; the roofs are separate structures with drops
        -- between them. `npc_prison_roof_worgen` gives each summoned copy a single
        -- `MoveJump` onto the summoner's position, which is Crowley and therefore the
        -- roof being defended. That primitive is both what the scene wants and the one
        -- that ignores navmesh connectivity, so the gap stops mattering. Landing on
        -- the defenders is enough to start the fight - ScriptedAI's own
        -- MoveInLineOfSight takes the target from there.
        --
        -- All four entries are also spawned around Gilneas as ordinary mobs, so the
        -- AI gates the leap on IsTemporarySummon(); only the copies the quest script
        -- throws out cross to the roof, and the ambient ones are left alone.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_prison_roof_worgen';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_prison_roof_worgen', 35167, 0),   -- Worgen Alpha
        (0, 'npc_prison_roof_worgen', 35170, 0),   -- Worgen Alpha
        (0, 'npc_prison_roof_worgen', 35188, 0),   -- Worgen Runt
        (0, 'npc_prison_roof_worgen', 35456, 0);   -- Worgen Runt

        -- ---- from Prison_Roof_Squatters ----
        -- The engine trace caught them: 22 permanent world spawns of the
        -- prison-event worgen (35456/35167/35170/35188) sit at the EXACT wave
        -- staging positions on the roofs, wandering at walk pace in chapters
        -- 0-1 - TDB imported captured event actors as world spawns. They
        -- interleave with the real waves and read as broken wave behavior.
        -- Retail shows the roofs empty between waves.
        DELETE FROM `creature_movement` WHERE `id` IN (220892,221491,221492,221493,221494,221495,221496,221497,221498,221499,221500,221501,221502,221505,221506,221507,221508,221509,221510,221511,221512,221513);
        DELETE FROM `creature_addon` WHERE `guid` IN (220892,221491,221492,221493,221494,221495,221496,221497,221498,221499,221500,221501,221502,221505,221506,221507,221508,221509,221510,221511,221512,221513);
        DELETE FROM `creature` WHERE `guid` IN (220892,221491,221492,221493,221494,221495,221496,221497,221498,221499,221500,221501,221502,221505,221506,221507,221508,221509,221510,221511,221512,221513);

        -- ---- from Prison_Waves_Retail_Timing ----
        -- The captured retail schedule for By the Skin of His Teeth, offsets
        -- from the quest accept: a lone alpha at +2s and +60s, three waves of
        -- seven house-roof runts plus a perch alpha (+31s, +89s, +185s), and
        -- the +214s finale - nine runts gliding off the tower with the spell
        -- runt, plus one house straggler. Thirty-six summons in retail rhythm;
        -- waves three and four land AFTER the two-minute timer, so the assault
        -- theatrically continues past the turn-in, exactly as captured. This
        -- replaces the imported drip of 52 alpha-heavy singles.
        DELETE FROM `db_scripts` WHERE `script_type`=0 AND `id`=14154 AND `command`=10;
        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `x`, `y`, `z`, `o`, `comments`) VALUES
        (0, 14154, 2, 10, 35170, 120000, -1607.9341, 1499.3767, 68.8139, 3.9791, 'lone alpha east perch'),
        (0, 14154, 31, 10, 35167, 120000, -1620.1620, 1509.9991, 67.1256, 3.9192, 'wave 1 alpha perch'),
        (0, 14154, 31, 10, 35456, 120000, -1718.2622, 1518.5573, 55.5595, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1717.7500, 1513.7274, 55.4794, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1709.6302, 1527.4635, 56.8609, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1729.3455, 1526.4948, 55.4796, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1718.1041, 1524.0712, 55.8164, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1713.9740, 1526.6250, 56.2198, 4.6775, 'wave 1 house runt'),
        (0, 14154, 31, 10, 35456, 120000, -1724.7188, 1526.7310, 55.6618, 4.6775, 'wave 1 house runt'),
        (0, 14154, 60, 10, 35170, 120000, -1609.1117, 1498.0695, 68.5817, 3.9791, 'lone alpha east perch'),
        (0, 14154, 89, 10, 35167, 120000, -1619.5980, 1510.5543, 67.1402, 3.9192, 'wave 2 alpha perch'),
        (0, 14154, 89, 10, 35456, 120000, -1718.2622, 1518.5573, 55.5595, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1717.7500, 1513.7274, 55.4794, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1709.6302, 1527.4635, 56.8609, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1729.3455, 1526.4948, 55.4796, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1718.1041, 1524.0712, 55.8164, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1713.9740, 1526.6250, 56.2198, 4.6775, 'wave 2 house runt'),
        (0, 14154, 89, 10, 35456, 120000, -1724.7188, 1526.7310, 55.6618, 4.6775, 'wave 2 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1718.2622, 1518.5573, 55.5595, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1717.7500, 1513.7274, 55.4794, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1709.6302, 1527.4635, 56.8609, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1729.3455, 1526.4948, 55.4796, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1718.1041, 1524.0712, 55.8164, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1713.9740, 1526.6250, 56.2198, 4.6775, 'wave 3 house runt'),
        (0, 14154, 185, 10, 35456, 120000, -1724.7188, 1526.7310, 55.6618, 4.6775, 'wave 3 house runt'),
        (0, 14154, 188, 10, 35167, 120000, -1636.2845, 1494.1252, 67.4367, 3.9192, 'wave 3 alpha tower ledge'),
        (0, 14154, 214, 10, 35188, 120000, -1635.6514, 1482.7128, 72.4233, 4.0812, 'finale spell runt'),
        (0, 14154, 214, 10, 35456, 120000, -1634.3438, 1491.3004, 70.1010, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1627.2726, 1499.6892, 68.8940, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1622.6649, 1489.8177, 71.0380, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1631.9791, 1491.5851, 71.1148, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1622.4236, 1483.8820, 67.6738, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1630.3993, 1481.6598, 71.4152, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1638.5695, 1489.7361, 68.5527, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1625.6198, 1487.0330, 71.2776, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1618.0538, 1489.6442, 68.4515, 4.6775, 'finale tower glide runt'),
        (0, 14154, 214, 10, 35456, 120000, -1720.6528, 1526.7084, 55.9107, 4.6775, 'finale house straggler');

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
