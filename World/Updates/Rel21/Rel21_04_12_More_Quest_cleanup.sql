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
    SET @cOldStructure = '04'; 
    SET @cOldContent = '11';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '04';
    SET @cNewContent = '12';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'More_Quest_cleanup';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'More_Quest_cleanup';

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
		
UPDATE `quest_template` SET `QuestFlags` = 524296 WHERE `entry` IN (218, 457);
UPDATE `quest_template` SET `QuestFlags` = 524288 WHERE `entry` IN (3100, 3103, 3101, 3102, 3105, 3104);
UPDATE `quest_template` SET `QuestFlags` = 8 WHERE `entry` IN (2499, 932, 26032, 26036, 26632, 27531, 26122, 30112, 29864, 29836, 29835, 29763, 29658, 29654, 2499, 208, 486, 10180, 876, 899, 2518, 2459, 29807, 28318, 28271, 27806, 25440, 13648, 24467, 11359, 13519, 13946, 26079, 25369, 26049, 26618);
UPDATE `quest_template` SET `QuestFlags` = 0 WHERE `entry` IN (8471, 30107, 29802, 193, 188, 197, 414, 751, 931, 14458, 14336, 6365, 14005, 13875, 14042, 14091, 13989);
UPDATE `quest_template` SET `QuestFlags` = 4480 WHERE `entry` IN (13833);
UPDATE `quest_template` SET `QuestFlags` = 4232 WHERE `entry` IN (27991, 28390, 28669, 28063, 28137, 27987, 28391, 27973, 28698, 28223, 28685, 28687, 28694, 28695, 28700, 29205, 29206);
UPDATE `quest_template` SET `QuestFlags` = 4224 WHERE `entry` IN (26543, 29358, 29360, 29122, 29126, 29148, 29160, 29162, 29165, 29334, 29354, 29363, 29248, 29278, 29434);
UPDATE `quest_template` SET `QuestFlags` = 10 WHERE `entry` IN (2561);
UPDATE `quest_template` SET `QuestFlags` = 136 WHERE `entry` IN (9487, 11272, 8329, 11911, 13187, 11262, 12090, 14034, 12238, 13529, 13646, 13644, 14118, 14249, 13124, 13132, 13844, 13876, 14324, 14257, 14248, 14245, 14056, 14386, 13897, 14367, 12493, 28045, 25943, 25428, 28502, 27329, 26031, 26328, 28155, 26111, 28109, 28455, 25405, 25564, 28217, 26483, 25791, 25681, 27739, 27594, 26575, 26568, 27613, 27606, 26583, 25256, 25260, 26314, 26577, 25288, 25947, 25290, 26659, 25343, 25380, 25415, 25416, 26263, 25627, 28184, 26722, 26548, 28377, 27651, 13515, 13558, 13563, 13565, 13653, 13797, 13890, 13979,13982, 14197, 14253, 14383, 14397, 14403, 14428, 14464, 14484, 24439, 24501, 27338, 25432, 26530, 26103, 25900, 24674, 24675, 24678, 24686, 24690, 24692, 24699, 26095, 24703, 25361, 24709, 24714, 25373, 27922, 25956, 24733, 29606, 29575, 24744, 27960, 25916, 25357, 27906, 25942, 25433, 27986, 26157, 26157, 26022, 24817, 26250, 27597, 26194, 25687, 27901, 26362, 26024, 25340, 25849, 24924, 24929, 25244, 24950, 25839, 24957, 25628, 25193, 25654, 25001, 26171, 26330, 25003, 25308, 25012, 25017, 25018, 27431, 28247, 27432, 26283, 25205, 25066, 25670, 26187, 26042, 25103, 25108, 28509, 25123, 28507, 25800, 26428, 26842, 25166, 27943, 25195, 25202, 25203, 26601, 29540, 29527, 25222, 28520, 25243, 25251, 25274, 28418, 25277, 25278, 26679, 26542, 28578, 25310, 25314, 25334, 26436, 25362, 25363, 25368, 25374, 28108, 26193, 25389, 28333, 28124, 25762, 28413, 26359, 26367, 25794, 26305, 25431, 28200, 25458, 25463, 26140, 28264, 28381, 25651, 25510, 25659, 25522, 27655, 25541, 25545, 26920, 25546, 25550, 25551, 25553, 25555, 26932, 28226, 27478, 27053, 25657, 27083, 26409, 25701, 25704, 27117, 25719, 25720, 25725, 25731, 25732, 25756, 25757, 26369, 25776, 25790, 26453, 27479, 25813, 25814, 27042, 26481, 26433, 26441, 27318, 25865, 26300, 25871, 25872, 25873, 25874, 25880, 26352, 25921, 25941, 25944, 26316, 26781, 25990, 25995, 26161, 26029, 26032, 26036, 26632, 28451, 26110, 27581, 26122, 27531, 26828, 26844, 26176, 27645, 26186, 26210, 27110, 26243, 26887, 26299, 27684, 26315, 27683, 26326, 26366, 27323, 26376, 27275, 27229, 28106, 27227, 26418, 28113, 26466, 26490, 26647, 26515, 26517, 26518, 26526, 27956, 26937, 26590, 26606, 26613, 27208, 26625, 26627, 27576, 28602, 27580, 28554, 28359, 27564, 26685, 27632, 27640, 26698, 28159, 26703, 27942, 27950, 26729, 26730, 26731, 26735, 27616, 27620, 28129, 26747, 27934, 28443, 26773, 26775, 27958, 26785, 27964, 27910, 28427, 26810, 26815, 27477, 27988, 27998, 27996, 26831, 28579, 26834, 26836, 26839, 26840, 26855, 28030, 26858, 26864, 27974, 27461, 28491, 27316, 27825, 26889, 27324, 26905, 26906, 27276, 26912, 29653, 26924, 27228, 26925, 27823, 26942, 26960, 27328, 28306, 28386, 27879, 27157, 27013, 27043, 27197, 27054, 27654, 27057, 27652, 27068, 27074, 27102, 27104, 27764, 27125, 27213, 27158, 27162, 27163, 27164, 30094, 27179, 28511, 28505, 27184, 28577, 28591, 27204, 28098, 28138, 28655, 27931, 28518, 28114, 27963, 28422, 27314, 27315, 27319, 27915, 27327, 27330, 27685, 28510, 28508, 27346, 28735, 28590, 27367, 27370, 27383, 27979, 27386, 27392, 28337, 27407, 29134, 27440, 28321, 27456, 27460, 27462, 28415, 28311, 28313, 27882, 27523, 28180, 27527, 27567, 28174, 27578, 28254, 27593, 27603, 27607, 27615, 27619, 27621, 27630, 27631, 27635, 28236, 27648, 27653, 27657, 27658, 27661, 27690, 27695, 27696, 27725, 27745, 27765, 29173, 27776, 28445, 27792, 27838, 27877, 29567, 28485, 27900, 27917, 27920, 27921, 29326, 27936, 28853, 27962, 27968, 27984, 27989, 28044, 28257, 28048, 28051, 28052, 28062, 28372, 28085, 28100, 28101, 28133, 28144, 28218, 28272, 29685, 28403, 28416, 28426, 28432, 28574, 29242, 28643, 28674, 28704, 29528, 28749, 28750, 28760, 26551, 30103, 29596, 29537, 28824, 28828, 28829, 28836, 28841, 28842, 28843, 28854, 29565, 29027, 29613, 28936, 28939, 29312, 29833, 29272, 29032, 29336, 29285, 29241, 29197, 29269, 29132, 29309, 29168, 29169, 29172, 29174, 29175, 30098, 29307, 29308, 29329, 29335, 29337, 29338, 29834);
UPDATE `quest_template` SET `QuestFlags` = 128 WHERE `entry` IN (11248, 11256, 10724, 11951, 13886, 14155, 14126, 13995, 12886, 14138, 27187, 25980, 25272, 26888, 26882, 25355, 13888, 13935, 14435, 20441, 24215, 24473, 24526, 24625, 28566, 28646, 24718, 29597, 26065, 25353, 27176, 24814, 25729, 27787, 24868, 25328, 25129, 24958, 24960, 27867, 27698, 25035, 27444, 27768, 25213, 27720, 26553, 27868, 26390, 25273, 25366, 27094, 27798, 25474, 27719, 26973, 26971, 27638, 25977, 26143, 27850, 27866, 26967, 27700, 26555, 27940, 26651, 26656, 27636, 28153, 28143, 28119, 27445, 26801, 26812, 26814, 28222, 27517, 26869, 26899, 27785, 26910, 27729, 28330, 29657, 27380, 26950, 26959, 27847, 26974, 27692, 26976, 26996, 27007, 27670, 27009, 27758, 27756, 27865, 27061, 27148, 28885, 27848, 27864, 28617, 28647, 27701, 27378, 28329, 27842, 27541, 28220, 27637, 27639, 27723, 27674, 27697, 28644, 27773, 27781, 27788, 27790, 27844, 27935, 28169, 28784, 28131, 28142, 28794, 28224, 28449, 28645, 28654, 29532, 28733, 28737, 28738, 28740, 28741, 28744, 28747, 28748, 28759, 28769, 28770, 28771, 28772, 28773, 28774, 28780, 28785, 28786, 28787, 28788, 28789, 28791, 28792, 28793, 28795, 28796, 28797, 28840, 29453, 29533, 30116, 29079, 29080, 29081, 29089, 29100, 29129, 29170, 29171, 29219, 29254, 29327, 29452, 29474, 172);


