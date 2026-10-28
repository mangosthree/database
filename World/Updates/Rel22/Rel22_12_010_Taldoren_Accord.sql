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
    SET @cOldStructure = '12';
    SET @cOldContent = '009';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '010';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Taldoren_Accord';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Return to Stormglen (24673): spawn the Taldoren Godfrey + Greymane at capture positions and play the accord scene on accept - six lines, Greymane';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @oldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @oldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- The Tal'doren accord: the actors arrive rather than loiter.


        -- ---- from Taldoren_Accord ----
        -- Return to Stormglen (24673): the accord scene needs its actors -
        -- neither the Tal'doren Lord Godfrey (38766) nor King Greymane (38767)
        -- had spawns. Capture positions; phase 131072 like Darius beside them.
        DELETE FROM `creature` WHERE `guid` IN (400075, 400076);
        INSERT INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `DeathState`, `MovementType`) VALUES
        (400075, 38766, 654, 1, 131072, 0, 0, -2118.87, 1290.50, -80.70, 6.03, 300, 0, 0, 1, 0, 0, 0),
        (400076, 38767, 654, 1, 131072, 0, 0, -2104.65, 1282.23, -83.59, 6.16, 300, 0, 0, 1, 0, 0, 0);

        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_darius_taldoren';
        INSERT INTO `script_binding` (`type`, `bind`, `ScriptName`) VALUES
        (0, 37195, 'npc_darius_taldoren');

        DELETE FROM `script_texts` WHERE `entry` BETWEEN -1999973 AND -1999968;
        INSERT INTO `script_texts` (`entry`, `content_default`, `type`, `comment`) VALUES
        (-1999968, 'Crowley!  You and your elven allies are hereby ordered to serve along the king''s army.  Cursed or not, you are still bound by Gilnean law!', 0, 'taldoren accord - godfrey order'),
        (-1999969, 'Does this toad speak for you, Genn?  Do you come to our dwelling as a friend?  Or do you come as a tyrant?', 0, 'taldoren accord - crowley toad'),
        (-1999970, 'No, old friend.  I''ve come to you as an equal.', 0, 'taldoren accord - greymane equal'),
        (-1999971, 'Impossible!', 0, 'taldoren accord - godfrey gasp'),
        (-1999972, 'Aye, Genn.  It is not law that binds us.  It is something far stronger.  My men are ready to give their lives under your command.', 0, 'taldoren accord - crowley aye'),
        (-1999973, 'It is decided, then.  We will unite all Gilneans and drive the Forsaken from our lands.', 0, 'taldoren accord - greymane unite');

        -- ---- from Accord_Walk_In ----
        -- The accord actors ARRIVE, they do not loiter: the capture shows
        -- Darius yelling "Lorna!" as she runs to him, with Greymane and Godfrey
        -- walking up the path behind her. The static spawns from Rel22_07_116
        -- go (their mid-walk coordinates were wrong anyway); the scene summons
        -- the trio on accept.
        DELETE FROM `creature` WHERE `guid` IN (400075, 400076);

        DELETE FROM `script_texts` WHERE `entry` = -1999974;
        INSERT INTO `script_texts` (`entry`, `content_default`, `type`, `comment`) VALUES
        (-1999974, 'Lorna!', 0, 'taldoren accord - darius calls lorna');

        -- ---- from Accord_Voice_Over ----
        -- The accord lines DO have voice-over: the capture carries one unparsed
        -- play-sound packet (opcode 0x0C43) per line, timestamp-exact. Decoded
        -- ids form per-actor families (Crowley 19510/19511/19512, Godfrey
        -- 19636/19637, Greymane 19723/19724), which confirms the mapping.
        -- "Lorna!" is a MonsterYell (SlashCmd 14) in the capture, not a say.
        UPDATE `script_texts` SET `sound` = 19636 WHERE `entry` = -1999968;
        UPDATE `script_texts` SET `sound` = 19510 WHERE `entry` = -1999969;
        UPDATE `script_texts` SET `sound` = 19723 WHERE `entry` = -1999970;
        UPDATE `script_texts` SET `sound` = 19637 WHERE `entry` = -1999971;
        UPDATE `script_texts` SET `sound` = 19512 WHERE `entry` = -1999972;
        UPDATE `script_texts` SET `sound` = 19724 WHERE `entry` = -1999973;
        UPDATE `script_texts` SET `sound` = 19511, `type` = 1 WHERE `entry` = -1999974;

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
            SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@newResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @newResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@oldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @oldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
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
