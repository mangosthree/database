/* ***********
* This script will provide Database configuration about Gilneas city zone for phase, quest, npc, etc...
*********** */

-- Fix some health bug on startup
UPDATE creature AS c JOIN creature_template AS ct ON c.id = ct.entry SET c.curhealth = ct.minhealth WHERE c.curhealth < ct.minhealth;

-- Fix docs info
UPDATE dbdocsfields SET `fieldComment` = 'Check the inverse phase mask', `fieldNotes` = 'Check the inverse phase mask (event doesn\'t trigger if current phase bit is set in mask)' WHERE `fieldId` = '78' and`languageId` = '0';
UPDATE dbdocsfields SET `fieldNotes`='This references a script using an action of the type ACTION_T_TEXT in the Creature AI Scripts table tables entry (See creature_ai_scripts). Valid range are -1 to -999999' WHERE `fieldId`='103' and`languageId`='0';

-- Gilneas city npc scripted
UPDATE creature_template SET ScriptName='npc_prince_liam_greymane_phase1', flags_extra='0', unit_flags='33024' WHERE entry='34850';
UPDATE creature_template SET `npcflag` = 640 WHERE `entry` in (36779, 38783, 38853, 43558);

INSERT INTO mangos.creature_ai_scripts
(id, creature_id, event_type, event_inverse_phase_mask, event_chance, event_flags, event_param1, event_param2, event_param3, event_param4, action1_type, action1_param1, action1_param2, action1_param3, action2_type, action2_param1, action2_param2, action2_param3, action3_type, action3_param1, action3_param2, action3_param3, comment) VALUES
(3536901, 35369, 29, 1, 70, 1, 5000, 25000, 300000, 300000, 1, -353691, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Josiah Avery - Say in Phase 4'),
(3536902, 35369, 29, 1, 70, 1, 30000, 50000, 300000, 300000, 1, -353692, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Josiah Avery - Say in Phase 4'),
(3536903, 35369, 29, 1, 70, 1, 55000, 65000, 300000, 300000, 1, -353693, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Josiah Avery - Say in Phase 4'),
(3536904, 35369, 29, 1, 70, 1, 70000, 90000, 300000, 300000, 1, -353694, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Josiah Avery - Say in Phase 4');
INSERT INTO mangos.creature_ai_texts (entry, content_default, sound, type, language, emote, comment) VALUES
(-353691, 'My face! What\'s wrong with my face!', 0, 1, 7, 424, 'creature_Josiah_Avery_phase4'),
(-353692, 'My hands... don\'t look at my hands!', 0, 1, 7, 424, 'creature_Josiah_Avery_phase4'),
(-353693, 'The pain is unbearable!', 0, 1, 7, 424, 'creature_Josiah_Avery_phase4'),
(-353694, 'What\'s wrong with me??!', 0, 1, 7, 424, 'creature_Josiah_Avery_phase4');
UPDATE `creature_template` SET `AIName` = 'EventAI' WHERE `entry` = 35369;

-- Sets proper scriptName, flag to get aggroed from other mob, unitflag instead of 33284 to aggro and move
UPDATE creature_template SET ScriptName='npc_prince_liam_greymane_phase2', flags_extra='0', unit_flags='33024' WHERE entry='34913';
UPDATE creature_template SET ScriptName='rampaging_worgen' WHERE entry='34884';
UPDATE creature_template SET unit_flags='32768', ScriptName='rampaging_worgen' WHERE entry='35660';
UPDATE creature_template SET MovementType='2',  speed_walk='2', unit_flags2='2048', AIName='EventAI', flags_extra='2', ScriptName='frightened_citizen_quest' WHERE entry='34981';

UPDATE creature_template SET `faction_A` = '2173', `faction_H` = '2173', `mindmg` = '0', `maxdmg` = '1' WHERE `entry` = '35232';

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
(4755, 2, 2, 1, 0, 2, (SELECT condition_entry FROM conditions WHERE type = 8 AND value1 = 14091 AND value2 = 0), 'Gilneas city stay in second phase'),
(4714, 1, 2, 1, 0, 1, (SELECT condition_entry FROM conditions WHERE type = 9 AND value1 = 14091 AND value2 = 2), 'Gilneas city entering in second phase'),
(4714, 2, 2, 1, 0, 2, (SELECT condition_entry FROM conditions WHERE type = 8 AND value1 = 14091 AND value2 = 0), 'Gilneas city stay in second phase');

-- Gilneas Quest correction
UPDATE quest_template SET `SrcSpell` = '68218' WHERE `entry` = '14154';

-- UPDATE db_version SET cache_id = '728';
-- UPDATE db_version SET version = 'YTDB_0.16.9_R728_MaNGOS3_R12924_SD2_R3035_ACID_R320_RuDB_R64';