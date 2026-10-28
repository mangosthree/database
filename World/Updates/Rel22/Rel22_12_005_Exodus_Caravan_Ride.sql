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
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '005';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Exodus_Caravan_Ride';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Exodus (24438): retire the crash-site TELEPORT stub; the caravan ride replaces it - accept summons the harness, the player boards the coach';

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

        -- The Exodus caravan ride.
        --
        -- The parked caravan IS the ride. The summoned pair 43336/43337 is out
        -- of the flow, so their vehicle_accessory rows are not carried.


        -- ---- from Exodus_Caravan_Ride ----
        -- Exodus (24438). The quest StartScript TELEPORTED the player straight to
        -- the stagecoach crash site; retail has them walk to the manor gate,
        -- board the caravan coach, and RIDE the 1197-yard route down (capture:
        -- ride harness 43336 pulling coach 43337, 95 seconds). Retire the stub;
        -- the ride is served by npc_exodus_harness/npc_exodus_coach, the caravan
        -- assembled by vehicle_accessory, the coach click gated to the quest.
        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 24438;
        UPDATE `quest_template` SET `StartScript` = 0 WHERE `entry` = 24438;

        -- The summoned pair 43336/43337 is NOT assembled here. A later step in this
        -- same migration retires them: the PARKED caravan is the ride, and nothing
        -- summons those entries any more. The delete is kept so a database that got
        -- the interim rows is cleaned; retail's own two-caravan design would need
        -- them back, and they are recoverable from the campaign history.
        DELETE FROM `vehicle_accessory` WHERE `vehicle_entry` IN (43336, 43337);

        DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 43337;
        INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `quest_start`, `quest_start_active`, `quest_end`, `cast_flags`, `condition_id`) VALUES
        (43337, 43671, 24438, 1, 0, 1, 0);

        DELETE FROM `script_binding` WHERE `ScriptName` IN ('npc_exodus_coach', 'npc_exodus_harness');
        INSERT INTO `script_binding` (`type`, `bind`, `ScriptName`) VALUES
        (0, 43337, 'npc_exodus_coach'),
        (0, 43336, 'npc_exodus_harness');

        -- ---- from Exodus_Click_Swap ----
        -- Exodus (24438), the retail flow: the player CLICKS the parked display
        -- carriage at the manor gate; it vanishes, the ride caravan rises in its
        -- place, and the clicker is already seated as it assembles
        -- (npc_display_carriage does the swap, npc_exodus_harness the seating -
        -- the click aura resolves no seat on vehicle 959, so boarding is raw).
        -- The direct click on the ride coach 43337 is retired with it.
        DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (43337, 44928);
        INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `quest_start`, `quest_start_active`, `quest_end`, `cast_flags`, `condition_id`) VALUES
        (44928, 43671, 24438, 1, 0, 1, 0);

        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_display_carriage';
        INSERT INTO `script_binding` (`type`, `bind`, `ScriptName`) VALUES
        (0, 44928, 'npc_display_carriage');

        -- ---- from Exodus_Parked_Is_Ride ----
        -- Exodus (24438): the swap machinery broke boarding (the click aura
        -- seated the player on the display coach, which the swap then despawned
        -- under them). Simplification: the parked caravan IS the ride - the
        -- coach 44928 takes the drive-signal script, the harness 38755 the
        -- driver script; after the ride the caravan folds away and respawns
        -- parked. The summoned pair 43336/43337 is out of the flow.
        DELETE FROM `script_binding` WHERE `ScriptName` IN ('npc_display_carriage', 'npc_exodus_coach', 'npc_exodus_harness');
        INSERT INTO `script_binding` (`type`, `bind`, `ScriptName`) VALUES
        (0, 44928, 'npc_exodus_coach'),
        (0, 38755, 'npc_exodus_harness');

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
