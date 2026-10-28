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
    SET @cOldContent = '026';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '027';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Rebel_Cannons_14218';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Make Rebel Cannon 35317 clickable via Ride Vehicle 43671 while By Blood and Ash (14218) is in the log, as the retail capture shows';

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

        -- By Blood and Ash: the rebel cannons and their auto-eject.


        -- ---- from By_Blood_And_Ash_Cannons ----
        -- `By Blood and Ash` (14218) asks for 80 Bloodfang Stalker (35229) kills made
        -- with the Rebel Cannons on Tobias Mistmantle's hill. The cannons could not be
        -- clicked, so the quest was unfinishable. Everything except one row was already
        -- in place; this adds the row.
        --
        -- What was already right, checked rather than assumed:
        --   * 35317 is a creature-vehicle, `VehicleTemplateId` 470. Vehicle.dbc 470
        --     carries a single seat, 5206, flags 0x62100803 = CAN_CONTROL | CAN_CAST |
        --     CAN_EXIT | NOT_SELECTABLE | ALLOW_TURNING. One seat means no
        --     `vehicle_accessory` row is wanted, and CAN_CAST is what hands the player
        --     the cannon's action bar.
        --   * `creature_template_spells` already lists 67279 as the cannon's spell 1.
        --     67279 fires a TRIGGER_MISSILE of 67278, which is a 15 yd knock-back plus
        --     412 school damage - a one-shot against a 102 hp stalker.
        --   * Our 14 cannon spawns (219596-219605, 219991-219993, 220555) are the same
        --     14 the retail capture shows, position for position to three decimals,
        --     e.g. ours (-1549.4, 1595.7, 26.5) against retail (-1549.410, 1595.730,
        --     26.536). Nothing to add or move.
        --
        -- The capture settles the boarding chain exactly. At t=3045.03 the client sends
        -- a selection and an interact packet both carrying the cannon's guid; at
        -- t=3045.70 spell **43671 `Ride Vehicle`** casts, and one tick later its
        -- CONTROL_VEHICLE aura (effect 0, aura 236) lands on the cannon while the
        -- dummy on effect 1 lands on the player. `Ride Vehicle Hardcoded` (46598)
        -- never appears - the chain is click -> 43671, nothing else. At t=3047.01 the
        -- cannon's charmer becomes the player and its faction flips to the player's.
        --
        -- `cast_flags` 1 makes the player the caster and the cannon the target, which
        -- is what SpellHandler.cpp does with the flag and the shape our own horse row
        -- (44427, 67001, ...) has been running on since Rel22_07_056.
        --
        -- Gated on the quest being in the log, which is what TrinityCore expresses as
        -- condition (18, 35317, 43671, 9, 14218) and what m3 expresses natively with
        -- quest_start + quest_start_active. `quest_end` = the same quest retires the
        -- click once it is handed in.
        --
        -- No script, no `spell_script_target` and no core change are needed:
        --   * 67278's second target is a plain hostile area fill, not the
        --     TARGET_AREAEFFECT_CUSTOM that made the Sacrifices torch burn its own
        --     horse, and the manned cannon wears the player's faction anyway.
        --   * The client, not the server, aims the shot - the capture shows CMSG
        --     0x00E8 carrying an explicit destination triple that SMSG_SPELL_START
        --     echoes back byte for byte, so m3's TARGET_DIRECTLY_FORWARD random-range
        --     path is never entered.
        --   * Rel22_07_058's sparring floor on 35229 does not block the kills.
        --     `Unit::IsSparringWith` exempts any attacker that resolves to a player,
        --     and boarding sets the cannon's charmer to the player.
        --   * `Vehicle.cpp` already calls `ClearTemporaryFaction()` on unboard, so a
        --     used cannon returns to faction 35 and stays clickable for the next run.
        DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 35317;
        INSERT INTO `npc_spellclick_spells`
            (`npc_entry`, `spell_id`, `quest_start`, `quest_start_active`, `quest_end`, `cast_flags`, `condition_id`)
        VALUES
            (35317, 43671, 14218, 1, 14218, 1, 0);

        -- ---- from Rebel_Cannon_Auto_Eject ----
        -- Bind the new `npc_rebel_cannon` script to Rebel Cannon 35317, so the gunner
        -- is thrown out of the seat the moment `By Blood and Ash` (14218) reaches
        -- 80/80 instead of sitting in a cannon with nothing left to shoot.
        --
        -- Retail does exactly this and does it server-side: in the capture the
        -- eightieth credit lands at t=3077.07 and at t=3077.73 the cannon's charmer is
        -- cleared, its faction returns to 35, the `Ride Vehicle` aura is stripped and
        -- the player is splined out. The client's next fire request at t=3077.59 is
        -- ignored. No spell is cast to do it - `Eject All Passengers` (51254) appears
        -- nowhere near, it only ends the horse ride of the previous quest.
        DELETE FROM `script_binding` WHERE `type` = 0 AND `bind` = 35317;
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
            (0, 'npc_rebel_cannon', 35317, 0);

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
