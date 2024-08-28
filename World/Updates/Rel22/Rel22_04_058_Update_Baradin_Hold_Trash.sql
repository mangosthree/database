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
    SET @cOldStructure = '04'; 
    SET @cOldContent = '057';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '04';
    SET @cNewContent = '058';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'Update_Baradin_Hold_Trash';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Update_Baradin_Hold_Trash';

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

    -- Remove the following "Eye of Occu'thar" they were removed in Patch 4.3.2 and replaced with Disciples of Hate
DELETE FROM `creature` WHERE `guid` IN (345420,345421,345422,345423,345424,345425,345426,345427,345428,345429,345430,345431,345432,345433,345434,345435);

-- Remove the following "Eye of Occu'thar" in Occu'thar's area
DELETE FROM `creature` WHERE `guid` IN (332395, 332396, 332397, 332398, 332399, 332400, 332401, 332402, 332403, 332404, 332405, 332406, 332407, 332408, 332409, 332410, 332411, 332412, 332413, 332414, 332415, 332424, 332425, 332426, 332427, 332428, 332429, 332431, 332432, 332433, 332434, 332435, 332436, 332437, 332438, 332439, 332440, 332441, 332442, 332449, 332450, 332467, 332468, 332469, 332470, 332471, 332472, 332473, 332474, 332475, 332476, 332477, 332478, 332479, 332480, 332481, 332482, 332483, 332484, 332485, 332486, 332487, 332488, 332489, 332490, 332491, 332492, 332493, 332494, 332495, 332496, 332497, 332498, 332499, 332500, 332501, 332502, 332503, 332504, 332505, 332506, 332506, 332507, 332508, 332513, 332526, 332527, 332528, 332529, 332530, 332531, 332532, 332533, 332534, 332535, 332536, 332537, 332538, 332539, 332540, 332541, 332542, 332543);
DELETE FROM `creature_addon` WHERE `guid` IN (332395, 332396, 332397, 332398, 332399, 332400, 332401, 332402, 332403, 332404, 332405, 332406, 332407, 332408, 332409, 332410, 332411, 332412, 332413, 332414, 332415, 332424, 332425, 332426, 332427, 332428, 332429, 332431, 332432, 332433, 332434, 332435, 332436, 332437, 332438, 332439, 332441, 332442, 332449, 332450, 332467, 332468, 332469, 332470, 332471, 332472, 332473, 332474, 332475, 332476, 332477, 332478, 332479, 332480, 332481, 332482, 332483, 332484, 332485, 332486, 332487, 332488, 332489, 332490, 332491, 332492, 332493, 332494, 332495, 332496, 332497, 332498, 332499, 332500, 332501, 332502, 332503, 332504, 332505, 332506, 332507, 332508, 332513, 332526, 332527, 332528, 332529, 332530, 332531, 332532, 332533, 332534, 332535, 332536, 332537, 332538, 332539, 332540, 332541, 332542, 332543);

-- Update two packs of "Eye of Occu'thar" as dead.
UPDATE `creature` SET `DeathState` = 1 WHERE `guid` IN (345764,345766,345767,345768,345769,345770,345771,345772,345774,345775,345776,345777,345778,345779,345780);

-- Update starting position and add a patrol path for Disciple of Hate 345765
UPDATE `creature` SET `position_x` = 256.561707, `position_y` = 1367.275391, `position_z` = 170.192490, `orientation` = 3.657553, `MovementType` = 2 WHERE `guid` = 345765;
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 1, 247.392, 1361.19, 170.188, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 2, 239.148, 1348.97, 170.186, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 3, 237.397, 1330.86, 170.19, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 4, 242.61, 1316.11, 170.196, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 5, 258.429, 1306.62, 170.193, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 6, 274.367, 1305.11, 170.193, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 7, 291.629, 1312.75, 170.193, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 8, 301.455, 1327.82, 170.192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 9, 301.448, 1344.84, 170.192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 10, 292.71, 1361.46, 170.199, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 11, 277.45, 1369.33, 170.192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);
INSERT INTO `creature_movement` (`id`, `point`, `position_x`, `position_y`, `position_z`, `waittime`, `script_id`, `textid1`, `textid2`, `textid3`, `textid4`, `textid5`, `emote`, `spell`, `orientation`, `model1`, `model2`) VALUES (345765, 12, 258.766, 1368.47, 170.192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 100.0, 0, 0);


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


