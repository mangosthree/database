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
    SET @cOldContent = '025';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '026';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Panicked_Citizens_Cower';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Merchant Square Panicked Citizens 34851/44086 stand still, cower periodically (52385) and the clusters emote like the 18019 capture';

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

        -- Panicked citizens cower instead of wandering.


        -- Merchant Square at character creation: the `Panicked Citizen` crowd.
        --
        -- Two entries share the name. 34851 (28 spawns) is spread through the square;
        -- 44086 (21 spawns) stands in two tight clusters. Our rows had 34851 strolling
        -- waypoint paths (5 guids), wandering a 3 yard radius (the other 23), and ten
        -- guids with a per-guid `creature_addon` row whose `auras` is NULL - which
        -- overrides the template addon and silently strips the cower aura. 44086 did
        -- nothing at all.
        --
        -- Retail, decoded from the 18019 Gilneas capture (75 x 34851, 33 x 44086
        -- create blocks, layout anchored on entry + unit_flags 33024):
        --   * 34851 never appears in SMSG_EMOTE and never gets an emote-state field
        --     update; 8 of 75 hold UNIT_NPC_EMOTESTATE 431 (STATE_COWER). The
        --     terrified look for the rest is aura 52385 `Cosmetic - Periodic Cower`:
        --     every 6 s it casts 52384, whose SpellVisual 10905 -> kit 10057 plays
        --     AnimID 225 (Cower) client-side. Standing still is the whole act.
        --   * 44086: 31 of 33 play a one-shot emote roughly every 7.5 s (median),
        --     drawn from ONESHOT_ROAR 15, EXCLAMATION 5, TALK 1, BEG 20, CRY 18,
        --     COWER 430 (177/99/94/89/80/77 of 616 sends). One holds STATE_COWER.
        --
        -- So: everyone stands; every 34851 carries 52385 (the nine with STATE_COWER
        -- keep it); 44086 gets EventAI with two OOC random-emote timers whose combined
        -- cadence is ~7 s. The walkers' `creature_movement` rows go, and the
        -- HOVER|LOCAL_DIRTY moveflags the paths left on their addon rows go with them.

        -- 34851: stand still
        UPDATE `creature`
        SET `MovementType` = 0,
            `spawndist` = 0
        WHERE `id` = 34851;

        DELETE FROM `creature_movement`
        WHERE `id` IN (219632, 219638, 220005, 221437, 221438);

        -- 34851: every per-guid addon row carries the periodic cower; emote kept as-is
        UPDATE `creature_addon`
        SET `auras` = '52385',
            `moveflags` = 0
        WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 34851);

        -- 44086: stand still (one guid was on a 5-node path)
        UPDATE `creature`
        SET `MovementType` = 0,
            `spawndist` = 0
        WHERE `id` = 44086;

        DELETE FROM `creature_movement`
        WHERE `id` = 220012;

        UPDATE `creature_addon`
        SET `moveflags` = 0
        WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 44086);

        -- 44086: retail's rotating one-shot emotes
        UPDATE `creature_template`
        SET `AIName` = 'EventAI'
        WHERE `entry` = 44086;

        DELETE FROM `creature_ai_scripts` WHERE `creature_id` = 44086;
        INSERT INTO `creature_ai_scripts`
            (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`,
             `event_param1`, `event_param2`, `event_param3`, `event_param4`,
             `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`,
             `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`,
             `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES
            (4408601, 44086, 1, 0, 100, 1, 1000,  8000, 12000, 16000, 10, 15,  5,   1, 0, 0, 0, 0, 0, 0, 0, 0, 'Panicked Citizen - Random Emote Roar/Exclamation/Talk OOC'),
            (4408602, 44086, 1, 0, 100, 1, 4000, 10000, 12000, 16000, 10, 20, 18, 430, 0, 0, 0, 0, 0, 0, 0, 0, 'Panicked Citizen - Random Emote Beg/Cry/Cower OOC');

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