-- More obsolete quest clean up
DELETE FROM `quest_template` WHERE `entry` IN (8396, 8292, 8298, 7886, 8163, 7925, 8293, 8157, 8159, 8124, 7921, 8396, 8300, 8164, 7888, 8081, 8165, 8158, 7922, 7923, 7924, 7887);
DELETE FROM `quest_poi_points` WHERE `questId` IN (8396, 8292, 8298, 7886, 8163, 7925, 8293, 8157, 8159, 8124, 7921, 8396, 8300, 8164, 7888, 8081, 8165, 8158, 7922, 7923, 7924, 7887);
DELETE FROM `quest_poi` WHERE `questId` IN (8396, 8292, 8298, 7886, 8163, 7925, 8293, 8157, 8159, 8124, 7921, 8396, 8300, 8164, 7888, 8081, 8165, 8158, 7922, 7923, 7924, 7887);
DELETE FROM `locales_quest` WHERE `entry` IN (8396, 8292, 8298, 7886, 8163, 7925, 8293, 8157, 8159, 8124, 7921, 8396, 8300, 8164, 7888, 8081, 8165, 8158, 7922, 7923, 7924, 7887);

DELETE FROM `creature_questrelation` WHERE `quest` IN (8298, 8163, 8157, 8159, 8124, 8300, 8164, 8081, 8165, 8158);
DELETE FROM `creature_involvedrelation` WHERE `quest` IN (8163, 8157, 8159, 8124, 8300, 8164, 8081, 8165, 8158, 8298); 
    

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

