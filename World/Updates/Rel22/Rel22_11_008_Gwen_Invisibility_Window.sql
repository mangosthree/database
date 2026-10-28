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
    SET @cOldContent = '007';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '008';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Gwen_Invisibility_Window';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'End Generic Quest Invisibility Detection 1 at Royal Orders so the Merchant Square Gwen Armstead stops sharing a phase with the one over the bridge';

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

        -- Gate Gwen Armstead's invisibility to the right quest window.


        -- ---- from Merchant_Square_Gwen_Invis ----
        -- Gwen Armstead 34936 stands in Merchant Square and hands out `Salvage the
        -- Supplies` (14094), whose 17 Supply Crates all spawn beside her. She carries
        -- `Generic Quest Invisibility 1` (49414), so she is only visible to a player
        -- holding the matching detection 49416 - and the Merchant Square row already
        -- ends that detection at `Royal Orders` (14099), which is where the chapter
        -- hands over to the Gwen Armstead across the bridge (35840).
        --
        -- The two zone-wide rows carried the phase spell's window (14078 -> 14159)
        -- instead. `SpellMgr::GetSpellAllowedInLocationError` allows a spell when ANY
        -- spell_area row fits, so the wider rows always matched and the narrower one
        -- never took effect: both Gwens stayed visible for another five quests.
        --
        -- 34936 is the only creature in Gilneas using invisibility 1, so nothing else
        -- depends on this detection window. Deleting the zone rows instead would hide
        -- her from a player standing in Gilneas City proper looking into the square,
        -- which is presumably why they exist - so narrow them rather than drop them.
        UPDATE `spell_area` SET `quest_end` = 14099
            WHERE `spell` = 49416 AND `area` IN (4714, 4755) AND `quest_start` = 14078;

        -- ---- from Merchant_Square_Gwen_Retire ----
        -- Two Gwen Armstead spawns are visible at once during the Merchant Square
        -- chapter:
        --   34936 (guid 219619) at (-1465, 1403) - gives AND ends `Salvage the
        --         Supplies` (14094), 30 yards from the 14098 quest POI. The Merchant
        --         Square Gwen.
        --   35840 (guid 219973) at (-1633, 1304) - ends `Royal Orders` (14099) and
        --         opens the class-trainer chain (14265..14280). The bridge Gwen, and
        --         the 14099 POI sits exactly on her.
        -- Royal Orders sends the player to the bridge, so from that moment 34936
        -- should be gone.
        --
        -- Gilneas already ships the mechanism for this, and 34936 is the ONLY creature
        -- in the zone that uses it:
        --     49414 = SPELL_AURA_MOD_INVISIBILITY           type 7  (on the creature,
        --             via `creature_template_addon`)
        --     49416 = SPELL_AURA_MOD_INVISIBILITY_DETECTION type 7  (on the player,
        --             via `spell_area`)
        -- She is invisible unless the player holds the matching detection, so
        -- retiming that detection moves her and nothing else.
        --
        -- The defect is the end condition. `spell_area.quest_end` gates on
        -- `GetQuestRewardStatus` (`SpellArea::IsFitToRequirements`), so the detection
        -- survived until Royal Orders was handed IN, whereas she must go the moment it
        -- is ACCEPTED. `condition_id` replaces the whole quest/race/gender block, and
        -- CONDITION_QUEST_NONE (22) is exactly "neither taken nor rewarded".
        --
        -- Operands are numbered BELOW the composite on purpose: `PlayerCondition::
        -- IsValid` rejects CONDITION_AND/_OR/_NOT whose value1/value2 are >= their own
        -- entry, so the tree stays acyclic.
        --
        -- Phasing cannot express this. `Aura::HandlePhase` is "always non stackable" -
        -- it drops any phase aura already on the unit and assigns the new mask instead
        -- of OR-ing it, so a second phase aura would evict 59073 and blank the entire
        -- district.
        --
        -- `quest_start` / `quest_end` on the touched rows are left as they are. They
        -- are inert while `condition_id` is set, and remain a sane fallback if the
        -- condition is ever removed. Only the 14078 rows are touched; the later 49416
        -- windows (14159, 14221, 14293) belong to other chapters.
        DELETE FROM `conditions` WHERE `condition_entry` IN (57902, 57903, 57904);
        INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
        (57902,  8, 14078, 0, 'Lockdown! (14078) rewarded'),
        (57903, 22, 14099, 0, 'Royal Orders (14099) neither taken nor rewarded'),
        (57904, -1, 57902, 57903, 'Merchant Square Gwen visible: Lockdown! done, Royal Orders not yet taken');

        UPDATE `spell_area` SET `condition_id` = 57904
            WHERE `spell` = 49416 AND `quest_start` = 14078 AND `area` IN (4714, 4755, 4756);

        -- `Player::UpdateAreaDependentAuras` is the only thing that re-tests the rule,
        -- and the 1s zone timer calls it ONLY when the zone or area id actually
        -- changes. A player who accepts Royal Orders and stands still would keep the
        -- detection, and Gwen, until they crossed a boundary - so strip it on accept.
        -- `ScriptsStart(DBS_ON_QUEST_START, ..., questGiver, this)` passes the quest
        -- giver as source and the player as target, while SCRIPT_COMMAND_REMOVE_AURA
        -- (14) strips from `pSource`; SCRIPT_FLAG_REVERSE_DIRECTION (0x02) swaps them
        -- so the aura leaves the player and not Prince Liam.
        UPDATE `quest_template` SET `StartScript` = 14099 WHERE `entry` = 14099;

        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 14099;
        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `data_flags`, `comments`) VALUES
        (0, 14099, 0, 14, 49416, 2, 'Royal Orders - drop type-7 invisibility detection so Gwen 34936 is retired at once');

        -- ---- from Gwen_Stays_For_Salvage ----
        -- Rel22_07_014 retires Gwen 34936 the moment `Royal Orders` (14099) is
        -- accepted. That is right only when the player is actually done with her.
        -- `Salvage the Supplies` (14094) hangs off `Lockdown!` (14078), NOT off the
        -- Merchant Square pair, so it is not a prerequisite for Royal Orders: a player
        -- may take her errand, hand in All Hell Breaks Loose and Evacuate the Merchant
        -- Square, accept Royal Orders, and still owe her the crates. Retiring her then
        -- strands 14094 with no way to turn it in - she both gives AND ends it.
        --
        -- Corrected rule:
        --     visible = 14078 rewarded
        --               AND ( Royal Orders not taken yet OR 14094 still in the log )
        -- A player who never took the errand, or who already handed it in, still loses
        -- her the instant Royal Orders is accepted.
        --
        -- CONDITION_QUESTTAKEN (9) with value2 = 0 resolves to
        -- `Player::IsCurrentQuest(14094, 0)` = INCOMPLETE or (COMPLETE and not
        -- rewarded) - precisely "still in the log, not yet turned in".
        --
        -- Operand ids stay strictly below their composite, as
        -- `PlayerCondition::IsValid` demands for CONDITION_AND (-1) / _OR (-2).
        DELETE FROM `conditions` WHERE `condition_entry` IN (57902, 57903, 57904, 57905, 57906);
        INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `value2`, `comments`) VALUES
        (57902,  8, 14078, 0, 'Lockdown! (14078) rewarded'),
        (57903, 22, 14099, 0, 'Royal Orders (14099) neither taken nor rewarded'),
        (57904,  9, 14094, 0, 'Salvage the Supplies (14094) still in the log'),
        (57905, -2, 57903, 57904, 'Royal Orders not taken yet, OR Salvage the Supplies still owed'),
        (57906, -1, 57902, 57905, 'Merchant Square Gwen visible');

        UPDATE `spell_area` SET `condition_id` = 57906
            WHERE `spell` = 49416 AND `quest_start` = 14078 AND `area` IN (4714, 4755, 4756);

        -- The start script must now honour the same exception, otherwise it would
        -- strip the detection on accept even for a player who still owes the crates.
        -- SCRIPT_COMMAND_TERMINATE_COND (34) without SCRIPT_FLAG_COMMAND_ADDITIONAL
        -- terminates the remaining steps when its condition is TRUE, and it locates
        -- the player from the target, so it runs with no flags. Steps load
        -- `ORDER BY script_guid ASC`, so the guard is inserted first and runs first.
        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 14099;
        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `data_flags`, `comments`) VALUES
        (0, 14099, 0, 34, 57904, 0, 0, 'Royal Orders - keep Gwen if Salvage the Supplies is still owed'),
        (0, 14099, 0, 14, 49416, 0, 2, 'Royal Orders - otherwise drop type-7 detection so Gwen goes at once');

        -- Mirror image: handing in the crates after Royal Orders is the other moment
        -- she becomes redundant. Guarded so that a player who has NOT yet taken Royal
        -- Orders keeps her.
        UPDATE `quest_template` SET `CompleteScript` = 14094 WHERE `entry` = 14094;

        DELETE FROM `db_scripts` WHERE `script_type` = 1 AND `id` = 14094;
        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `data_flags`, `comments`) VALUES
        (1, 14094, 0, 34, 57903, 0, 0, 'Salvage the Supplies - keep Gwen while Royal Orders is not yet taken'),
        (1, 14094, 0, 14, 49416, 0, 2, 'Salvage the Supplies - otherwise drop type-7 detection, the errand is done');

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
