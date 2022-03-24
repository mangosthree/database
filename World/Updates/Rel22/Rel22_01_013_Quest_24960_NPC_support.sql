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
    SET @cOldStructure = '01'; 
    SET @cOldContent = '012';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '01';
    SET @cNewContent = '013';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Quest 24960 NPC support';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Quest 24960 NPC support';

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

	-- Set condition, Gossip should only be available to player with Quest:24960 active.
	SET @condition := (SELECT max(`condition_entry`) FROM `conditions`);
	INSERT INTO `conditions` (`condition_entry`, `type`, `value1`, `comments`) VALUES
	(@condition+1,9,24960,'Gossip Option check for q.24960');
	
	-- Update gossip_menu_option flags and next page.
	-- Speak with Marshal Redpath.
	UPDATE `gossip_menu_option` set `npc_option_npcflag` = 1, `action_menu_id` = 12486, `condition_id` = @condition+1 WHERE `menu_id` = 12485 AND `id` = 0;
	UPDATE `gossip_menu_option` set `npc_option_npcflag` = 1, `action_menu_id` = -1, `action_script_id` = 12486 WHERE `menu_id` = 12486 AND `id` = 0;
	 
	-- Speak with Lilian Voss.
	UPDATE `gossip_menu_option` SET `npc_option_npcflag` = 1, `action_menu_id` = 12484, `condition_id` = @condition+1 WHERE `menu_id` = 12483 AND `id` = 0;
	UPDATE `gossip_menu_option` SET `npc_option_npcflag` = 1, `action_menu_id` = -1, `action_script_id` = 12485 WHERE `menu_id` = 12484 AND `id` = 0;
	 
	-- Speak with Valdred Moray.
	UPDATE `gossip_menu_option` SET `npc_option_npcflag` = 1, `action_menu_id` = 12488, `condition_id` = @condition+1 WHERE `menu_id` = 12487 AND `id` = 0;
	UPDATE `gossip_menu_option` SET `npc_option_npcflag` = 1, `action_menu_id` = 12489 WHERE `menu_id` = 12488 AND `id` = 0;
	UPDATE `gossip_menu_option` SET `npc_option_npcflag` = 1, `action_menu_id` = -1, `action_script_id` = 12489 WHERE `menu_id` = 12489 AND `id` = 0;

	-- DB Strings
	SET @MAXstringentry := (SELECT max(`entry`) FROM `db_script_string`);
	INSERT INTO `db_script_string` (`entry`,`content_default`,`sound`,`type`,`language`,`emote`,`comment`) VALUES
	(@MAXstringentry+1,'Who are you calling a monster? You\'re the monster! I\'m just a man who died.',0,0,0,0,'Marshal Redpath'),
	(@MAXstringentry+2, 'No. You\'re lying! My father will protect me!',0,0,0,0,'Lilian Voss'),
	(@MAXstringentry+3, 'I see. Well then, let\'s get to work $n! The Dark Lady needs us, right?',0,0,0,0,'Valdred Moray');

	-- DB script for say after gossip.
	DELETE FROM `db_scripts` WHERE `id` IN (12486,12485,12489);
	INSERT INTO `db_scripts` (`script_type`,`id`,`delay`,`command`,`datalong`,`datalong2`,`buddy_entry`,`search_radius`,`data_flags`,`dataint`,`comments`) VALUES
	(2,12486,0,0,0,0,0,0,0,@MAXstringentry+1,'Marshal Redpath Say on gossip.'),
	(2,12485,0,0,0,0,0,0,0,@MAXstringentry+2,'Lilian Voss Say on gossip.'),
	(2,12489,0,0,0,0,0,0,0,@MAXstringentry+3,'Valdred Moray Say on gossip.');
	
	-- Add static emote to Lilian Voss and Valdred Moray.
	DELETE FROM `creature_addon` WHERE guid IN (372908,372910,372913);
	DELETE FROM `creature_template_addon` WHERE `entry` = 38895;
	INSERT INTO `creature_template_addon` (`entry`,`emote`) VALUES
	(38895,431);
	DELETE FROM `creature_template_addon` WHERE `entry` = 49231;
	INSERT INTO `creature_template_addon` (`entry`,`auras`) VALUES
	(49231,68442);    

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


