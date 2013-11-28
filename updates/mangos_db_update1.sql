ALTER TABLE db_version CHANGE COLUMN required_c12729_01_mangos_playercreateinfo_spell 12738_01_mangos_spell_template bit;

UPDATE `command` SET help = 'Syntax: .account create $account $password [$expansion]\r\n\r\nCreate account and set password to it. Optionally, you may also set another expansion for this account than the defined default value.' WHERE name = 'account create';

ALTER TABLE db_version CHANGE COLUMN required_c12739_01_mangos_command required_c12763_01_mangos_playercreateinfo_action bit;

ALTER TABLE playercreateinfo_action DROP INDEX playercreateinfo_race_class_index;


# SD2_2928
UPDATE gameobject_template SET ScriptName='' WHERE entry IN (187982,187995,187996,187997,187998,187999,188000,188001,188002,188003,188004,188005,188006,188007,188008);
UPDATE creature_template SET ScriptName='npc_kinelory' WHERE entry=2713;
UPDATE creature_template SET ScriptName='npc_stinky_ignatz' WHERE entry=4880;
UPDATE creature_template SET ScriptName='npc_rabid_bear' WHERE entry=2164;
UPDATE creature_template SET ScriptName='npc_kernobee' WHERE entry=7850;
UPDATE creature_template SET ScriptName='' WHERE entry IN (30890, 31214);
UPDATE creature_template SET ScriptName='mob_twilight_eggs' WHERE entry IN (31204);
UPDATE creature_template SET ScriptName='npc_tenebron_egg_controller' WHERE entry=31138;
UPDATE creature_template SET ScriptName='npc_netherspite_portal' WHERE entry IN (17367,17368,17369);
UPDATE creature_template SET ScriptName='boss_ignis' WHERE entry=33118;
UPDATE creature_template SET ScriptName='npc_iron_construct' WHERE entry=33121;
UPDATE creature_template SET ScriptName='npc_scorch' WHERE entry=33221;
DELETE FROM scripted_event_id WHERE id IN (21620);
INSERT INTO scripted_event_id VALUES
(21620,'event_ulduar');
UPDATE creature_template SET ScriptName='boss_xt_002' WHERE entry=33293;
UPDATE creature_template SET ScriptName='npc_hogger' WHERE entry=448;
