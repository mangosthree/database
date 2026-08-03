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
    SET @cOldStructure = '06';
    SET @cOldContent = '001';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '07';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'ai_playerbot_gear';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'ai_playerbot_gear - 2nd attempt';

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
-- Table structure for table `ai_playerbot_guild_tasks`
-- ============================================================

DROP TABLE IF EXISTS `ai_playerbot_guild_tasks`;

CREATE TABLE `ai_playerbot_guild_tasks` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `owner` BIGINT(20) NOT NULL,
  `guildid` BIGINT(20) NOT NULL,
  `time` BIGINT(20) NOT NULL,
  `validIn` BIGINT(20) DEFAULT NULL,
  `type` VARCHAR(45) DEFAULT NULL,
  `value` BIGINT(20) DEFAULT NULL,
  `data` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`),

  KEY `owner` (`owner`),

  KEY `guildid` (`guildid`),

  KEY `type` (`type`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

-- ============================================================
-- Cataclysm Guild Tasks (Playerbot)
-- ============================================================

-- Notes:
-- owner = 0 (system)
-- guildid = 0 (global tasks)
-- time = 0 (bots fill when assigned)
-- validIn = 0 (no expiration)
-- type = category
-- value = numeric objective
-- data = description

-- ============================================================
-- LEVELING ZONES (Hyjal, Vashj'ir, Deepholm, Uldum, Twilight Highlands)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'zone_kill',25,'Mount Hyjal - Kill 25 Twilight Cultists'),
(0,0,0,0,'zone_kill',25,'Vashj\'ir - Kill 25 Naga Invaders'),
(0,0,0,0,'zone_kill',25,'Deepholm - Kill 25 Stone Troggs'),
(0,0,0,0,'zone_kill',25,'Uldum - Kill 25 Schnottz Troopers'),
(0,0,0,0,'zone_kill',25,'Twilight Highlands - Kill 25 Dragonmaw Orcs'),

(0,0,0,0,'zone_collect',10,'Mount Hyjal - Collect 10 Embers of Flame'),
(0,0,0,0,'zone_collect',10,'Deepholm - Collect 10 Heartshard Fragments'),
(0,0,0,0,'zone_collect',10,'Uldum - Collect 10 Titan Relics');

-- ============================================================
-- DUNGEONS (Tier 11 Heroics)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'dungeon_clear',1,'Clear Blackrock Caverns'),
(0,0,0,0,'dungeon_clear',1,'Clear Throne of the Tides'),
(0,0,0,0,'dungeon_clear',1,'Clear The Stonecore'),
(0,0,0,0,'dungeon_clear',1,'Clear Vortex Pinnacle'),
(0,0,0,0,'dungeon_clear',1,'Clear Grim Batol'),
(0,0,0,0,'dungeon_clear',1,'Clear Halls of Origination'),

-- Dungeon Boss Kill Tasks
(0,0,0,0,'boss_kill',1,'Kill Ascendant Lord Obsidius (BRC)'),
(0,0,0,0,'boss_kill',1,'Kill Ozumat (Throne of the Tides)'),
(0,0,0,0,'boss_kill',1,'Kill High Priestess Azil (Stonecore)'),
(0,0,0,0,'boss_kill',1,'Kill Altairus (Vortex Pinnacle)'),
(0,0,0,0,'boss_kill',1,'Kill Erudax (Grim Batol)'),
(0,0,0,0,'boss_kill',1,'Kill Rajh (Halls of Origination)');

-- ============================================================
-- RAIDS (Tier 11, Tier 12, Tier 13)
-- ============================================================

-- Tier 11: BoT / BWD / Throne of the Four Winds
INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'raid_clear',11,'Clear Bastion of Twilight'),
(0,0,0,0,'raid_clear',11,'Clear Blackwing Descent'),
(0,0,0,0,'raid_clear',11,'Clear Throne of the Four Winds'),

(0,0,0,0,'boss_kill',11,'Kill Cho\'gall (BoT)'),
(0,0,0,0,'boss_kill',11,'Kill Nefarian (BWD)'),
(0,0,0,0,'boss_kill',11,'Kill Al\'Akir (Four Winds)');

-- Tier 12: Firelands
INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'raid_clear',12,'Clear Firelands'),
(0,0,0,0,'boss_kill',12,'Kill Ragnaros (Firelands)');

-- Tier 13: Dragon Soul
INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'raid_clear',13,'Clear Dragon Soul'),
(0,0,0,0,'boss_kill',13,'Kill Deathwing (Dragon Soul)');

-- ============================================================
-- PROFESSIONS (Cataclysm Materials)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'profession_gather',20,'Gather 20 Elementium Ore'),
(0,0,0,0,'profession_gather',20,'Gather 20 Obsidium Ore'),
(0,0,0,0,'profession_gather',20,'Gather 20 Cinderbloom'),
(0,0,0,0,'profession_gather',20,'Gather 20 Azshara\'s Veil'),
(0,0,0,0,'profession_gather',20,'Gather 20 Twilight Jasmine'),

(0,0,0,0,'profession_craft',5,'Craft 5 Cataclysm Armor pieces'),
(0,0,0,0,'profession_craft',5,'Craft 5 Cataclysm Weapons');

-- ============================================================
-- REPUTATION TASKS (Therazane, Ramkahen, Earthen Ring)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'rep_gain',2500,'Gain 2500 reputation with Therazane'),
(0,0,0,0,'rep_gain',2500,'Gain 2500 reputation with Ramkahen'),
(0,0,0,0,'rep_gain',2500,'Gain 2500 reputation with The Earthen Ring');

-- ============================================================
-- PVP TASKS (Tol Barad)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'pvp_win',1,'Win a Tol Barad Battle'),
(0,0,0,0,'pvp_kill',25,'Tol Barad - Kill 25 enemy players');

-- ============================================================
-- GUILD ADVANCEMENT TASKS (Cata Guild Achievements)
-- ============================================================

INSERT INTO ai_playerbot_guild_tasks (OWNER, guildid, TIME, validIn, TYPE, VALUE, DATA) VALUES
(0,0,0,0,'guild_xp',50000,'Earn 50,000 Guild XP'),
(0,0,0,0,'guild_gold',500,'Deposit 500 gold into the guild bank'),
(0,0,0,0,'guild_repair',100,'Spend 100 gold on guild repairs'),
(0,0,0,0,'guild_dungeon',5,'Complete 5 guild dungeon runs'),
(0,0,0,0,'guild_raid',1,'Complete 1 guild raid run');

-- ============================================================
-- END OF CATA GUILD TASKS
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
