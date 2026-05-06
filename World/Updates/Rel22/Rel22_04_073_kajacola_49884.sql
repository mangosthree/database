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
    SET @cOldContent = '072';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '073';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'KajaCola 49884 Fix';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Add KajaCola item effect data and gate KajaCola GO loot behind quest 25473 rewarded';

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

        SET @ITEM_KAJACOLA := 49884;
        SET @SPELL_KAJACOLA_ITEM_EFFECT := 70478;
        SET @SPELL_KAJACOLA_AURA_SCRIPT := 'aura_kajacola_item_effect';
        SET @QUEST_KAJACOLA := 25473;
        SET @COND_KAJACOLA_REWARDED := 57807;

        UPDATE `item_template`
        SET
            `spellid_1` = @SPELL_KAJACOLA_ITEM_EFFECT,
            `spelltrigger_1` = 0,
            `spellcharges_1` = -1,
            `spellcooldown_1` = 1500,
            `spellcategorycooldown_1` = -1
        WHERE `entry` = @ITEM_KAJACOLA;

        DELETE FROM `script_binding`
        WHERE `type` = 5
          AND `bind` = @SPELL_KAJACOLA_ITEM_EFFECT
          AND `data` = 0;

        INSERT INTO `script_binding`
            (`type`, `ScriptName`, `bind`, `data`)
        VALUES
            (5, @SPELL_KAJACOLA_AURA_SCRIPT, @SPELL_KAJACOLA_ITEM_EFFECT, 0);

        DELETE FROM `script_texts`
        WHERE `entry` BETWEEN -1002037 AND -1002000;

        INSERT INTO `script_texts`
            (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`)
        VALUES
            (-1002000, 'A big convention, see? To show off all of our inventions. We call it GoblinCon. And we give away special pets!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002001, 'A binary number system. It uses only two numbers, 6 and 11.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002002, 'A globe that shows the inside of the planet... on the outside. So you know where to dig!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002003, 'A truck that delivers ice-cream. With a catapult.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002004, 'Bagel-holes!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002005, 'Chocolate-flavored vanilla!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002006, 'Clowns. Except instead of making you laugh, they''re for beating.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002007, 'Distilling the juice out of Kaja''mite to make a delicious, carbonated beverage that will give people IDEAS! Hey, wait a minute...', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002008, 'Dwarves. In. Space!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002009, 'Earwax. It''s got to be good for SOMETHING.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002010, 'Edible beds. So you can have breakfast in bed. Beds... for breakfast!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002011, 'Fake food! Created by grinding up real food and pressing it into shapes of different food. With artificial flavoring!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002012, 'Flerberts. I''m not sure what they do, but I''d better lock down the name with a trademark.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002013, 'Games you can play with your face!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002014, 'Giant gnomes. No, wait... tiny giants!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002015, 'Goblins with gills!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002016, 'Half man... half sharkalligator!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002017, 'Headshoes!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002018, 'Houses made of dirt! When you clean them... THEY''RE GONE.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002019, 'How about this: Instant water! Just add... oh.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002020, 'Invisible bunnies! We''ll put them all over the place, and they''ll control everything!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002021, 'It''s like bungie-jumping, right? But without a cord, see? And you start at the bottom. I guess it''s just sorta like regular jumping. But with guns.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002022, 'Leashes... with pre-attached pets.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002023, 'Motorized gravy-boat. With laser lump vaporizer!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002024, 'Mouse-sized beartraps... no... Bear-sized mousetraps!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002025, 'Murder permits!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002026, 'Portable gasoline squirt-guns!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002027, 'Recycling! But, for stuff that''s never been used before.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002028, 'Shoes with wheels on them. And gloves with wheels on them - for when you fall down.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002029, 'Soap on a rope! Attached to a chain! Mounted via a steel cable. To some soap.', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002030, 'Spoon sharpeners!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002031, 'Stairways... for horizontal surfaces!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002032, 'String-less kites!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002033, 'Tauren Paladins!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002034, 'Thirteen-sided dice!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002035, 'Water-proof soap! For underwater use!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002036, 'We put a whole town... in a tiny little box!', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea'),
            (-1002037, 'What if we were to ORGANIZE crime?', 0, 1, 0, 0, 'Item 49884 Kaja''Cola idea');

        DELETE FROM `conditions`
        WHERE `condition_entry` = @COND_KAJACOLA_REWARDED;

        INSERT INTO `conditions`
            (`condition_entry`, `type`, `value1`, `value2`, `comments`)
        VALUES
            (@COND_KAJACOLA_REWARDED, 8, @QUEST_KAJACOLA, 0, 'Kaja''Cola gameobject loot requires quest 25473 rewarded');

        UPDATE `gameobject_loot_template`
        SET `condition_id` = @COND_KAJACOLA_REWARDED
        WHERE `entry` BETWEEN 201798 AND 201803
          AND `item` = @ITEM_KAJACOLA;

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
