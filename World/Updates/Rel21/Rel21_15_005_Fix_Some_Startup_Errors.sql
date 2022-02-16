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
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '15'; 
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '15';
    SET @cNewContent = '005';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Fix_Some_Startup_Errors';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Fix_Some_Startup_Errors';

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

UPDATE creature_template SET NpcFlags=NpcFlags &~(16777216) WHERE entry IN (
14864, 24750, 24896, 25460, 26200, 26421, 26477, 26813, 27061, 27258, 27354, 
27496, 27626, 27692, 27755, 27756, 27850, 27852, 27881, 27894, 27924, 27996, 
28061, 28094, 28161, 28203, 28222, 28312, 28319, 28366, 28451, 28605, 28606, 
28607, 28669, 28683, 28781, 28782, 28833, 29152, 29351, 29358, 29403, 29414, 
29460, 29488, 29500, 29501, 29555, 29563, 29598, 29602, 29625, 29679, 29708, 
29856, 29903, 29912, 29918, 29929, 30021, 30123, 30228, 30234, 30236, 30248, 
30337, 30468, 30560, 30564, 30585, 30645, 30841, 30850, 30852, 30895, 31110, 
31157, 31406, 31407, 31408, 31409, 31583, 31748, 31749, 31784, 31785, 31830, 
31861, 31862, 31883, 31893, 31894, 31895, 31896, 31897, 32189, 32286, 32292, 
32344, 32370, 32627, 32629, 32633, 32640, 32788, 32790, 32795, 32796, 32975, 
33062, 33067, 33114, 33127, 33139, 33143, 33167, 33264, 33313, 33317, 33321, 
33322, 33323, 33348, 33357, 33531, 33669, 33782, 33790, 33791, 33792, 33793, 
33794, 33795, 33800, 33842, 33843, 33978, 34045, 34072, 34111, 34125, 34132, 
34183, 34214, 34306, 34567, 34568, 34658, 34775, 34776, 34777, 34778, 34793, 
34802, 34812, 34819, 34822, 34823, 34824, 34830, 34929, 34935, 34944, 35069, 
35111, 35129, 35196, 35257, 35273, 35410, 35413, 35415, 35417, 35419, 35421, 
35427, 35429, 35431, 35433, 35436, 35526, 35628, 35636, 35644, 35819, 35892, 
35968, 36059, 36232, 36283, 36287, 36288, 36289, 36355, 36356, 36357, 36358, 
36400, 36440, 36459, 36540, 36557, 36558, 36559, 36756, 36768, 36812, 36838, 
36839, 37227, 37738, 37807, 37927, 37945, 37966, 37980, 38111, 38186, 38248, 
38377, 38412, 38424, 38429, 38430, 38542, 38615, 38755, 38933, 39140, 39238, 
39270, 39422, 39443, 39456, 39464, 39592, 39619, 39710, 39714, 39715, 39716, 
39717, 39745, 39860, 39867, 39911, 39996, 39997, 39998, 39999, 40176, 40190, 
40240, 40250, 40340, 40604, 40719, 40720, 40723, 40725, 40869, 40934, 41097, 
41099, 41100, 41101, 41103, 41104, 41109, 41111, 41174, 41196, 41327, 41445, 
41460, 41570, 41620, 41744, 41747, 41776, 41789, 41989, 42175, 42548, 42571, 
42603, 42608, 42644, 42646, 42673, 42689, 42801, 42857, 42871, 42947, 42949, 
42951, 42954, 42956, 42958, 42960, 42964, 43003, 43032, 43044, 43046, 43048, 
43115, 43182, 43334, 43499, 43721, 43984, 43996, 44049, 44057, 44126, 44157, 
44269, 44369, 44427, 44429, 44578, 44579, 44580, 44731, 44764, 44776, 44836, 
44928, 45005, 45191, 45197, 45344, 45455, 45651, 45682, 45715, 45731, 45732, 
45910, 46014, 46041, 46042, 46085, 46100, 46157, 46165, 46301, 46333, 46344, 
46395, 46411, 46536, 47058, 47066, 47098, 47112, 47201, 47203, 47207, 47213, 
47216, 47219, 47241, 47274, 47278, 47316, 47403, 47404, 47422, 47446, 47481, 
47507, 47538, 47732, 47747, 47814, 47820, 47821, 47822, 47872, 48006, 48092, 
48116, 48147, 48148, 48266, 48276, 48283, 48293, 48294, 48295, 48296, 48297, 
48298, 48299, 48300, 48301, 48302, 48309, 48324, 48331, 48341, 48342, 48343, 
48457, 48526, 48649, 48671, 48699, 48803, 48804, 48913, 49143, 49194, 49208, 
49211, 49215, 49216, 49340, 49457, 49499, 49550, 49560, 49604, 49637, 49680, 
50047, 50067, 50426, 50610, 50635, 50636, 50638, 50643, 50655, 51101, 51102, 
51103, 51157, 51340, 51391, 51395, 51396, 51397, 51551, 51681, 52171, 52177, 
52203, 52218, 52225, 52279, 52280, 52314, 52529, 52585, 52676, 52682, 52688, 
52884, 52885, 52886, 52887, 52888, 52889, 52890, 52978, 53082, 53088, 53089, 
53131, 53163, 53243, 53275, 53354, 53373, 53440, 53441, 53442, 53444, 53445, 
53483, 53493, 53517, 53522, 53526, 53555, 53556, 53557, 53670, 53742, 53789, 
53792, 53887, 54223, 54247, 54348, 54367, 54434, 55549, 55715, 55837, 56097, 
56129, 56130, 56131, 57107, 57287, 57288, 57289, 57328, 57377, 57378, 57379, 
57443, 57882); 

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
