-- --------------------------------------------------------------------------------
-- This is an attempt to create a full transactional update
-- --------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos` ()

BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT structure FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurContent := (SELECT content FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '02'; 
    SET @cOldContent = '02'; 

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '02';
    SET @cNewContent = '03';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'many cmangos updates';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'many cmangos updates';

    -- Evaluate all settings
    SET @cCurResult := (SELECT description FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cOldResult := (SELECT description FROM db_version WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;

        -- UPDATE THE DB VERSION
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
        SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
 

-- new spell
DELETE FROM spell_template WHERE id = 21883;
INSERT INTO spell_template VALUES 
('21883', '0x00000180', '0x10000000', '0x00000000', '0x00000000', '0x00000000', '101', '225', '76', '22', '0', '0', '0', '178904', '0', '0', 'Summon Healed Celebrian Vine');

-- teleport quest to Dalaran
UPDATE `dbscripts_on_gossip` SET `data_flags` = '2' WHERE `dbscripts_on_gossip`.`id` = 9511;

-- Implement spell effect 11756, 19394
DELETE FROM spell_template WHERE id IN (11756,19394);
INSERT INTO spell_template VALUES
(11756, 0x00000180, 0x10000000, 0x00000000, 0x00000000, 0x00000000, 101,   4,  76,  47,    0,  15,   0, 144064,  0,    0,     'Summon Gordunni chest (COBALT)'),
(19394, 0x00000180, 0x10000000, 0x00000000, 0x00000000, 0x00000000, 101,   4,  76,  47,    0,  15,   0, 177681,  0,    0,     'Summon Gordunni chest (JUNK)');

-- Add server side spells 68523 and 68620
DELETE FROM spell_template WHERE id IN (68523,68620);
INSERT INTO spell_template VALUES
(68523, 0x00800180, 0x00000000, 0x00000005, 0x00000000, 0x00000000, 101,  37,   6,  22,    7,  28,   4, 0,       0,    0,     'Achievement check - Trial of the Crusader - Not One, But Two Jormungars'),
(68620, 0x00800180, 0x00000000, 0x00000005, 0x00000000, 0x00000000, 101,  37,   6,  22,    7,  28,   4, 0,       0,    0,     'Achievement check - Trial of the Crusader - Resilience Will Fix It');

-- [c13058] Add missing achiev check spells for ToC5
DELETE FROM spell_template WHERE id IN (68572,68574,68575);
INSERT INTO spell_template VALUES
(68572, 0x00800180, 0x00000000, 0x00000005, 0x00000000, 0x00000000, 101,  37,   6,  22,    7,  28,   4, 0,       0,    0,     'Achievement check - Grand Champions'),
(68574, 0x00800180, 0x00000000, 0x00000005, 0x00000000, 0x00000000, 101,  37,   6,  22,    7,  28,   4, 0,       0,    0,     'Achievement check - Confessor Paletress'),
(68575, 0x00800180, 0x00000000, 0x00000005, 0x00000000, 0x00000000, 101,  37,   6,  22,    7,  28,   4, 0,       0,    0,     'Achievement check - Eadric the Pure');

-- [c13027] Rewrite Waypoint related commands
-- Toggle the commands .wp add .wp modify and .wp show to be able to work with waypoints from creature_movement_template
DELETE FROM command WHERE name='wp add' OR name='wp modify' OR name='wp show';
INSERT INTO command VALUES
('wp add',2,'Syntax: .wp add [Selected Creature or dbGuid] [pathId [wpOrigin] ]'),
('wp modify',2,'Syntax: .wp modify command [dbGuid, id] [value]\r\nwhere command must be one of: waittime  | scriptid | orientation | del | move\r\nIf no waypoint was selected, one can be chosen with dbGuid and id.\r\nThe commands have the following meaning:\r\n waittime (Set the time the npc will wait at a point (in ms))\r\n scriptid (Set the DB-Script that will be executed when the wp is reached)\r\n orientation (Set the orientation of this point) \r\n del (Remove the waypoint from the path)\r\n move (Move the wayoint to the current position of the player)'),
('wp show',2,'Syntax: .wp show command [dbGuid] [pathId [wpOrigin] ]\r\nwhere command can have one of the following values\r\non (to show all related wp)\r\nfirst (to see only first one)\r\nlast (to see only last one)\r\noff (to hide all related wp)\r\ninfo (to get more info about theses wp)\r\n\r\nFor using info you have to do first show on and than select a Visual-Waypoint and do the show info!\r\nwith pathId and wpOrigin you can specify which path to show (optional)');

DELETE FROM mangos_string WHERE entry BETWEEN 220 AND 252;
INSERT INTO mangos_string VALUES
(220,'Cannot find waypoint id %u for %s (in path %i, loaded from %s)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(221,'Last Waypoint not found for %s',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(222,'%s has no path or path empty, path-id %i (loaded from %s)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(223,'Creature (GUID: %u) No waypoints found - This is a MaNGOS db problem (single float).',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(224,'Cannot access %s on map, maybe you are too far away from its spawn location',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(225,'Creature (GUID: %u) not found',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(226,'You must select a visual waypoint.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(227,'No visual waypoints found',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(228,'Could not create visual waypoint with creatureID: %d',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(229,'All visual waypoints removed',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(230,'Could not add waypoint %u to %s (pathId %i stored by %s)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(231,'No GUID provided.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(232,'No waypoint number provided.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(233,'Argument required for \'%s\'.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(234,'Added Waypoint %u to %s (PathId %i, path stored by %s)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(235,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(236,'Waypoint changed.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(237,'Waypoint %s modified.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(238,'WP export successfull.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(239,'No waypoints found inside the database.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(240,'File imported.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(241,'Waypoint removed.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(242,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(243,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(244,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(245,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(246,'Waypoint %u for %s (from pathId %i, stored by %s)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(247,' Waittime: %d',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(248,' Orientation: %f',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(249,' ScriptId: %u',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(250,'ScriptID set to non-existing id %u, add it to DBScriptsEngine and reload the table.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(251,'UNUSED',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(252,'AIScriptName: %s',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- (Cmangos) [c13034] Waypoint Commands: Improve export command, remove import command
ALTER TABLE creature_movement DROP COLUMN wpguid;
ALTER TABLE creature_movement_template DROP COLUMN wpguid;

-- New scripts

-- (Cmangos) Script for quest 11881
DELETE FROM script_binding WHERE ScriptName = 'npc_jenny' AND bind = 25969;
INSERT INTO script_binding VALUES (0, 'npc_jenny', 25969, 0);

-- (Cmangos) Implement script for creature 10498
DELETE FROM script_binding WHERE ScriptName = 'npc_spectral_tutor' AND bind = 10498;
INSERT INTO script_binding VALUES (0, 'npc_spectral_tutor', 10498, 0);


-- (Cmangos) Implement script for burster worms in Outland
DELETE FROM script_binding WHERE ScriptName = 'npc_burster_worm' AND bind IN (16844,16857,16968,21380,21849,22038,22466,22482,23285);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 16844, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 16857, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 16968, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 21380, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 21849, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 22038, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 22466, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 22482, 0);
INSERT INTO script_binding VALUES (0, 'npc_burster_worm', 23285, 0);


-- Script for quest 10218
-- ----------------------

/* MANA TOMBS */
DELETE FROM script_binding WHERE ScriptName = 'npc_shaheen' AND bind = 19671;
INSERT INTO script_binding VALUES (0, 'npc_shaheen', 19671, 0);

DELETE FROM script_texts where entry IN (-1557015,-1557016,-1557017,-1557018,-1557019,-1557020,-1557021,-1557022,-1557023,-1557024,-1557025,-1557026,-1557027,-1557028,-1557029,-1557030,-1557031,-1557032,-1557033,-1557034,-1557035);
INSERT INTO script_texts (entry,content_default,sound,type,language,emote,comment) VALUES
(-1557015,'This should\'t take very long. Just watch my back as I empty these nether collectors.',0,0,0,0,'sha\'heen SAY_ESCORT_START'),
(-1557016,'Fantastic! let\'s move on, shall we?',0,0,0,0,'sha\'heen SAY_START'),
(-1557017,'Looking at these energy levels, Shaffar was set to make a killing!',0,0,0,28,'sha\'heen SAY_FIRST_STOP'),
(-1557018,'That should do it...',0,0,0,0,'sha\'heen SAY_FIRST_STOP_COMPLETE'),
(-1557019,'Hmm, now where is the next collector?',0,0,0,0,'sha\'heen SAY_COLLECTOR_SEARCH'),
(-1557020,'Ah, there it is. Follow me, fleshling.',0,0,0,0,'sha\'heen SAY_COLLECTOR_FOUND'),
(-1557021,'There can\'t be too many more of these collectors. Just keep me safe as I do my job.',0,0,0,28,'sha\'heen SAY_SECOND_STOP'),
(-1557022,'What do we have here? I thought you said the area was secure? This is now the third attack? If we make it out of here, I will definitely be deducting this from your reward. Now don\'t just stand here, destroy them so I can get to that collector.',0,0,0,0,'sha\'heen SAY_THIRD_STOP'),
(-1557023,'We\'re close to the exit. I\'ll let you rest for about thirty seconds, but then we\'re out of here.',0,0,0,0,'sha\'heen SAY_REST'),
(-1557024,'Are you ready to go?',0,0,0,0,'sha\'heen SAY_READY_GO'),
(-1557025,'Ok break time is OVER. Let\'s go!',0,0,0,0,'sha\'heen SAY_BREAK_OVER'),
(-1557026,'Shadow Lord Xiraxis yells: Bravo! Bravo! Good show... I couldn\'t convince you to work for me, could I? No, I suppose the needless slaughter of my employees might negatively impact your employment application.',0,1,0,0,'xiraxis SAY_SPAWN'),
(-1557027,'Your plan was a good one, Sha\'heen, and you would have gotten away with it if not for one thing...',0,0,0,1,'xiraxis SAY_FINAL_STOP_1'),
(-1557028,'Oh really? And what might that be?',0,0,0,1,'sha\'heen SAY_FINAL_STOP_2'),
(-1557029,'Never underestimate the other ethereal\'s greed!',0,0,0,0,'xiraxis SAY_FINAL_STOP_3'),
(-1557030,'He was right, you know. I\'ll have to take that tag-line for my own... It\'s not like he\'ll have a use for it anymore!',0,0,0,1,'sha\'heen SAY_XIRAXIS_DEAD'),
(-1557031,'Thanks and good luck!',0,0,0,1,'sha\'heen SAY_COMPLETE'),
(-1557032,'%s checks to make sure his body is intact.',0,2,0,0,'sha\'heen EMOTE_TELEPORT'),
(-1557033,'You made it! Well done, $r. Now if you\'ll excuse me, I have to get the rest of our crew inside.',0,0,0,1,'sha\'heen SAY_SPAWN'),
(-1557034,'%s expertly manipulates the control panel.',0,2,0,28,'sha\'heen EMOTE_PANEL'),
(-1557035,'Let\'s not waste any time! Take anything that isn\'t nailed down to the floor and teleport directly to Stormspire! Chop chop!',0,0,0,1,'sha\'heen SAY_ESCORT_READY');
  
DELETE FROM script_waypoint WHERE entry=19671;
INSERT INTO script_waypoint VALUES
(19671, 0, -362.876, -71.333, -0.960, 5000, 'SAY_ESCORT_START'),
(19671, 1, -372.647, -88.728, -0.958, 0, ''),
(19671, 2, -373.163, -114.959, -0.958, 0, ''),
(19671, 3, -373.137, -138.439, -0.958, 0, ''),
(19671, 4, -373.687, -152.964, -0.958, 0, ''),
(19671, 5, -379.091, -158.089, -0.958, 0, ''),
(19671, 6, -381.149, -164.796, -0.958, 0, ''),
(19671, 7, -375.292, -164.111, 0.715, 0, 'SAY_FIRST_STOP - escort paused'),
(19671, 8, -375.292, -164.111, 0.715, 1000, 'SAY_FIRST_STOP_COMPLETE'),
(19671, 9, -381.149, -164.796, -0.958, 0, ''),
(19671, 10, -374.292, -193.614, -0.967, 0, ''),
(19671, 11, -370.799, -217.796, -0.959, 0, ''),
(19671, 12, -344.132, -222.647, -0.959, 0, ''),
(19671, 13, -310.880, -219.357, -0.945, 9000, 'SAY_COLLECTOR_SEARCH'),
(19671, 14, -299.879, -201.809, -1.181, 0, ''),
(19671, 15, -285.874, -187.791, -0.694, 0, ''),
(19671, 16, -271.884, -164.856, -1.912, 0, ''),
(19671, 17, -260.729, -159.094, -1.190, 0, 'SAY_SECOND_STOP - escort paused'),
(19671, 18, -244.372, -163.136, -0.924, 0, ''),
(19671, 19, -236.428, -185.952, -0.953, 0, ''),
(19671, 20, -210.659, -206.710, 0.906, 0, ''),
(19671, 21, -193.375, -219.378, -0.518, 0, ''),
(19671, 22, -171.121, -223.043, -0.955, 0, ''),
(19671, 23, -148.658, -221.031, -0.770, 0, ''),
(19671, 24, -128.150, -215.657, -0.187, 0, ''),
(19671, 25, -93.429, -219.264, -1.320, 0, ''),
(19671, 26, -72.886, -222.278, -0.184, 0, 'SAY_THIRD_STOP - escort paused'),
(19671, 27, -42.343, -224.004, -0.268, 0, ''),
(19671, 28, -15.603, -223.780, 0.793, 0, ''),
(19671, 29, -12.975, -223.157, 1.811, 42000, 'SAY_REST'),
(19671, 30, -12.975, -223.157, 1.811, 5000, 'SAY_BREAK_OVER'),
(19671, 31, -14.898, -222.906, 0.786, 0, ''),
(19671, 32, -44.684, -221.592, -0.146, 0, ''),
(19671, 33, -59.746, -211.847, 0.216, 0, ''),
(19671, 34, -63.100, -195.288, -0.615, 0, ''),
(19671, 35, -63.218, -191.959, -1.725, 0, ''),
(19671, 36, -67.063, -160.281, -0.955, 0, ''),
(19671, 37, -67.888, -128.704, -1.226, 0, ''),
(19671, 38, -68.226, -107.766, -0.289, 0, ''),
(19671, 39, -68.251, -105.624, -1.631, 0, ''),
(19671, 40, -66.342, -88.147, -1.167, 0, 'SAY_XIRAXIS_SPAWN - escort paused'),
(19671, 41, -67.831, -78.571, -2.114, 0, ''),
(19671, 42, -67.692, -76.665, -0.941, 0, ''),
(19671, 43, -67.624, -56.025, -0.844, 0, 'quest complete'),
(19671, 44, -64.493, -15.776, -0.943, 0, '');
 

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
            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
	    IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
	    ELSE
                SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurResult AS `===== Found Version =====`;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;      