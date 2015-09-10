# Y2kCat
/*ALTER TABLE db_version_ytdb CHANGE COLUMN 724_FIX_12803 725_FIX_12849 bit;
REPLACE INTO `db_version_ytdb` (`version`) VALUES ('725_FIX_12849');*/

# Transport_Sniff
# DELETE FROM transports WHERE entry=204423;
# INSERT INTO `transports` VALUES ('204423', 'Orc Gunship', '8016');

# Fix
UPDATE `quest_template` SET `ExclusiveGroup` = -26326 WHERE `entry` = 26876;
UPDATE `quest_template` SET `ExclusiveGroup` = -26326 WHERE `entry` = 27938;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'7' FROM `gameobject` WHERE `id`=206305;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'7' FROM `gameobject` WHERE `id`=206304;
DELETE FROM `gameobject_loot_template` WHERE (`entry`=195668) AND (`item`=49044);
DELETE FROM `gameobject_loot_template` WHERE (`entry`=195668) AND (`item`=49046);
DELETE FROM `creature` WHERE `id`=6729;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(327434, 6729, 48, 1, 1, 5465, 0, -859.915, -468.448, -33.8265, 0.252448, 7200, 0, 0, 840, 0, 2);
DELETE FROM `gameobject` WHERE `id`=301028;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(217594, 301028, 1, 1, 1, -1090.97, 1385.4, 61.9833, 0, 0, 0, 0, 1, 300, 255, 1),
(217595, 301028, 1, 1, 1, -1103.98, 1303.44, 90.5823, 0, 0, 0, 0, 1, 300, 255, 1),
(217596, 301028, 1, 1, 1, -1084.24, 1416.61, 61.7715, 0, 0, 0, 0, 1, 300, 255, 1),
(217597, 301028, 1, 1, 1, -1068.2, 1887.38, 60.2275, 0, 0, 0, 0, 1, 300, 255, 1),
(217598, 301028, 1, 1, 1, -1063.63, 1947.84, 63.5011, 0, 0, 0, 0, 1, 300, 255, 1),
(217599, 301028, 1, 1, 1, -1049.99, 1358.8, 65.7721, 0, 0, 0, 0, 1, 300, 255, 1),
(217600, 301028, 1, 1, 1, -922.672, 1926.03, 60.8396, 0, 0, 0, 0, 1, 300, 255, 1),
(217601, 301028, 1, 1, 1, -872.094, 1828.09, 62.0108, 0, 0, 0, 0, 1, 300, 255, 1),
(217602, 301028, 1, 1, 1, -1022.86, 1924.99, 61.5294, 0, 0, 0, 0, 1, 300, 255, 1),
(217603, 301028, 1, 1, 1, -974.259, 1939.49, 62.5998, 0, 0, 0, 0, 1, 300, 255, 1),
(217604, 301028, 1, 1, 1, -884.028, 1892.53, 62.9832, 0, 0, 0, 0, 1, 300, 255, 1),
(217605, 301028, 1, 1, 1, -1024.58, 1960.77, 63.188, 0, 0, 0, 0, 1, 300, 255, 1),
(217606, 301028, 1, 1, 1, -1303.52, 1627.32, 64.5241, 0, 0, 0, 0, 1, 300, 255, 1),
(217607, 301028, 1, 1, 1, -1303.77, 1593.97, 62.9723, 0, 0, 0, 0, 1, 300, 255, 1);
DELETE FROM `creature_questrelation` WHERE `quest` = 24609;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 24609;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 24609;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (38041, 24609);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 24609;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 24609;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (42928, 24609);

