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
    SET @cOldContent = '015';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '02';
    SET @cNewContent = '001';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Add new localisation fields';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Add new localisation fields - loc9,loc10,loc11';

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
         ALTER TABLE `locales_command`
             ADD COLUMN `help_text_loc9` VARCHAR(100) AFTER `help_text_loc8`,
             ADD COLUMN `help_text_loc10` VARCHAR(100) AFTER `help_text_loc9`,
             ADD COLUMN `help_text_loc11` VARCHAR(100) AFTER `help_text_loc10`;


        ALTER TABLE `locales_creature`
            ADD COLUMN `name_loc9` VARCHAR(100) AFTER `name_loc8`,
            ADD COLUMN `name_loc10` VARCHAR(100) AFTER `name_loc9`,
            ADD COLUMN `name_loc11` VARCHAR(100) AFTER `name_loc10`,
            ADD COLUMN `subname_loc9` VARCHAR(100) AFTER `subname_loc8`,
            ADD COLUMN `subname_loc10` VARCHAR(100) AFTER `subname_loc9`,
            ADD COLUMN `subname_loc11` VARCHAR(100) AFTER `subname_loc10`;


        ALTER TABLE `creature_ai_texts`
            ADD COLUMN `content_loc9` TEXT AFTER `content_loc8`,
            ADD COLUMN `content_loc10` TEXT AFTER `content_loc9`,
            ADD COLUMN `content_loc11` TEXT AFTER `content_loc10`;


        ALTER TABLE `db_script_string`
            ADD COLUMN `content_loc9` TEXT AFTER `content_loc8`,
            ADD COLUMN `content_loc10` TEXT AFTER `content_loc9`,
            ADD COLUMN `content_loc11` TEXT AFTER `content_loc10`;


        ALTER TABLE `gossip_texts`
            ADD COLUMN `content_loc9` TEXT AFTER `content_loc8`,
            ADD COLUMN `content_loc10` TEXT AFTER `content_loc9`,
            ADD COLUMN `content_loc11` TEXT AFTER `content_loc10`;


        ALTER TABLE `mangos_string`
            ADD COLUMN `content_loc9` TEXT AFTER `content_loc8`,
            ADD COLUMN `content_loc10` TEXT AFTER `content_loc9`,
            ADD COLUMN `content_loc11` TEXT AFTER `content_loc10`;


        ALTER TABLE `script_texts`
            ADD COLUMN `content_loc9` TEXT AFTER `content_loc8`,
            ADD COLUMN `content_loc10` TEXT AFTER `content_loc9`,
            ADD COLUMN `content_loc11` TEXT AFTER `content_loc10`;

    
        ALTER TABLE `locales_item`
            ADD COLUMN `name_loc9` VARCHAR(100) AFTER `name_loc8`,
            ADD COLUMN `name_loc10` VARCHAR(100) AFTER `name_loc9`,
            ADD COLUMN `name_loc11` VARCHAR(100) AFTER `name_loc10`,
            ADD COLUMN `description_loc9` VARCHAR(255) AFTER `description_loc8`,
            ADD COLUMN `description_loc10` VARCHAR(255) AFTER `description_loc9`,
            ADD COLUMN `description_loc11` VARCHAR(255) AFTER `description_loc10`;


        ALTER TABLE `locales_gameobject`
            ADD COLUMN `name_loc9` VARCHAR(100) NOT NULL DEFAULT '' AFTER `name_loc8`,
            ADD COLUMN `name_loc10` VARCHAR(100) NOT NULL DEFAULT '' AFTER `name_loc9`,
            ADD COLUMN `name_loc11` VARCHAR(100) NOT NULL DEFAULT '' AFTER `name_loc10`,
            ADD COLUMN `castbarcaption_loc9` VARCHAR(100) NOT NULL DEFAULT '' AFTER `castbarcaption_loc8`,
            ADD COLUMN `castbarcaption_loc10` VARCHAR(100) NOT NULL DEFAULT '' AFTER `castbarcaption_loc9`,
            ADD COLUMN `castbarcaption_loc11` VARCHAR(100) NOT NULL DEFAULT '' AFTER `castbarcaption_loc10`;


        ALTER TABLE `locales_gossip_menu_option`
            ADD COLUMN `option_text_loc9` TEXT AFTER `option_text_loc8`,
            ADD COLUMN `option_text_loc10` TEXT AFTER `option_text_loc9`,
            ADD COLUMN `option_text_loc11` TEXT AFTER `option_text_loc10`,
            ADD COLUMN `box_text_loc9` TEXT AFTER `box_text_loc8`,
            ADD COLUMN `box_text_loc10` TEXT AFTER `box_text_loc9`,
            ADD COLUMN `box_text_loc11` TEXT AFTER `box_text_loc10`;


        ALTER TABLE `locales_npc_text`
            ADD COLUMN `Text0_0_loc9` LONGTEXT AFTER `Text0_0_loc8`,
            ADD COLUMN `Text0_1_loc9` LONGTEXT AFTER `Text0_1_loc8`,
            ADD COLUMN `Text1_0_loc9` LONGTEXT AFTER `Text1_0_loc8`,
            ADD COLUMN `Text1_1_loc9` LONGTEXT AFTER `Text1_1_loc8`,
            ADD COLUMN `Text2_0_loc9` LONGTEXT AFTER `Text2_0_loc8`,
            ADD COLUMN `Text2_1_loc9` LONGTEXT AFTER `Text2_1_loc8`,
            ADD COLUMN `Text3_0_loc9` LONGTEXT AFTER `Text3_0_loc8`,
            ADD COLUMN `Text3_1_loc9` LONGTEXT AFTER `Text3_1_loc8`,
            ADD COLUMN `Text4_0_loc9` LONGTEXT AFTER `Text4_0_loc8`,
            ADD COLUMN `Text4_1_loc9` LONGTEXT AFTER `Text4_1_loc8`,
            ADD COLUMN `Text5_0_loc9` LONGTEXT AFTER `Text5_0_loc8`,
            ADD COLUMN `Text5_1_loc9` LONGTEXT AFTER `Text5_1_loc8`,
            ADD COLUMN `Text6_0_loc9` LONGTEXT AFTER `Text6_0_loc8`,
            ADD COLUMN `Text6_1_loc9` LONGTEXT AFTER `Text6_1_loc8`,
            ADD COLUMN `Text7_0_loc9` LONGTEXT AFTER `Text7_0_loc8`,
            ADD COLUMN `Text7_1_loc9` LONGTEXT AFTER `Text7_1_loc8`,

            ADD COLUMN `Text0_0_loc10` LONGTEXT AFTER `Text0_0_loc9`,
            ADD COLUMN `Text0_1_loc10` LONGTEXT AFTER `Text0_1_loc9`,
            ADD COLUMN `Text1_0_loc10` LONGTEXT AFTER `Text1_0_loc9`,
            ADD COLUMN `Text1_1_loc10` LONGTEXT AFTER `Text1_1_loc9`,
            ADD COLUMN `Text2_0_loc10` LONGTEXT AFTER `Text2_0_loc9`,
            ADD COLUMN `Text2_1_loc10` LONGTEXT AFTER `Text2_1_loc9`,
            ADD COLUMN `Text3_0_loc10` LONGTEXT AFTER `Text3_0_loc9`,
            ADD COLUMN `Text3_1_loc10` LONGTEXT AFTER `Text3_1_loc9`,
            ADD COLUMN `Text4_0_loc10` LONGTEXT AFTER `Text4_0_loc9`,
            ADD COLUMN `Text4_1_loc10` LONGTEXT AFTER `Text4_1_loc9`,
            ADD COLUMN `Text5_0_loc10` LONGTEXT AFTER `Text5_0_loc9`,
            ADD COLUMN `Text5_1_loc10` LONGTEXT AFTER `Text5_1_loc9`,
            ADD COLUMN `Text6_0_loc10` LONGTEXT AFTER `Text6_0_loc9`,
            ADD COLUMN `Text6_1_loc10` LONGTEXT AFTER `Text6_1_loc9`,
            ADD COLUMN `Text7_0_loc10` LONGTEXT AFTER `Text7_0_loc9`,
            ADD COLUMN `Text7_1_loc10` LONGTEXT AFTER `Text7_1_loc9`,

            ADD COLUMN `Text0_0_loc11` LONGTEXT AFTER `Text0_0_loc10`,
            ADD COLUMN `Text0_1_loc11` LONGTEXT AFTER `Text0_1_loc10`,
            ADD COLUMN `Text1_0_loc11` LONGTEXT AFTER `Text1_0_loc10`,
            ADD COLUMN `Text1_1_loc11` LONGTEXT AFTER `Text1_1_loc10`,
            ADD COLUMN `Text2_0_loc11` LONGTEXT AFTER `Text2_0_loc10`,
            ADD COLUMN `Text2_1_loc11` LONGTEXT AFTER `Text2_1_loc10`,
            ADD COLUMN `Text3_0_loc11` LONGTEXT AFTER `Text3_0_loc10`,
            ADD COLUMN `Text3_1_loc11` LONGTEXT AFTER `Text3_1_loc10`,
            ADD COLUMN `Text4_0_loc11` LONGTEXT AFTER `Text4_0_loc10`,
            ADD COLUMN `Text4_1_loc11` LONGTEXT AFTER `Text4_1_loc10`,
            ADD COLUMN `Text5_0_loc11` LONGTEXT AFTER `Text5_0_loc10`,
            ADD COLUMN `Text5_1_loc11` LONGTEXT AFTER `Text5_1_loc10`,
            ADD COLUMN `Text6_0_loc11` LONGTEXT AFTER `Text6_0_loc10`,
            ADD COLUMN `Text6_1_loc11` LONGTEXT AFTER `Text6_1_loc10`,
            ADD COLUMN `Text7_0_loc11` LONGTEXT AFTER `Text7_0_loc10`,
            ADD COLUMN `Text7_1_loc11` LONGTEXT AFTER `Text7_1_loc10`;


        ALTER TABLE `locales_page_text`
            ADD COLUMN `Text_loc9` LONGTEXT AFTER `Text_loc8`,
            ADD COLUMN `Text_loc10` LONGTEXT AFTER `Text_loc9`,
            ADD COLUMN `Text_loc11` LONGTEXT AFTER `Text_loc10`;


        ALTER TABLE `locales_points_of_interest`
            ADD COLUMN `icon_name_loc9` TEXT AFTER `icon_name_loc8`,
            ADD COLUMN `icon_name_loc10` TEXT AFTER `icon_name_loc9`,
            ADD COLUMN `icon_name_loc11` TEXT AFTER `icon_name_loc10`;

        ALTER TABLE `locales_quest`
            ADD COLUMN `Title_loc9` LONGTEXT AFTER `Title_loc8`,
            ADD COLUMN `Details_loc9` LONGTEXT AFTER `Details_loc8`,
            ADD COLUMN `Objectives_loc9` LONGTEXT AFTER `Objectives_loc8`,
            ADD COLUMN `OfferRewardText_loc9` LONGTEXT AFTER `OfferRewardText_loc8`,
            ADD COLUMN `RequestItemsText_loc9` LONGTEXT AFTER `RequestItemsText_loc8`,
            ADD COLUMN `EndText_loc9` LONGTEXT AFTER `EndText_loc8`,
            ADD COLUMN `CompletedText_loc9` TEXT AFTER `CompletedText_loc8`,
            ADD COLUMN `ObjectiveText1_loc9` LONGTEXT AFTER `ObjectiveText1_loc8`,
            ADD COLUMN `ObjectiveText2_loc9` LONGTEXT AFTER `ObjectiveText2_loc8`,
            ADD COLUMN `ObjectiveText3_loc9` LONGTEXT AFTER `ObjectiveText3_loc8`,
            ADD COLUMN `ObjectiveText4_loc9` LONGTEXT AFTER `ObjectiveText4_loc8`,
            ADD COLUMN `PortraitGiverName_loc9` LONGTEXT AFTER `PortraitGiverName_loc8`,
            ADD COLUMN `PortraitGiverText_loc9` LONGTEXT AFTER `PortraitGiverText_loc8`,
            ADD COLUMN `PortraitTurnInName_loc9` LONGTEXT AFTER `PortraitTurnInName_loc8`,
            ADD COLUMN `PortraitTurnInText_loc9` LONGTEXT AFTER `PortraitTurnInText_loc8`,

            ADD COLUMN `Title_loc10` LONGTEXT AFTER `Title_loc9`,
            ADD COLUMN `Details_loc10` LONGTEXT AFTER `Details_loc9`,
            ADD COLUMN `Objectives_loc10` LONGTEXT AFTER `Objectives_loc9`,
            ADD COLUMN `OfferRewardText_loc10` LONGTEXT AFTER `OfferRewardText_loc9`,
            ADD COLUMN `RequestItemsText_loc10` LONGTEXT AFTER `RequestItemsText_loc9`,
            ADD COLUMN `EndText_loc10` LONGTEXT AFTER `EndText_loc9`,
            ADD COLUMN `CompletedText_loc10` TEXT AFTER `CompletedText_loc9`,
            ADD COLUMN `ObjectiveText1_loc10` LONGTEXT AFTER `ObjectiveText1_loc9`,
            ADD COLUMN `ObjectiveText2_loc10` LONGTEXT AFTER `ObjectiveText2_loc9`,
            ADD COLUMN `ObjectiveText3_loc10` LONGTEXT AFTER `ObjectiveText3_loc9`,
            ADD COLUMN `ObjectiveText4_loc10` LONGTEXT AFTER `ObjectiveText4_loc9`,
            ADD COLUMN `PortraitGiverName_loc10` LONGTEXT AFTER `PortraitGiverName_loc9`,
            ADD COLUMN `PortraitGiverText_loc10` LONGTEXT AFTER `PortraitGiverText_loc9`,
            ADD COLUMN `PortraitTurnInName_loc10` LONGTEXT AFTER `PortraitTurnInName_loc9`,
            ADD COLUMN `PortraitTurnInText_loc10` LONGTEXT AFTER `PortraitTurnInText_loc9`,

            ADD COLUMN `Title_loc11` LONGTEXT AFTER `Title_loc10`,
            ADD COLUMN `Details_loc11` LONGTEXT AFTER `Details_loc10`,
            ADD COLUMN `Objectives_loc11` LONGTEXT AFTER `Objectives_loc10`,
            ADD COLUMN `OfferRewardText_loc11` LONGTEXT AFTER `OfferRewardText_loc10`,
            ADD COLUMN `RequestItemsText_loc11` LONGTEXT AFTER `RequestItemsText_loc10`,
            ADD COLUMN `EndText_loc11` LONGTEXT AFTER `EndText_loc10`,
            ADD COLUMN `CompletedText_loc11` TEXT AFTER `CompletedText_loc10`,
            ADD COLUMN `ObjectiveText1_loc11` LONGTEXT AFTER `ObjectiveText1_loc10`,
            ADD COLUMN `ObjectiveText2_loc11` LONGTEXT AFTER `ObjectiveText2_loc10`,
            ADD COLUMN `ObjectiveText3_loc11` LONGTEXT AFTER `ObjectiveText3_loc10`,
            ADD COLUMN `ObjectiveText4_loc11` LONGTEXT AFTER `ObjectiveText4_loc10`,
            ADD COLUMN `PortraitGiverName_loc11` LONGTEXT AFTER `PortraitGiverName_loc10`,
            ADD COLUMN `PortraitGiverText_loc11` LONGTEXT AFTER `PortraitGiverText_loc10`,
            ADD COLUMN `PortraitTurnInName_loc11` LONGTEXT AFTER `PortraitTurnInName_loc10`,
            ADD COLUMN `PortraitTurnInText_loc11` LONGTEXT AFTER `PortraitTurnInText_loc10`;


        ALTER TABLE `locales_achievement_reward`
            ADD COLUMN `subject_loc9` VARCHAR(100) NOT NULL DEFAULT '' AFTER `subject_loc8`,
            ADD COLUMN `subject_loc10` VARCHAR(100) NOT NULL DEFAULT '' AFTER `subject_loc9`,
            ADD COLUMN `subject_loc11` VARCHAR(100) NOT NULL DEFAULT '' AFTER `subject_loc10`,
            ADD COLUMN `text_loc9` TEXT NOT NULL AFTER `text_loc8`,
            ADD COLUMN `text_loc10` TEXT NOT NULL AFTER `text_loc9`,
            ADD COLUMN `text_loc11` TEXT NOT NULL AFTER `text_loc10`;

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


