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
    SET @cOldStructure = '11';
    SET @cOldContent = '022';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '023';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Gilneas_Retail_Health';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Let the Gilneas City Guards on the road to Time to Regroup survive long enough to fight, and re-form in thirty seconds instead of five minutes';

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

        -- Retail health and creature types for the Gilneas cast.
        --
        -- The HealthMultiplier values here are DOCUMENTARY on this core: every
        -- entry is Expansion = -1, for which GetCreatureClassLvlStats returns
        -- NULL and SelectLevel never reads the multiplier, falling back to
        -- MinLevelHealth. They record what retail broadcasts, and would take
        -- effect if these creatures ever gain classlevelstats rows. The health
        -- that actually bites comes from the MinLevelHealth migrations.


        -- ---- from Guards_Hold_The_Passage ----
        -- The road to `Time to Regroup` (14294) was undefended, so the player walked it
        -- alone into the horde.
        --
        -- Eight Gilneas City Guards hold that stretch - three on the passage itself at
        -- about y 1455, five more strung north to y 1519 - and phase 8 puts 42
        -- Afflicted Gilneans and 14 Bloodfang Stalkers on top of them. All three
        -- creatures are HealthMultiplier 1 and the guards are level 3 against level 3-4
        -- and 4-5, so the guards lose, and on `spawntimesecs` 300 the corridor then
        -- stayed empty for five minutes. The same trap the cannon's targets were in.
        --
        -- Thirty seconds re-forms the line at about the rate it breaks. The health is a
        -- judgement call rather than anything the capture told me: at 1 a guard falls to
        -- the first pair that reaches him, which is why nothing was holding. Six lets
        -- him fight several and take some with him. He is still meant to be losing this
        -- battle - forty-two against eight has one ending - but he should cost them
        -- something and keep them busy while the player gets past.
        UPDATE `creature_template` SET `HealthMultiplier` = 6 WHERE `entry` = 50474;
        UPDATE `creature` SET `spawntimesecs` = 30 WHERE `id` = 50474;

        -- ---- from Gilneas_Retail_Health ----
        -- Gilneas creature health, taken from retail.
        --
        -- The Worgen Hunter capture answers `SMSG_DB_REPLY` with the creature record
        -- the client caches, and the float immediately after the name is its health
        -- modifier - confirmed against creatures we had right, e.g. Afflicted Gilnean
        -- reads 1.0 in both. 476 records parsed, every one with the expected trailing
        -- structure and every name matching ours.
        --
        -- 198 of them disagree with this database, almost always the same way: ours
        -- ships 1.0 where retail gives 3 to 190. King Genn Greymane is 120 on retail
        -- and 1 here; Darius Crowley 11; the Wounded Guard 50; both cannons 10; the
        -- Gilneas City Guard 3. That is why the defenders of this city die to anything
        -- that looks at them - the guards on the road to `Time to Regroup` among them,
        -- which is where this started.
        --
        -- Rel22_07_053 guessed 6 for that guard. Retail says 3, so retail wins.
        --
        -- King Greymane's Horse (35905) is deliberately NOT in this list. Retail has it
        -- at 6 and we run 25, set while making the quest ride survivable. The ride is
        -- tested and working at 25; 6 may well be enough now the ride also caps how
        -- many attackers it carries, but that is a change to a working sequence and
        -- belongs in its own pass with a test behind it.
        UPDATE `creature_template` SET `HealthMultiplier` = 190 WHERE `entry` IN (38331);
        UPDATE `creature_template` SET `HealthMultiplier` = 120 WHERE `entry` IN (38470);
        UPDATE `creature_template` SET `HealthMultiplier` = 50 WHERE `entry` IN (37808,47091);
        UPDATE `creature_template` SET `HealthMultiplier` = 30 WHERE `entry` IN (36294,36528,38530,38539,43567);
        UPDATE `creature_template` SET `HealthMultiplier` = 29 WHERE `entry` IN (38469);
        UPDATE `creature_template` SET `HealthMultiplier` = 20 WHERE `entry` IN (35231,38415,50902);
        UPDATE `creature_template` SET `HealthMultiplier` = 11 WHERE `entry` IN (35077,35230,35552,35566,37195,37197,38149,42953);
        UPDATE `creature_template` SET `HealthMultiplier` = 10 WHERE `entry` IN (5782,35317,35914,36140,36283,36440,36451,36462,36616,36693,36698,36797,36798,37065,37807,37921,38377,38424,44427,44429);
        UPDATE `creature_template` SET `HealthMultiplier` = 8 WHERE `entry` IN (33864);
        UPDATE `creature_template` SET `HealthMultiplier` = 6.173 WHERE `entry` IN (37927,38150);
        UPDATE `creature_template` SET `HealthMultiplier` = 6 WHERE `entry` IN (38218,38464);
        UPDATE `creature_template` SET `HealthMultiplier` = 5 WHERE `entry` IN (34056,36190,36231,36312,36454,36455,36456,36491,36492,38420,38465,38467,38473,43566,43727,50881);
        UPDATE `creature_template` SET `HealthMultiplier` = 4 WHERE `entry` IN (14378,14379,14380,38426,38611);
        UPDATE `creature_template` SET `HealthMultiplier` = 3 WHERE `entry` IN (3838,4155,4208,4209,35504,35509,35839,35872,35915,36057,36631,36651,36695,36717,36779,36814,37822,37870,37873,38287,38466,38474,38614,38783,38791,38792,38793,38794,38853,40552,41015,43558,44455,44465,50252,50371,50474,50500,50504,50505);
        UPDATE `creature_template` SET `HealthMultiplier` = 3 WHERE `entry` IN (3841,50499,50506,50507);
        UPDATE `creature_template` SET `HealthMultiplier` = 2.5 WHERE `entry` IN (36461);
        UPDATE `creature_template` SET `HealthMultiplier` = 2 WHERE `entry` IN (2041,3468,4423,25053,25054,25055,25056,32969,33115,33359,35081);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.5 WHERE `entry` IN (4262,36479,51371);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.35 WHERE `entry` IN (4138,4214,4217,24042,28332,35006,35010,35011,35164,35166,35374,35830,36198,36200,36286,36449,40350,43718,43793);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.3 WHERE `entry` IN (11700);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.25 WHERE `entry` IN (4205,4215,4218,4242,4243);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.2 WHERE `entry` IN (4753,37735);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.15 WHERE `entry` IN (3607,4146,4163,4219,10089,37045,38780);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.1 WHERE `entry` IN (2796,4210,4211,4730,7296,25050,43431,52636,52642,55285);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.05 WHERE `entry` IN (3561,4167,4220,4223,4244,7907,7916,10056,10085,11037,43420,43428,51997,52637,52643);
        UPDATE `creature_template` SET `HealthMultiplier` = 1.02 WHERE `entry` IN (4187,10118,43429);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.6 WHERE `entry` IN (35188,35456);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.5 WHERE `entry` IN (32936,37718);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.3 WHERE `entry` IN (37889,37891,37892);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.2 WHERE `entry` IN (36714);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.19 WHERE `entry` IN (49842);
        UPDATE `creature_template` SET `HealthMultiplier` = 0.1 WHERE `entry` IN (36292);

        -- And eight creature types the same source disagrees with.
        UPDATE `creature_template` SET `CreatureType` = 4 WHERE `entry` IN (34056);
        UPDATE `creature_template` SET `CreatureType` = 5 WHERE `entry` IN (36294,36528,37808);
        UPDATE `creature_template` SET `CreatureType` = 7 WHERE `entry` IN (39015,39016,39017);
        UPDATE `creature_template` SET `CreatureType` = 8 WHERE `entry` IN (37889);

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
