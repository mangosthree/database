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
    SET @cOldContent = '023';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '024';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Sacrifices_Ride';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Replace the placeholder teleport on Sacrifices (14212) with the ride: click the horse, Crowley drives, the player throws torches';

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

        -- The Sacrifices torch ride and its stalkers.


        -- ---- from Sacrifices_Ride ----
        -- `Sacrifices` (14212) is Lord Darius Crowley's ride. The player climbs on
        -- behind him and throws torches at the Bloodfang while Crowley rides the loop
        -- through the burning quarter.
        --
        -- None of it ran. The quest carried a `StartScript` whose single command is
        -- SCRIPT_COMMAND_TELEPORT_TO to (-1552.49, 1564.42, 29.22) - which is the
        -- turn-in - so accepting the quest dropped the player at the end of it.
        --
        -- The real sequence, timed off a retail capture of this quest (Worgen Hunter,
        -- build 18019, Gilneas City), measured from the click on the horse:
        --     +0.00s  67001 `Summon Crowley's Horse` -> 46598; the player is seated
        --     +4.15s  the horse lands at (-1714.76, 1673.16, 20.49)   [jump 1]
        --     +9.48s  67063 `Throw Torch`, the first of many
        --     +10.8s  the first `Bloodfang Stalker Credit` (35582) ticks
        --     +37.5s  it leaves the path at (-1592.10, 1710.71)
        --     +39.6s  it lands at (-1566.71, 1708.04, 20.49)          [jump 2]
        --     +79.5s  51254 `Dan's Eject All Passengers`; the player is on the ground
        --             at (-1541.03, 1575.31, 29.21), beside Tobias Mistmantle
        -- Exactly 30 credits are sent across that window, which is the objective count.
        --
        -- The client sends only five movement packets in the whole 80 seconds, and all
        -- five are acks of those two jumps and the dismount. So the horse is ROOTED
        -- server-side for the entire ride and driven by splines - the player holds the
        -- control seat but steers nothing. That is what the script does.

        -- 1. The placeholder teleport. This is the bug the player sees.
        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 14212;
        UPDATE `quest_template` SET `StartScript` = 0 WHERE `entry` = 14212;

        -- 2. The mount is a click on the horse standing beside Crowley, not something
        --    the quest does on accept. 44427 `Crowley's Horse` is the prop - no vehicle
        --    id, phaseMask 8, parked at (-1737.68, 1655.11) two yards from the quest
        --    giver. Clicking it cast 67766 `Force Cast - Summon Crowley's Horse`, and
        --    SPELL_EFFECT_FORCE_CAST is stubbed in this core into a `db_scripts` call
        --    that had no rows, so the click did nothing at all.
        --
        --    67766 exists only to make the player cast 67001, so point the click
        --    straight at 67001 with `cast_flags` 1 (the player is the caster). 67001 is
        --    SUMMON of 35231 under SummonProperties 161 - summon group 4, a VEHICLE - so
        --    `Spell::DoSummonVehicle` seats the caster the moment the horse appears,
        --    exactly as Greymane's horse does in 14293.
        --
        --    quest_start + quest_start_active means "has it or has done it"; quest_end
        --    on the same quest takes the second half back, leaving "only while active".
        DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 44427;
        INSERT INTO `npc_spellclick_spells`
            (`npc_entry`, `spell_id`, `quest_start`, `quest_start_active`, `quest_end`, `cast_flags`, `condition_id`) VALUES
        (44427, 67001, 14212, 1, 14212, 1, 0);

        -- 3. Lord Darius Crowley rides in front. Vehicle 463 has two seats and the seat
        --    numbers do not describe who sits where - the offsets do:
        --        seat 0 = 5106, offset x -0.200 (rear), CAN_CONTROL | CAN_CAST
        --        seat 1 = 5107, offset x +0.400 (front), CAN_EXIT
        --    The player has to hold seat 0 because CAN_CAST is what gives the client a
        --    vehicle action bar, and the capture shows every `Throw Torch` arriving as
        --    CMSG_PET_CAST_SPELL off that bar. Seat 0 is also the rear seat, so the
        --    player still ends up sitting behind Crowley, which is the intent.
        --
        --    `DoSummonVehicle` casts 46598 with no seat, so `GetUsableSeatFor` takes the
        --    lowest free one; with Crowley already installed in seat 1 by
        --    `VehicleInfo::Initialize`, the player lands in seat 0 without being asked.
        DELETE FROM `vehicle_accessory` WHERE `vehicle_entry` = 35231;
        INSERT INTO `vehicle_accessory` (`vehicle_entry`, `seat`, `accessory_entry`, `comment`) VALUES
        (35231, 1, 35230, 'Lord Darius Crowley rides in front; the player takes the rear seat 0');

        -- 4. Ride pace. 1.28571 is 9 yards a second, which is what walks the 15 leg
        --    path between the two jumps in the 33 seconds the capture gives it.
        --
        --    And keep the horse on its feet. It has 860 hit points, and the whole point
        --    of the ride is that the pack chases it, so a level 4 horse standing in a
        --    street of level 4-5 worgen for eighty seconds does not finish the trip.
        --    Retail never lets it drop. CREATURE_FLAG_EXTRA_UNKILLABLE (0x40000) clamps
        --    killing damage to leave it at 1 HP - the same tool the training dummies
        --    got in Rel22_05: it still takes hits and still holds their attention.
        UPDATE `creature_template` SET `SpeedRun` = 1.28571,
            `ExtraFlags` = `ExtraFlags` | 0x40000 WHERE `Entry` = 35231;

        -- 5. The credit. The objective is 30 `Bloodfang Stalker Credit` (35582) and the
        --    ADD_KILL packets in the capture name that entry, but nothing in this
        --    database credits it: the worgen killed on the ride is 35229 `Bloodfang
        --    Stalker` and its KillCredit columns are empty. `Player::KilledMonster`
        --    credits the entry itself AND every KillCredit entry, so this does not
        --    disturb `By Blood and Ash` (14218), which counts 35229 directly.
        UPDATE `creature_template` SET `KillCredit1` = 35582 WHERE `Entry` = 35229;

        -- 6. The pack has to survive being ridden through. 402 of them are already
        --    spawned in phaseMask 8 along the route, but on a 90 second respawn and
        --    rooted to the spot, so a single pass strips the street and the second half
        --    of the ride has nothing to burn. Retail keeps them coming - the capture is
        --    thick with `Summon Bloodfang Stalker` while the horse is moving.
        UPDATE `creature` SET `spawntimesecs` = 5, `spawndist` = 5, `MovementType` = 1 WHERE `id` = 35229;

        -- 7. Crowley's two lines during the ride, from the retail text.
        DELETE FROM `script_texts` WHERE `entry` IN (-1999947, -1999948);
        INSERT INTO `script_texts` (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (-1999947, 'Let''s round up as many of them as we can.  Every worgen chasing us is one less worgen chasing the survivors!', 19696, 0, 0, 0, 'lord darius crowley - as the ride sets off, quest 14212'),
        (-1999948, 'You''ll never catch us, you blasted mongrels!', 19696, 1, 0, 0, 'lord darius crowley - taunting the pack mid-ride, quest 14212');

        -- 8. Bind the ride script.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_crowleys_horse';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_crowleys_horse', 35231, 0);

        -- ---- from Sacrifices_Torch ----
        -- Four things were wrong with the `Sacrifices` (14212) ride shipped in
        -- Rel22_07_056. Three of them are here; the jump arc and the route vias are in
        -- the script.
        --
        -- 1. THE HORSE WAS KILLING ITSELF WITH THE TORCH.
        --
        --    67063 `Throw Torch` resolves through TARGET_AREAEFFECT_CUSTOM, and
        --    `SpellTargeting.cpp:633` reads:
        --        FillAreaTargets(bounds.first != bounds.second ? tempTargetUnitMap
        --                                                      : targetUnitMap,
        --                        radius, PUSH_DEST_CENTER, SPELL_TARGETS_ALL);
        --    With no `spell_script_target` rows the bounds are empty, the sweep goes
        --    straight into the real target list under SPELL_TARGETS_ALL, and the throw
        --    lands on everything inside 5 yards - which includes the vehicle it was
        --    thrown from. The log is unambiguous:
        --        PeriodicTick: Vehicle (Entry: 35231) attacked Vehicle (Entry: 35231)
        --                      for 42 dmg inflicted by 67063
        --    42 is five percent of the horse's 860 hit points, the burn has no
        --    duration, and CREATURE_FLAG_EXTRA_UNKILLABLE does not save it, because
        --    the clamp in `Unit.cpp` is written `damage >= health && pVictim != this`
        --    - self-damage is deliberately exempt. So the horse burned itself down,
        --    both CONTROL_VEHICLE auras went with it, the player was dumped in the
        --    street mid-route, and the accessory Crowley despawned five seconds later,
        --    which is the corpse line that made it look like Crowley had died.
        --
        --    Rats and passing citizens were being set on fire by the same fallback.
        --
        --    Restricting the sweep fixes all of it. TrinityCore restricts to 35229
        --    alone; ours has 31 spawns of 51277 - the same `Bloodfang Stalker` under a
        --    later entry - and the log shows them being hit too, so both belong here.
        DELETE FROM `spell_script_target` WHERE `entry` = 67063;
        INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`, `inverseEffectMask`) VALUES
        (67063, 1, 35229, 0),
        (67063, 1, 51277, 0);

        -- 2. NOTHING DIED AND NO CREDIT WAS GIVEN, and neither was ever going to
        --    happen by waiting for a corpse. The torch's damage effect has 0 base
        --    points and its burn ticks 4 against a 102 hit point stalker; the capture
        --    shows retail crediting 35582 **0.79 seconds after the throw**, with four
        --    credits arriving together when one throw catches four of them. That is
        --    credit on hit, not on kill. The new `npc_bloodfang_stalker` script hands
        --    the credit to whoever holds the control seat of the caster - the caster
        --    being the vehicle, since the throw comes off the vehicle bar.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_bloodfang_stalker';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_bloodfang_stalker', 35229, 0),
        (0, 'npc_bloodfang_stalker', 51277, 0);

        -- 3. Ride pace. Rel22_07_056 took 1.28571 from TrinityCore; the capture
        --    disagrees. Every leg of the retail ride runs at 12.6 yards a second - the
        --    Rosetta leg covers a 33.6 yard chord in 2665 ms, and the rate holds
        --    across all thirty-odd legs. Creature run speed here is
        --    `baseMoveSpeed[MOVE_RUN] = 7.0` times the rate, so the rate is 1.8.
        --    At TC's number the ride runs forty percent slow.
        UPDATE `creature_template` SET `SpeedRun` = 1.8 WHERE `Entry` = 35231;

        -- 4. Crowley rides; he has no business picking fights from the saddle.
        --    CREATURE_FLAG_EXTRA_CIVILIAN (0x2) retires his AggressorAI - the horse
        --    script speaks his lines itself. TrinityCore marks him the same way.
        --    Belt and braces: nothing hostile ever attacked him in the log, because
        --    faction 35 has no enemies.
        UPDATE `creature_template` SET `ExtraFlags` = `ExtraFlags` | 0x2 WHERE `Entry` = 35230;

        -- ---- from Crowleys_Horse_Health ----
        -- Crowley's Horse (35231), the Sacrifices (14212) mount.
        --
        -- Decoded from the 18019 Gilneas capture: created with UNIT_FIELD_MAXHEALTH
        -- 4080 at level 5, Run Speed 9, UNIT_FIELD_FLAGS 8. Over the 80 s ride the
        -- Bloodfang Stalkers (35229, and three 51277) attack the HORSE - never the
        -- rider or Crowley - 28 attack starts, 19 hits, 189 damage in all; it is set
        -- down at 3911/4080. Ours had 2040. The UNKILLABLE extra flag Rel22_07_056 gave
        -- it stays as a backstop; with retail health it should never be reached.
        UPDATE `creature_template`
        SET `MinLevelHealth` = 4080,
            `MaxLevelHealth` = 4080
        WHERE `Entry` = 35231;

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
