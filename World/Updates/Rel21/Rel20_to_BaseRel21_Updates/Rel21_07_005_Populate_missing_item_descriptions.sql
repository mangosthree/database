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
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '07';
    SET @cNewContent = '005';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Populate_missing_item_desc';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Populate_missing_item_descriptions';

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

-- Mangos3 - Item Description Updates from updated Mangos0
UPDATE item_template SET description='Engraved with the words \'For years of service: -EVC.\'' WHERE entry=2239;
UPDATE item_template SET description='Only ONE May Rise... (and consequently, only ONE may loot this head)' WHERE entry=20383;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=22345;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=22395;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=22396;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=23005;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=23199;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=23200;

-- Mangos3 - Item Description Updates from updated Mangos1
UPDATE item_template SET description='The totem\'s inscription identifies the bearer as an ally of the water elemental Naias.' WHERE entry=23680;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=24413;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=25645;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=27544;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=27815;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=27947;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=27984;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=28066;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=28248;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=28357;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=28523;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=29389;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=30023;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=31031;
UPDATE item_template SET description='Required by jewelcrafters to transmute mercurial adamantite.' WHERE entry=31080;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=32330;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33078;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33505;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33506;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33507;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33843;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33939;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33940;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33941;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33951;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33952;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=33953;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=35104;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=35105;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=35106;

-- Mangos3 - Item Description Updates from updated Mangos2
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=37575;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=38361;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=38367;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=38368;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=39728;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=40267;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=40322;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=40708;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=40709;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=40710;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42597;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42602;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42607;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42598;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42603;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42608;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=45114;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=45169;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=45255;
UPDATE item_template SET description='Tiffany Cartier of Dalaran would be very interested in this fine powder.' WHERE entry=46849;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42609;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42599;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42604;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=46978;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=47666;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=47665;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=47667;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=50458;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=50463;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=50464;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=51501;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=51507;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=51513;

-- Mangos3 - Item Description Updates from updated Mangos2
UPDATE item_template SET description='A weak alcohol, but a technological triumph in brewing technology.' WHERE entry=37906;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42593;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42594;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42595;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42596;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42601;
UPDATE item_template SET description='Counts as an Air, Earth, Fire, and Water totem.' WHERE entry=42606;
    

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

