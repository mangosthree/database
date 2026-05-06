-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

-- CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
CREATE PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '22';
    SET @cOldStructure = '04';
    SET @cOldContent = '069';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '070';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Quest 14069 Fix';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix Good Help is Hard to Find spellclick objective, rewards, and Kezan parallel quest chain';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        SET @QUEST_GOOD_HELP     := 14069;
        SET @QUEST_TAKING_CARE   := 14138;
        SET @QUEST_TROUBLE_MINES := 14075;
        SET @QUEST_KAJACOLA      := 25473;
        SET @QUEST_GROUP_MINES   := 14069;
        SET @NPC_DAMPWICK        := 34872;
        SET @NPC_DEFIANT_TROLL   := 34830;
        SET @SPELL_SHOCKER       := 66306;
        SET @FACTION_BILGEWATER  := 1133;

        UPDATE `quest_template`
        SET
            `Method` = 2,
            `QuestLevel` = 1,
            `MinLevel` = 1,
            `RequiredRaces` = 256,
            `PrevQuestId` = @QUEST_TAKING_CARE,
            `NextQuestId` = @QUEST_KAJACOLA,
            `ExclusiveGroup` = @QUEST_GROUP_MINES,
            `NextQuestInChain` = 0,
            `ReqCreatureOrGOId1` = @NPC_DEFIANT_TROLL,
            `ReqCreatureOrGOCount1` = 8,
            `ReqSpellCast1` = @SPELL_SHOCKER,
            `ReqCreatureOrGOId2` = 0,
            `ReqCreatureOrGOCount2` = 0,
            `ReqSpellCast2` = 0,
            `ReqCreatureOrGOId3` = 0,
            `ReqCreatureOrGOCount3` = 0,
            `ReqSpellCast3` = 0,
            `ReqCreatureOrGOId4` = 0,
            `ReqCreatureOrGOCount4` = 0,
            `ReqSpellCast4` = 0,
            `ReqItemId1` = 0,
            `ReqItemCount1` = 0,
            `ReqItemId2` = 0,
            `ReqItemCount2` = 0,
            `ReqItemId3` = 0,
            `ReqItemCount3` = 0,
            `ReqItemId4` = 0,
            `ReqItemCount4` = 0,
            `ReqItemId5` = 0,
            `ReqItemCount5` = 0,
            `ReqItemId6` = 0,
            `ReqItemCount6` = 0,
            `ReqSourceId1` = 0,
            `ReqSourceCount1` = 0,
            `ReqSourceId2` = 0,
            `ReqSourceCount2` = 0,
            `ReqSourceId3` = 0,
            `ReqSourceCount3` = 0,
            `ReqSourceId4` = 0,
            `ReqSourceCount4` = 0,
            `SrcItemId` = 0,
            `SrcItemCount` = 0,
            `SrcSpell` = 0,
            `RewOrReqMoney` = 15,
            `RewMoneyMaxLevel` = 75,
            `RewRepFaction1` = @FACTION_BILGEWATER,
            `RewRepValueId1` = 5,
            `RewRepValue1` = 0,
            `Objectives` = 'Adjust the attitudes of 8 Defiant Trolls.',
            `Details` = 'I''ve failed! I tried to meet our Kaja''Cola quotas, but you know troll slaves these days. Good help is hard to find!$B$BI think your personal touch is called for. A shock from the battery on your Goblin All-In-1-Der Belt should do the trick. Adjust their attitudes and the rest will fall in line.$B$BKaja''Cola production must continue or the Trade Prince will have all of our heads!',
            `RequestItemsText` = 'A good start, sir, but might I suggest that you may want to make an example of a few more?',
            `OfferRewardText` = 'I couldn''t have done better myself. In fact, I didn''t.$B$BI''m sure that in no time at all we''ll all be talking about the great and powerful, and may I add extremely wealthy, Trade $GPrince:Princess; $N!',
            `EndText` = '',
            `CompletedText` = 'Return to Foreman Dampwick at KTC Headquarters on Kezan.',
            `ObjectiveText1` = 'Attitudes Adjusted',
            `ObjectiveText2` = '',
            `ObjectiveText3` = '',
            `ObjectiveText4` = ''
        WHERE `entry` = @QUEST_GOOD_HELP;

        UPDATE `quest_template`
        SET
            `PrevQuestId` = @QUEST_TAKING_CARE,
            `NextQuestId` = @QUEST_KAJACOLA,
            `ExclusiveGroup` = @QUEST_GROUP_MINES,
            `NextQuestInChain` = 0
        WHERE `entry` = @QUEST_TROUBLE_MINES;

        UPDATE `quest_template`
        SET
            `PrevQuestId` = @QUEST_GOOD_HELP
        WHERE `entry` = @QUEST_KAJACOLA;

        DELETE FROM `quest_relations`
        WHERE `actor` = 0
          AND `entry` = @NPC_DAMPWICK
          AND `quest` = @QUEST_GOOD_HELP;

        INSERT INTO `quest_relations` (`actor`, `entry`, `quest`, `role`) VALUES
        (0, @NPC_DAMPWICK, @QUEST_GOOD_HELP, 0),
        (0, @NPC_DAMPWICK, @QUEST_GOOD_HELP, 1);

        DELETE FROM `npc_spellclick_spells`
        WHERE `npc_entry` = @NPC_DEFIANT_TROLL
          AND `spell_id` = @SPELL_SHOCKER;

        INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `quest_start`, `quest_start_active`, `quest_end`, `cast_flags`, `condition_id`) VALUES
        (@NPC_DEFIANT_TROLL, @SPELL_SHOCKER, @QUEST_GOOD_HELP, 1, @QUEST_GOOD_HELP, 1, 0);

        DELETE FROM `script_binding`
        WHERE `type` = 0
          AND `bind` = @NPC_DEFIANT_TROLL;

        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_defiant_troll_q14069', @NPC_DEFIANT_TROLL, 0);

        DELETE FROM `db_scripts`
        WHERE `script_type` = 5
          AND `id` = @SPELL_SHOCKER;

        -- UNIT_NPC_FLAG_SPELLCLICK is dynamic in MaNGOS and is populated from npc_spellclick_spells at load time.

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
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
            SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@cOldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
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
