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
    SET @cOldContent = '004';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '01';
    SET @cNewContent = '005';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'EventAI_startup_errors_pt3';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'EventAI_startup_errors_pt3';

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

	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2738911;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2739001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2771711;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2796402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2796403;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2796602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797103;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797104;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797703;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2797704;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2808702;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2810302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2812301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2820101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2820102;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2821202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2838803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2854711;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2858103;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2873311;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2873312;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2891802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2899809;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2902817;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2902819;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2923601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2926605;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2926606;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2931201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2931403;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2931404;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2931603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2937502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2941101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2950302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2951802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2965601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2968001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 2982602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 2998401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3000309;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3002205;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3004502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3055001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3095403;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3113409;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3113410;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3113411;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3116003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3152802;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3218502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3223003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3223004;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3223105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3223106;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3223502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3223701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3227302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3236101;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3239202;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3287603;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3288601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3295701;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3311001;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3334402;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3345302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3352401;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3399301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3399302;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3401404;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3401405;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3419803;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3419804;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3426901;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3444105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3470504;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3482602;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 7 WHERE `id` = 3492508;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3498505;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3501304;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3561105;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3651612;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3672504;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3682902;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3702301;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3712904;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3713405;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3753201;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3754502;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3766413;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3766414;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 0 WHERE `id` = 3788601;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3794903;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3801003;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3811203;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3812511;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3849002;
	UPDATE `creature_ai_scripts` SET `action1_param2` = 1 WHERE `id` = 3849402;    

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


