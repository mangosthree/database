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
    SET @cOldContent = '046';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '047';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'creature_temp_addon_Startup';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix_creature_template_addon_Startup_errors: has spell xxxx defined in `auras` field in `creature_template_addon, but spell is no self-only spell`.';

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

UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=2358;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=2546; --  has spell 83932;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=4625; --  has spell 7083;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=5043; --  has spell 10032;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=6517; --  has spell 14178;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=6518; --  has spell 14178;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=6519; --  has spell 14178;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=6527; --  has spell 14178;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=7458; --  has spell 15876;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=7459; --  has spell 15876;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=7460; --  has spell 15876;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=9236; --  has spell 12380;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=11448; --  has spell 21157;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=14507; --  has spell 21157;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=15277; --  has spell 19595;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=17324; --  has spell 31284;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=17847; --  has spell 31324;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18424; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18437; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18438; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18480; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18490; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=18794; --  has spell 32958;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=19668; --  has spell 34429;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=19796; --  has spell 35190;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=19797; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=20397; --  has spell 34062;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=20645; --  has spell 32958;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=20654; --  has spell 32958;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=20904; --  has spell 36852;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=21440; --  has spell 36852;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=21622; --  has spell 36852;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=21737; --  has spell 37248;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=21757; --  has spell 37248;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22074; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22075; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22076; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22093; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22232; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22233; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22235; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22240; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22246; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22444; --  has spell 39184;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22452; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=22859;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=23498; --  has spell 34429;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=23919; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24119; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24160; --  has spell 43161;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24228; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24229; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24235; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=24954; --  has spell 45797;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25319; --  has spell 46473;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25350; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25351; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25514; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25615; --  has spell 45797;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25712;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25716;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25720; --  has spell 54219;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25766; --  has spell 45967;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25781; --  has spell 35357;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25962; --  has spell 46322;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=25994; --  has spell 46322;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=26336; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=26336;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=26343; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=26344; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=28158; --  has spell 45857;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=28199; --  has spell 52871;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=28779; --  has spell 54262;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=28851; --  has spell 32423;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=28996; --  has spell 34427;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=29238; --  has spell 53772;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=29720; --  has spell 43161;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=30288; --  has spell 56571;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=30444; --  has spell 56763;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=30849; --  has spell 42617;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=30973; --  has spell 52097;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=30993; --  has spell 54262;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31110; --  has spell 58548;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31188; --  has spell 52871;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31333; --  has spell 60778;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31372; --  has spell 51776;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31469; --  has spell 60342;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31533; --  has spell 52097;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31611; --  has spell 53317;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31786; --  has spell 35357;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=31900; --  has spell 60023;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=32149; --  has spell 54262;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=32255; --  has spell 54262;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=33090; --  has spell 62287;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=33218; --  has spell 63605;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=33455; --  has spell 61894;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34286; --  has spell 65077;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34286; --  has spell 64482;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34496; --  has spell 66132;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34497; --  has spell 66133;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34812; --  has spell 61796;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34819; --  has spell 61795;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34822; --  has spell 61794;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34823; --  has spell 61793;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34824; --  has spell 61797;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34852; --  has spell 35356;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=34888; --  has spell 37119;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35064; --  has spell 66730;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35092; --  has spell 66857;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35324; --  has spell 35356;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35347; --  has spell 66132;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35348; --  has spell 66132;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35351; --  has spell 66133;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=35352; --  has spell 66133;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=36085; --  has spell 63438;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=36621; --  has spell 54219;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37504; --  has spell 69157;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37504; --  has spell 69162;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37504; --  has spell 69164;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37505; --  has spell 69157;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37505; --  has spell 69162;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37505; --  has spell 69164;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37506; --  has spell 69157;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37506; --  has spell 69162;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37506; --  has spell 69164;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=37690; --  has spell 70347;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=38080; --  has spell 69882;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=38080; --  has spell 69898;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=38081; --  has spell 69926;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=38307; --  has spell 14178;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=38718; --  has spell 72664;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=39048; --  has spell 37090;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=39708; --  has spell 74911;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=39709; --  has spell 74911;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=39984; --  has spell 74699;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=40305; --  has spell 75166;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=40351; --  has spell 76624;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=40939; --  has spell 35356;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=41168; --  has spell 77026;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=41588; --  has spell 77854;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=41589; --  has spell 77855;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=41843; --  has spell 78017;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=42220; --  has spell 35356;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=43232; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=43261; --  has spell 35356;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=44992;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=45344; --  has spell 84974;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=45394; --  has spell 84860;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=45416; --  has spell 84877;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=45429; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=46203; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=47092; --  has spell 84877;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=47221; --  has spell 63413;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48350; --  has spell 74699;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48699; --  has spell 85399;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48739; --  has spell 94524;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48790; --  has spell 94524;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48794; --  has spell 94524;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48796; --  has spell 94524;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48923; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=49457; --  has spell 95514;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=49499; --  has spell 85809;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=49793; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=49957; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=50012; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=50023; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=50035; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=50470; --  has spell 85809;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=51143; --  has spell 79976;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=52039; --  has spell 96372;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=53567; --  has spell 99561;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=53883; --  has spell 100612;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=54429; --  has spell 101570;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=54695; --  has spell 102293;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=55441; --  has spell 103678;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=55469; --  has spell 103780;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=56724; --  has spell 106814;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=57977; --  has spell 106814;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=58140; --  has spell 106814;
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=58141; --  has spell 106814;


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


