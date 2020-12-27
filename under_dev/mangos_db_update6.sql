
-- cata zone portals (alliance)
UPDATE `gameobject_template` SET `data0` = '85040' , `data5` = '0' WHERE `entry` = '207691'; -- teleport to vashj'ir

-- Human start zone - Stormwind Infantry attack blackrock battle worgs
INSERT INTO dbscripts_on_creature_movement VALUES (49869,0,26,1,0,49871,8,0,0,0,0,0,0,0,0,0,'Stormwind Infantry - Looking for Blackrock Battle Worg to Attack');

insert into creature_movement values (177935,1,-8821.14,-143.156,81.0599,500,49869,0,0,0,0,0,0,0,0,1.16937,0,0),
(177936,1,-8962.33,-233.414,76.6618,500,49869,0,0,0,0,0,0,0,0,-2.18532,0,0),
(177937,1,-8983.45,-148.417,81.5943,500,49869,0,0,0,0,0,0,0,0,3.76991,0,0),
(177938,1,-8857.78,-134.865,81.3496,500,49869,0,0,0,0,0,0,0,0,0.893835,0,0),
(177939,1,-8972.67,-82.4306,86.9969,500,49869,0,0,0,0,0,0,0,0,0.767945,0,0),
(177940,1,-8907.56,-78.8308,87.3481,500,49869,0,0,0,0,0,0,0,0,1.39788,0,0),
(177941,1,-8807.43,-163.302,81.7143,500,49869,0,0,0,0,0,0,0,0,6.00393,0,0),
(177942,1,-8983,-53.6076,91.4949,500,49869,0,0,0,0,0,0,0,0,0.17645,0,0),
(177943,1,-8872.65,-120.501,81.2425,500,49869,0,0,0,0,0,0,0,0,0.498396,0,0),
(177944,1,-8981.61,-66.4004,89.9789,500,49869,0,0,0,0,0,0,0,0,0.634094,0,0),
(177961,1,-9018.34,-115.545,88.0175,500,49869,0,0,0,0,0,0,0,0,4.62992,0,0),
(177962,1,-8811.47,-151.259,82.6853,500,49869,0,0,0,0,0,0,0,0,0.296706,0,0),
(177963,1,-8950.66,-86.0417,87.7749,500,49869,0,0,0,0,0,0,0,0,1.3439,0,0),
(177964,1,-9004.6,-126.356,84.7341,500,49869,0,0,0,0,0,0,0,0,-2.75209,0,0),
(177965,1,-8835.9,-147.991,80.9152,500,49869,0,0,0,0,0,0,0,0,0.71315,0,0);

update creature set MovementType = 2 where id = 49869;

-- Training dummy fix for humans

insert into creature_ai_scripts values (4454801,44548,8,0,100,0,20271,-1,0,0,33,44175,1,0,33,44420,1,0,0,0,0,0,'Training Dummy - On Judgement Spellhit (Quest 26918 Credit) - (44420 Is Workaround Until Core Support Exists)'),
(4454802,44548,8,0,100,0,100,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Charge Spellhit (Quest 26913 Credit)'),
(4454803,44548,8,0,100,0,348,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Immolate Spellhit (Quest 26914 Credit)'),
(4454804,44548,8,0,100,0,56641,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Steady Shot Spellhit (Quest 26917 Credit)'),
(4454805,44548,8,0,100,0,5143,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Arcane Missiles Spellhit (Quest 26916 Credit)'),
(4454806,44548,8,0,100,0,2098,-1,0,0,33,44175,1,0,0,0,0,0,0,0,0,0,'Training Dummy - On Eviscerate Spellhit (Quest 26915 Credit)');

update creature_template set ainame = 'EventAI', minhealth = 70, maxhealth = 70 where entry = 44548;

UPDATE `db_version` SET `version` = 'YTDB_0.16.9_R722_MaNGOS3_R12751_SD2_R2928_ACID_R310_RuDB_R63_+_mangosdb_update_6';
