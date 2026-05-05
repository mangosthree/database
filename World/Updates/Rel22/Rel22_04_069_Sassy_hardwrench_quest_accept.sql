-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

-- CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
CREATE PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '22';
    SET @cOldStructure = '04';
    SET @cOldContent = '068';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '069';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Quest 14138 Fix';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix Taking Care of Business scripts/gossip with retail incentive spell and knockdown emote';

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

        DELETE FROM `db_scripts` WHERE (`script_type` = 0 AND `id` = 14138) OR (`script_type` = 1 AND `id` = 14138);
        DELETE FROM `db_script_string` WHERE `entry` IN (2000005302, 2000005304, 2000005305, 2000005306);
        DELETE FROM `gameobject` WHERE `guid` = 515631;

        INSERT INTO `db_script_string` (`entry`, `content_default`, `content_loc1`, `content_loc2`, `content_loc3`, `content_loc4`, `content_loc5`, `content_loc6`, `content_loc7`, `content_loc8`, `content_loc9`, `content_loc10`, `content_loc11`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (2000005302, 'Haha! that should be a blast!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 25, 'Sassy Hardwrench on quest accept'),
        (2000005304, 'Always nice to get a gift hand delivered by the second-in-command. I''ll unwrap this right now!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 'Foreman Dampwick on quest complete - 1'),
        (2000005305, 'OUCH!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, 0, 34, 'Foreman Dampwick on quest complete - 2'),
        (2000005306, 'Okay, okay! I got the message!', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, 1, 'Foreman Dampwick on quest complete - 3');

        INSERT INTO `db_scripts` (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES
        (0, 14138, 0, 0, 0, 0, 0, 0, 0, 2000005302, 0, 0, 0, 0, 0, 0, 0, 'Sassy Hardwrench on quest accept'),
        (1, 14138, 0, 0, 0, 0, 0, 0, 0, 2000005304, 0, 0, 0, 0, 0, 0, 0, 'Foreman Dampwick on quest complete - 1'),
        (1, 14138, 3, 15, 82025, 0, 0, 0, 12, 0, 0, 0, 0, 0, 0, 0, 0, 'Foreman Dampwick on quest complete - Sassy''s Incentive'),
        (1, 14138, 3, 1, 482, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Foreman Dampwick on quest complete - knockdown'),
        (1, 14138, 4, 0, 0, 0, 0, 0, 0, 2000005305, 0, 0, 0, 0, 0, 0, 0, 'Foreman Dampwick on quest complete - 2'),
        (1, 14138, 8, 0, 0, 0, 0, 0, 0, 2000005306, 0, 0, 0, 0, 0, 0, 0, 'Foreman Dampwick on quest complete - 3');

        UPDATE `quest_template` SET `StartScript` = 14138, `CompleteScript` = 14138 WHERE `entry` = 14138;
        DELETE FROM `gossip_menu_option` WHERE `menu_id` = 12493 AND `id` = 0;
        UPDATE `creature_template` SET `GossipMenuId` = 10547 WHERE `entry` = 34668;
        UPDATE `creature_template` SET `GossipMenuId` = 10613 WHERE `entry` = 34872;
        UPDATE `npc_text` SET `text0_0` = 'Hey there, boss-$g man : lady;. This batch of troll slaves has got to be the worst yet!$B$BLucky for us that the kaja''mite doesn''t seem to be making their soft brains any smarter, eh?' WHERE `ID` = 14684;

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
