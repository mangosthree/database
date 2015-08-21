# SD2_3000
UPDATE creature_template SET ScriptName='npc_rethhedron' WHERE entry=22357;
UPDATE creature_template SET ScriptName='npc_drijya' WHERE entry=20281;
UPDATE creature_template SET ScriptName='npc_firecrackers_bunny' WHERE entry=24230;
UPDATE creature_template SET ScriptName='npc_ghoul_feeding_bunny' WHERE entry=28591;
UPDATE creature_template SET ScriptName='npc_decaying_ghoul' WHERE entry=28565;
UPDATE creature_template SET ScriptName='npc_scourged_flamespitter' WHERE entry=25582;
UPDATE creature_template SET ScriptName='npc_anchorite_barada' WHERE entry=22431;
UPDATE creature_template SET ScriptName='npc_colonel_jules' WHERE entry=22432;
UPDATE creature_template SET ScriptName='npc_dorius_stonetender' WHERE entry=8284;
UPDATE creature_template SET ScriptName='npc_fhwoor' WHERE entry=17877;
UPDATE creature_template SET ScriptName='npc_nagrand_captive' WHERE entry IN (18209,18210);
UPDATE creature_template SET ScriptName="npc_skyguard_prisoner" WHERE entry=23383;
UPDATE creature_template SET ScriptName='npc_bonker_togglevolt' WHERE entry=25589;

# SD2_3035
UPDATE creature_template SET ScriptName='npc_squad_leader' WHERE entry IN (31737,31833);
UPDATE creature_template SET ScriptName='npc_infantry' WHERE entry IN (31701,31832);
UPDATE creature_template SET ScriptName='npc_father_kamaros' WHERE entry IN (31279,32800);
UPDATE creature_template SET ScriptName='npc_injured_miner' WHERE entry=29434;
UPDATE creature_template SET ScriptName='npc_harrison_jones' WHERE entry=26814;
UPDATE creature_template SET ScriptName='npc_apothecary_hanes' WHERE entry=23784;
UPDATE creature_template SET ScriptName='npc_taelan_fordring' WHERE entry=1842;
UPDATE creature_template SET ScriptName='npc_isillien' WHERE entry=1840;
UPDATE creature_template SET ScriptName='npc_tirion_fordring' WHERE entry=12126;
DELETE FROM scripted_areatrigger WHERE entry IN (4052);
INSERT INTO scripted_areatrigger VALUES
(4052,'at_temple_ahnqiraj');
UPDATE creature_template SET ScriptName='boss_tethyr' WHERE entry=23899;
UPDATE creature_template SET ScriptName='npc_shay_leafrunner' WHERE entry=7774;
DELETE FROM scripted_areatrigger WHERE entry IN (5710,5711,5712,5714,5715,5716);
INSERT INTO scripted_areatrigger VALUES
(5710, 'at_hot_on_the_trail'),
(5711, 'at_hot_on_the_trail'),
(5712, 'at_hot_on_the_trail'),
(5714, 'at_hot_on_the_trail'),
(5715, 'at_hot_on_the_trail'),
(5716, 'at_hot_on_the_trail');
UPDATE creature_template SET ScriptName='npc_saronite_mine_slave' WHERE entry=31397;
UPDATE creature_template SET ScriptName='npc_tipsy_mcmanus' WHERE entry=28566;
UPDATE creature_template SET ScriptName='npc_wants_fruit_credit' WHERE entry IN (28535,28536,28537);
UPDATE gameobject_template SET ScriptName='go_quest_still_at_it_credit' WHERE entry IN (190635,190636);
UPDATE creature_template SET ScriptName='boss_head_of_horseman' WHERE entry=23775;
UPDATE creature_template SET ScriptName='npc_scalawag_frog' WHERE entry=26503;
UPDATE creature_template SET ScriptName='npc_crystalline_ice_giant' WHERE entry=26809;
UPDATE creature_template SET ScriptName='npc_guardian_of_yogg' WHERE entry=33136;
UPDATE creature_template SET ScriptName='boss_yogg_saron' WHERE entry=33288;
UPDATE creature_template SET ScriptName='npc_captured_arkonarin' WHERE entry=11016;
UPDATE creature_template SET ScriptName='npc_arei' WHERE entry=9598;
UPDATE creature_template SET ScriptName='npc_death_ray' WHERE entry=33881;
UPDATE creature_template SET ScriptName='npc_immortal_guardian' WHERE entry=33988;
UPDATE creature_template SET ScriptName='npc_constrictor_tentacle' WHERE entry=33983;
UPDATE creature_template SET ScriptName='npc_brain_yogg_saron' WHERE entry=33890;
UPDATE creature_template SET ScriptName='npc_descent_madness' WHERE entry=34072;
UPDATE creature_template SET ScriptName='npc_laughing_skull' WHERE entry=33990;
UPDATE creature_template SET ScriptName='npc_keeper_mimiron' WHERE entry=33412;
UPDATE creature_template SET ScriptName='npc_keeper_thorim' WHERE entry=33413;
