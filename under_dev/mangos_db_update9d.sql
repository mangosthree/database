/* ***********
* This script will provide Database configuration about Gilneas city zone for phase, quest, npc, etc...
*********** */

-- Gilneas city npc scripted
UPDATE creature_template SET ScriptName='npc_prince_liam_greymane_phase1' WHERE entry='34850';
-- Sets proper scriptName, flag to get aggroed from other mob, unitflag instead of 33284 to aggro and move
UPDATE creature_template SET ScriptName='npc_prince_liam_greymane_phase2', flags_extra='0', unit_flags='33024' WHERE entry='34913';
UPDATE creature_template SET ScriptName='rampaging_worgen' WHERE entry='34884';
UPDATE creature_template SET unit_flags='32768', ScriptName='rampaging_worgen' WHERE entry='35660';
UPDATE creature_template SET MovementType='2',  speed_walk='2', unit_flags2='2048', AIName='EventAI', flags_extra='2', ScriptName='frightened_citizen_quest' WHERE entry='34981';

INSERT INTO mangos.creature_movement_template (entry, point, position_x, position_y, position_z, waittime, script_id, textid1, textid2, textid3, textid4, textid5, emote, spell, wpguid, orientation, model1, model2) VALUES 
('34981', '1', '-1498.11', '1411.46', '35.56', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0');

--  Gilneas GameObject dbscripts

INSERT INTO dbscripts_on_go_template_use (id, delay, command, datalong, datalong2, buddy_entry, search_radius, data_flags, dataint, dataint2, dataint3, dataint4, x, y, z, o, comments) VALUES 
(195327, 1, 8, 35830, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Quest progression (Quest: 14098)'),
(195327, 0, 10, 34981, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Summon Frightened Citizen'),
(195327, 0, 10, 35660, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Summon Rampaging Worgen');

-- Gilneas city condition and phase definitions

INSERT INTO conditions (type, value1, value2) VALUES 
(9, 14091, 2), 
(8, 14091, 0);

INSERT INTO phase_definitions (zoneId, entry, phasemask, phaseId, terrainswapmap, flags, condition_id, comment) VALUES 
(4755, 1, 2, 1, 0, 1, (SELECT condition_entry FROM conditions WHERE type = 9 AND value1 = 14091 AND value2 = 2), 'Gilneas city entering in second phase'),
(4755, 2, 2, 1, 0, 2, (SELECT condition_entry FROM conditions WHERE type = 8 AND value1 = 14091 AND value2 = 0), 'Gilneas city stay in second phase');


-- UPDATE db_version SET version= 'YTDB_0.16.9_R727_MaNGOS3_R12924_SD2_R3035_ACID_R320_RuDB_R64';