# Ulduar
UPDATE `creature` SET `modelid` = 11686 WHERE `id` = 53789;
DELETE FROM `creature` WHERE `id`=53784;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(342232, 53784, 720, 0, 1, 11686, 0, -63.1434, -321.911, 55.5413, 4.27606, 7200, 0, 0, 77490, 0, 0),
(342272, 53784, 720, 0, 1, 11686, 0, -17.7448, -241.701, 54.7966, 0.95993, 7200, 0, 0, 77490, 0, 0),
(342354, 53784, 720, 0, 1, 11686, 0, -68.667, -256.992, 55.7692, 2.53073, 7200, 0, 0, 77490, 0, 0),
(342413, 53784, 720, 0, 1, 11686, 0, -58.8755, -263.848, 55.4425, 2.53073, 7200, 0, 0, 77490, 0, 0),
(342568, 53784, 720, 0, 1, 11686, 0, -15.2482, -238.135, 53.2553, 0.959932, 7200, 0, 0, 77490, 0, 0),
(342700, 53784, 720, 0, 1, 11686, 0, -19.4949, -244.2, 51.5943, 0.959932, 7200, 0, 0, 77490, 0, 0),
(342756, 53784, 720, 0, 1, 11686, 0, -45.8092, -252.483, 50.0239, 1.74533, 7200, 0, 0, 77490, 0, 0),
(342793, 53784, 720, 0, 1, 11686, 0, -74.3988, -252.979, 53.8461, 2.53073, 7200, 0, 0, 77490, 0, 0),
(342856, 53784, 720, 0, 1, 11686, 0, -66.2569, -258.68, 51.0823, 2.53073, 7200, 0, 0, 77490, 0, 0),
(342977, 53784, 720, 0, 1, 11686, 0, -7.45087, -299.856, 49.4731, 5.67232, 7200, 0, 0, 77490, 0, 0),
(343060, 53784, 720, 0, 1, 11686, 0, -48.6803, -236.2, 52.6858, 1.74533, 7200, 0, 0, 77490, 0, 0);
UPDATE `creature` SET `position_x` = -55.4252, `position_y` = -304.359, `position_z` = 54.7895, `orientation` = 0.908905 WHERE `guid` = 373964;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 337598;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 337602;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 342467;
UPDATE `creature` SET `spawnMask` = 0 WHERE  guid IN (342232, 342272, 342354, 342413, 342568, 342700, 342700, 342756, 342793, 342856, 342977, 343060, 373966);
DELETE FROM `creature` WHERE `id`=53793;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(376076, 53793, 720, 15, 65535, 0, 0, 482.386, 531.415, 244.18, 3.4677, 7200, 0, 0, 641560, 197380, 0),
(376077, 53793, 720, 15, 65535, 0, 0, 445.674, 544.212, 244.349, 5.1507, 7200, 0, 0, 641560, 197380, 0),
(376078, 53793, 720, 15, 65535, 0, 0, 420.123, 504.78, 243.199, 0.609075, 7200, 0, 0, 641560, 197380, 0),
(376079, 53793, 720, 15, 65535, 0, 0, 463.086, 487.067, 244.203, 1.88965, 7200, 0, 0, 641560, 197380, 0),
(373965, 53793, 720, 15, 65535, 0, 0, -53.2882, -271.948, 54.9999, 0.680678, 7200, 0, 0, 641560, 197380, 0),
(376080, 53793, 720, 15, 65535, 0, 0, -56.7305, -292.038, 54.9428, 4.98035, 7200, 0, 0, 641560, 197380, 0),
(376081, 53793, 720, 10, 65535, 0, 0, -56.083, -266.851, 55.2003, 0.390404, 7200, 0, 0, 641560, 197380, 0),
(376082, 53793, 720, 10, 65535, 0, 0, 457.234, 538.311, 243.298, 4.61484, 7200, 0, 0, 962340, 197380, 0),
(376083, 53793, 720, 10, 65535, 0, 0, 429.384, 532.414, 244.731, 5.4924, 7200, 0, 0, 962340, 197380, 0),
(376084, 53793, 720, 10, 65535, 0, 0, 440.581, 482.341, 243.301, 1.49409, 7200, 0, 0, 962340, 197380, 0),
(376085, 53793, 720, 10, 65535, 0, 0, -60.9619, -293.14, 54.925, 4.8071, 7200, 0, 0, 641560, 197380, 0);
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342468;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 337604;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342375;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342468;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342213;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342308;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 337599;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342185;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342293;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342332;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 342212;
UPDATE `creature` SET `spawnMask` = 15 WHERE `guid` = 373963;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 337604;

