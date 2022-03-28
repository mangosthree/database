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
    SET @cOldStructure = '02'; 
    SET @cOldContent = '002';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '02';
    SET @cNewContent = '003';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Random Updates';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Random Updates';

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

	-- Spell_aura update.
	-- Steel Gate Relic Drop-Off Zone Buff
	-- See Caladis Brightspear Invis
	DELETE FROM `spell_area` WHERE `spell`=43889;
	INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_active`) VALUES 
	(43889, 3999, 11390, 0, 0, 0, 2, 1, 1);
	DELETE FROM `spell_area` WHERE `spell`=71313;
	INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_active`) VALUES 
	(71313, 4862, 24461, 24522, 0, 0, 2, 1, 1);
	-- Kil'jaeden <The Deceiver>
	UPDATE `creature_template` SET `minlootgold` =2250000, `maxlootgold` =2750000, `InhabitType` =1 WHERE `entry` =25315;
	UPDATE `creature` SET `spawnMask` = 0 WHERE `id` = 25315;
	-- Kil'jaeden
	DELETE FROM `creature` WHERE `id`=25608;
	INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
	(81346, 25608, 580, 1, 1, 0, 0, 1699.42, 628.038, 27.5451, 3.84519, 604800, 0, 0, 8338871, 0, 0);
	-- Madrigosa
	DELETE FROM `creature` WHERE `guid` = 80778;
	DELETE FROM `creature_template_spells` WHERE `entry` = 24895;
	-- Kalecgos
	DELETE FROM `creature` WHERE `guid` = 102510;
	DELETE FROM `creature_template_spells` WHERE `entry` = 24850;
	DELETE FROM `creature` WHERE `guid` = 130052;
	-- Shield Orb
	DELETE FROM `creature_template_spells` WHERE `entry` = 25502;
	-- Brutallus, Sathrovarr the Corruptor, Felmyst, Lady Sacrolash, Grand Warlock Alythess, Entropius.
	UPDATE `creature_template` SET `minLootGold` =2250000, `maxLootGold` =2750000, `InhabitType` =1 WHERE `entry` IN (25166,24882,24892,25038,25165,25166,25840);
	-- Item drop chance
	UPDATE `creature_loot_template` SET `ChanceOrQuestChance` =100 WHERE `item` IN (12335,12336,12337);
	UPDATE `creature_loot_template` SET `ChanceOrQuestChance` =10 WHERE `item` =12219;
	-- Remove static spawns.
	DELETE FROM `creature` WHERE `id` = 19226;
	DELETE FROM `creature` WHERE `id` = 19224;
	DELETE FROM `creature` WHERE `id` = 22459;
	DELETE FROM `creature` WHERE `id` = 18042;
	DELETE FROM `creature` WHERE `id` = 22466;
	DELETE FROM `creature` WHERE `id` = 2776;
	DELETE FROM `creature` WHERE `id` = 11078;
	DELETE FROM `creature` WHERE `id` = 12860;
	DELETE FROM `creature` WHERE `id` = 20427;
	DELETE FROM `creature` WHERE `id` = 3451;
	DELETE FROM `creature` WHERE `id` = 19919;
	DELETE FROM `creature` WHERE `id` = 19920;
	DELETE FROM `creature` WHERE `id` = 33016;
	DELETE FROM `creature` WHERE `id` = 33017;
	DELETE FROM `creature` WHERE `id` = 24213;
	DELETE FROM `creature` WHERE `id` = 24214;
	DELETE FROM `creature` WHERE `id` = 24215;
	-- Chained Spirit
	UPDATE `creature_template` SET `FactionAlliance` =35, `FactionHorde` =35 WHERE `entry` =15117;

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


