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
    SET @cOldContent = '021';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '022';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Cannon_Camera_Scene';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fire the cannon camera on the 14293 turn-in: the seat itself selects CameraMode 150, so only the forcecast stub needed rows';

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

        -- The Bloodfang cannon camera scene and the muster it fires on.


        -- ---- from Gilneas_Cannon_Camera ----
        -- The cannon shot at the end of `Save Krennan Aranas` (14293).
        --
        -- It is not a cinematic in the CinematicSequences sense, and the server sends
        -- no camera opcode at all. The whole thing is spell driven and the camera is
        -- chosen by the client from the SEAT it puts the player in:
        --
        --   quest 14293 RewSpellCast = 93555 `Forcecast Cannon Camera`
        --     -> 93522 `Cannon Camera`, SUMMON 50420 under SummonProperties 161,
        --        which is summon group 4 - a VEHICLE, so `Spell::DoSummonVehicle`
        --        boards the caster exactly as Greymane's horse does
        --     -> creature 50420 `Gilneas - Cannon Camera` has VehicleTemplateId 1418
        --     -> Vehicle 1418 has one seat, 9351
        --     -> VehicleSeat 9351 carries CameraMode 150 in the trailing field this
        --        core does not map (column 64 of 66; verified as the camera reference
        --        because all 241 non-zero values in it resolve to a CameraMode row)
        --     -> CameraMode.dbc 150 `Gilneas - Cannon Camera`:
        --            eye     -1768.83  1426.68  27.90
        --            look at -1768.81  1422.30  25.70
        --            fov     65
        --
        -- So there is nothing to script but the first link. 93522 runs 7000 ms, which
        -- is the length of the shot, and seat 9351 does NOT carry SEAT_FLAG_CAN_CONTROL
        -- (flags 0x8000), so the player rides as a plain passenger and is released when
        -- the summon expires - no control handover either way.
        --
        -- `SPELL_EFFECT_FORCE_CAST` is stubbed in this core into
        --     m_caster->GetMap()->ScriptsStart(DBS_ON_SPELL, m_spellInfo->ID, ...)
        -- with the player as source and target, so 93555 already starts a script of
        -- type 5; it simply had no rows. Same shape as Rel22_07_029 for the cellar.
        DELETE FROM `db_scripts` WHERE `script_type` = 5 AND `id` = 93555;

        -- Godfrey's line, from the retail text.
        DELETE FROM `db_script_string` WHERE `entry` = 2000005308;
        INSERT INTO `db_script_string` (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (2000005308, 'We''ve got Aranas! Fire at will!', 0, 1, 0, 0, 'lord godfrey - orders the cannons to open fire, quest 14293 turn-in');

        INSERT INTO `db_scripts`
            (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `x`, `y`, `z`, `o`, `comments`) VALUES
        -- The buddy becomes the SOURCE unless SCRIPT_FLAG_BUDDY_AS_TARGET is set, which
        -- is what puts the words in Godfrey's mouth rather than the player's.
        (5, 93555, 0, 0,     0, 0, 35906, 60, 0, 2000005308, 0, 0, 0, 0, 'Lord Godfrey gives the order'),
        -- Triggered: the player is mid quest-reward and this must not be refused.
        (5, 93555, 0, 15, 93522, 0,     0,  0, 8,          0, 0, 0, 0, 0, 'The cannon camera takes over for seven seconds');

        -- ---- from Gilneas_Cannons_Fire ----
        -- Make the cannons actually fire during the shot at the end of `Save Krennan
        -- Aranas` (14293). Timings and target come from a retail capture of this exact
        -- sequence (Worgen Hunter, build 18019, Gilneas City), measured from the
        -- turn-in:
        --     +1.06s  93522 Cannon Camera
        --     +1.53s  phase flips; the Commandeered Cannons appear
        --     +5.09s  Cannon Fire
        --     +6.60s  Cannon Fire
        --     +10.33s Cannon Fire
        -- Three shots, and `db_scripts`.`delay` is in seconds, so 5 / 7 / 10.
        --
        -- 1. The cannon needs somewhere to aim. 68235 `Cannon Fire` is
        --    SPELL_EFFECT_TRIGGER_MISSILE at TARGET_SCRIPT_COORDINATES (46), which
        --    reads `spell_script_target` - the same mechanism the Krennan rescue needed
        --    in Rel22_07_038 - and it had no row, so the cannon had nothing to shoot at.
        --
        --    The target is 50471 `Afflicted Gilnean`: faction 2179, the same hostile
        --    faction as the Bloodfang worgen, and 42 of them are already spawned in
        --    phaseMask 8 - the phase this scene runs in - between 54 and 159 yards up
        --    the approach from the cannon. 68235 reaches 150 yards (SpellRange 152), so
        --    the nearest of them is well inside it, and the missile it triggers, 68236,
        --    carries a 32 yard radius. The cannon fires on the advancing horde.
        DELETE FROM `spell_script_target` WHERE `entry` = 68235;
        INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`, `inverseEffectMask`) VALUES
        (68235, 1, 50471, 0);

        -- 2. The shots themselves, hung off the same forcecast script that starts the
        --    camera. The buddy becomes the SOURCE unless SCRIPT_FLAG_BUDDY_AS_TARGET is
        --    set, so 35914 `Commandeered Cannon` is what casts; the nearer of the two is
        --    the one the camera is pointed at, 16.5 yards from its eye. Triggered,
        --    because a vehicle mid-scene should not be able to refuse the cast.
        DELETE FROM `db_scripts` WHERE `script_type` = 5 AND `id` = 93555 AND `command` = 15 AND `datalong` = 68235;
        INSERT INTO `db_scripts`
            (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `x`, `y`, `z`, `o`, `comments`) VALUES
        (5, 93555,  5, 15, 68235, 0, 35914, 60, 8, 0, 0, 0, 0, 0, 'The cannon opens fire'),
        (5, 93555,  7, 15, 68235, 0, 35914, 60, 8, 0, 0, 0, 0, 0, 'Second shot'),
        (5, 93555, 10, 15, 68235, 0, 35914, 60, 8, 0, 0, 0, 0, 0, 'Third shot, as the camera lets go');

        -- ---- from Cannon_Aims_At_Rippers ----
        -- The cannons were firing the wrong way. Rel22_07_044 aimed 68235 at 50471
        -- `Afflicted Gilnean`, which is the horde advancing on the barricade - 54 yards
        -- and more to the NORTH. The cannon points the other way.
        --
        -- The real target was already in the data, unspawned in the scene's phase.
        -- 35916 `Bloodfang Ripper` - a separate entry from the 35505 rippers, and part
        -- of the cannon block 35914 / 35915 / 35916 - has 13 spawns scattered from 1.4
        -- to 42 yards around the point the cannon actually looks at, two of them
        -- practically on it. The geometry is unambiguous:
        --     cannon 219587 at -1768.82 1410.16, orientation 5.236
        --     bearing from it to the nearest 35916  = 5.259
        -- and the distance is 30 yards, comfortably inside 68235's 150 yard range.
        --
        -- Every one of those 13 sits on phaseMask 1, so in phase 8 - the phase this
        -- scene runs in - the cannon was aiming at an empty street. The same mistake
        -- the spell focus made in Rel22_07_040, and the same fix: ADD the scene's phase
        -- rather than replace what is there. 1|8 = 9.
        UPDATE `creature` SET `phaseMask` = 9 WHERE `id` = 35916 AND `phaseMask` = 1;

        -- And point the shot at them instead of at the horde behind the camera.
        DELETE FROM `spell_script_target` WHERE `entry` = 68235;
        INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`, `inverseEffectMask`) VALUES
        (68235, 1, 35916, 0);

        -- ---- from Cannon_Casts_On_Itself ----
        -- The cannons still did not fire. The script steps ran on time - the trace shows
        -- command 15 at the right moments and no buddy failure - but no SMSG_SPELL_START
        -- or SMSG_SPELL_GO for 68235 ever went out, so the cast was refused rather than
        -- skipped.
        --
        -- The cast was aimed at the PLAYER, because a db_scripts cast sends
        --     pSource->CastSpell(pTarget, spell, triggered)
        -- and the target of this script is the player. 68235 does not want a unit at
        -- all: it is SPELL_EFFECT_TRIGGER_MISSILE at TARGET_SCRIPT_COORDINATES, and
        -- `Spell::CheckCast` only consults `spell_script_target` when nothing has
        -- claimed the target list yet:
        --     // Database based targets from spell_target_script
        --     if (m_UniqueTargetInfo.empty())
        -- Handing it the player fills that list, the search for the Bloodfang Rippers
        -- never runs, the missile has no destination, and a triggered spell that fails
        -- returns SPELL_FAILED_DONT_REPORT - silently, which is exactly what we saw.
        --
        -- SCRIPT_FLAG_SOURCE_TARGETS_SELF (0x04) points the cast back at the cannon, so
        -- nothing foreign is in the target list and the script target search is free to
        -- pick the nearest ripper. 0x08 | 0x04 = 12.
        UPDATE `db_scripts` SET `data_flags` = 12
        WHERE `script_type` = 5 AND `id` = 93555 AND `command` = 15 AND `datalong` = 68235;

        -- ---- from Rippers_Run_Not_Walk ----
        -- Bind the script that makes the cannon's targets actually charge it.
        --
        -- Rel22_07_046 gave them a path in to the cannon, taken from the retail
        -- capture, and they walked it. A waypoint leg only runs for a creature holding
        -- UNIT_STAT_RUNNING:
        --     m_legWalk = !creature.hasUnitState(UNIT_STAT_RUNNING_STATE) && ...
        -- `Creature::Create` starts everything walking, only `SetWalk(enable, true)`
        -- reaches that state, and nothing in `creature` or `creature_template` exposes
        -- it - so this cannot be done from data alone.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_bloodfang_ripper_cannon';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_bloodfang_ripper_cannon', 35916, 0);

        -- ---- from Rippers_Respawn_Quickly ----
        -- The cannon kills its targets, which is the point - but they were on
        -- `spawntimesecs` 300, so the scene stripped itself bare and stayed that way
        -- for five minutes. Running it twice in a row left one ripper alive out of
        -- thirteen, and with only one living target the second and third shells had
        -- nothing to aim at either: the search behind TARGET_SCRIPT_COORDINATES is
        --     NearestCreatureEntryWithLiveStateInObjectRangeCheck(..., onlyAlive = true, ...)
        -- so a field of corpses reads as an empty field. One shot, one worgen.
        --
        -- Twenty seconds keeps the assault replenishing at about the rate the cannon
        -- destroys it, so the scene is populated whenever a player reaches it rather
        -- than only the first time.
        UPDATE `creature` SET `spawntimesecs` = 20 WHERE `id` = 35916;

        -- ---- from Rippers_Charge_On_Cue ----
        -- Take the patrol back off the rippers; the charge is scripted now.
        --
        -- Rel22_07_046 and _049 gave them a waypoint path in to the cannon and back.
        -- That can never line up with the shot: a patrol runs on its own clock, so
        -- where the pack stood when a player turned the quest in was luck, and they
        -- were often already at the far end before a shell was fired. `MovementType` 2
        -- also respawns a creature at its CURRENT waypoint rather than its spawn, which
        -- is why they came back standing on the impact point.
        --
        -- The retail capture has no patrol in it - each ripper makes one long move as
        -- the scene begins, 57 yards down to 24. `npc_bloodfang_ripper_cannon` now does
        -- exactly that, triggered by the cannon camera being summoned, so they wait at
        -- the muster until there is something to charge into.
        UPDATE `creature` SET `MovementType` = 0, `currentwaypoint` = 0 WHERE `id` = 35916;
        DELETE FROM `creature_movement` WHERE `id` IN (SELECT `guid` FROM `creature` WHERE `id` = 35916);

        -- ---- from Rippers_Open_Formation ----
        -- Open the pack out. Thirteen rippers were mustering on a front eight yards
        -- wide and arriving on top of each other.
        --
        -- Half of that was the charge itself, which is fixed in the script: aiming
        -- every one of them at the cannon converged their paths, so a front eight yards
        -- wide at fifty yards out arrived under four wide at twenty. They now advance
        -- along their own facing by a fixed distance, which preserves whatever spacing
        -- they start with - so the spacing here is the whole formation.
        --
        -- Five to a rank at three and a half yards apart gives a front fourteen yards
        -- wide, and six yards between ranks keeps the ones behind from running through
        -- the ones in front. The orientation is the direction of the run, which is what
        -- the script now steers by.
        UPDATE `creature` SET `position_x` = -1733.23, `position_y` = 1371.01, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221193;
        UPDATE `creature` SET `position_x` = -1736.06, `position_y` = 1368.95, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221194;
        UPDATE `creature` SET `position_x` = -1738.88, `position_y` = 1366.88, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221195;
        UPDATE `creature` SET `position_x` = -1741.70, `position_y` = 1364.81, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221536;
        UPDATE `creature` SET `position_x` = -1744.53, `position_y` = 1362.75, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221537;
        UPDATE `creature` SET `position_x` = -1729.69, `position_y` = 1366.17, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221538;
        UPDATE `creature` SET `position_x` = -1732.51, `position_y` = 1364.10, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221539;
        UPDATE `creature` SET `position_x` = -1735.34, `position_y` = 1362.04, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221540;
        UPDATE `creature` SET `position_x` = -1738.16, `position_y` = 1359.97, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221541;
        UPDATE `creature` SET `position_x` = -1740.99, `position_y` = 1357.90, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221542;
        UPDATE `creature` SET `position_x` = -1726.14, `position_y` = 1361.33, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221543;
        UPDATE `creature` SET `position_x` = -1728.97, `position_y` = 1359.26, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221544;
        UPDATE `creature` SET `position_x` = -1731.79, `position_y` = 1357.20, `position_z` = 20.00, `orientation` = 2.202 WHERE `guid` = 221545;

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
