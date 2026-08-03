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
    SET @cOldStructure = '03';
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'ai_playerbot_gear';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'ai_playerbot_gear';

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

-- ============================================================
-- Cataclysm Playerbot Gear Table Definition
-- ============================================================

DROP TABLE IF EXISTS `ai_playerbot_gear`;

CREATE TABLE `ai_playerbot_gear` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `class` TINYINT UNSIGNED NOT NULL COMMENT 'Player class (1=Warrior, 2=Paladin, etc.)',
    `spec` TINYINT UNSIGNED NOT NULL COMMENT 'Spec index (0=default, 1=primary, 2=secondary)',
    `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Equipment slot (0–18)',
    `item` INT UNSIGNED NOT NULL COMMENT 'ItemTemplate entry ID',
    `quality` TINYINT UNSIGNED NOT NULL COMMENT 'Item quality (0=poor, 1=common, 2=uncommon, etc.)',
    `required_level` TINYINT UNSIGNED NOT NULL COMMENT 'Minimum level required to equip',
    `comment` VARCHAR(255) DEFAULT NULL COMMENT 'Description',
    PRIMARY KEY (`id`),
    KEY `idx_class_spec` (`class`, `spec`),
    KEY `idx_slot` (`slot`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- ============================================================
-- CATA LEVELING GEAR (80–85)
-- ============================================================

-- Warrior Leveling (Hyjal / Vashj'ir / Deepholm)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(1,0,4, 55824,2,81,'Warrior Leveling - Breastplate of the Earth'),
(1,0,6, 55827,2,82,'Warrior Leveling - Stone-Wrapped Greaves'),
(1,0,7, 55830,2,82,'Warrior Leveling - Treads of the Earth'),
(1,0,9, 55829,2,82,'Warrior Leveling - Gauntlets of the Earth'),
(1,0,15, 55284,2,81,'Warrior Leveling - Hardened Obsidium Axe'),
(1,0,15, 55285,2,82,'Warrior Leveling - Obsidium Executioner'),
(1,0,16, 55286,2,82,'Warrior Leveling - Obsidium Cleaver');

-- Paladin Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(2,0,4, 55811,2,81,'Paladin Leveling - Breastplate of the North'),
(2,0,6, 55814,2,82,'Paladin Leveling - Legplates of the North'),
(2,0,7, 55816,2,82,'Paladin Leveling - Boots of the North'),
(2,0,15, 55290,2,81,'Paladin Leveling - Obsidium Warhammer'),
(2,0,15, 55291,2,82,'Paladin Leveling - Stoneforge Hammer');

-- Hunter Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(3,0,4, 55850,2,81,'Hunter Leveling - Chain Vest of the Deep'),
(3,0,6, 55852,2,82,'Hunter Leveling - Chain Leggings of the Deep'),
(3,0,17, 55853,2,82,'Hunter Leveling - Bow of the Deep'),
(3,0,17, 55854,2,83,'Hunter Leveling - Deepholm Longbow');

-- Rogue Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(4,0,4, 55868,2,81,'Rogue Leveling - Jerkin of the Deep'),
(4,0,6, 55869,2,82,'Rogue Leveling - Leggings of the Deep'),
(4,0,15, 55292,2,81,'Rogue Leveling - Obsidium Dagger'),
(4,0,16, 55293,2,82,'Rogue Leveling - Razor of the Deep');

-- Priest Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(5,0,4, 55855,2,81,'Priest Leveling - Robe of the Deep'),
(5,0,6, 55856,2,82,'Priest Leveling - Pants of the Deep'),
(5,0,17, 55857,2,82,'Priest Leveling - Wand of the Deep');

-- Shaman Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(7,0,4, 55840,2,81,'Shaman Leveling - Hauberk of the Deep'),
(7,0,6, 55841,2,82,'Shaman Leveling - Legguards of the Deep'),
(7,0,15, 55294,2,81,'Shaman Leveling - Obsidium Mace'),
(7,0,16, 55295,2,82,'Shaman Leveling - Deepstone Axe');

-- Mage Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(8,0,4, 55858,2,81,'Mage Leveling - Robe of the Deep'),
(8,0,6, 55859,2,82,'Mage Leveling - Pants of the Deep'),
(8,0,17, 55860,2,82,'Mage Leveling - Wand of the Deep');

-- Warlock Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(9,0,4, 55861,2,81,'Warlock Leveling - Robe of the Deep'),
(9,0,6, 55862,2,82,'Warlock Leveling - Pants of the Deep'),
(9,0,17, 55863,2,82,'Warlock Leveling - Wand of the Deep');

-- Death Knight Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(6,0,4, 55821,2,81,'DK Leveling - Saronite Chestguard'),
(6,0,6, 55822,2,82,'DK Leveling - Saronite Legplates'),
(6,0,7, 55823,2,82,'DK Leveling - Saronite Boots'),
(6,0,15, 55296,2,81,'DK Leveling - Obsidium Greatsword');

-- Druid Leveling
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(11,0,4, 55870,2,81,'Druid Leveling - Jerkin of the Deep'),
(11,0,6, 55871,2,82,'Druid Leveling - Leggings of the Deep'),
(11,0,15, 55297,2,81,'Druid Leveling - Deepstone Staff');

-- ============================================================
-- CATA MINIMAL BIS (NO LEGENDARIES)
-- ============================================================

-- Warrior BIS (Prot/Fury)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(1,1,15, 65139,4,85,'Warrior BIS - Akirus the Worm-Breaker'),
(1,1,16, 65017,4,85,'Warrior BIS - Shalug\'doom'),
(1,1,4, 60323,4,85,'Warrior BIS - Tier 11 Chest'),
(1,1,6, 60325,4,85,'Warrior BIS - Tier 11 Legs'),
(1,1,7, 65051,4,85,'Warrior BIS - Boots of the Perilous Seas');

-- Paladin BIS (Ret/Prot/Holy)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(2,1,15, 65003,4,85,'Paladin BIS - Lava Spine'),
(2,1,4, 60359,4,85,'Paladin BIS - Tier 11 Chest'),
(2,1,6, 60361,4,85,'Paladin BIS - Tier 11 Legs'),
(2,1,7, 65079,4,85,'Paladin BIS - Sabatons of the Flame');

-- Hunter BIS
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(3,1,17, 65095,4,85,'Hunter BIS - Themios the Darkbringer'),
(3,1,4, 60303,4,85,'Hunter BIS - Tier 11 Chest'),
(3,1,6, 60305,4,85,'Hunter BIS - Tier 11 Legs');

-- Rogue BIS
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(4,1,15, 65007,4,85,'Rogue BIS - Twilight Blade'),
(4,1,16, 65041,4,85,'Rogue BIS - Fang of Twilight'),
(4,1,4, 60298,4,85,'Rogue BIS - Tier 11 Chest'),
(4,1,6, 60300,4,85,'Rogue BIS - Tier 11 Legs');

-- Priest BIS (Holy/Shadow)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(5,1,17, 65090,4,85,'Priest BIS - Brimstone Igniter'),
(5,1,4, 60262,4,85,'Priest BIS - Tier 11 Chest'),
(5,1,6, 60260,4,85,'Priest BIS - Tier 11 Legs');

-- Shaman BIS (Ele/Enh/Resto)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(7,1,15, 65094,4,85,'Shaman BIS - Incineratus'),
(7,1,4, 60313,4,85,'Shaman BIS - Tier 11 Chest'),
(7,1,6, 60315,4,85,'Shaman BIS - Tier 11 Legs');

-- Mage BIS
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(8,1,17, 65091,4,85,'Mage BIS - Brimstone Igniter'),
(8,1,4, 60244,4,85,'Mage BIS - Tier 11 Chest'),
(8,1,6, 60246,4,85,'Mage BIS - Tier 11 Legs');

-- Warlock BIS
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(9,1,17, 65092,4,85,'Warlock BIS - Brimstone Igniter'),
(9,1,4, 60252,4,85,'Warlock BIS - Tier 11 Chest'),
(9,1,6, 60250,4,85,'Warlock BIS - Tier 11 Legs');

-- Death Knight BIS
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(6,1,15, 65139,4,85,'DK BIS - Akirus the Worm-Breaker'),
(6,1,4, 60339,4,85,'DK BIS - Tier 11 Chest'),
(6,1,6, 60341,4,85,'DK BIS - Tier 11 Legs');

-- Druid BIS (Feral/Balance/Resto)
INSERT INTO `ai_playerbot_gear` (`class`,`spec`,`slot`,`item`,`quality`,`required_level`,`comment`) VALUES
(11,1,15, 65007,4,85,'Druid BIS - Twilight Blade'),
(11,1,4, 60279,4,85,'Druid BIS - Tier 11 Chest'),
(11,1,6, 60281,4,85,'Druid BIS - Tier 11 Legs');

-- ============================================================
-- END OF CATA FILE
-- ============================================================

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
