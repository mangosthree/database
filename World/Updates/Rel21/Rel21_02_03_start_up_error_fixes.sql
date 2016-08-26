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
    SET @cNewDescription = 'start up error fixes';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'start up error fixes';

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
      
-- no record of these being game objects anywhere
-- '207282', '22', '10361', 'Oasis flower', '', '', '', '0', '0', '1.5', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
-- '207283', '22', '10355', 'Feeler', '', '', '', '0', '0', '1.5', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
-- '207284', '22', '10354', 'Dryzgun', '', '', '', '0', '0', '3', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
-- '207285', '22', '10248', 'Thorns', '', '', '', '0', '0', '0.33', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
-- '207326', '22', '10262', 'Pumpkin bomb', '', '', '', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
-- '207350', '22', '10356', 'Ledenyuka', '', '', '', '0', '0', '3', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', ''
DELETE FROM gameobject_template WHERE ENTRY IN (207350, 207326, 207285, 207284, 207283, 207282);


-- 2016-08-09 20:08:50 Item (Entry: 70735) has wrong RandomSuffix (462)
-- 2016-08-09 20:08:50 Item (Entry: 71030) has wrong RandomSuffix (464)
-- 2016-08-09 20:08:50 Item (Entry: 71403) has wrong RandomSuffix (465)
-- 2016-08-09 20:08:50 Item (Entry: 71421) has wrong RandomSuffix (457)
-- 2016-08-09 20:08:50 Item (Entry: 71428) has wrong RandomSuffix (463)
-- 2016-08-09 20:08:50 Item (Entry: 71450) has wrong RandomSuffix (461)
-- 2016-08-09 20:08:50 Item (Entry: 71458) has wrong RandomSuffix (459)
-- These do not exist in item_enchantment_template table
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='70735';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71030';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71403';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71421';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71428';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71450';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71458';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71011';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='71025';
UPDATE item_template SET `RandomSuffix`='0' WHERE `entry`='70917';

-- wrong value for spellid_1
-- spellid_1 109659
UPDATE item_template SET `spellid_1`='483' WHERE `entry`='78342';

-- creature guid does not exist
DELETE FROM creature_addon WHERE `guid`='354064';


-- 2016-08-10 09:08:31 Creature (Entry: 9983) has gossip_menu_id = 10902 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 11948) has gossip_menu_id = 6268 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 23736) has gossip_menu_id = 13045 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 36730) has gossip_menu_id = 10844 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 36919) has gossip_menu_id = 10852 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 39594) has gossip_menu_id = 11236 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 40035) has gossip_menu_id = 11828 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 40344) has gossip_menu_id = 11371 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 42323) has gossip_menu_id = 11617 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 48735) has gossip_menu_id = 12677 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 50041) has gossip_menu_id = 12548 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 50502) has gossip_menu_id = 12882 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 51735) has gossip_menu_id = 12720 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 51944) has gossip_menu_id = 12718 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 52335) has gossip_menu_id = 12755 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 52636) has gossip_menu_id = 8517 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 55285) has gossip_menu_id = 13111 for nonexistent menu
-- 2016-08-10 09:08:31 Creature (Entry: 56041) has gossip_menu_id = 13210 for nonexistent menu

-- missing records found in SkyFire's 4.3.4 database
-- Creature (Entry: 9983)
UPDATE creature_template SET GossipMenuId = 9821 WHERE entry = 9983;
UPDATE creature_template SET GossipMenuId = 0 WHERE entry IN (11948, 23736, 36730, 36919, 39594, 40035, 40344, 42323, 48735, 50041, 50502, 51735, 51944, 52335, 52636, 55285, 56041);

-- '26373', '1', '7991.88', '-2679.84', '512.1', '0.034183'
-- '64014', '603', '-705.971', '-92.5573', '430.819', '0'
-- '64025', '603', '2518.13', '2569.34', '412.682', '0'
-- '64028', '603', '553.243', '-12.309', '410.543', '0'
-- '64029', '603', '1859.56', '-24.8377', '449.194', '6.23082'
-- '64030', '603', '1497.99', '-24.1616', '421.625', '0.0349066'
-- '64031', '603', '926.292', '-11.4444', '418.978', '0.0174533'
-- '64032', '603', '131.139', '-35.3681', '410.187', '0'
-- '65042', '603', '1855.07', '-11.4879', '334.559', '5.53269'
-- '70781', '631', '-17.0711', '2211.47', '30.0546', '3.14159'
-- '70856', '631', '-503.593', '2211.47', '62.7621', '3.14159'
-- '70857', '631', '-615.146', '2211.47', '199.909', '0'
-- '70858', '631', '-549.073', '2211.29', '539.223', '0'
-- '70859', '631', '4199.48', '2769.32', '351.372', '3.12414'
-- '70860', '631', '529.302', '-2124.49', '840.857', '3.1765'
-- '70861', '631', '4356.58', '2565.75', '220.402', '4.71238'
-- '84463', '730', '852.306', '1038.92', '-5.3136', '4.88692'
-- '84505', '0', '-8208.25', '429.244', '118.11', '3.4775'
-- '84506', '1', '2049.2', '-4376.8', '98.8446', '0.785398'
-- '88345', '732', '-344.6', '1043.8', '21.5', '1.5'
-- '88346', '732', '-601.4', '1382.03', '21.9', '1.5'
-- '88775', '657', '-907', '-185', '665', '2'
-- '90244', '0', '-6561.97', '6140.03', '-671.06', '1.14835'
-- '90245', '0', '-6884.06', '5963.37', '-765.385', '2.85659'
DELETE FROM spell_target_position WHERE id IN (64024, 70860, 84506, 84505, 70781, 70856, 70857, 70858, 70859, 70861, 84463, 88345, 88346, 88775, 90244, 90245, 26373, 65042, 64032, 64031, 64030, 64029, 64028, 64028, 64025, 64014);

