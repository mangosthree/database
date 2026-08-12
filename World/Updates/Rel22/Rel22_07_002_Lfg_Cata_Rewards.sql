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
    SET @cOldStructure = '07';
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '07';
    SET @cNewContent = '002';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Lfg_Cata_Rewards';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Cataclysm Dungeon Finder reward rows for levels 81-85, a level 80 correction, and heroic gear gates';

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


-- Cataclysm reward rows for levels 81-85, and a correction at 80.
--
-- Values come from the era reward quests, halved: this table stores the
-- subsequent-run reward and the core doubles it on the first random of the
-- day. Levels 80-82 follow quest pair 24790/24791; 83-84 follow 28907;
-- 85 takes 28908's max-level money. The 80-82 / 83+ split is the reward
-- quests' own MinLevel of 83, which is why the slot spans 80-85 in
-- LFGDungeons.dbc but pays on two tiers. Experience is flat within a
-- bracket because the quests pin QuestLevel, and 0 at the level cap.
--
-- The existing level 80 row is corrected, not kept: its 0 experience is a
-- Wrath level-cap artifact (80 is not the cap in Cataclysm) and 99300 is a
-- max-level money figure that does not apply at 80 here.
UPDATE `dungeonfinder_rewards` SET `base_xp_reward` = 16550, `base_monetary_reward` = 74000 WHERE `level` = 80;

DELETE FROM `dungeonfinder_rewards` WHERE `level` BETWEEN 81 AND 85;
INSERT INTO `dungeonfinder_rewards` (`id`, `level`, `base_xp_reward`, `base_monetary_reward`) VALUES
(67, 81, 16550, 74000),
(68, 82, 16550, 74000),
(69, 83, 52050, 94000),
(70, 84, 52050, 94000),
(71, 85, 0, 124025);

-- Average item level gates for the Cataclysm heroics, by content tier:
-- 329 for the launch heroics (4.0.3), 346 for Zul'Aman and Zul'Gurub
-- (4.1.0 patch notes), 353 for the three Caverns of Time heroics (4.3.0).
-- Normal-difficulty Cataclysm dungeons carry no gear gate.
DELETE FROM `dungeonfinder_requirements` WHERE `mapId` IN (33, 36, 568, 643, 644, 645, 657, 670, 725, 755, 859, 938, 939, 940) AND `difficulty` = 1;
INSERT INTO `dungeonfinder_requirements` (`mapId`, `difficulty`, `min_item_level`, `item`, `item_2`, `alliance_quest`, `horde_quest`, `achievement`, `quest_incomplete_text`, `comment`) VALUES
(33,  1, 329, 0, 0, 0, 0, 0, NULL, 'Shadowfang Keep (heroic)'),
(36,  1, 329, 0, 0, 0, 0, 0, NULL, 'Deadmines (heroic)'),
(643, 1, 329, 0, 0, 0, 0, 0, NULL, 'Throne of the Tides (heroic)'),
(644, 1, 329, 0, 0, 0, 0, 0, NULL, 'Halls of Origination (heroic)'),
(645, 1, 329, 0, 0, 0, 0, 0, NULL, 'Blackrock Caverns (heroic)'),
(657, 1, 329, 0, 0, 0, 0, 0, NULL, 'The Vortex Pinnacle (heroic)'),
(670, 1, 329, 0, 0, 0, 0, 0, NULL, 'Grim Batol (heroic)'),
(725, 1, 329, 0, 0, 0, 0, 0, NULL, 'The Stonecore (heroic)'),
(755, 1, 329, 0, 0, 0, 0, 0, NULL, 'Lost City of the Tol\'vir (heroic)'),
(568, 1, 346, 0, 0, 0, 0, 0, NULL, 'Zul\'Aman (heroic)'),
(859, 1, 346, 0, 0, 0, 0, 0, NULL, 'Zul\'Gurub (heroic)'),
(938, 1, 353, 0, 0, 0, 0, 0, NULL, 'End Time (heroic)'),
(939, 1, 353, 0, 0, 0, 0, 0, NULL, 'Well of Eternity (heroic)'),
(940, 1, 353, 0, 0, 0, 0, 0, NULL, 'Hour of Twilight (heroic)');

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
