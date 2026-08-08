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
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '07';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Lfg_Dungeon_Entrances';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Dungeon Finder entrance overrides for multi-wing maps; wing coords from TC 4.3.4 lfg_dungeon_template seed';

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

-- Multi-wing instance maps share one areatrigger target per map, so
-- GetMapEntranceTrigger cannot tell Scarlet Monastery's four wings (or
-- Dire Maul's three, Maraudon's three, Stratholme's two) apart. This
-- table overrides the entrance per LFGDungeons.dbc id; absent rows fall
-- back to the areatrigger. Coordinate provenance (TC 4.3.4 seed): only
-- Ahune and Crown Chemical Co. are sniffed; the rest derive from
-- areatrigger_teleport or were hand-placed.
CREATE TABLE IF NOT EXISTS `lfg_dungeon_entrances` (
  `dungeonId` mediumint(8) unsigned NOT NULL COMMENT 'LFGDungeons.dbc id',
  `position_x` float NOT NULL DEFAULT 0,
  `position_y` float NOT NULL DEFAULT 0,
  `position_z` float NOT NULL DEFAULT 0,
  `orientation` float NOT NULL DEFAULT 0,
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dungeonId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Dungeon Finder Entrance Overrides';

DELETE FROM `lfg_dungeon_entrances`;
INSERT INTO `lfg_dungeon_entrances` (`dungeonId`, `position_x`, `position_y`, `position_z`, `orientation`, `comment`) VALUES
(18,  1688.99,  1053.48,   18.6775, 0.00117,  'Scarlet Monastery - Graveyard'),
(163, 1610.83,  -323.433,  18.6738, 6.28022,  'Scarlet Monastery - Armory'),
(164, 855.683,  1321.5,    18.6709, 0.001747, 'Scarlet Monastery - Cathedral'),
(165, 255.346,  -209.09,   18.6773, 6.26656,  'Scarlet Monastery - Library'),
(26,  1019.69,  -458.31,   -43.43,  0.31,     'Maraudon - Foulspore Cavern'),
(272, 752.91,   -616.53,   -33.11,  1.37,     'Maraudon - The Wicked Grotto'),
(273, 495.702,  17.3372,   -96.3128,3.11854,  'Maraudon - Earth Song Falls'),
(34,  44.4499,  -154.822,  -2.71201,0,        'Dire Maul - Warpwood Quarter'),
(36,  -62.9658, 159.867,   -3.46206,3.14788,  'Dire Maul - Capital Gardens'),
(38,  255.249,  -16.0561,  -2.58737,4.7,      'Dire Maul - Gordok Commons'),
(40,  3395.09,  -3380.25,  142.702, 0.1,      'Stratholme - Main Gate'),
(274, 3593.15,  -3646.56,  138.5,   5.33,     'Stratholme - Service Entrance'),
(255, 5239.01,  1932.64,   707.695, 0.800565, 'Halls of Reflection'),
(256, 5239.01,  1932.64,   707.695, 0.800565, 'Halls of Reflection - Heroic'),
(285, 1797.52,  1347.38,   18.8876, 3.142,    'The Headless Horseman'),
(286, -100.396, -95.9996,  -4.28423,4.71239,  'The Frost Lord Ahune'),
(287, 897.495,  -141.976,  -49.7563,2.1255,   'Coren Direbrew'),
(288, -238.075, 2166.43,   88.853,  1.13446,  'The Crown Chemical Co.');

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