REPLACE INTO `game_event_creature` SELECT `guid`,'8' FROM `creature` WHERE `id`=51613;
UPDATE `quest_template` SET `RequiredRaces` = 0 WHERE `entry` = 12531;
DELETE FROM `creature_questrelation` WHERE `quest` = 25316;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 25316;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 25316;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (39865, 25316);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 25316;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 25316;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (40289, 25316);
UPDATE `creature_template` SET `minlevel` = 10, `maxlevel` = 10 WHERE `entry` = 18823;
UPDATE `creature` SET `spawnMask` = 0 WHERE `id` = 22101;
UPDATE `creature` SET `spawnMask` = 0 WHERE `id` IN (25397, 25398, 25399);
DELETE FROM `creature_questrelation` WHERE `quest` = 25069;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 25069;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 25069;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (38922, 25069);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 25069;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 25069;
INSERT INTO `gameobject_involvedrelation` (`id`, `quest`) VALUES (202474, 25069);
DELETE FROM `creature_questrelation` WHERE `quest` = 25566;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 25566;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 25566;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (40109, 25566);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 25566;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 25566;
INSERT INTO `gameobject_involvedrelation` (`id`, `quest`) VALUES (202474, 25566);
DELETE FROM `creature` WHERE `id`=52838;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(293595, 52838, 1, 1, 1, 31605, 0, 4653, -2078.98, 1231.42, 3.44762, 300, 0, 0, 17178400, 473500, 0),
(293611, 52838, 1, 1, 1, 31605, 0, 4417.22, -2080.25, 1210.4, 5.68977, 300, 0, 0, 17178400, 473500, 0),
(293646, 52838, 1, 1, 1, 31605, 0, 5125.25, -1758.53, 1334.55, 3.42085, 300, 0, 0, 17178400, 473500, 0);
DELETE FROM `creature` WHERE `id`=52845;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(293589, 52845, 1, 1, 1, 35095, 0, 4653.62, -2082.89, 1230.56, 3.49066, 300, 0, 0, 42946000, 4735000, 0),
(293612, 52845, 1, 1, 1, 35095, 0, 4420.84, -2076.3, 1210.4, 5.55015, 300, 0, 0, 42946000, 4735000, 0);
DELETE FROM `creature` WHERE `id`=22465;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(60631, 22465, 530, 1, 1, 0, 0, 3014.64, 5458.52, 146.1, 0.898333, 180, 0, 0, 86, 0, 0);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 184405;
UPDATE `creature` SET `phaseMask` = 65535, `position_x` = -29.7461, `position_y` = -62.5811, `position_z` = 57.1725, `orientation` = 3.16261 WHERE `guid` = 341637;
DELETE FROM `creature` WHERE `id`=53694;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(341692, 53694, 720, 15, 65535, 38449, 0, -29.5338, -53.5929, 56.8279, 2.85454, 604800, 0, 0, 7901028, 0, 0);
DELETE FROM `creature` WHERE `id`=53695;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(341716, 53695, 720, 15, 65535, 38450, 0, -30.7631, -69.0932, 57.0759, 2.9996, 604800, 0, 0, 7901028, 0, 0);
DELETE FROM `creature_movement` WHERE `id`=341692;
DELETE FROM `creature_movement` WHERE `id`=341716;
DELETE FROM `creature_movement` WHERE `id`=341637;
INSERT INTO `creature_movement` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`) VALUES
(341637, 1, -60.8271, -57.8747, 57.5443, 2.99241),
(341637, 2, -52.9406, -26.92, 56.9163, 1.20028),
(341637, 3, -45.7467, 1.81121, 56.18, 1.30657),
(341637, 4, -35.4741, 39.7676, 56.0453, 1.31107),
(341637, 5, -25.51, 73.3006, 56.623, 1.09394),
(341637, 6, -0.887647, 112.145, 53.1511, 0.98441),
(341637, 7, 7.08702, 128.382, 51.3349, 1.11941),
(341637, 8, 12.3615, 154.522, 45.4759, 1.48391),
(341637, 9, 14.3915, 177.828, 46.221, 1.48391),
(341637, 10, -9.30758, 200.478, 47.6974, 2.50654),
(341637, 11, -37.514, 190.16, 46.9819, 3.49229),
(341637, 12, -70.0809, 176.872, 44.8304, 3.44842),
(341637, 13, -110.644, 186.577, 46.0396, 2.68566),
(341637, 14, -141.743, 194.066, 46.1569, 2.99617),
(341637, 15, -184.277, 171.893, 46.6047, 3.66216),
(341637, 16, -214.042, 153.131, 47.7112, 3.84441),
(341637, 17, -237.377, 133.364, 49.2368, 3.84441),
(341637, 18, -247.484, 94.8853, 47.1096, 4.26115),
(341637, 19, -286.558, 73.3914, 46.1589, 3.60141),
(341637, 20, -318.091, 64.9672, 46.1589, 3.2794),
(341637, 21, -313.36, 28.4864, 46.1589, 5.08581),
(341637, 22, -305.467, -1.96577, 46.1577, 4.65777),
(341637, 23, -319.892, -48.1874, 46.1577, 4.55567),
(341637, 24, -306.657, -75.3232, 46.1577, 5.1997),
(341637, 25, -286.002, -122.424, 45.1147, 5.20755),
(341637, 26, -276.656, -135.714, 46.3301, 5.31358),
(341637, 27, -260.324, -157.115, 52.8896, 5.36856),
(341637, 28, -242.202, -177.663, 53.8598, 5.48637),
(341637, 29, -220.287, -200.085, 54.4089, 5.48637),
(341637, 30, -199.595, -223.611, 54.6031, 5.4039),
(341637, 31, -176.06, -240.152, 55.7363, 6.24035),
(341637, 32, -145.848, -224.246, 57.1218, 0.699364),
(341637, 33, -123.659, -206.313, 57.1177, 0.640459),
(341637, 34, -112.98, -171.846, 56.8274, 1.51225),
(341637, 35, -101.017, -141.828, 55.6541, 0.962472),
(341637, 36, -76.2261, -113.641, 56.9193, 0.954618),
(341637, 37, -61.9035, -68.2799, 57.5244, 1.33554);
REPLACE INTO `creature_linking_template` (`entry`, `map`, `master_entry`, `flag`, `search_range`) VALUES
('16697','532','15689','4112','0'),
('17367','532','15689','4112','0'),
('17368','532','15689','4112','0'),
('17369','532','15689','4112','0');
DELETE FROM `creature_questrelation` WHERE `quest` = 27517;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 27517;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 27517;
INSERT INTO `gameobject_questrelation` (`id`, `quest`) VALUES (205540, 27517);
UPDATE `item_template` SET `startquest`=27517 WHERE `entry` = 61322;
DELETE FROM `creature_involvedrelation` WHERE `quest` = 27517;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 27517;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (45296, 27517);
UPDATE `quest_template` SET `QuestFlags` = 136 WHERE `entry` = 27517;
DELETE FROM `creature` WHERE `id`=34307;

# Ulduar
REPLACE INTO `creature_linking_template` (`entry`, `map`, `master_entry`, `flag`, `search_range`) VALUES
('53694','720','53691','551','0'),
('53695','720','53691','551','0');

UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 63982;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 64023;
DELETE FROM `creature` WHERE `id`=33941;
DELETE FROM `creature` WHERE `id`=33933;
DELETE FROM `creature` WHERE `id`=34094;
DELETE FROM `creature` WHERE `id`=34095;
DELETE FROM `creature` WHERE `id`=33937;
DELETE FROM `creature` WHERE `id`=40210;
DELETE FROM `creature` WHERE `id`=52540;
DELETE FROM `creature` WHERE `id`=33938;
DELETE FROM `creature` WHERE `id`=40205;
DELETE FROM `creature` WHERE `id`=52534;
DELETE FROM `creature` WHERE `id`=40922;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(300534, 40922, 1, 1, 1, 25191, 0, 4582.76, -4272.38, 902.86, 2.70129, 300, 0, 0, 74374, 0, 0);
UPDATE `quest_template` SET `NextQuestId` = 29598, `NextQuestInChain` = 29598 WHERE `entry` = 10282;
UPDATE `quest_template` SET `NextQuestId` = 29599 WHERE `entry` = 29598;
UPDATE `quest_template` SET `PrevQuestId` = 29599 WHERE `entry` = 10285;

DELETE FROM `creature_questrelation` WHERE `quest` = 10277;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 10277;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 10277;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (20130, 10277);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 10277;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 10277;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (20130, 10277);
DELETE FROM `creature_questrelation` WHERE `quest` = 10282;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 10282;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 10282;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (20130, 10282);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 10282;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 10282;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (18723, 10282);
DELETE FROM `creature_questrelation` WHERE `quest` = 10283;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 10283;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 10283;
DELETE FROM `creature_involvedrelation` WHERE `quest` = 10283;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 10283;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (17876, 10283);
DELETE FROM `creature_questrelation` WHERE `quest` = 29598;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 29598;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 29598;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (18723, 29598);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 29598;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 29598;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (17876, 29598);
DELETE FROM `creature_questrelation` WHERE `quest` = 29599;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 29599;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 29599;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (17876, 29599);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 29599;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 29599;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (18723, 29599);
UPDATE `quest_template` SET `QuestFlags` = 136 WHERE `entry` = 10285;
UPDATE `quest_template` SET `NextQuestId` = 0 WHERE `entry` = 8279;

# Ulduar
UPDATE `gameobject` SET `state` = 1 WHERE `guid` = 188806;

UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 44791;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 44792;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 197994;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 59652;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 65752;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 276817;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 256259;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 43653;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 175868;
DELETE FROM `creature` WHERE `id`=14277;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(176400, 14277, 0, 1, 1, 11260, 0, -1003.78, -811.744, 14.3696, 5.98016, 28800, 3, 0, 694, 20355, 1);
DELETE FROM `creature` WHERE `id`=1657;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(194144, 1657, 0, 1, 1, 11399, 0, 2815.8, 821.38, 113.084, 1.44862, 300, 3, 0, 216, 178, 1);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 1535;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 45762;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 45280;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 187699;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 312182;
DELETE FROM `creature_questrelation` WHERE `quest` = 12637;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 12637;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 12637;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (28518, 12637);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 12637;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 12637;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (28518, 12637);
UPDATE `creature_template_addon` SET auras=NULL WHERE entry IN (2080);
DELETE FROM `creature_addon` WHERE (`guid`=276656);
DELETE FROM `creature_addon` WHERE (`guid`=276681);
UPDATE `quest_template` SET `ExclusiveGroup` = 26235 WHERE `entry` IN (26235,26227,26226,26220,26233,26234,29362,29363,29358,29364,29365,29332,29334,29315,29360,29333);
UPDATE `quest_template` SET `ExclusiveGroup` = 26572 WHERE `entry` IN (26572,26557,26556,26588,26543,29354,29349,29346,29348,29345,29317,29361,29320,29319,29322);
UPDATE `quest_template` SET `PrevQuestId` = 27372 WHERE `entry` = 27555;
UPDATE `quest_template` SET `PrevQuestId` = 27368 WHERE `entry` = 27556;
UPDATE `quest_template` SET `PrevQuestId` = 27371 WHERE `entry` = 27557;
UPDATE `quest_template` SET `PrevQuestId` = 27390 WHERE `entry` = 27558;
UPDATE `quest_template` SET `PrevQuestId` = 27449 WHERE `entry` = 27559;
UPDATE `quest_template` SET `PrevQuestId` = 27448 WHERE `entry` = 27560;
UPDATE `quest_template` SET `PrevQuestId` = 27457 WHERE `entry` = 27561;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 42387;

DELETE FROM `creature` WHERE `map`=720 AND `id` IN (53158, 53986, 53089, 53896, 53369, 53554, 53541, 53520, 53375, 53734, 53693, 53698, 53372, 53898, 53784, 53487, 53787, 54020, 35592);
UPDATE `creature` SET `spawnmask`=0 WHERE `map`=720 AND `id` IN (54019, 54015, 53786, 53791, 53795, 53793, 53914, 53794, 53789, 341088, 53900, 53680, 53792);
UPDATE `creature` SET `spawnmask`=15, `position_x`=10.62, `position_y`=-317.29, `position_z`=58.0, `orientation`=2.41 WHERE `id`=52530;
UPDATE `creature_addon` SET `bytes1`=0, `auras`='100712 99905 99595' WHERE `guid`=337598;
UPDATE `creature_template_addon` SET `bytes1`=0, `auras`='100712 99905 99595' WHERE `entry` IN (52530, 54044, 54045, 54046);
UPDATE `creature_template_addon` SET `auras`='98462' WHERE `entry`=53158;
UPDATE `creature_template` SET `Inhabittype`=7 WHERE `entry` IN (53158, 53554, 53541, 53698);
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=53554;
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=53541;
UPDATE `creature_template_addon` SET `auras`='' WHERE `entry`=53698;

UPDATE `gameobject_template` SET `flags` = 0 WHERE `entry` = 191349;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` IN (46878,50496,42681,46880,46877,46879,45027);
UPDATE `creature` SET `spawnMask` = 0, `phaseMask` = 1 WHERE `guid` = 13308;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 51139;
DELETE FROM `creature` WHERE `id`=10096;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(322264, 10096, 230, 1, 1, 9329, 0, 620.146, -206.206, -52.9641, 2.62262, 43200, 0, 0, 10670, 0, 2);
DELETE FROM `creature` WHERE `id`=9526;
DELETE FROM `fishing_loot_template` WHERE (`entry`=8) AND (`item`=16970);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (8, 16970, -12.8171, 0, 1, 1);
DELETE FROM `fishing_loot_template` WHERE (`entry`=405) AND (`item`=16968);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (405, 16968, -17.6985, 0, 1, 1);
DELETE FROM `fishing_loot_template` WHERE (`entry`=5287) AND (`item`=16969);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (5287, 16969, -0.1212, 0, 1, 1);
DELETE FROM `fishing_loot_template` WHERE (`entry`=5339) AND (`item`=16969);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (5339, 16969, -0.2253, 0, 1, 1);
REPLACE INTO `game_event_gameobject` SELECT `guid`,'2' FROM `gameobject` WHERE `id` in (187235,187567,185582,187194,180654);
REPLACE INTO `game_event_creature` SELECT `guid`,'7' FROM `creature` WHERE `id`=22229;
REPLACE INTO `game_event_creature` SELECT `guid`,'8' FROM `creature` WHERE `id`=22239;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'75' FROM `gameobject` WHERE `id` in (209114,209115);
DELETE FROM `creature` WHERE `id`=52389;
DELETE FROM `creature_questrelation` WHERE `quest` = 9410;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 9410;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 9410;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (16574, 9410);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 9410;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 9410;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (16845, 9410);
UPDATE `gameobject` SET `position_x` = -9978.9, `position_y` = 1006.32, `position_z` = 30.4318 WHERE `guid` = 165990;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'9' FROM `gameobject` WHERE `id` in (113768,113769,113770,113771,113772);
DELETE FROM `creature` WHERE `id`=29296;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(102561, 29296, 0, 1, 1, 0, 0, -8432.93, 1319.45, 6.70441, 3.03687, 300, 0, 0, 955, 0, 2);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 43388;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 44855;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 14715;
UPDATE `quest_template` SET `RequiredRaces` = 0 WHERE `entry` IN (10204,10341,10202);
DELETE FROM `fishing_loot_template` WHERE (`entry`=1537) AND (`item`=69932);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (1537, 69932, -0.5, 0, 1, 1);
DELETE FROM `fishing_loot_template` WHERE (`entry`=1537) AND (`item`=69933);
INSERT INTO `fishing_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`) VALUES (1537, 69933, -1.5, 0, 1, 1);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(217608, 207125, 0, 1, 1, -8399.39, -2788.58, 194.798, 0.523598, 0, 0, 0, 1, 120, 255, 1);
UPDATE `item_template` SET `bonding` = 0 WHERE `entry` = 44794;
UPDATE `quest_template` SET `RequiredClasses` = 16 WHERE `entry` = 28478;
DELETE FROM `npc_vendor` WHERE (`entry`=27806) AND (`item`=37488);
DELETE FROM `npc_vendor` WHERE (`entry`=27810) AND (`item`=37489);
DELETE FROM `npc_vendor` WHERE (`entry`=27811) AND (`item`=37490);
DELETE FROM `npc_vendor` WHERE (`entry`=27812) AND (`item`=37491);
DELETE FROM `npc_vendor` WHERE (`entry`=27813) AND (`item`=37492);
DELETE FROM `npc_vendor` WHERE (`entry`=27814) AND (`item`=37493);
DELETE FROM `npc_vendor` WHERE (`entry`=27815) AND (`item`=37494);
DELETE FROM `npc_vendor` WHERE (`entry`=27816) AND (`item`=37495);
DELETE FROM `npc_vendor` WHERE (`entry`=27817) AND (`item`=37496);
DELETE FROM `npc_vendor` WHERE (`entry`=27818) AND (`item`=37497);
DELETE FROM `npc_vendor` WHERE (`entry`=27819) AND (`item`=37498);
DELETE FROM `npc_vendor` WHERE (`entry`=27820) AND (`item`=37499);
DELETE FROM `creature` WHERE `id`=43352;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(167383, 43352, 0, 1, 1, 33321, 0, -5403.03, -1041.91, 390.959, 3.38225, 300, 0, 0, 92853, 0, 2);
UPDATE `creature` SET `spawnMask` = 0 WHERE `id` = 6866;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 180637;
UPDATE `gameobject` SET `phaseMask` = 1, `spawntimesecs` = -900 WHERE `guid` = 22541;
UPDATE `gameobject` SET `spawntimesecs` = -300 WHERE `guid` = 161077;
DELETE FROM spell_loot_template WHERE entry=109947 AND item=71810;
DELETE FROM spell_loot_template WHERE entry=109947 AND item=71807;
DELETE FROM spell_loot_template WHERE entry=109947 AND item=71806;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` = 43900;

DELETE FROM `gameobject` WHERE `id`=196475;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(184343, 196475, 1, 1, 1, 2576.74, -5907.77, 93.9106, 6.24828, 0, 0, -0.0174522, 0.999848, -300, 255, 1);
UPDATE `creature` SET `spawnMask` = 0 WHERE `id` = 36156;
UPDATE `creature` SET `spawnMask` = 0 WHERE `id` = 36157;
DELETE FROM `creature` WHERE `id`=3520;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(6312, 3520, 0, 1, 1, 0, 0, -8656.06, 677.202, 108.141, 5.41554, 600, 0, 0, 55, 0, 2);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 184846;
DELETE FROM `creature_loot_template` WHERE (`item`=49426);
UPDATE creature_loot_template SET ChanceOrQuestChance=-ABS(ChanceOrQuestChance) WHERE item = 48857;
UPDATE creature_loot_template SET ChanceOrQuestChance=-ABS(ChanceOrQuestChance) WHERE item = 48943;
DELETE FROM `creature_questrelation` WHERE `quest` = 26896;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 26896;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 26896;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (44374, 26896);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 26896;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 26896;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (39034, 26896);
UPDATE `creature_template_addon` SET auras=NULL WHERE entry IN (53243);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` IN (43222,52907,43247,651,653,650,649,652,648);
UPDATE `gameobject_template` SET `data1`=20 WHERE `entry`=300222;
DELETE FROM `creature` WHERE `id`=22914;
INSERT INTO `creature` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawndist`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`) VALUES
(318126, 22914, 530, 1, 1, 19315, 0, -1893.72, 5156.19, -39.7882, 0.392672, 300, 0, 0, 40, 120, 0);
DELETE FROM `creature_loot_template` WHERE `item`=20310;
DELETE FROM `creature_loot_template` WHERE `item`=30436;
DELETE FROM `creature_loot_template` WHERE `item`=30437;
UPDATE `gameobject` SET `spawntimesecs` = -600 WHERE `id` = 2554;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 188982;
UPDATE `creature` SET `spawnMask` = 0 WHERE `guid` = 188981;
DELETE FROM `gameobject` WHERE `id`=184691;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`spawnMask`,`phaseMask`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`) VALUES
(217609, 184691, 530, 1, 1, -2506.16, 1087.25, 63.3567, 0.691934, 0, 0, 0.339106, 0.940748, 600, 100, 1),
(217610, 184691, 530, 1, 1, -2682.68, 1485.94, 23.9594, 2.9873, 0, 0, 0.997026, 0.0770677, 600, 100, 1),
(217611, 184691, 530, 1, 1, -2717.63, 1501.52, 11.6948, 4.00597, 0, 0, 0.908052, -0.418857, 600, 100, 1),
(217612, 184691, 530, 1, 1, -2650.07, 1381.24, 88.7094, 3.44519, 0, 0, 0.988501, -0.151217, 600, 100, 1),
(217613, 184691, 530, 1, 1, -2709.49, 1531.09, 22.2107, 5.4896, 0, 0, 0.386462, -0.922305, 600, 100, 1),
(217614, 184691, 530, 1, 1, -2780.45, 1536.37, 7.80505, 2.90721, 0, 0, 0.993141, 0.116923, 600, 100, 1),
(217615, 184691, 530, 1, 1, -2608.64, 1418.05, 73.4127, 3.65411, 0, 0, 0.967345, -0.253462, 600, 100, 1),
(217616, 184691, 530, 1, 1, -2796.47, 1446.46, 7.05808, 3.74444, 0, 0, 0.954914, -0.296881, 600, 100, 1),
(217617, 184691, 530, 1, 1, -2678.28, 1535.78, 7.53246, 3.70439, 0, 0, 0.960668, -0.277698, 600, 100, 1),
(217618, 184691, 530, 1, 1, -2625.17, 1321.74, 86.3524, 4.4568, 0, 0, 0.79146, -0.611221, 600, 100, 1),
(217619, 184691, 530, 1, 1, -2564.21, 1262.88, 81.8769, 4.81965, 0, 0, 0.668185, -0.743995, 600, 100, 1),
(217620, 184691, 530, 1, 1, -2561.77, 1167.14, 77.1197, 4.12379, 0, 0, 0.881815, -0.471595, 600, 100, 1),
(217621, 184691, 530, 1, 1, -2534.43, 1373.09, 81.3293, 3.08706, 0, 0, 0.999628, 0.0272609, 600, 100, 1);
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES 
(376086, 57770, 0, 1, 1, 0, 57770, -11158.9, -2141.06, 62.3149, 5.91476, 300, 0, 0, 116235, 8908, 0);
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES 
(312119, 57770, 0, 1, 1, 39799, 0, -1387.91, 1235.23, 35.643, 3.75246, 300, 0, 0, 116235, 17816, 0);
DELETE FROM `creature` WHERE `id`=57910;
INSERT IGNORE INTO `creature` (`guid`, `id`, `map`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`) VALUES 
(376087, 57910, 0, 1, 1, 0, 0, -11378.5, -2185.35, 23.0363, 6.27491, 300, 0, 0, 3054578, 0, 0);
REPLACE INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `quest_start`) VALUES 
(58039, 109940, 0, 0);
UPDATE `gameobject` SET `spawntimesecs` = -300 WHERE `guid` = 184102;
UPDATE `creature_template` SET `InhabitType` = 5 WHERE `entry` = 34982;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 188611;
DELETE FROM `gameobject_loot_template` WHERE (`entry`=202947) AND (`item`=49354);
UPDATE `creature` SET `modelid` = 0 WHERE `id` = 299;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` IN (52779,52781,52777,52782,52778,52780,52787,52729,52700);
UPDATE `creature` SET `modelid` = 0 WHERE `guid` = 302345;
UPDATE `creature` SET `modelid` = 0 WHERE `guid` = 375106;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'8' FROM `gameobject` WHERE `id`=202947;
REPLACE INTO `game_event_gameobject` SELECT `guid`,'8' FROM `gameobject` WHERE `id`=202948;
DELETE FROM `creature_questrelation` WHERE `quest` = 28156;
DELETE FROM `gameobject_questrelation` WHERE `quest` = 28156;
UPDATE `item_template` SET `StartQuest`=0 WHERE `StartQuest` = 28156;
INSERT INTO `creature_questrelation` (`id`, `quest`) VALUES (47681, 28156);
DELETE FROM `creature_involvedrelation` WHERE `quest` = 28156;
DELETE FROM `gameobject_involvedrelation` WHERE `quest` = 28156;
INSERT INTO `creature_involvedrelation` (`id`, `quest`) VALUES (47554, 28156);
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `guid` = 276442;
UPDATE `creature` SET `spawndist` = 0, `MovementType` = 0 WHERE `id` IN (51166);
UPDATE `creature_template` SET `InhabitType` = 5 WHERE `entry` = 45239;

UPDATE db_version SET `cache_id`= '725';
UPDATE db_version SET `version`= 'YTDB_0.16.9_R725_cMaNGOS4_R12849_SD2_R3000_ACID_R320_RuDB_R64';
