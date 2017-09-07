-- ----------------------------------------
-- Added to prevent timeout's while loading
-- ----------------------------------------
SET GLOBAL net_read_timeout=30;
SET GLOBAL net_write_timeout=60;
SET GLOBAL net_buffer_length=1000000; 
SET GLOBAL max_allowed_packet=1000000000;
SET GLOBAL connect_timeout=10000000;

-- --------------------------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update (v1.3)
-- --------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT structure FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurContent := (SELECT content FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '07'; 
    SET @cOldContent = '005';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '07';
    SET @cNewContent = '006';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Populate_missing_GO_desc';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Populate_missing_GameObject_and_Creature_descriptions';

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


-- M3 update from M0
UPDATE creature_template SET subname='Librarian' WHERE entry=951;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=2704;
UPDATE creature_template SET subname='Crocilisk Trainer' WHERE entry=2876;
UPDATE creature_template SET subname='Pet Trainer' WHERE entry=3698;
UPDATE creature_template SET subname='Explorers\' League' WHERE entry=10301;
UPDATE creature_template SET subname='The Head of The Black Flight' WHERE entry=11583;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11865;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11866;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11867;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11868;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11869;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=11870;
UPDATE creature_template SET subname='Demon Trainer' WHERE entry=12807;
UPDATE creature_template SET subname='DO NOT DELETE' WHERE entry=12999;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=13084;
UPDATE creature_template SET subname='Stable Master' WHERE entry=16156;
UPDATE creature_template SET subname='Ammunition Vendor' WHERE entry=17598;

-- M3 Update from M1
UPDATE creature_template SET subname='Cook' WHERE entry=1677;
UPDATE creature_template SET subname='Blacksmith Trainer' WHERE entry=2220;
UPDATE creature_template SET subname='Cooking Trainer' WHERE entry=2223;
UPDATE creature_template SET subname='Ranged Skills Trainer' WHERE entry=2886;
UPDATE creature_template SET subname='Magic Skill Trainer *Temp*' WHERE entry=2896;
UPDATE creature_template SET subname='Toughness/Resist Trainer *Temp*' WHERE entry=2899;
UPDATE creature_template SET subname='Demon Trainer' WHERE entry=2935;
UPDATE creature_template SET subname='Bear Trainer' WHERE entry=2938;
UPDATE creature_template SET subname='Wolf Trainer' WHERE entry=2942;
UPDATE creature_template SET subname='Cat Trainer' WHERE entry=3699;
UPDATE creature_template SET subname='Foraging Trainer' WHERE entry=4149;
UPDATE creature_template SET subname='Cat Trainer' WHERE entry=4153;
UPDATE creature_template SET subname='Bear Trainer' WHERE entry=4206;
UPDATE creature_template SET subname='Wolf Trainer' WHERE entry=4207;
UPDATE creature_template SET subname='Raptor Trainer' WHERE entry=4621;
UPDATE creature_template SET subname='Turtle Trainer' WHERE entry=4881;
UPDATE creature_template SET subname='Wolf Pet Trainer' WHERE entry=4994;
UPDATE creature_template SET subname='Bird Pet Trainer' WHERE entry=5001;
UPDATE creature_template SET subname='Cat Pet Trainer' WHERE entry=5003;
UPDATE creature_template SET subname='Crawler Pet Trainer' WHERE entry=5004;
UPDATE creature_template SET subname='Crocodile Pet Trainer' WHERE entry=5005;
UPDATE creature_template SET subname='Gorilla Pet Trainer' WHERE entry=5008;
UPDATE creature_template SET subname='Horse Pet Trainer' WHERE entry=5009;
UPDATE creature_template SET subname='Raptor Pet Trainer' WHERE entry=5011;
UPDATE creature_template SET subname='Scorpid Pet Trainer' WHERE entry=5012;
UPDATE creature_template SET subname='Spider Pet Trainer' WHERE entry=5013;
UPDATE creature_template SET subname='Tallstrider Pet Trainer' WHERE entry=5015;
UPDATE creature_template SET subname='Turtle Pet Trainer' WHERE entry=5017;
UPDATE creature_template SET subname='Horse Riding Trainer' WHERE entry=5026;
UPDATE creature_template SET subname='Tiger Riding Trainer' WHERE entry=5030;
UPDATE creature_template SET subname='Gun Trainer' WHERE entry=5104;
UPDATE creature_template SET subname='Tallstrider Trainer' WHERE entry=5507;
UPDATE creature_template SET subname='Dagger Trainer' WHERE entry=10292;
UPDATE creature_template SET subname='Fist Weapons Trainer' WHERE entry=10294;
UPDATE creature_template SET subname='Bow Trainer' WHERE entry=10297;
UPDATE creature_template SET subname='Crossbow Trainer' WHERE entry=10446;
UPDATE creature_template SET subname='Crossbow Trainer' WHERE entry=10450;
UPDATE creature_template SET subname='Mace Trainer' WHERE entry=10452;
UPDATE creature_template SET subname='Axe Trainer' WHERE entry=10453;
UPDATE creature_template SET subname='Crossbow Trainer' WHERE entry=10454;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=16621;
UPDATE creature_template SET subname='Demon Trainer' WHERE entry=16720;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=16773;
UPDATE creature_template SET subname='Weapon Master' WHERE entry=17005;
UPDATE creature_template SET subname='Mage Trainer' WHERE entry=17105;
UPDATE creature_template SET subname='Horse Pet Trainer' WHERE entry=19145;

-- M3 Update from M2
UPDATE creature_template SET subname='Arena Organizer' WHERE entry=30611;    


-- Update M3 from M0
UPDATE gameobject_template SET name='Fire Pit' WHERE entry=6286;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18047;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18048;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18049;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18050;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18051;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18052;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18053;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18054;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18055;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18056;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18057;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18058;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18059;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18060;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18061;
UPDATE gameobject_template SET name='Stand up Torch' WHERE entry=18062;
UPDATE gameobject_template SET name='Fire on ground' WHERE entry=56809;
UPDATE gameobject_template SET name='Fire Pit' WHERE entry=56810;
UPDATE gameobject_template SET name='Fire With Boiling Water' WHERE entry=103773;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126337;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126338;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126339;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126340;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126341;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126342;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=126345;
UPDATE gameobject_template SET name='Bed' WHERE entry=174849;
UPDATE gameobject_template SET name='Lever' WHERE entry=175432;
UPDATE gameobject_template SET name='Locked Cage' WHERE entry=175786;
UPDATE gameobject_template SET name='SmallBrazier31' WHERE entry=179874;
UPDATE gameobject_template SET name='SmallBrazier19' WHERE entry=179875;
UPDATE gameobject_template SET name='SmallBrazier03' WHERE entry=179876;
UPDATE gameobject_template SET name='SmallBrazier04' WHERE entry=179877;
UPDATE gameobject_template SET name='SmallBrazier01' WHERE entry=179878;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183497;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183498;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183499;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183500;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183501;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183502;
UPDATE gameobject_template SET name='Large Fire' WHERE entry=184094;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=184114;
UPDATE gameobject_template SET name='Large Fire' WHERE entry=184416;
UPDATE gameobject_template SET name='Large x2 Fire' WHERE entry=184563;
UPDATE gameobject_template SET name='Large x2 Fire' WHERE entry=184564;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=184565;

-- update M3 from M1
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183503;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=183504;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=184294;
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=184331;

-- Update M3 from M2
UPDATE gameobject_template SET name='Cooking Fire' WHERE entry=192235;
UPDATE gameobject_template SET name='High Back Chair' WHERE entry=186851;
UPDATE gameobject_template SET name='High Back Chair' WHERE entry=186850;

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
		IF(@cOldResult IS NULL) THEN    -- Something has gone wrong
		    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurStructure := (SELECT `STRUCTURE` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurContent := (SELECT `Content` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @cOldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
		ELSE
		    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurStructure := (SELECT `STRUCTURE` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
		    SET @cCurContent := (SELECT `Content` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
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

