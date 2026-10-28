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
    SET @cOldContent = '027';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '028';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Last_Stand_Battle';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Last Stand plaza battle to the 18019 capture - stalker sparring floor 80, 30 s waves on the retail muster spots, courtyard pack mills';

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

        -- The Last Stand plaza battle: census, posts and sparring floors.


        -- ---- from Last_Stand_Battle ----
        -- Last Stand (14222): the cathedral plaza battle, from the 18019 capture.
        --
        -- What retail shows at the phase flip and over the next 90 seconds:
        --   * 8 Northgate Rebels (41015, 516/612 hp) hold the line, most created
        --     mid-combat; their health floors at ~85% (433/516, 431/516 observed) -
        --     the sparring row Rel22_07_058 already gives them.
        --   * 8 Frenzied Stalkers (35627): two on the line at ~80% health (168/204,
        --     163/204 - so the STALKERS are floored too), six milling in the east
        --     courtyard in small circles.
        --   * Every ~30 s five more rise on the SAME five muster spots by Tobias
        --     (coordinates below, byte-identical between the +17 s and +45 s waves)
        --     and charge the rebel line, 45+ yards away.
        --   * The theatre kills nobody: 236 rebel hits total 170 damage. All eight
        --     stalker deaths in the window are the player's - the quest's own count.

        -- 1. The stalkers are sparred like the rebels; the player's hits are exempt.
        DELETE FROM `creature_sparring_template` WHERE `CreatureID` = 35627;
        INSERT INTO `creature_sparring_template` (`CreatureID`, `HealthLimitPct`) VALUES
        (35627, 80);

        -- 2. Retail refills the field about every thirty seconds, not ninety.
        UPDATE `creature` SET `spawntimesecs` = 30 WHERE `id` = 35627;

        -- 3. The courtyard pack mills about in small circles instead of standing.
        UPDATE `creature` SET `MovementType` = 1, `spawndist` = 5
        WHERE `guid` IN (219730, 220040, 220041, 220681, 221032, 221033);

        -- 4. Five spawns go to the exact muster spots the capture's waves use; the
        --    script charges anything that spawns there.
        UPDATE `creature` SET `position_x` = -1556.6395, `position_y` = 1568.4559, `position_z` = 29.2848, `orientation` = 4.0719, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 219727;
        UPDATE `creature` SET `position_x` = -1553.1216, `position_y` = 1569.9879, `position_z` = 29.2848, `orientation` = 5.9111, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 220043;
        UPDATE `creature` SET `position_x` = -1554.5330, `position_y` = 1567.6285, `position_z` = 29.2848, `orientation` = 5.1637, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 220042;
        UPDATE `creature` SET `position_x` = -1552.1580, `position_y` = 1569.3750, `position_z` = 29.2848, `orientation` = 5.8169, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 219729;
        UPDATE `creature` SET `position_x` = -1553.8073, `position_y` = 1566.1493, `position_z` = 29.2848, `orientation` = 5.6351, `MovementType` = 0, `spawndist` = 0 WHERE `guid` = 219728;

        -- 5. Bind the wave script.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_frenzied_stalker';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_frenzied_stalker', 35627, 0);

        -- ---- from Last_Stand_Retail_Census ----
        -- Rel22_07_067 kept all 23 Frenzied Stalker spawns, so the cathedral held
        -- three times retail's population the moment the quest phase landed. The
        -- capture's census: 8 at the flip (TWO engaged on the rebel line, six milling
        -- by the entrance), then waves - 3 at the entrance (+5 s), 3 at the nave's
        -- west end (+14 s), 5 on the muster spots (+17 s and +45 s) - reaching 16
        -- alive by the window's end after the player's eight kills.
        --
        -- So: 16 spawns, at retail's own coordinates. The five muster and six
        -- entrance-mill spawns stand; the twelve line spawns become the two engaged
        -- ones and the three west-enders (exact create-block positions), and the
        -- surplus seven go.

        -- 1. The engaged pair on the rebel line.
        UPDATE `creature` SET `position_x` = -1583.9185, `position_y` = 1536.9521, `position_z` = 29.2243, `orientation` = 2.6442 WHERE `guid` = 221363;
        UPDATE `creature` SET `position_x` = -1586.8597, `position_y` = 1539.8812, `position_z` = 29.2273, `orientation` = 4.3835 WHERE `guid` = 221370;

        -- 2. The three at the nave's west end.
        UPDATE `creature` SET `position_x` = -1601.5200, `position_y` = 1520.1500, `position_z` = 29.3230, `orientation` = 0.8203 WHERE `guid` = 221360;
        UPDATE `creature` SET `position_x` = -1609.7048, `position_y` = 1527.1598, `position_z` = 29.3123, `orientation` = 5.9690 WHERE `guid` = 221364;
        UPDATE `creature` SET `position_x` = -1592.3629, `position_y` = 1537.8351, `position_z` = 29.3142, `orientation` = 3.4382 WHERE `guid` = 221354;

        -- 3. The surplus seven.
        DELETE FROM `creature` WHERE `guid` IN (221099, 221100, 221176, 221179, 221181, 221184, 221365);

        -- ---- from Last_Stand_No_Accept_Summons ----
        -- The cathedral still held twice the census after Rel22_07_068, and the wire
        -- said why: the stock world DB ships `quest_template`.`StartScript` = 14222,
        -- whose `db_scripts` block SUMMONS 15 more Frenzied Stalkers and 6 more
        -- Northgate Rebels as 120-second temporaries every time the quest is
        -- accepted - the packet log showed them arriving with temp-summon guids on
        -- top of the 16 + 8 static spawns. It was the old approximation of this
        -- battle; the static spawns, the sparring floors and the wave script are the
        -- capture-accurate replacement, so the accept-summons go.
        --
        -- The quest's `CompleteScript` (script_type 1: 72799, the teleport to
        -- Duskhaven, 68996) is left exactly as it is - that is the turn-in
        -- transition, and today it is the only thing moving the player to chapter 5.
        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 14222;
        UPDATE `quest_template` SET `StartScript` = 0 WHERE `entry` = 14222;

        -- ---- from Last_Stand_Stock_Positions ----
        -- Walk back the MoP-capture coordinate experiment. 067/068 moved ten
        -- Frenzied Stalker spawns onto positions read out of the 18019 (Mists client)
        -- capture; the 4.3.4 cathedral did not agree with all of them in play. The
        -- stock 4.3.4 positions from FullDB/creature.sql return - they were placed
        -- against OUR world model - and the wave-charge script is unbound with them:
        -- TC's 4.3.4 preservation tree stages this battle exactly this way, static
        -- spawns with both sides sparred, no scripted waves. What stays from the
        -- capture work: the 16-spawn census, the 30 s respawn, the courtyard wander
        -- and the 80/85 sparring floors.
        UPDATE `creature` SET `position_x` = -1559.12, `position_y` = 1569.80, `position_z` = 29.1958, `orientation` = 1.67506  WHERE `guid` = 219727;
        UPDATE `creature` SET `position_x` = -1551.22, `position_y` = 1553.85, `position_z` = 29.1871, `orientation` = 0.868762 WHERE `guid` = 219728;
        UPDATE `creature` SET `position_x` = -1558.76, `position_y` = 1549.10, `position_z` = 29.1913, `orientation` = 2.84384  WHERE `guid` = 219729;
        UPDATE `creature` SET `position_x` = -1550.79, `position_y` = 1562.45, `position_z` = 29.2167, `orientation` = 4.93044  WHERE `guid` = 220042;
        UPDATE `creature` SET `position_x` = -1558.62, `position_y` = 1569.09, `position_z` = 29.1981, `orientation` = 3.40092  WHERE `guid` = 220043;
        UPDATE `creature` SET `position_x` = -1594.87, `position_y` = 1533.80, `position_z` = 29.2258, `orientation` = 1.3982   WHERE `guid` = 221354;
        UPDATE `creature` SET `position_x` = -1596.87, `position_y` = 1522.53, `position_z` = 29.2431, `orientation` = 0.473134 WHERE `guid` = 221360;
        UPDATE `creature` SET `position_x` = -1591.22, `position_y` = 1537.84, `position_z` = 29.2290, `orientation` = 0.00253  WHERE `guid` = 221363;
        UPDATE `creature` SET `position_x` = -1597.21, `position_y` = 1524.86, `position_z` = 29.2418, `orientation` = 6.10129  WHERE `guid` = 221364;
        UPDATE `creature` SET `position_x` = -1590.64, `position_y` = 1535.88, `position_z` = 29.2232, `orientation` = 0.568065 WHERE `guid` = 221370;

        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_frenzied_stalker';

        -- ---- from Last_Stand_Post_Assignment ----
        -- Rebind the Frenzied Stalker AI, rewritten from the charge experiment into
        -- post assignment: a stalker with no target seeks the nearest Northgate Rebel
        -- that has no stalker on him, walks over - through the door if it waits
        -- outside - and fights AT that post; assist calls are swallowed so the room
        -- can never collapse into one melee ball again; death sends the replacement
        -- in from the entrance. One wolf per guard, eight fights spread across the
        -- nave, the spares visibly queueing - which is the retail picture.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_frenzied_stalker';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_frenzied_stalker', 35627, 0);

        -- ---- from Northgate_Rebels_Hold_Posts ----
        -- The stalker side of the battle held after Rel22_07_071, but the REBELS
        -- still packed into one knot: their default AI chased whatever they aggroed
        -- and answered every assist call, walking all eight off their posts. Their
        -- spawn rows were never the problem - they match the retail capture's create
        -- blocks to the decimal. `npc_northgate_rebel` plants them: fight whatever
        -- stands in front, never take a step, ignore assist calls, and turn to face
        -- the current wolf. The stalker AI now allows TWO wolves per rebel, the
        -- retail pairing.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_northgate_rebel';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_northgate_rebel', 41015, 0);

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
