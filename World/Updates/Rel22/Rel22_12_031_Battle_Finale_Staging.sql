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
    SET @cOldContent = '030';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '12';
    SET @cNewContent = '031';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Battle_Finale_Staging';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Battle for Gilneas City vs 18019 capture: cannon delivery goes fully dynamic, worgen waves hold posts, finale cast staged, VO wired';

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

        -- The city battle finale staging and its voice-over map.


        -- ---- from Battle_City_Finale_Staging ----
        -- The Battle for Gilneas City (24904), staged against the 18019
        -- capture. Retail pre-places NOTHING for the cannon delivery: at
        -- Lorna's beat, three Emberstone Cannons and their villager crew
        -- spawn at the foot of the Emberstone slope and are pushed up onto
        -- the plaza - two guns emplace at the top of the stairs, one rolls
        -- on down to the lower street. Our DB carried a spawn-dump of that
        -- event frozen as statics: four cannons and twenty-five crew
        -- villagers standing at both ends of the route all battle long.
        DELETE FROM `creature` WHERE `guid` IN (222262,222263,222845,222846);
        DELETE FROM `creature` WHERE `id`=38425 AND `map`=654 AND (`phaseMask` & 262144)
            AND `position_x` BETWEEN -1615 AND -1540 AND `position_y` BETWEEN 1278 AND 1318;

        -- The finale actors the scene script now summons on cue: the dying
        -- prince (38474) runs in only at Sylvanas' beat, and King Genn
        -- (38470) enters from the northwest road when the army reaches the
        -- square. Their statics stood in plain sight the whole battle.
        DELETE FROM `creature` WHERE `guid` IN (222991, 222979);

        -- Battle Lorna starts WITH the crew at the foot of the slope
        -- (capture create 12:41:44.669) and runs up to the stairs on cue.
        UPDATE `creature` SET `position_x`=-1547.71, `position_y`=1286.53,
            `position_z`=10.54, `orientation`=3.398, `MovementType`=0, `spawndist`=0
            WHERE `guid`=222860;

        -- The worgen warrior waves (38348) sit on their capture spawn spots
        -- but were imported with wander/waypoint movement - the "worgen
        -- pacing up and down" at the square. Retail: they fight where they
        -- stand. The script now runs the fight; the rows hold their posts.
        UPDATE `creature` SET `MovementType`=0, `spawndist`=0
            WHERE `id`=38348 AND `map`=654 AND (`phaseMask` & 262144);

        -- VO wiring, sized against the client speech archive (bytes track
        -- syllables; anchors: Sylvanas Enough!=10.4k/1 word, Liam Speech03
        -- =138k/28 words). GIEvent/War/Death sets are definitive by name.
        UPDATE `script_texts` SET `sound`=19620 WHERE `entry`=-1999987; -- Liam: Attack!            (Market04)
        UPDATE `script_texts` SET `sound`=19618 WHERE `entry`=-1999988; -- Liam: Push them back!    (Market02)
        UPDATE `script_texts` SET `sound`=19609 WHERE `entry`=-1999989; -- Liam: time is up         (Battle01)
        UPDATE `script_texts` SET `sound`=19621 WHERE `entry`=-1999990; -- Liam: prevail            (Market05)
        UPDATE `script_texts` SET `sound`=19610 WHERE `entry`=-1999991; -- Liam: abomination wall   (Battle02)
        UPDATE `script_texts` SET `sound`=19606 WHERE `entry`=-1999993; -- Liam: sight for sore eyes (Ambush02)
        UPDATE `script_texts` SET `sound`=19611 WHERE `entry`=-1999994; -- Liam: prevail voiced     (Battle03; was a Lorna file)
        UPDATE `script_texts` SET `sound`=20914 WHERE `entry`=-1999995; -- Gorerot: crush puny worgen

        -- The finale lines (script_texts is full below -1999997; SD3 loads
        -- custom_texts through the same DoScriptText path).
        DELETE FROM `custom_texts` WHERE `entry` BETWEEN -2000008 AND -2000001;
        INSERT INTO `custom_texts` (`entry`,`content_default`,`sound`,`type`,`language`,`emote`,`comment`) VALUES
        (-2000001,'Block their retreat, Liam!  We''ve got them right where we want them!',19725,1,0,0,'battle finale - genn block retreat'),
        (-2000002,'SYLVANAS!!',19726,1,0,0,'battle finale - genn sylvanas'),
        (-2000003,'Enough!',20457,1,0,0,'battle finale - sylvanas enough'),
        (-2000004,'Let''s see how brave Gilneas gets on without its stubborn leader!',20458,1,0,0,'battle finale - sylvanas leader'),
        (-2000005,'FATHER!!!',19612,1,0,0,'battle finale - liam father'),
        (-2000006,'LIAM!!  NO!!!',19727,1,0,0,'battle finale - genn liam no'),
        (-2000007,'We did it, father...',20562,0,0,0,'battle finale - liam we did it'),
        (-2000008,'We took back our city... we took back...',20563,0,0,0,'battle finale - liam took back');

        -- Script bindings for the new actors.
        DELETE FROM `script_binding` WHERE `ScriptName` IN
            ('npc_battle_worgen_warrior','npc_sylvanas_battle','npc_soultethered_banshee',
             'npc_lorna_battle','npc_cannon_crew','npc_liam_dying');
        INSERT INTO `script_binding` (`type`,`ScriptName`,`bind`,`data`) VALUES
        (0,'npc_battle_worgen_warrior',38348,0),
        (0,'npc_sylvanas_battle',38469,0),
        (0,'npc_soultethered_banshee',38473,0),
        (0,'npc_lorna_battle',38426,0),
        (0,'npc_cannon_crew',38425,0),
        (0,'npc_liam_dying',38474,0);

        -- ---- from Battle_VO_By_Duration ----
        -- Liam's battle VO, re-mapped by MEASURED ogg durations (granule /
        -- sample-rate from the speech archive), calibrated on the six known
        -- speech verses (0.35-0.45 s/word). Byte size lied: the abomination
        -- line (13 words, ~5.2s) is Battle01 - which sat on the time-is-up
        -- text and fired the abomination audio back at the first plaza brawl.
        UPDATE `script_texts` SET `sound`=19611 WHERE `entry`=-1999989; -- time is up          (Battle03, 3.48s / 6 words)
        UPDATE `script_texts` SET `sound`=19617 WHERE `entry`=-1999990; -- prevail             (Market01, 2.10s / 3 words)
        UPDATE `script_texts` SET `sound`=19609 WHERE `entry`=-1999991; -- abomination wall    (Battle01, 5.22s / 13 words)
        UPDATE `script_texts` SET `sound`=19619 WHERE `entry`=-1999994; -- prevail, 2nd take   (Market03, 1.77s / 3 words)
        -- Duration-validated and untouched: sore-eyes=19606 (10.33s/24w),
        -- Lorna=19684 (7.25s/20w), Genn 19725-27 (4.0/2.4/2.5s),
        -- Sylvanas 20457/20458 (1.1/7.6s), dying Liam 19612/20562/20563.

        -- The class trainers travel with the army on retail (created ONCE at
        -- the muster; the capture later saw them mid-route, and the dump froze
        -- those sightings as extra statics). One Myriam stands duplicated at
        -- the plaza, and Huntsman Blake's only row is his mid-march position
        -- by the stairs instead of the muster.
        DELETE FROM `creature` WHERE `guid`=222164;                     -- duplicate Myriam Spellwaker at the plaza
        UPDATE `creature` SET `position_x`=-1395.32, `position_y`=1224.65,
            `position_z`=35.643, `orientation`=1.815 WHERE `guid`=222163; -- Blake back to the muster

        -- ---- from Battle_VO_Broadcast_Truth ----
        -- Ground truth found: tc-preservation's build-18019 broadcast_text dump
        -- carries Blizzard's own text->sound links for every battle line
        -- (093_2014_03_30_06_world_broadcast_text.sql). Duration-fitting guessed
        -- wrong twice; this is authoritative:
        --   38495 Attack! / 38496 Push them back! / 38493 prevail /
        --   38494 time-is-up ......................... SoundId 0 (TEXT-ONLY on retail)
        --   38362 abominations blocking .............. 19609 (already set)
        --   38345 sight-for-sore-eyes ................ 19610
        --   38322 Lorna villagers .................... 19684 (already set)
        --   Gorerot 20914, Genn 19725/26/27, dying Liam 19612/20562/20563,
        --   Darius 19499/19500 ....................... all confirmed unchanged.
        UPDATE `script_texts` SET `sound`=0     WHERE `entry`=-1999987; -- Attack!            (retail: no VO)
        UPDATE `script_texts` SET `sound`=0     WHERE `entry`=-1999988; -- Push them back!    (retail: no VO)
        UPDATE `script_texts` SET `sound`=0     WHERE `entry`=-1999989; -- time is up         (retail: no VO)
        UPDATE `script_texts` SET `sound`=0     WHERE `entry`=-1999990; -- prevail            (retail: no VO)
        UPDATE `script_texts` SET `sound`=0     WHERE `entry`=-1999994; -- prevail voiced     (retail: no VO)
        UPDATE `script_texts` SET `sound`=19610 WHERE `entry`=-1999993; -- sight for sore eyes
        -- Sylvanas' two scene lines read SoundId 0 in the 18019 dump, but the
        -- client ships exactly two files named for her and this event
        -- (VO_QE_SP_Sylvanas_GIEvent01/02) whose lengths match the two lines;
        -- they stay wired (-2000003/-2000004 keep 20457/20458).

        -- The spawns removed above leave their addon and waypoint rows behind;
        -- drop those too, or every boot logs them as orphans.
        DELETE FROM `creature_addon` WHERE `guid` IN (222845,222846,222847,222849,222850,222851,222852,222853,222854,222855,222856,222857)
            AND `guid` NOT IN (SELECT `guid` FROM `creature`);
        DELETE FROM `creature_movement` WHERE `id` IN (222845,222846,222847,222849,222850,222851,222852,222853,222854,222855,222856,222857,222979,222991)
            AND `id` NOT IN (SELECT `guid` FROM `creature`);

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
