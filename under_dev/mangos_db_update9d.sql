
-- Gilneas city npc scripted
UPDATE `mangos`.`creature_template` SET `ScriptName`='npc_prince_liam_greymane_phase1' WHERE `entry`='34850';
-- Sets proper scriptName, flag to get aggroed from other mob, unitflag instead of 33284 to aggro and move
UPDATE `mangos`.`creature_template` SET `ScriptName`='npc_prince_liam_greymane_phase2', `flags_extra`='0', `unit_flags`='33024' WHERE `entry`='34913';
UPDATE `mangos`.`creature_template` SET `ScriptName`='rampaging_worgen' WHERE `entry`='34884';


-- Gilneas city condition and phase definitions

INSERT INTO `mangos`.`conditions` (`type`, `value1`, `value2`) VALUES 
(9, 14091, 2), 
(8, 14091, 0);

INSERT INTO `mangos`.`phase_definitions` (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `condition_id`, `comment`) VALUES 
(4755, 1, 2, 1, 0, 1, (SELECT `condition_entry` FROM `mangos`.`conditions` WHERE `type` = 9 AND `value1` = 14091 AND `value2` = 2), 'Gilneas city entering in second phase'),
(4755, 2, 2, 1, 0, 2, (SELECT `condition_entry` FROM `mangos`.`conditions` WHERE `type` = 8 AND `value1` = 14091 AND `value2` = 0), 'Gilneas city stay in second phase');

-- UPDATE db_version SET `version`= 'YTDB_0.16.9_R727_MaNGOS3_R12924_SD2_R3035_ACID_R320_RuDB_R64';
