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
    SET @cOldContent = '016';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '017';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Josiah_Bite_Scene';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Hang the cellar scene off Blizzards own trigger: Josiah transforms into his worgen form and it throws the player, then the bite lands';

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

        -- The Josiah cellar scene: bite, Lorna's pull, whisper and worgen.
        --
        -- Five earlier iterations of a knockback mechanism are not carried;
        -- the scene settled on Lorna pulling the player instead.


        -- ---- from Josiah_Blizzard_Chain ----
        -- Rel22_07_022 through 028 hung this scene off the quest end script and made
        -- the player throw themselves, because a friendly Josiah could not resolve
        -- them as the enemy target a knockback needs. Blizzard's own trigger is
        -- already present and does it properly, so the scene moves onto it.
        --
        -- Quest 14159 carries `RewSpellCast` = 67352 `Force Cast Summon Josiah`, and
        -- `Player::RewardQuest` casts it. This core stubs SPELL_EFFECT_FORCE_CAST to
        --     m_caster->GetMap()->ScriptsStart(DBS_ON_SPELL, m_spellInfo->ID, ...)
        -- so turning the quest in ALREADY starts a script of type 5 for id 67352 with
        -- the player as both source and target. There simply were no rows for it.
        --
        -- With the worgen form actually present, the throw stops being a workaround.
        -- `ScriptAction` resolves a buddy as the SOURCE unless SCRIPT_FLAG_BUDDY_AS_TARGET
        -- is set:
        --     pFinalSource = pBuddy ? pBuddy : pOrigSource;
        --     pFinalTarget = pOrigTarget;
        -- so naming 35370 as the buddy makes the worgen the caster and the player the
        -- target. 35370 is faction 2179, hostile, so TARGET_CHAIN_DAMAGE resolves -
        -- which it never could from the human Josiah on 2163 - and `KnockBackFrom`
        -- throws along the worgen-to-player line. No self cast, no facing dependency.
        --
        -- Order follows Wowpedia: "Avery transforms into a worgen, attacks and knocks
        -- away the player". Transform at 0, throw at 1, and the bite at 3 so it lands
        -- after the 1.6 second flight. 72870 `Worgen Bite` is TARGET_SELF and must be
        -- cast by the player, which the default source already is.
        --
        -- Spell 67350 is deliberately not cast to do the summoning. Its summon effects
        -- use TARGET_SCRIPT_COORDINATES, which needs `spell_target_position` rows this
        -- DB does not have; summoning 35370 directly at Josiah's own spawn is the same
        -- creature in the same place without inventing coordinate data.
        UPDATE `quest_template` SET `CompleteScript` = 0 WHERE `entry` = 14159;
        DELETE FROM `db_scripts` WHERE `script_type` = 1 AND `id` = 14159;

        DELETE FROM `db_scripts` WHERE `script_type` = 5 AND `id` = 67352;
        INSERT INTO `db_scripts`
            (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `x`, `y`, `z`, `o`, `comments`) VALUES
        (5, 67352, 0, 10, 35370, 30000,     0,  0, 0, -1813.62, 1428.32, 12.5465, 3.85718, 'Josiah turns - his worgen form takes his place'),
        (5, 67352, 1, 15, 62354,     0, 35370, 30, 8,        0,       0,       0,       0, 'The worgen hurls the player back up the cellar'),
        (5, 67352, 3, 15, 72870,     0,     0,  0, 8,        0,       0,       0,       0, 'Worgen Bite lands - carries the phase 4 aura');

        -- ---- from Lorna_Shoots_Josiah ----
        -- The worgen was summoned before the bite, so it inherited the player's phase
        -- 2 while Lorna Crowley stands in phase 4. They could never see one another,
        -- which is why she never reacted to it.
        --
        -- The bite moves first. `Worgen Bite` phases the player to 4, the human Josiah
        -- on phase 2 drops out of sight - which is the transform, from the player's
        -- side - and the worgen summoned a second later inherits phase 4 instead,
        -- landing in the same phase as Lorna and as the player. The throw follows once
        -- it is on its feet.
        UPDATE `db_scripts` SET `delay` = 0 WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 72870;
        UPDATE `db_scripts` SET `delay` = 1 WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 35370;
        UPDATE `db_scripts` SET `delay` = 2 WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 62354;

        -- Lorna finishes him. `db_scripts` cannot express a cast whose source is one
        -- creature and whose target is another - a buddy becomes one or the other, not
        -- both - so the shot lives in `npc_josiah_worgen`, bound here.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_josiah_worgen';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_josiah_worgen', 35370, 0);

        -- ---- from Lorna_Pulls_Player ----
        -- The throw was wrong. Every knockback used here so far was picked by solving
        -- for distance, because no Blizzard knockback for this scene could be found -
        -- but the scene never used one. Lorna PULLS the player to her.
        --
        -- 67357 `Pull-to` sits in Blizzard's own cellar cluster, beside 67348 `Stay
        -- Put`, 67349 `Get Shot`, 67350 `Summon Josiah` and 67352 `Force Cast Summon
        -- Josiah`. It carries SPELL_EFFECT_PLAYER_PULL, which the core documents as
        -- "opposite of knockback effect (pulls player toward caster)" and implements
        -- as a move to the caster's own position:
        --     x = m_caster->Where().X(); ... // then nudged 0.6 back along its facing
        -- Its Misc and BasePoints are both 0 because it needs no speed - it is a
        -- placement, not a trajectory.
        --
        -- That is why the destination surveyed in game was Lorna's own spawn
        -- (-1789.75, 1427.41, 13.0): the player ends up there because she pulls them
        -- there. The teleport in Rel22_07_024 was accidentally right about the
        -- position and wrong about the mechanism; the knockbacks after it were wrong
        -- about both.
        --
        -- She is named as the script's buddy, so `ScriptAction` makes her the source
        -- and leaves the player as the target. By this point the bite has already put
        -- the player in phase 4, which is hers, so the search finds her.
        UPDATE `db_scripts` SET `datalong` = 67357, `buddy_entry` = 35378, `search_radius` = 60,
            `comments` = 'Lorna pulls the player to her - Blizzards Pull-to, not a knockback'
        WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 62354;

        -- ---- from Josiah_Get_Shot_Spell ----
        -- Lorna's shot was borrowed: 50092, the rifle spell Prince Liam uses elsewhere
        -- in this file, with the kill dealt by the script afterwards. Blizzard's own
        -- spell for the moment is 67349 `Get Shot`, sitting beside `Summon Josiah` and
        -- `Pull-to` in the same block of ids.
        --
        -- It is a bare SPELL_EFFECT_DUMMY, which is why it did nothing on its own -
        -- retail decided what being shot meant on the server. That behaviour now lives
        -- in `spell_josiah_get_shot`, an SD3 SpellScript on the effect itself, so what
        -- kills Josiah IS the shot rather than a script reaching past it. No core
        -- change was needed: `Spell::EffectDummy` already forwards unhandled dummies
        -- to the script library via `sScriptMgr.OnEffectDummy`.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'spell_josiah_get_shot';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (4, 'spell_josiah_get_shot', 67349, 0);

        -- ---- from Lorna_Pulls_First ----
        -- Lorna pulled the player only after the worgen was already on its feet, so
        -- she read as reacting late. She goes first now: the bite still leads, because
        -- it is what puts the player in her phase 4 and she cannot be found by the
        -- script's buddy search before that, but the pull moves ahead of the summon.
        --     0s  Worgen Bite  - phase 4, the human Josiah drops out of sight
        --     1s  Pull-to      - Lorna hauls the player back to the stairs
        --     2s  the worgen takes his place, with the player already clear
        UPDATE `db_scripts` SET `delay` = 1 WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 67357;
        UPDATE `db_scripts` SET `delay` = 2 WHERE `script_type` = 5 AND `id` = 67352 AND `datalong` = 35370;

        -- The two Gilnean Mastiffs at her side carried MovementType 1 with spawndist
        -- 3, so they wandered off during the scene - the same defect the refugees
        -- around King Genn had. Only these two are touched: they are the pair standing
        -- within a yard and a half of Lorna in phase 4, and every other mastiff in
        -- Gilneas belongs to a different scene.
        UPDATE `creature` SET `MovementType` = 0, `spawndist` = 0
        WHERE `id` = 38844 AND `phaseMask` = 4
          AND SQRT(POW(`position_x` - (-1789.8), 2) + POW(`position_y` - 1427.4, 2)) <= 10;

        -- ---- from Bite_Whisper_Lorna_Voice ----
        -- The capture, 19:36 window: two seconds after The Rebel Lord s Arsenal
        -- is turned in, the invisible Josiah Event Trigger (50415) RAID-BOSS-
        -- WHISPERS the bitten line - fang icon inline - to the player; and at
        -- the From the Shadows offer Lorna speaks her mastiff line with voice
        -- 19696 (script side: npc_lorna_crowley). Lorna is SILENT during the
        -- pull and the shot - the capture shows no line and no sound there.
        DELETE FROM `db_script_string` WHERE `entry`=2000005309;
        INSERT INTO `db_script_string` (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (2000005309, 'You''ve been bitten by a worgen.  It''s probably nothing, but it sure stings a little.$B$B|TInterface\\Icons\\INV_Misc_monsterfang_02.blp:32|t', 0, 5, 0, 0, 'Josiah Event Trigger - the bite whisper, capture-exact incl. the fang icon');
        DELETE FROM `creature` WHERE `guid`=400114;
        INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `DeathState`, `MovementType`) VALUES
        (400114, 50415, 654, 1, 6, 0, 0, -1813.62, 1428.32, 12.5465, 0, 300, 0, 0, 1, 0, 0, 0);
        DELETE FROM `db_scripts` WHERE `script_type`=5 AND `id`=67352 AND `command`=0;
        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `dataint`, `buddy_entry`, `search_radius`, `data_flags`, `comments`) VALUES
        (5, 67352, 2, 0, 0, 2000005309, 50415, 60, 4, 'the bite whisper, two seconds after the turn-in - capture timing');
        DELETE FROM `script_texts` WHERE `entry`=-1999998;
        INSERT INTO `script_texts` (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (-1999998, 'This mastiff will help you find the hidden worgen.', 19696, 0, 0, 0, 'Lorna Crowley - the mastiff handoff, voiced (capture 19:36:42)');

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