-- '26678', '21816', '10', '0', '1', '1', '0'
-- '26678', '21817', '10', '0', '1', '1', '0'
-- '26678', '21818', '10', '0', '1', '1', '0'
-- '26678', '21819', '10', '0', '1', '1', '0'
-- '26678', '21820', '15', '0', '1', '1', '0'
-- '26678', '21821', '15', '0', '1', '1', '0'
-- '26678', '21822', '15', '0', '1', '1', '0'
-- '26678', '21823', '15', '0', '1', '1', '0'
-- spell id does not exist
DELETE FROM spell_loot_template WHERE entry = 26678;

-- duplicate instances of William
-- '53074', '2533', '0', '1', '1', '0', '0', '-8739.04', '549.987', '100.173', '5.45979', '370', '0', '0', '42', '0', '0', '2'
DELETE FROM creature WHERE `guid`='53074';
-- '188982', '2533', '0', '1', '1', '262', '0', '-8747.63', '692.959', '99.827', '3.89866', '300', '0', '0', '42', '0', '0', '2'
DELETE FROM creature WHERE `guid`='188982';

-- '188982', '1', '-8742.19', '699.102', '99.1405', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- '188982', '2', '-8742.19', '698.102', '99.1405', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- '188982', '3', '-8747.27', '693.297', '99.7655', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- '188982', '4', '-8751.63', '689.178', '100.516', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- '188982', '5', '-8752.98', '687.911', '100.641', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- '188982', '6', '-8752.98', '687.911', '100.641', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'
-- duplicate William
DELETE FROM creature_movement WHERE `id`='188982' and`point`='1';
DELETE FROM creature_movement WHERE `id`='188982' and`point`='2';
DELETE FROM creature_movement WHERE `id`='188982' and`point`='3';
DELETE FROM creature_movement WHERE `id`='188982' and`point`='4';
DELETE FROM creature_movement WHERE `id`='188982' and`point`='5';
DELETE FROM creature_movement WHERE `id`='188982' and`point`='6';

-- 2016-08-11 18:16:29 Table `dbscripts_on_quest_start` has searchRadius = 0 in command 15 for script id 25141 for buddy 3155, skipping.
-- '25141', '0', '15', '25141', '0', '3155', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', 'This should cause the NPC to cast the spell corresponding to combo points at the beginning of the eviscerate quest... #25141'
-- does not exist
SET SQL_SAFE_UPDATES = 0;
DELETE FROM dbscripts_on_quest_start WHERE id = 25141;

-- 2016-08-12 08:55:44 Table 'gameobject_loot_template' entry 17155 item 5397: item entry not listed in `item_template` - skipped
-- 2016-08-12 08:55:44 Table 'gameobject_loot_template' entry 17155 (gameobject lootid) not exist but used as loot id in DB
-- Defias Gunpowder removed in Cata
-- '17155', '5397', '100', '0', '1', '1', '0'
DELETE FROM gameobject_loot_template WHERE entry = 17155;
DELETE FROM gameobject_template WHERE entry = 17155;
DELETE FROM dbscripts_on_event WHERE id = 619;
DELETE FROM gameobject_loot_template WHERE entry = 208430;
-- Defias gunpowder was removed in patch 4.0.3
DELETE FROM item_template WHERE entry = 5397;

-- 82175 does not exist
-- deleted records: 
-- '84425', '82175', '425', '100'
-- '84424', '82175', '425', '100'
-- '82177', '82175', '425', '100'
-- '82200', '82175', '425', '100'
-- '82201', '82175', '425', '100'
-- '84427', '82175', '425', '100'
-- '82180', '82175', '425', '100'
-- '82175', '82175', '425', '100'
DELETE FROM skill_discovery_template WHERE reqSpell = 82175;

-- 81275 does not exist
-- '82180', '81275', '425', '100'
-- '84427', '81275', '425', '100'
-- '82201', '81275', '425', '100'
-- '82200', '81275', '425', '100'
-- '82177', '81275', '425', '100'
-- '84424', '81275', '425', '100'
-- '84425', '81275', '425', '100'
DELETE FROM skill_discovery_template WHERE reqSpell = 81275;

-- spell_symbol_of_life removed in Cata
-- '4', 'spell_symbol_of_life', '8593', '0'
-- '4', 'spell_symbol_of_life', '31225', '0'
DELETE FROM script_binding WHERE ScriptName = 'spell_symbol_of_life' and bind = 8593;
DELETE FROM script_binding WHERE ScriptName = 'spell_symbol_of_life' and bind = 31225;


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