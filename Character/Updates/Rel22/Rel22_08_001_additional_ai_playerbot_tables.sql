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
    SET @cNewStructure = '08';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'ai_playerbot_tables';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'ai_playerbot_tables';

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

DROP TABLE IF EXISTS `ai_playerbot_gear_enchant`;

CREATE TABLE `ai_playerbot_gear_enchant` (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  class TINYINT NOT NULL,
  spec TINYINT NOT NULL,
  slot TINYINT NOT NULL,
  enchant INT NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- ============================================================
-- CATA ENCHANTS
-- ============================================================
-- | Slot | Meaning |
-- |    1 | Head |
-- |    2 | Neck |
-- |    3 | Shoulder |
-- |    4 | Chest |
-- |    5 | Waist |
-- |    6 | Legs |
-- |    7 | Feet |
-- |    8 | Wrist |
-- |    9 | Hands |
-- |   15 | Main‑hand |
-- |   16 | Off‑hand |
-- |   17 | Ranged / Wand / Relic |

-- Warrior
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(1,1,3,85008),   -- Shoulder: Therazane
(1,1,6,85007),   -- Legs: Dragonscale
(1,1,15,74223);  -- Weapon: Landslide

-- Paladin
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(2,1,3,85008),
(2,1,6,85007),
(2,1,15,74223);

-- Hunter
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(3,1,3,85008),
(3,1,6,85007),
(3,1,17,81932);  -- Ranged: Gnomish X-Ray

-- Rogue
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(4,1,3,85008),
(4,1,6,85007),
(4,1,15,74223);

-- Priest
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(5,1,3,85009),
(5,1,6,85006),   -- Spellthread
(5,1,15,74225);  -- Power Torrent

-- Shaman
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(7,1,3,85008),
(7,1,6,85007),
(7,1,15,74223);

-- Mage
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(8,1,3,85009),
(8,1,6,85006),
(8,1,15,74225);

-- Warlock
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(9,1,3,85009),
(9,1,6,85006),
(9,1,15,74225);

-- DK
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(6,1,3,85008),
(6,1,6,85007),
(6,1,15,53344);

-- Druid
INSERT INTO ai_playerbot_gear_enchant (class,spec,slot,enchant) VALUES
(11,1,3,85009),
(11,1,6,85006),
(11,1,15,74225);


DROP TABLE IF EXISTS `ai_playerbot_gem`;
CREATE TABLE `ai_playerbot_gem` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `class` TINYINT(3) NOT NULL,
  `spec` TINYINT(3) NOT NULL,
  `color` VARCHAR(20) NOT NULL,
  `gem_item` INT(10) NOT NULL,
  `gem_enchant` INT(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



-- ============================================================
-- Cataclysm Playerbot Gem Templates
-- ============================================================

-- Format:
-- class, spec, color, gem_item, gem_enchant

-- ============================================================
-- WARRIOR (Arms / Fury / Protection)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(1,1,'red',52206,73336),     -- Bold Inferno Ruby (Strength)
(1,1,'yellow',52217,73340),  -- Fractured Amberjewel (Mastery)
(1,1,'blue',52242,73339),    -- Solid Ocean Sapphire (Stamina)
(1,1,'meta',52291,73468);    -- Agile Shadowspirit Diamond

-- ============================================================
-- PALADIN (Holy / Prot / Ret)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(2,1,'red',52206,73336),     -- Strength (Ret/Prot)
(2,1,'yellow',52217,73340),  -- Mastery (Prot)
(2,1,'blue',52242,73339),    -- Stamina (Prot)
(2,1,'meta',52295,73468);    -- Powerful Shadowspirit Diamond (Holy/Prot)

-- ============================================================
-- HUNTER (MM / SV / BM)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(3,1,'red',52212,73336),     -- Agility
(3,1,'yellow',52219,73340),  -- Crit
(3,1,'blue',52242,73339),    -- Stamina
(3,1,'meta',52291,73468);    -- Agile Shadowspirit Diamond

-- ============================================================
-- ROGUE (Assassination / Combat / Subtlety)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(4,1,'red',52212,73336),     -- Agility
(4,1,'yellow',52219,73340),  -- Crit
(4,1,'blue',52242,73339),    -- Stamina
(4,1,'meta',52291,73468);    -- Agile Shadowspirit Diamond

-- ============================================================
-- PRIEST (Holy / Disc / Shadow)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(5,1,'red',52207,73336),     -- Intellect
(5,1,'yellow',52222,73340),  -- Haste
(5,1,'blue',52242,73339),    -- Stamina
(5,1,'meta',52294,73468);    -- Chaotic Shadowspirit Diamond

-- ============================================================
-- SHAMAN (Ele / Enh / Resto)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(7,1,'red',52207,73336),     -- Intellect (Ele/Resto)
(7,1,'red',52212,73336),     -- Agility (Enh)
(7,1,'yellow',52222,73340),  -- Haste
(7,1,'blue',52242,73339),    -- Stamina
(7,1,'meta',52294,73468);    -- Chaotic Shadowspirit Diamond

-- ============================================================
-- MAGE (Arcane / Fire / Frost)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(8,1,'red',52207,73336),     -- Intellect
(8,1,'yellow',52222,73340),  -- Haste
(8,1,'blue',52242,73339),    -- Stamina
(8,1,'meta',52294,73468);    -- Chaotic Shadowspirit Diamond

-- ============================================================
-- WARLOCK (Aff / Demo / Destro)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(9,1,'red',52207,73336),     -- Intellect
(9,1,'yellow',52222,73340),  -- Haste
(9,1,'blue',52242,73339),    -- Stamina
(9,1,'meta',52294,73468);    -- Chaotic Shadowspirit Diamond

-- ============================================================
-- DEATH KNIGHT (Blood / Frost / Unholy)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(6,1,'red',52206,73336),     -- Strength
(6,1,'yellow',52217,73340),  -- Mastery (Blood)
(6,1,'blue',52242,73339),    -- Stamina
(6,1,'meta',52291,73468);    -- Agile Shadowspirit Diamond

-- ============================================================
-- MONK (Brewmaster / Mistweaver / Windwalker)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(10,1,'red',52212,73336),    -- Agility
(10,1,'yellow',52222,73340), -- Haste
(10,1,'blue',52242,73339),   -- Stamina
(10,1,'meta',52291,73468);   -- Agile Shadowspirit Diamond

-- ============================================================
-- DRUID (Feral / Guardian / Balance / Resto)
-- ============================================================

INSERT INTO ai_playerbot_gem (class, spec, color, gem_item, gem_enchant) VALUES
(11,1,'red',52212,73336),    -- Agility (Feral/Guardian)
(11,1,'red',52207,73336),    -- Intellect (Balance/Resto)
(11,1,'yellow',52222,73340), -- Haste
(11,1,'blue',52242,73339),   -- Stamina
(11,1,'meta',52291,73468);   -- Agile Shadowspirit Diamond

-- ============================================================
-- END OF CATA GEM TABLE
-- ============================================================

DROP TABLE IF EXISTS `ai_playerbot_glyph`;
CREATE TABLE `ai_playerbot_glyph` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `class` TINYINT(3) NOT NULL,
  `spec` TINYINT(3) NOT NULL,
  `glyph_type` TINYINT(3) NOT NULL,
  `glyph_spell` INT(10) NOT NULL,
  `slot_idx` TINYINT(3) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- Warrior Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(1,1,1,58367,0),
(1,1,1,58368,1),
(1,1,1,58364,2);

-- Warrior Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(1,1,2,58095,3),
(1,1,2,58096,4),
(1,1,2,68164,5);

-- Paladin Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(2,1,1,54922,0),
(2,1,1,54927,1),
(2,1,1,54925,2);

-- Paladin Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(2,1,2,54929,3),
(2,1,2,54930,4),
(2,1,2,54931,5);

-- Hunter Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(3,1,1,56850,0),
(3,1,1,56856,1),
(3,1,1,56842,2);

-- Hunter Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(3,1,2,57870,3),
(3,1,2,57866,4),
(3,1,2,57868,5);

-- Rogue Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(4,1,1,56800,0),
(4,1,1,56801,1),
(4,1,1,56802,2);

-- Rogue Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(4,1,2,56808,3),
(4,1,2,56807,4),
(4,1,2,56809,5);

-- Priest Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(5,1,1,55672,0),
(5,1,1,55685,1),
(5,1,1,55682,2);

-- Priest Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(5,1,2,55684,3),
(5,1,2,55688,4),
(5,1,2,55683,5);

-- Shaman Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(7,1,1,55454,0),
(7,1,1,55447,1),
(7,1,1,55440,2);

-- Shaman Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(7,1,2,55438,3),
(7,1,2,55439,4),
(7,1,2,55437,5);

-- Mage Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(8,1,1,56368,0),
(8,1,1,56370,1),
(8,1,1,56363,2);

-- Mage Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(8,1,2,56383,3),
(8,1,2,56382,4),
(8,1,2,56384,5);

-- Warlock Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(9,1,1,56218,0),
(9,1,1,56228,1),
(9,1,1,56232,2);

-- Warlock Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(9,1,2,56241,3),
(9,1,2,56242,4),
(9,1,2,56240,5);

-- DK Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(6,1,1,58631,0),
(6,1,1,58629,1),
(6,1,1,58618,2);

-- DK Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(6,1,2,58673,3),
(6,1,2,58677,4),
(6,1,2,58676,5);

-- Druid Major
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(11,1,1,54810,0),
(11,1,1,54812,1),
(11,1,1,54815,2);

-- Druid Minor
INSERT INTO ai_playerbot_glyph (class, spec, glyph_type, glyph_spell, slot_idx) VALUES
(11,1,2,54825,3),
(11,1,2,57856,4),
(11,1,2,54824,5);

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
