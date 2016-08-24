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
    SET @cOldStructure = '01'; 
    SET @cOldContent = '00'; 

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '02';
    SET @cNewContent = '00';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'script refactoring';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Major script system refactoring';

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
      

DROP TABLE IF EXISTS `script_binding`;
CREATE TABLE `script_binding` (
 `type` TINYINT(2) UNSIGNED NOT NULL COMMENT 'enum ScriptedObjectType',
 `ScriptName` CHAR(64) NOT NULL COMMENT 'Script name, to be unique across all types',
 `bind` MEDIUMINT(10) NOT NULL COMMENT 'Bound to entry (>0) or GUID (<0)',
 `data` TINYINT(2) UNSIGNED DEFAULT 0 COMMENT 'Misc data; Effect number for spellscripts',
 PRIMARY KEY(`ScriptName`,`bind`),
 KEY(`type`)
) Engine=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='SD2 Script Names and Binding';

-- grab the script binding info into the new table
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 0,`ScriptName`,`entry` FROM `creature_template` WHERE (`ScriptName` IS NOT NULL AND `ScriptName` != "");
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 1,`ScriptName`,`entry` FROM `gameobject_template` WHERE (`ScriptName` IS NOT NULL AND `ScriptName` != "");
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 2,`ScriptName`,`entry` FROM `item_template` WHERE (`ScriptName` IS NOT NULL AND `ScriptName` != "");
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 3,`ScriptName`,`entry` FROM `scripted_areatrigger`;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 6,`ScriptName`,`id` FROM `scripted_event`;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 7,`ScriptName`,`map` FROM `world_template`;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) SELECT 10,`ScriptName`,`map` FROM `instance_template` WHERE (`ScriptName` IS NOT NULL AND `ScriptName` != "");

-- truncate/drop the old tables. NOTE: ALTERs are necessary for the core start because of SQLStorage class behaviour
ALTER TABLE `creature_template` DROP COLUMN `ScriptName`;
ALTER TABLE `gameobject_template` DROP COLUMN `ScriptName`;
ALTER TABLE `item_template` DROP COLUMN `ScriptName`;
DROP TABLE IF EXISTS `scripted_areatrigger`;
DROP TABLE IF EXISTS `scripted_event`;
DROP TABLE IF EXISTS `world_template`;
ALTER TABLE `instance_template` DROP COLUMN `ScriptName`;

-- ** detailed fixes **
DELETE FROM `script_binding` WHERE `type`=6 AND `bind`=8328;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`) VALUES (6, 'event_npc_kroshius', 8328);

UPDATE `script_binding` SET `ScriptName`='guard_generic' WHERE `ScriptName` IN ('guard_bluffwatcher', 'guard_contested', 'guard_darnassus', 'guard_dunmorogh', 'guard_durotar',
  'guard_elwynnforest', 'guard_ironforge', 'guard_mulgore', 'guard_teldrassil', 'guard_tirisfal', 'guard_undercity');

-- instance script added (via code refactoring)
DELETE FROM `script_binding` WHERE `bind`=129 AND `type`=10;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (10,'instance_razorfen_downs',129,0);
-- UPDATE `instance_template` SET `ScriptName`='instance_razorfen_downs' WHERE `map`=129;

-- ****************************************************************************
-- spellscripts: created binds to spell/aura ID
-- ****************************************************************************
DELETE FROM `script_binding` WHERE `bind`=27517 AND `type`=4 AND `data`=1;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_banner_of_provocation',27517,1);
DELETE FROM `script_binding` WHERE `type`=0 AND `ScriptName`='npc_theldren_trigger';

DELETE FROM `script_binding` WHERE `bind`=13489 AND `type`=4 AND `data`=1;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_boss_ambassador_flamelash',13489,1);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind`=16049 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_emberseer_growing',16049,0);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind` IN (11511,11795) AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_boss_thermaplugg',11511,0);
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_boss_thermaplugg',11795,0);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind`=12639 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_summon_hakkar',12639,0);
DELETE FROM `script_binding` WHERE `type`=0 AND `ScriptName`='npc_shade_of_hakkar';

