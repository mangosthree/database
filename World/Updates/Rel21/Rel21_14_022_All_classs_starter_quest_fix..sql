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
    SET @cOldStructure = '14'; 
    SET @cOldContent = '021';

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '14';
    SET @cNewContent = '022';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'All classs starter quest fix.';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'All classs starter quest fix.';

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

    UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` IN (44548,44171,44389,44614,44703,44820,44794,44848,38038,48304,44937);
 -- Reorder Alliance version script ID, to match the new Horde scripts.
 -- Prevent Alliance Targets from chasing players.
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (44548,44171,44389,44614,44703,44820,44794,44848,38038,48304,44937);
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES
(4454801,44548,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4454802,44548,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4454803,44548,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454804,44548,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454805,44548,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454806,44548,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454807,44548,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454808,44548,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)'),
(4417101,44171,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4417102,44171,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4417103,44171,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26204 Credit)'),
(4417104,44171,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26201 Credit)'),
(4417105,44171,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26198 Credit)'),
(4417106,44171,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26207 Credit)'),
(4438901,44389,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4438902,44389,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4438903,44389,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 24528 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4438904,44389,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 24531 Credit)'),
(4438905,44389,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26904 Credit)'),
(4438906,44389,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 24530 Credit)'),
(4438907,44389,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 24526 Credit)'),
(4438908,44389,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 24532 Credit)'),
(4438909,44389,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 24527 Credit)'),
(4461401,44614,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4461402,44614,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4461403,44614,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26945 Credit)'),
(4461404,44614,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26947 Credit)'),
(4461405,44614,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26940 Credit)'),
(4461406,44614,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26946 Credit)'),
(4470301,44703,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4470302,44703,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4470303,44703,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26966 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4470304,44703,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26958 Credit)'),
(4470305,44703,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26963 Credit)'),
(4470306,44703,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26968 Credit)'),
(4470307,44703,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 26969 Credit)'),
(4482001,44820,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4482002,44820,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4482003,44820,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 25147 Credit)'),
(4482004,44820,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 25145 Credit)'),
(4482005,44820,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 25139 Credit)'),
(4482006,44820,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 25149 Credit)'),
(4482007,44820,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 25141 Credit)'),
(4482008,44820,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 25143 Credit)'),
(4479401,44794,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4479402,44794,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4479403,44794,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 24969 Credit)'),
(4479404,44794,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 24968 Credit)'),
(4479405,44794,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 24964 Credit)'),
(4479406,44794,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 24965 Credit)'),
(4479407,44794,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 24967 Credit)'),
(4484801,44848,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4484802,44848,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4484803,44848,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 27023 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4484804,44848,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 27020 Credit)'),
(4484805,44848,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 27021 Credit)'),
(4484806,44848,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 27027 Credit)'),
(3803801,38038,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(3803802,38038,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(3803803,38038,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 24640 Credit)'),
(3803804,38038,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26274 Credit)'),
(3803805,38038,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 24778 Credit)'),
(3803806,38038,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 24752 Credit)'),
(3803807,38038,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 24772 Credit)'),
(3803808,38038,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 24760 Credit)'),
(4830401,48304,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4830402,48304,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4830403,48304,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 14013 Credit)'),
(4830404,48304,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 14012 Credit)'),
(4830405,48304,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 14007 Credit)'),
(4830406,48304,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 14008 Credit)'),
(4830407,48304,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 14010 Credit)'),
(4830408,48304,8,0,100,0,73899,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Primal Strike Spellhit (Quest 14011 Credit)'),
(4493701,44937,4,0,100,0,0,0,0,0,20,0,0,0,21,0,0,0,0,0,0,0,'Training Dummy'),
(4493702,44937,2,0,100,1,2,1,1000,1000,42,1,-1,0,0,0,0,0,0,0,0,0,'Training Dummy'),
(4493703,44937,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 10069 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4493704,44937,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest -- Credit)'),
(4493705,44937,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 10073 Credit)'),
(4493706,44937,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 10070 Credit)'),
(4493707,44937,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 10068 Credit)'),
(4493708,44937,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 10071 Credit)');

-- Druid and Priest Quest targets.
UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `Entry` IN (44857,44405,44617,42501,16971,47091,44795,45199,47057,48305);
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (44857,44405,44617,42501,16971,47091,44795,45199,47057,48305);
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES
(4485701,44857,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 10072 - Heal kill credit'),
(4440501,44405,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 24533 - Heal kill credit'),
(4461701,44617,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 26949 - Heal kill credit'),
(4461702,44617,8,0,100,0,774,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 26948 - rejuvenation kill credit'),
(4250101,42501,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 26200 - Heal kill credit'),
(1697101,16971,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 26970 - Heal kill credit'),
(4479501,44795,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 14279 - Heal kill credit'),
(4479502,44795,8,0,100,0,774,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 14283 - rejuvenation kill credit'),
(4709101,47091,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 14266 Credit)'),
(4709102,47091,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 14274 Credit)'),
(4709103,47091,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 14276 Credit)'),
(4709104,47091,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 14281 Credit)'),
(4709105,47091,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 14272 Credit)'),
(4519901,45199,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 27066 - Heal kill credit'),
(4519902,45199,8,0,100,0,774,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 27067 - rejuvenation kill credit'),
(4705701,47057,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 24784 - Heal kill credit'),
(4705702,47057,8,0,100,0,774,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 24766 - rejuvenation kill credit'),
(4830501,48305,8,0,100,0,2061,-1,0,0,33,44175,6,0,0,0,0,0,0,0,0,0,'Q. 14009 - Heal kill credit');

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


