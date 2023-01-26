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
    SET @cOldContent = '006';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '03';
    SET @cNewContent = '007';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'FIX_GameEvents';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'FIX_GameEvents';

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

UPDATE `game_event` set start_time='2013-06-20 20:00:00', end_time='2020-12-29 21:00:00' where entry=1; -- Midsummer Fire Festival
UPDATE `game_event` set start_time='2013-12-15 03:00:00', end_time='2020-12-30 17:00:00' where entry=2; -- Feast of Winter Veil
UPDATE `game_event` set start_time='2013-08-31 18:01:00', end_time='2012-12-30 14:00:00' where entry=3; -- Darkmoon Faire (Terokkar Forest
UPDATE `game_event` set start_time='2013-10-05 18:01:00', end_time='2012-12-30 14:00:00' where entry=4; -- Darkmoon Faire (Elwynn Forest
UPDATE `game_event` set start_time='2013-08-03 18:01:00', end_time='2012-12-30 14:00:00' where entry=5; -- Darkmoon Faire (Mulgore
UPDATE `game_event` set start_time='2010-12-31 17:00:00', end_time='2010-12-31 17:00:00' where entry=6; -- New Year's Eve
UPDATE `game_event` set start_time='2013-01-22 03:00:00', end_time='2020-12-30 17:00:00' where entry=7; -- Lunar Festival
UPDATE `game_event` set start_time='2013-02-04 19:01:00', end_time='2020-12-20 15:00:00' where entry=8; -- Love is in the Air
UPDATE `game_event` set start_time='2013-03-31 18:01:00', end_time='2020-12-30 17:00:00' where entry=9; -- Noblegarden
UPDATE `game_event` set start_time='2013-04-28 18:01:00', end_time='2020-12-30 17:00:00' where entry=10; -- Children's Week 
UPDATE `game_event` set start_time='2013-09-05 18:01:00', end_time='2020-12-29 21:00:00' where entry=11; -- Harvest Festival
UPDATE `game_event` set start_time='2013-10-17 18:00:00', end_time='2020-12-31 04:00:00', occurence=525600 where entry=12; -- Hallow's End
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=13; -- Elemental Invasions
UPDATE `game_event` set start_time='2010-12-19 11:50:00', end_time='2020-12-30 11:00:00' where entry=14; -- Fishing Extravaganza Announce
UPDATE `game_event` set start_time='2010-12-19 12:00:00', end_time='2020-12-27 11:00:00' where entry=15; -- Fishing Extravaganza
UPDATE `game_event` set start_time='2010-11-30 19:00:00', end_time='2020-12-30 14:00:00' where entry=16; -- Gurubashi Arena Booty Run
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=17; -- Scourge Invasion
UPDATE `game_event` set start_time='2012-11-15 19:01:00', end_time='2020-11-19 17:00:00' where entry=18; -- Call to Arms: Alterac Valley!
UPDATE `game_event` set start_time='2012-11-22 19:01:00', end_time='2020-11-26 17:00:00' where entry=19; -- Call to Arms: Warsong Gulch!
UPDATE `game_event` set start_time='2012-11-26 19:01:00', end_time='2020-11-30 17:00:00' where entry=20; -- Call to Arms: Arathi Basin!
UPDATE `game_event` set start_time='2012-11-08 19:01:00', end_time='2020-11-12 17:00:00' where entry=21; -- Call to Arms: Eye of the Storm!
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=22; -- AQ War Effort
UPDATE `game_event` set start_time='2009-03-06 02:00:00', end_time='2011-12-30 20:00:00' where entry=23; -- Wolfs Attack to the Orgrimmar (Wolfs Group One
UPDATE `game_event` set start_time='2009-03-05 23:05:00', end_time='2011-12-30 20:00:00' where entry=24; -- Wolfs Attack to the Orgrimmar (Wolfs Group Two
UPDATE `game_event` set start_time='2007-08-12 10:00:07', end_time='2020-12-30 20:00:00' where entry=25; -- Orgrimmar Grunts Start Defend
UPDATE `game_event` set start_time='2013-09-19 20:00:00', end_time='2020-12-30 15:00:00' where entry=26; -- Brewfest
UPDATE `game_event` set start_time='2010-12-05 19:10:00', end_time='2020-12-30 18:00:00' where entry=27; -- Leader of Jin'Alai, Kutube'sa
UPDATE `game_event` set start_time='2007-08-12 15:59:59', end_time='2011-12-30 20:00:00' where entry=28; -- Death Legion Attack Stormwind City (Undead Attack
UPDATE `game_event` set start_time='2010-12-01 16:00:00', end_time='2020-12-30 17:00:00' where entry=29; -- Nights
UPDATE `game_event` set start_time='2012-11-29 19:01:00', end_time='2020-11-03 17:00:00' where entry=30; -- Call to Arms: Strand of the Ancients!
UPDATE `game_event` set start_time='2011-01-01 16:00:00', end_time='2020-12-30 19:00:00' where entry=31; -- Dalaran - Invitation to the Argent Crusade
UPDATE `game_event` set start_time='2013-09-18 18:01:00', end_time='2020-12-30 17:00:00' where entry=32; -- Pirates' Day
UPDATE `game_event` set start_time='2010-12-05 19:20:00', end_time='2020-12-30 18:00:00' where entry=33; -- Leader of Jin'Alai, Gawanil
UPDATE `game_event` set start_time='2010-09-18 08:00:00', end_time='2019-12-31 19:00:00' where entry=34; -- L70ETC Concert
UPDATE `game_event` set start_time='2010-09-05 18:01:00', end_time='2020-12-30 17:00:00' where entry=35; -- Edge of Madness, Gri'lek
UPDATE `game_event` set start_time='2010-09-19 18:01:00', end_time='2020-12-30 17:00:00' where entry=36; -- Edge of Madness, Hazza'rah
UPDATE `game_event` set start_time='2010-10-03 18:01:00', end_time='2020-12-30 17:00:00' where entry=37; -- Edge of Madness, Renataki
UPDATE `game_event` set start_time='2010-10-17 18:01:00', end_time='2020-12-30 17:00:00' where entry=38; -- Edge of Madness, Wushoolay
UPDATE `game_event` set start_time='2010-12-05 19:30:00', end_time='2020-12-30 18:00:00' where entry=39; -- Leader of Jin'Alai, Chulo
UPDATE `game_event` set start_time='2013-10-31 20:00:00', end_time='2020-12-30 17:00:00' where entry=40; -- Day of the Dead
UPDATE `game_event` set start_time='2013-11-17 20:00:00', end_time='2020-12-30 17:00:00' where entry=41; -- Pilgrim's Bounty
UPDATE `game_event` set start_time='2012-12-06 19:01:00', end_time='2020-12-10 17:00:00' where entry=42; -- Call to Arms: Isle of Conquest!
UPDATE `game_event` set start_time='2010-11-30 19:15:00', end_time='2020-12-30 17:00:00' where entry=43; -- Hammerfall Under Attack
UPDATE `game_event` set start_time='2010-11-30 19:00:00', end_time='2020-12-30 17:00:00' where entry=44; -- Thrallmar Demon Attack
UPDATE `game_event` set start_time='2010-12-18 09:00:00', end_time='2020-12-26 10:00:00' where entry=45; -- Kalu'ak Fishing Derby
UPDATE `game_event` set start_time='2010-09-07 18:00:01', end_time='2010-12-07 06:00:01' where entry=46; -- Zalazane's Fall
UPDATE `game_event` set start_time='2010-09-07 18:00:01', end_time='2010-12-07 06:00:01' where entry=47; -- Operation: Gnomeregan
UPDATE `game_event` set start_time='2010-11-01 05:00:01', end_time='2010-12-07 06:00:01' where entry=48; -- Twilight's Cult & Elemental Invasion
UPDATE `game_event` set start_time='2013-12-25 00:00:00', end_time='2020-12-31 00:00:00' where entry=49; -- Winter Veil: Gifts
UPDATE `game_event` set start_time='2009-12-31 19:01:00', end_time='2020-01-31 18:59:00' where entry=50; -- January
UPDATE `game_event` set start_time='2010-01-31 19:01:00', end_time='2020-02-29 18:59:00' where entry=51; -- February
UPDATE `game_event` set start_time='2010-02-28 19:01:00', end_time='2020-03-31 17:59:00' where entry=52; -- March
UPDATE `game_event` set start_time='2010-03-31 18:01:00', end_time='2020-04-30 17:59:00' where entry=53; -- April
UPDATE `game_event` set start_time='2010-04-30 18:01:00', end_time='2020-05-31 17:59:00' where entry=54; -- May
UPDATE `game_event` set start_time='2010-05-31 18:01:00', end_time='2020-06-30 17:59:00' where entry=55; -- June
UPDATE `game_event` set start_time='2010-06-30 18:01:00', end_time='2020-07-31 17:59:00' where entry=56; -- July
UPDATE `game_event` set start_time='2010-07-31 18:01:00', end_time='2020-08-31 17:59:00' where entry=57; -- August
UPDATE `game_event` set start_time='2010-08-31 18:01:00', end_time='2020-09-30 17:59:00' where entry=58; -- September
UPDATE `game_event` set start_time='2010-09-30 18:01:00', end_time='2020-10-31 18:59:00' where entry=59; -- October
UPDATE `game_event` set start_time='2010-10-31 19:01:00', end_time='2020-11-30 18:59:00' where entry=60; -- November
UPDATE `game_event` set start_time='2010-11-30 19:01:00', end_time='2020-12-31 18:59:00' where entry=61; -- December
UPDATE `game_event` set start_time='2010-12-31 21:48:00', end_time='2020-12-30 19:00:00' where entry=62; -- World's End Tavern - Perry Gatner Announce
UPDATE `game_event` set start_time='2010-12-31 22:00:00', end_time='2020-12-30 19:00:00' where entry=63; -- World's End Tavern - Perry Gatner Standup Comedy
UPDATE `game_event` set start_time='2010-09-22 18:01:00', end_time='2020-12-30 17:00:00' where entry=64; -- Fishing (winter season
UPDATE `game_event` set start_time='2011-03-19 19:01:00', end_time='2020-12-30 17:00:00' where entry=65; -- Fishing (summer season
UPDATE `game_event` set start_time='2010-10-31 19:00:00', end_time='2020-12-30 17:00:00' where entry=66; -- Fishing (00.00-06.00
UPDATE `game_event` set start_time='2010-11-01 01:00:00', end_time='2020-12-30 17:00:00' where entry=67; -- Fishing (06.00-12.00
UPDATE `game_event` set start_time='2010-11-01 07:00:00', end_time='2020-12-30 17:00:00' where entry=68; -- Fishing (12.00-18.00
UPDATE `game_event` set start_time='2010-11-01 13:00:00', end_time='2020-12-30 17:00:00' where entry=69; -- Fishing (18.00-00.00
UPDATE `game_event` set start_time='2010-12-31 22:48:00', end_time='2020-12-30 19:00:00' where entry=70; -- World's End Tavern - L70ETC Concert Announce
UPDATE `game_event` set start_time='2010-12-31 23:00:00', end_time='2020-12-30 19:00:00' where entry=71; -- World's End Tavern - L70ETC Concert
UPDATE `game_event` set start_time='2010-12-31 19:58:00', end_time='2020-12-30 19:00:00' where entry=72; -- Stormwind City - Stockades Jail Break
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=73; -- Night Elf Mohawk
UPDATE `game_event` set start_time='2013-08-03 19:01:00', end_time='2020-12-30 14:00:00' where entry=75; -- Darkmoon Faire
UPDATE `game_event` set start_time='2012-10-18 18:01:00', end_time='2020-10-22 16:00:00' where entry=76; -- Call to Arms: The Battle for Gilneas
UPDATE `game_event` set start_time='2012-10-25 18:01:00', end_time='2020-10-29 17:00:00' where entry=77; -- Call to Arms: Twin Peaks
UPDATE `game_event` set start_time='2012-11-22 19:01:00', end_time='2012-11-29 17:00:00' where entry=78; -- Rated Battleground 10x10
UPDATE `game_event` set start_time='2012-11-29 19:01:00', end_time='2012-12-06 17:00:00' where entry=79; -- Rated Battleground 15x15
UPDATE `game_event` set start_time='2012-12-06 19:01:00', end_time='2012-12-13 17:00:00' where entry=80; -- Rated Battleground 25x25
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=132; -- Arena Season 9
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=133; -- Arena Season 10
UPDATE `game_event` set start_time='0000-00-00 00:00:00', end_time='0000-00-00 00:00:00' where entry=134; -- Arena Season 11

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