DELETE FROM `script_binding` WHERE `bind`=10258 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_vault_warder',10258,0);
DELETE FROM `script_binding` WHERE `type`=0 AND `ScriptName`='mob_archaeras_add';

DELETE FROM `script_binding` WHERE `bind` IN (10252,10259) AND `type`=5 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (5,'spell_aura_awaken_dwarf',10252,0);
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (5,'spell_aura_awaken_dwarf',10259,0);
-- mob script deleted 5 lines above

DELETE FROM `script_binding` WHERE `bind`=19873 AND `type`=4 AND `data`=1;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_go_black_dragon_egg',19873,1);
DELETE FROM `script_binding` WHERE `type`=1 AND `ScriptName`='go_black_dragon_egg';

DELETE FROM `script_binding` WHERE `bind`=19484 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_boss_majordomo',19484,0);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind` IN (27892,27928,27935,27893,27929,27936,27915,27931,27937) AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES
 (4,'spell_anchor',27892,0),(4,'spell_anchor',27928,0),(4,'spell_anchor',27935,0),
 (4,'spell_anchor',27893,0),(4,'spell_anchor',27929,0),(4,'spell_anchor',27936,0),
 (4,'spell_anchor',27915,0),(4,'spell_anchor',27931,0),(4,'spell_anchor',27937,0);
DELETE FROM `script_binding` WHERE `type`=0 AND `ScriptName`='spell_anchor';

DELETE FROM `script_binding` WHERE `bind` IN (28159,28136) AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_thaddius_encounter',28159,0);
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_thaddius_encounter',28136,0);
-- no delete: was a part of mob script

DELETE FROM `script_binding` WHERE `bind`=24173 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_thekal_resurrection',24173,0);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind`=14250 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_capture_grark',14250,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=18969 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_taelan_fordring',18969,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=21708 AND `type`=5 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (5,'aura_dummy_noxxion_spawns',21708,0);
-- no delete: was a mob script part

-- the following activity is moved to the RFD instance script
DELETE FROM `script_binding` WHERE `bind` IN (7349,7351) AND `type`=0;

DELETE FROM `script_binding` WHERE `bind`=8283 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_snufflenose_gopher',8283,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=3730 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_prophet_skeram',3730,0);
-- no delete: was a boss script part

DELETE FROM `script_binding` WHERE `bind`=18153 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_aged_dying_ancient_kodo',18153,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=19938 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_lazy_peon_awake',19938,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=16510 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_kitten',16510,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=11402 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_shay_leafrunner',11402,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind`=25813 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_conjure_rift',25813,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind` IN (8593,31225) AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_npc_redemption_target',8593,0);
-- no delete: was a mob script part

DELETE FROM `script_binding` WHERE `bind` IN (10848,17327) AND `type`=5 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (5,'aura_spirit_particles',10848,0),(5,'aura_spirit_particles',17327,0);
DELETE FROM `script_binding` WHERE `bind`=19512 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_apply_salve',19512,0);
DELETE FROM `script_binding` WHERE `bind`=8913 AND `type`=4 AND `data`=1;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_sacred_cleansing',8913,1);
DELETE FROM `script_binding` WHERE `bind`=21050 AND `type`=4 AND `data`=0;
INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES (4,'spell_melodious_rapture',21050,0);
-- both dummy auras ans spells are affected
DELETE FROM `script_binding` WHERE `type`=0 AND `ScriptName`='spell_dummy_npc';

-- *** LATER FIXES ***
UPDATE `script_binding` SET `ScriptName`='npc_giant_claw_tentacle' WHERE `ScriptName`='mob_giant_claw_tentacle' AND `type`=0;
     

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