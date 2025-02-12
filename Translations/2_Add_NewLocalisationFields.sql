        ALTER TABLE `locales_command`
            ADD COLUMN `help_text_loc0` VARCHAR(100) NOT NULL DEFAULT '' AFTER `id`;

        ALTER TABLE `locales_creature`
            ADD COLUMN `name_loc0` VARCHAR(100) NOT NULL DEFAULT '' AFTER `entry`,
            ADD COLUMN `subname_loc0` VARCHAR(100) AFTER `name_loc9`;

        ALTER TABLE `creature_ai_texts`
            ADD COLUMN `content_loc0` TEXT AFTER `content_default`;

        ALTER TABLE `db_script_string`
            ADD COLUMN `content_loc0` TEXT AFTER `content_default`;

        ALTER TABLE `gossip_texts`
            ADD COLUMN `content_loc0` TEXT AFTER `content_default`;

        ALTER TABLE `mangos_string`
            ADD COLUMN `content_loc0` TEXT AFTER `content_default`;

        ALTER TABLE `script_texts`
            ADD COLUMN `content_loc0` TEXT AFTER `content_default`;
            
        ALTER TABLE `locales_item`
            ADD COLUMN `name_loc0` VARCHAR(100) NOT NULL DEFAULT '' AFTER `entry`,
            ADD COLUMN `description_loc0` VARCHAR(255) AFTER `name_loc9`;

        ALTER TABLE `locales_gameobject`
            ADD COLUMN `name_loc0` VARCHAR(100) NOT NULL DEFAULT '' AFTER `entry`;

        ALTER TABLE `locales_gossip_menu_option`
            ADD COLUMN `option_text_loc0` TEXT AFTER `id`,
            ADD COLUMN `box_text_loc0` TEXT AFTER `option_text_loc9`;

        ALTER TABLE `locales_npc_text`
            ADD COLUMN `Text0_0_loc0` LONGTEXT AFTER `entry`,
            ADD COLUMN `Text0_1_loc0` LONGTEXT AFTER `Text0_0_loc9`,
            ADD COLUMN `Text1_0_loc0` LONGTEXT AFTER `Text0_1_loc9`,
            ADD COLUMN `Text1_1_loc0` LONGTEXT AFTER `Text1_0_loc9`,
            ADD COLUMN `Text2_0_loc0` LONGTEXT AFTER `Text1_1_loc9`,
            ADD COLUMN `Text2_1_loc0` LONGTEXT AFTER `Text2_0_loc9`,
            ADD COLUMN `Text3_0_loc0` LONGTEXT AFTER `Text2_1_loc9`,
            ADD COLUMN `Text3_1_loc0` LONGTEXT AFTER `Text3_0_loc9`,
            ADD COLUMN `Text4_0_loc0` LONGTEXT AFTER `Text3_1_loc9`,
            ADD COLUMN `Text4_1_loc0` LONGTEXT AFTER `Text4_0_loc9`,
            ADD COLUMN `Text5_0_loc0` LONGTEXT AFTER `Text4_1_loc9`,
            ADD COLUMN `Text5_1_loc0` LONGTEXT AFTER `Text5_0_loc9`,
            ADD COLUMN `Text6_0_loc0` LONGTEXT AFTER `Text5_1_loc9`,
            ADD COLUMN `Text6_1_loc0` LONGTEXT AFTER `Text6_0_loc9`,
            ADD COLUMN `Text7_0_loc0` LONGTEXT AFTER `Text6_1_loc9`,
            ADD COLUMN `Text7_1_loc0` LONGTEXT AFTER `Text7_0_loc9`;

        ALTER TABLE `locales_page_text`
            ADD COLUMN `Text_loc0` LONGTEXT AFTER `entry`;

        ALTER TABLE `locales_points_of_interest`
            ADD COLUMN `icon_name_loc0` TEXT AFTER `entry`,;

        ALTER TABLE `locales_quest`
            ADD COLUMN `Title_loc0` LONGTEXT AFTER `entry`,
            ADD COLUMN `Details_loc0` LONGTEXT AFTER Title_loc9,
            ADD COLUMN `Objectives_loc0` LONGTEXT AFTER `Details_loc9`,
            ADD COLUMN `OfferRewardText_loc0` LONGTEXT AFTER `Objectives_loc9`,
            ADD COLUMN `RequestItemsText_loc0` LONGTEXT AFTER `OfferRewardText_loc9`,
            ADD COLUMN `EndText_loc0` LONGTEXT AFTER `RequestItemsText_loc9`,
            ADD COLUMN `ObjectiveText1_loc0` LONGTEXT AFTER `EndText_loc9`,
            ADD COLUMN `ObjectiveText2_loc0` LONGTEXT AFTER `ObjectiveText1_loc9`,
            ADD COLUMN `ObjectiveText3_loc0` LONGTEXT AFTER `ObjectiveText2_loc9`,
            ADD COLUMN `ObjectiveText4_loc0` LONGTEXT AFTER `ObjectiveText3_loc9`;

        ALTER TABLE `locales_achievement_reward`
            ADD COLUMN `subject_loc0` VARCHAR(100) NOT NULL DEFAULT '' AFTER `gender`,
            ADD COLUMN `text_loc0` TEXT NOT NULL AFTER `subject_loc9`;
