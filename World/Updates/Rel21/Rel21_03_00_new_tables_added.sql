-- --------------------------------------------------------------------------------
-- This is an attempt to create a full transactional update
-- --------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`; 

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos` ()

BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT structure FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cCurContent := (SELECT content FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '21'; 
    SET @cOldStructure = '02'; 
    SET @cOldContent = '03'; 

    -- New Values
    SET @cNewVersion = '21';
    SET @cNewStructure = '03';
    SET @cNewContent = '00';
                            -- DESCRIPTION IS 30 Characters MAX    
    SET @cNewDescription = 'new tables added';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'new tables added to the World database';

    -- Evaluate all settings
    SET @cCurResult := (SELECT description FROM db_version ORDER BY `version` DESC, STRUCTURE DESC, CONTENT DESC LIMIT 0,1);
    SET @cOldResult := (SELECT description FROM db_version WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @cOldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;

        -- UPDATE THE DB VERSION
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
        SET @cNewResult := (SELECT description FROM db_version WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
  

-- This update adds new tables to the World database

-- total World database tables
-- 158 tables in Dev21
-- 149 tables in Master

-- creature_template_classlevelstats
-- custom_texts
-- dungeonfinder_item_rewards
-- dungeonfinder_requirements
-- dungeonfinder_rewards
-- gossip_texts
-- script_binding (already implemented via previous updates)
-- warden_build_specific
-- warden_checks



--
-- creature_template_classlevelstats
--

DROP TABLE IF EXISTS `creature_template_classlevelstats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creature_template_classlevelstats` (
  `Level` tinyint(4) NOT NULL,
  `Class` tinyint(4) NOT NULL,
  `BaseHealthExp0` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BaseHealthExp1` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BaseHealthExp2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BaseHealthExp3` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BaseMana` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BaseDamageExp0` float NOT NULL DEFAULT '0',
  `BaseDamageExp1` float NOT NULL DEFAULT '0',
  `BaseDamageExp2` float NOT NULL DEFAULT '0',
  `BaseDamageExp3` float NOT NULL DEFAULT '0',
  `BaseMeleeAttackPower` float NOT NULL DEFAULT '0',
  `BaseRangedAttackPower` float NOT NULL DEFAULT '0',
  `BaseArmor` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Level`,`Class`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creature_template_classlevelstats`
--

INSERT INTO `creature_template_classlevelstats` (`Level`, `Class`, `BaseHealthExp0`, `BaseHealthExp1`, `BaseHealthExp2`, `BaseHealthExp3`, `BaseMana`, `BaseDamageExp0`, `BaseDamageExp1`, `BaseDamageExp2`, `BaseDamageExp3`, `BaseMeleeAttackPower`, `BaseRangedAttackPower`, `BaseArmor`) VALUES
(1,1,42,1,1,1,0,0.0607,0,0,0,10,1,8),
(2,1,55,1,1,1,0,0.3603,0,0,0,10,1,20),
(3,1,71,1,1,1,0,0.6976,0,0,0,11,1,33),
(4,1,86,1,1,1,0,1.0863,0,0,0,13,1,68),
(5,1,102,1,1,1,0,1.4422,0,0,0,17,1,111),
(6,1,120,1,1,1,0,2.1375,0,0,0,19,1,165),
(7,1,137,1,1,1,0,2.9811,0,0,0,21,1,230),
(8,1,156,1,1,1,0,3.485,0,0,0,24,1,306),
(9,1,176,1,1,1,0,3.0304,0,0,0,28,1,387),
(10,1,198,1,1,1,0,3.2707,0,0,0,32,1,463),
(11,1,222,1,1,1,0,4.8425,0,0,0,36,1,528),
(12,1,247,1,1,1,0,5.603,0,0,0,40,1,562),
(13,1,273,1,1,1,0,6.0787,0,0,0,44,1,596),
(14,1,300,1,1,1,0,6.6101,0,0,0,50,1,630),
(15,1,328,1,1,1,0,7.1981,0,0,0,54,2,665),
(16,1,356,1,1,1,0,7.7861,0,0,0,56,2,700),
(17,1,386,1,1,1,0,8.3741,0,0,0,60,2,734),
(18,1,417,1,1,1,0,8.9621,0,0,0,64,3,768),
(19,1,449,1,1,1,0,9.5501,0,0,0,68,3,802),
(20,1,484,1,1,1,0,10.1381,0,0,0,70,4,836),
(21,1,521,1,1,1,0,10.7261,0,0,0,74,4,872),
(22,1,562,1,1,1,0,11.3141,0,0,0,78,4,906),
(23,1,605,1,1,1,0,11.9021,0,0,0,80,5,940),
(24,1,651,1,1,1,0,12.4901,0,0,0,84,6,975),
(25,1,699,1,1,1,0,13.0781,0,0,0,86,6,1008),
(26,1,750,1,1,1,0,13.6661,0,0,0,90,7,1043),
(27,1,800,1,1,1,0,14.2541,0,0,0,92,7,1078),
(28,1,853,1,1,1,0,14.8421,0,0,0,96,8,1111),
(29,1,905,1,1,1,0,15.4301,0,0,0,100,8,1145),
(30,1,955,1,1,1,0,16.0181,0,0,0,102,9,1179),
(31,1,1006,1,1,1,0,16.6061,0,0,0,106,9,1213),
(32,1,1057,1,1,1,0,17.1941,0,0,0,108,10,1249),
(33,1,1110,1,1,1,0,17.7821,0,0,0,112,10,1281),
(34,1,1163,1,1,1,0,18.3701,0,0,0,114,11,1317),
(35,1,1220,1,1,1,0,18.9581,0,0,0,118,11,1349),
(36,1,1277,1,1,1,0,19.5461,0,0,0,120,12,1456),
(37,1,1336,1,1,1,0,20.1341,0,0,0,124,12,1568),
(38,1,1395,1,1,1,0,20.7221,0,0,0,128,13,1684),
(39,1,1459,1,1,1,0,21.3101,0,0,0,132,13,1808),
(40,1,1524,1,1,1,0,21.8981,0,0,0,136,14,1938),
(41,1,1585,1,1,1,0,22.4861,0,0,0,142,15,2074),
(42,1,1651,1,1,1,0,23.0741,0,0,0,152,15,2218),
(43,1,1716,1,1,1,0,23.6621,0,0,0,162,16,2369),
(44,1,1782,1,1,1,0,24.2501,0,0,0,174,16,2528),
(45,1,1848,1,1,1,0,24.8381,0,0,0,184,17,2695),
(46,1,1919,1,1,1,0,25.4261,0,0,0,188,17,2750),
(47,1,1990,1,1,1,0,26.0141,0,0,0,192,18,2804),
(48,1,2062,1,1,1,0,26.6021,0,0,0,196,19,2857),
(49,1,2138,1,1,1,0,27.1901,0,0,0,200,19,2912),
(50,1,2215,1,1,1,0,27.7781,0,0,0,206,20,2966),
(51,1,2292,1,1,1,0,28.3661,0,0,0,210,20,3018),
(52,1,2371,1,1,1,0,28.9541,0,0,0,214,21,3060),
(53,1,2453,1,1,1,0,29.5421,0,0,0,218,22,3128),
(54,1,2533,1,1,1,0,30.1301,0,0,0,224,22,3180),
(55,1,2614,1,1,1,0,30.7177,0,0,0,228,23,3234),
(56,1,2699,1,1,1,0,31.3057,0,0,0,234,23,3289),
(57,1,2784,1,1,1,0,31.8937,42.1353,0,0,238,24,3342),
(58,1,2871,3989,1,1,0,32.4817,46.9207,0,0,242,25,3396),
(59,1,2961,4142,1,1,0,33.0697,51.7061,0,0,248,25,3449),
(60,1,3052,4979,1,1,0,33.6577,56.4915,0,0,252,26,3750),
(61,1,3144,5158,1,1,0,34.2457,61.2769,0,0,258,28,4047),
(62,1,3237,5341,1,1,0,34.8337,66.0623,0,0,262,30,4344),
(63,1,3331,5527,1,1,0,35.4217,70.8477,0,0,268,32,4641),
(64,1,3427,5715,1,1,0,36.0097,75.6331,0,0,272,33,4937),
(65,1,3524,5914,1,1,0,36.5977,80.4185,0,0,278,35,5234),
(66,1,3624,6116,1,1,0,37.1857,85.2039,0,0,282,37,5531),
(67,1,3728,6326,1,1,0,37.7737,89.9893,111.174,0,288,39,5829),
(68,1,3834,6542,6986,1,0,38.3617,94.7747,115.224,0,292,41,6126),
(69,1,3942,6761,7984,1,0,38.9497,99.5601,119.274,0,298,43,6423),
(70,1,4050,6986,8982,1,0,39.5377,104.346,123.324,0,304,44,6719),
(71,1,4163,7181,9291,1,0,40.1257,109.131,127.374,0,308,48,7018),
(72,1,4278,7380,9610,1,0,40.7137,113.916,131.424,0,314,53,7318),
(73,1,4399,7588,9940,19880,0,41.3017,118.702,135.474,0,320,58,7618),
(74,1,4524,7804,10282,1,0,41.8897,0,139.524,0,354,63,7918),
(75,1,4652,8025,10635,1,0,42.4777,0,143.574,0,392,68,8219),
(76,1,4781,8247,11001,22002,0,43.0657,0,147.624,0,432,74,8520),
(77,1,4916,8480,11379,22758,0,43.6537,0,151.674,0,478,81,8822),
(78,1,5052,8715,11770,1,0,44.2417,0,155.724,0,528,88,9124),
(79,1,5194,8960,12175,1,0,44.8297,0,160.258,0,582,95,9426),
(80,1,5342,9215,12600,30951,0,45.4177,0,164.924,197.377,642,103,9729),
(81,1,5492,9474,13033,37187,0,46.0057,0,168.974,197.377,708,112,10033),
(82,1,5647,9741,13481,44679,0,46.5937,0,173.024,197.377,782,121,10356),
(83,1,5808,10019,13945,53681,0,47.1817,0,177.074,197.377,805,135,10673),
(84,1,5971,10300,1,64496,0,54.2634,0,0,197.377,867,151,10930),
(85,1,6141,10595,1,77490,0,54.2634,0,0,197.377,867,151,12720),
(1,2,41,1,1,1,60,0.746,0,0,0,1,1,7),
(2,2,54,1,1,1,69,0.7365,0,0,0,3,1,19),
(3,2,69,1,1,1,79,0.6984,0,0,0,7,1,33),
(4,2,83,1,1,1,104,1.2138,0,0,0,18,1,66),
(5,2,98,1,1,1,115,1.8471,0,0,0,19,1,109),
(6,2,115,1,1,1,126,2.6006,0,0,0,24,1,163),
(7,2,131,1,1,1,138,3.5412,0,0,0,28,1,208),
(8,2,148,1,1,1,165,4.1435,0,0,0,32,1,303),
(9,2,166,1,1,1,178,4.7933,0,0,0,36,1,369),
(10,2,186,1,1,1,191,5.066,0,0,0,38,1,460),
(11,2,208,1,1,1,205,5.3387,0,0,0,40,1,526),
(12,2,230,1,1,1,249,5.6114,0,0,0,42,1,560),
(13,2,253,1,1,1,264,5.8841,0,0,0,44,1,596),
(14,2,276,1,1,1,295,6.1568,0,0,0,46,1,630),
(15,2,301,1,1,1,326,6.8211,0,0,0,48,2,665),
(16,2,325,1,1,1,357,7.1374,0,0,0,52,2,700),
(17,2,350,1,1,1,390,7.6355,0,0,0,56,2,734),
(18,2,377,1,1,1,408,8.1353,0,0,0,58,3,768),
(19,2,404,1,1,1,456,8.6351,0,0,0,60,3,802),
(20,2,433,1,1,1,490,9.0674,0,0,0,64,4,836),
(21,2,464,1,1,1,510,9.3169,0,0,0,68,4,872),
(22,2,498,1,1,1,545,9.7231,0,0,0,72,5,906),
(23,2,533,1,1,1,581,10.0761,0,0,0,74,5,940),
(24,2,571,1,1,1,618,10.4619,0,0,0,78,6,975),
(25,2,610,1,1,1,655,10.8234,0,0,0,80,6,1008),
(26,2,651,1,1,1,693,11.185,0,0,0,84,6,1042),
(27,2,690,1,1,1,732,11.7126,0,0,0,86,7,1078),
(28,2,732,1,1,1,756,11.9663,0,0,0,90,7,1110),
(29,2,773,1,1,1,811,12.352,0,0,0,94,8,1145),
(30,2,811,1,1,1,852,13.0007,0,0,0,94,8,1178),
(31,2,850,1006,1,1,878,13.2348,0,0,0,98,9,1213),
(32,2,888,1,1,1,935,13.6924,0,0,0,100,9,1248),
(33,2,928,1,1,1,963,13.9511,0,0,0,104,10,1281),
(34,2,967,1,1,1,1007,14.4142,0,0,0,106,10,1316),
(35,2,1009,1,1,1,1067,14.7365,0,0,0,110,11,1349),
(36,2,1050,1,1,1,1097,15.1346,0,0,0,112,11,1455),
(37,2,1093,1,1,1,1142,15.5816,0,0,0,116,11,1567),
(38,2,1135,1,1,1,1189,15.9286,0,0,0,120,12,1683),
(39,2,1180,1,1,1,1236,16.4168,0,0,0,124,12,1807),
(40,2,1226,1,1,1,1283,16.9294,0,0,0,128,13,1937),
(41,2,1268,1,1,1,1332,17.8592,0,0,0,132,13,2072),
(42,2,1321,1,1,1,1381,18.8825,0,0,0,142,15,2216),
(43,2,1373,1,1,1,1432,20.1126,0,0,0,152,14,2367),
(44,2,1426,1,1,1,1483,21.6981,0,0,0,166,15,2527),
(45,2,1478,1,1,1,1534,22.9018,0,0,0,172,15,2692),
(46,2,1535,1,1,1,1587,23.345,0,0,0,176,16,2749),
(47,2,1592,1,1,1,1640,23.9542,0,0,0,180,16,2802),
(48,2,1650,1,1,1,1695,24.401,0,0,0,184,17,2855),
(49,2,1710,1,1,1,1750,24.9975,0,0,0,188,17,2910),
(50,2,1772,1,1,1,1807,25.5204,0,0,0,194,18,2964),
(51,2,1834,1,1,1,1864,26.0047,0,0,0,198,19,3017),
(52,2,1897,1,1,1,1923,26.6877,0,0,0,202,19,3072),
(53,2,1962,1,1,1,1982,27.1912,0,0,0,206,20,3126),
(54,2,2026,1,1,1,2041,27.8506,0,0,0,210,20,3178),
(55,2,2091,1,1,1,2117,28.3834,0,0,0,214,21,3232),
(56,2,2159,1,1,1,2163,28.9161,0,0,0,220,21,3287),
(57,2,2227,1,1,1,2241,29.5702,41.2575,0,0,224,22,3340),
(58,2,2297,3191,1,1,2289,30.1469,45.5251,0,0,228,23,3394),
(59,2,2369,3314,1,1,2369,30.7656,49.7927,0,0,234,23,3447),
(60,2,2442,3984,1,1,2434,31.3842,54.0603,0,0,238,24,3748),
(61,2,2515,4126,5776,1,2486,31.9807,58.3279,0,0,244,25,4044),
(62,2,2590,4274,1,1,2568,32.5772,62.4676,0,0,246,26,4340),
(63,2,2665,4422,1,1,2620,33.1737,66.121,0,0,252,26,4637),
(64,2,2740,4572,1,1,2705,33.7702,70.2568,0,0,256,27,4933),
(65,2,2819,4731,1,1,2790,34.3667,74.3252,0,0,262,29,5228),
(66,2,2899,4892,6116,1,2846,34.9632,78.472,0,0,266,29,5523),
(67,2,2982,5060,1,1,2933,35.5597,82.7944,110.698,0,272,31,5821),
(68,2,3067,5233,6986,1,2991,36.1562,87.2676,114.869,0,276,31,6116),
(69,2,3153,5409,7984,1,3080,36.7527,91.8915,119.04,0,282,32,6412),
(70,2,3240,5589,8982,1,3155,37.3492,96.7365,123.212,0,286,33,6708),
(71,2,3330,5744,9291,1,3231,37.9457,101.004,127.383,0,290,37,7007),
(72,2,3422,5903,9610,1,3309,38.5422,105.272,131.092,0,296,40,7305),
(73,2,3519,6070,9940,19880,3387,39.1387,109.539,134.908,0,302,44,7604),
(74,2,3619,6243,10282,1,3466,39.7352,0,138.836,0,334,48,7903),
(75,2,3722,6420,10635,1,3561,40.3317,0,142.878,0,370,53,8204),
(76,2,3825,6602,11001,1,3643,40.9282,0,147.038,0,408,57,8503),
(77,2,3933,6784,11379,1,3725,41.5247,0,151.319,0,452,62,8803),
(78,2,4042,6972,11770,1,3809,42.1212,0,155.724,0,500,68,9104),
(79,2,4155,7167,12175,1,3893,42.7177,0,160.258,0,550,74,9405),
(80,2,4274,7373,12600,30951,3994,43.3142,0,164.924,195.237,608,80,9706),
(81,2,4394,7581,13033,37187,4081,43.9107,0,169.095,195.237,670,86,10007),
(82,2,4518,7794,13481,44679,4169,44.5072,0,173.266,195.237,726,91,10253),
(83,2,4646,1,13945,53681,4258,45.1037,0,177.438,195.237,783,98,10573),
(84,2,1,1,1,64496,4363,50.2143,0,0,195.237,811,106,12122),
(85,2,4913,1,15498,77490,4454,50.2143,0,0,195.237,811,106,12122),
(1,4,42,1,1,1,0,0.25,0,0,0,24,1,6),
(2,4,55,1,1,1,0,0.54,0,0,0,26,1,18),
(3,4,71,1,1,1,0,0.74,0,0,0,28,1,31),
(4,4,86,1,1,1,0,0.9435,0,0,0,30,1,63),
(5,4,102,1,1,1,0,1.5,0,0,0,32,1,102),
(6,4,120,1,1,1,0,2.2,0,0,0,34,1,152),
(7,4,137,1,1,1,0,3,0,0,0,36,1,212),
(8,4,156,1,1,1,0,4.3597,0,0,0,38,1,286),
(9,4,176,1,1,1,0,4.6993,0,0,0,40,1,363),
(10,4,198,1,1,1,0,4.8281,0,0,0,42,1,443),
(11,4,222,1,1,1,0,5.1609,0,0,0,44,1,488),
(12,4,247,1,1,1,0,5.6558,0,0,0,46,1,519),
(13,4,273,1,1,1,0,6.0221,0,0,0,48,1,553),
(14,4,300,1,1,1,0,6.6101,0,0,0,50,1,577),
(15,4,328,1,1,1,0,7.1981,0,0,0,54,2,612),
(16,4,356,1,1,1,0,7.7861,0,0,0,56,2,645),
(17,4,386,1,1,1,0,8.3741,0,0,0,60,2,676),
(18,4,417,1,1,1,0,8.9621,0,0,0,64,3,706),
(19,4,449,1,1,1,0,9.5501,0,0,0,68,3,738),
(20,4,484,1,1,1,0,10.1381,0,0,0,70,4,769),
(21,4,521,1,1,1,0,10.7261,0,0,0,74,4,801),
(22,4,562,1,1,1,0,11.3141,0,0,0,78,4,833),
(23,4,605,1,1,1,0,11.9021,0,0,0,80,5,863),
(24,4,651,1,1,1,0,12.4901,0,0,0,84,6,895),
(25,4,699,1,1,1,0,13.0781,0,0,0,86,6,926),
(26,4,750,1,1,1,0,13.6661,0,0,0,90,7,957),
(27,4,800,1,1,1,0,14.2541,0,0,0,92,7,989),
(28,4,853,1,1,1,0,14.8421,0,0,0,96,8,1020),
(29,4,905,1,1,1,0,15.4301,0,0,0,100,8,1051),
(30,4,955,1,1,1,0,16.0181,0,0,0,102,9,1082),
(31,4,1006,1,1,1,0,16.6061,0,0,0,106,9,1113),
(32,4,1057,1,1,1,0,17.1941,0,0,0,108,10,1146),
(33,4,1110,1,1,1,0,17.7821,0,0,0,112,10,1173),
(34,4,1163,1,1,1,0,18.3701,0,0,0,114,11,1208),
(35,4,1220,1,1,1,0,18.9581,0,0,0,118,11,1237),
(36,4,1277,1,1,1,0,19.5461,0,0,0,120,12,1349),
(37,4,1336,1,1,1,0,20.1341,0,0,0,124,12,1434),
(38,4,1395,1,1,1,0,20.7221,0,0,0,128,13,1538),
(39,4,1459,1,1,1,0,21.3101,0,0,0,132,13,1649),
(40,4,1524,1,1,1,0,21.8981,0,0,0,136,14,1764),
(41,4,1585,1,1,1,0,22.4861,0,0,0,142,15,1886),
(42,4,1651,1,1,1,0,23.0741,0,0,0,152,15,2015),
(43,4,1716,1,1,1,0,23.6621,0,0,0,162,16,2148),
(44,4,1782,1,1,1,0,24.2501,0,0,0,174,16,2303),
(45,4,1848,1,1,1,0,24.8381,0,0,0,184,17,2436),
(46,4,1919,1,1,1,0,25.4261,0,0,0,188,17,2485),
(47,4,1990,1,1,1,0,26.0141,0,0,0,192,18,2535),
(48,4,2062,1,1,1,0,26.6021,0,0,0,196,19,2582),
(49,4,2138,1,1,1,0,27.1901,0,0,0,200,19,2631),
(50,4,2215,1,1,1,0,27.7781,0,0,0,206,20,2680),
(51,4,2292,1,1,1,0,28.3661,0,0,0,210,20,2728),
(52,4,2371,1,1,1,0,28.9541,0,0,0,214,21,2778),
(53,4,2453,1,1,1,0,29.5421,0,0,0,218,22,2826),
(54,4,2533,1,1,1,0,30.1301,0,0,0,224,22,2874),
(55,4,2614,1,1,1,0,30.7177,0,0,0,228,23,2922),
(56,4,2699,1,1,1,0,31.3057,0,0,0,234,23,2972),
(57,4,2784,1,1,1,0,31.8937,42.1353,0,0,238,24,3020),
(58,4,2871,3989,1,1,0,32.4817,46.9207,0,0,242,25,3068),
(59,4,2961,4142,1,1,0,33.0697,51.7061,0,0,248,25,3117),
(60,4,3052,4979,1,1,0,33.6577,56.4915,0,0,252,26,3388),
(61,4,3144,5158,1,1,0,34.2457,61.2769,0,0,258,28,3655),
(62,4,3237,5341,1,1,0,34.8337,66.0623,0,0,262,30,3922),
(63,4,3331,5527,1,1,0,35.4217,70.8477,0,0,268,32,4189),
(64,4,3427,5715,1,1,0,36.0097,75.6331,0,0,272,33,4457),
(65,4,3524,5914,1,1,0,36.5977,80.4185,0,0,278,35,4724),
(66,4,3624,6116,1,1,0,37.1857,85.2039,0,0,282,37,5104),
(67,4,3728,6326,1,1,0,37.7737,89.9893,111.174,0,288,39,5326),
(68,4,3834,6542,6986,1,0,38.3617,94.7747,115.224,0,292,41,5527),
(69,4,3942,6761,7984,1,0,38.9497,99.5601,119.274,0,298,43,5795),
(70,4,4050,6986,8982,1,0,39.5377,104.346,123.324,0,304,44,6062),
(71,4,4163,7181,9291,1,0,40.1257,109.131,127.374,0,308,48,6332),
(72,4,4278,7380,9610,1,0,40.7137,113.916,131.424,0,314,53,6602),
(73,4,4399,7580,9940,1,0,41.3017,118.702,135.474,0,320,58,6872),
(74,4,4524,1,10282,1,0,41.8897,0,139.524,0,354,63,7143),
(75,4,4652,1,10635,1,0,42.4777,0,143.574,0,392,68,7415),
(76,4,4781,1,11001,1,0,43.0657,0,147.624,0,432,74,7686),
(77,4,4916,1,11379,1,0,43.6537,0,151.674,0,478,81,7958),
(78,4,5052,1,11770,1,0,44.2417,0,155.724,0,528,88,8230),
(79,4,5194,1,12175,1,0,44.8297,0,160.258,0,582,95,8503),
(80,4,5342,1,12600,30951,0,45.4177,0,164.924,191.179,642,103,8776),
(81,4,5496,1,13033,37187,0,46.0057,0,168.974,191.179,708,112,9068),
(82,4,5647,1,13481,44679,0,46.5937,0,173.024,191.179,782,121,9348),
(83,4,5808,1,13945,53681,0,47.1817,0,177.074,191.179,805,135,9589),
(84,4,1,1,1,64496,0,52.2725,0,0,191.179,843,143,12001),
(85,4,1,1,1,77490,0,52.2725,0,0,191.179,843,143,12001),
(1,8,40,1,1,1,120,0.4564,0,0,0,1,10,5),
(2,8,52,1,1,1,147,0.4564,0,0,0,3,10,16),
(3,8,67,1,1,1,174,0.7334,0,0,0,7,10,28),
(4,8,81,1,1,1,202,1.1235,0,0,0,8,11,57),
(5,8,95,1,1,1,230,1.3456,0,0,0,9,11,93),
(6,8,111,1,1,1,259,1.9557,0,0,0,10,11,139),
(7,8,126,1,1,1,289,2.7876,0,0,0,13,11,194),
(8,8,143,1,1,1,319,3.2334,0,0,0,15,11,265),
(9,8,160,1,1,1,350,3.7654,0,0,0,16,11,339),
(10,8,178,1,1,1,382,4.2456,0,0,0,17,12,423),
(11,8,199,1,1,1,459,4.7654,0,0,0,17,12,447),
(12,8,219,1,1,1,537,5.0345,0,0,0,18,12,475),
(13,8,241,1,1,1,601,5.199,0,0,0,19,12,509),
(14,8,263,1,1,1,710,5.7241,0,0,0,21,12,523),
(15,8,285,1,1,1,790,6.3298,0,0,0,22,13,559),
(16,8,307,1,1,1,856,6.6051,0,0,0,24,13,589),
(17,8,330,1,1,1,938,7.0485,0,0,0,26,13,617),
(18,8,354,1,1,1,1020,7.4083,0,0,0,27,13,643),
(19,8,379,1,1,1,1118,7.9334,0,0,0,28,13,674),
(20,8,405,1,1,1,1202,8.3382,0,0,0,30,14,701),
(21,8,432,1,1,1,1272,8.5517,0,0,0,32,14,729),
(22,8,463,1,1,1,1357,8.9102,0,0,0,34,14,759),
(23,8,494,1,1,1,1443,9.228,0,0,0,35,14,786),
(24,8,528,1,1,1,1545,9.6818,0,0,0,36,15,815),
(25,8,562,1,1,1,1633,10.1014,0,0,0,37,15,843),
(26,8,598,1,1,1,1707,10.3246,0,0,0,39,15,871),
(27,8,633,1,1,1,1812,10.804,0,0,0,40,15,900),
(28,8,669,1,1,1,1977,11.0214,0,0,0,42,15,928),
(29,8,704,1,1,1,2068,11.3608,0,0,0,44,16,957),
(30,8,737,1,1,1,2175,11.9607,0,0,0,44,16,984),
(31,8,770,1,1,1,2253,12.16,0,0,0,46,16,1012),
(32,8,802,1,1,1,2362,12.5746,0,0,0,47,16,1042),
(33,8,835,1,1,1,2457,12.7966,0,0,0,49,17,1065),
(34,8,867,1,1,1,2553,13.2162,0,0,0,50,17,1098),
(35,8,902,1,1,1,2680,13.497,0,0,0,52,17,1124),
(36,8,935,1,1,1,2763,13.8566,0,0,0,53,18,1241),
(37,8,970,1,1,1,2861,14.367,0,0,0,54,18,1300),
(38,8,1004,1,1,1,2975,14.6707,0,0,0,56,18,1391),
(39,8,1040,1,1,1,3075,15.1049,0,0,0,58,18,1489),
(40,8,1077,1,1,1,3191,15.5617,0,0,0,60,19,1590),
(41,8,1110,1,1,1,3293,16.4044,0,0,0,62,19,1697),
(42,8,1156,1,1,1,3471,17.3076,0,0,0,67,19,1811),
(43,8,1201,1,1,1,3575,18.5165,0,0,0,71,19,1926),
(44,8,1247,1,1,1,3680,19.9224,0,0,0,78,20,2078),
(45,8,1294,1,1,1,3801,21.0097,0,0,0,81,20,2177),
(46,8,1343,1,1,1,3923,21.4023,0,0,0,83,20,2220),
(47,8,1393,1,1,1,4031,21.9484,0,0,0,85,21,2265),
(48,8,1443,1,1,1,4140,22.3444,0,0,0,87,21,2307),
(49,8,1497,1,1,1,4281,22.8788,0,0,0,89,21,2349),
(50,8,1551,1,1,1,4393,23.4508,0,0,0,91,22,2393),
(51,8,1604,1,1,1,4506,23.8815,0,0,0,93,22,2437),
(52,8,1660,1,1,1,4650,24.4958,0,0,0,95,22,2481),
(53,8,1717,1,1,1,4765,24.9442,0,0,0,97,23,2524),
(54,8,1773,1,1,1,4896,25.5368,0,0,0,99,23,2567),
(55,8,1830,1,1,1,5013,26.079,0,0,0,101,23,2609),
(56,8,1889,1,1,1,5206,26.4791,0,0,0,104,24,2654),
(57,8,1949,1,1,1,5340,27.0667,39.5236,0,0,106,24,2698),
(58,8,2010,2793,1,1,5461,27.6972,43.1021,0,0,107,24,2740),
(59,8,2073,2899,1,1,5598,28.1686,46.5379,0,0,110,25,2784),
(60,8,2136,3484,1,1,5751,28.7983,50.045,0,0,112,25,3025),
(61,8,2201,3611,1,1,5875,29.2976,53.4807,0,0,115,25,3263),
(62,8,2266,3739,1,1,6015,29.7969,57.2713,0,0,116,25,3500),
(63,8,2332,3870,1,1,6156,30.2962,60.577,0,0,119,26,3736),
(64,8,2399,4000,1,1,6299,30.7955,64.3364,0,0,121,26,3977),
(65,8,2467,4140,4731,1,6443,31.2948,68.0244,0,0,124,26,4214),
(66,8,2552,4281,4892,1,6588,31.7941,72.0499,0,0,125,27,4460),
(67,8,2610,4429,5060,1,6749,32.2934,75.9676,87.7106,0,128,27,4710),
(68,8,2684,4580,5588,1,6882,32.7927,79.9198,96.6868,0,130,27,4928),
(69,8,2759,4733,6387,1,7031,33.292,83.8005,105.591,0,133,28,5167),
(70,8,2835,4890,7185,1,7196,33.7913,87.7526,114.496,0,135,28,5404),
(71,8,2914,5027,7432,1,7332,34.2906,91.7048,117.829,0,137,31,5645),
(72,8,2995,5166,7688,1,7500,34.7899,95.5855,121.259,0,140,34,5886),
(73,8,3098,5311,7952,1,7654,35.2892,99.4662,124.79,0,143,37,6126),
(74,8,3186,1,8225,1,7809,35.7885,0,128.423,0,158,41,6368),
(75,8,3256,5617,8508,1,7981,36.2878,0,132.162,0,175,45,6610),
(76,8,3367,1,8800,1,8139,36.7871,0,136.01,0,193,49,6851),
(77,8,3462,1,9103,1,8313,37.2864,0,139.97,0,214,54,7094),
(78,8,3558,1,9416,1,8459,37.7857,0,144.045,0,236,58,7335),
(79,8,3658,1,9740,1,8636,38.285,0,148.239,0,260,64,7579),
(80,8,3739,1,10080,24761,8814,38.7843,0,152.412,183.236,289,69,7822),
(81,8,3870,1,10486,29750,8979,39.2836,0,157.584,183.236,304,74,8102),
(82,8,3977,1,10784,35743,9160,39.7829,0,162.257,183.236,326,79,8340),
(83,8,4090,1,11156,42945,9328,40.2822,0,167.286,183.236,343,84,8505),
(84,8,1,1,1,51597,9512,45.3711,0,0,183.236,375,91,9698),
(85,8,4299,1,1,61992,9697,45.3711,0,0,183.236,375,91,9698);

--
-- custom_texts
--

DROP TABLE IF EXISTS `custom_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `custom_texts` (
  `entry` mediumint(8) NOT NULL,
  `content_default` text NOT NULL,
  `content_loc1` text,
  `content_loc2` text,
  `content_loc3` text,
  `content_loc4` text,
  `content_loc5` text,
  `content_loc6` text,
  `content_loc7` text,
  `content_loc8` text,
  `sound` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `language` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `emote` smallint(5) unsigned NOT NULL DEFAULT '0',
  `comment` text,
  PRIMARY KEY (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Custom Texts';
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- dungeonfinder_item_rewards
--

DROP TABLE IF EXISTS `dungeonfinder_item_rewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dungeonfinder_item_rewards` (
  `id` int(10) unsigned NOT NULL,
  `min_level` smallint(3) unsigned NOT NULL COMMENT 'dbc value',
  `max_level` smallint(3) unsigned NOT NULL COMMENT 'dbc value',
  `item_reward` mediumint(8) unsigned NOT NULL,
  `item_amount` mediumint(4) unsigned NOT NULL,
  `dungeon_type` smallint(4) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dungeonfinder_item_rewards`
--

INSERT INTO `dungeonfinder_item_rewards` (`id`, `min_level`, `max_level`, `item_reward`, `item_amount`, `dungeon_type`) VALUES
(1,15,25,51999,1,0),
(2,26,35,52000,1,0),
(3,36,45,52001,1,0),
(4,46,55,52002,1,0),
(5,56,60,52003,1,0),
(6,61,64,52004,1,1),
(7,65,68,52005,1,1),
(8,69,80,29434,12,3),
(9,80,82,49426,2,4),
(10,70,75,0,0,2);

--
-- dungeonfinder_requirements
--

DROP TABLE IF EXISTS `dungeonfinder_requirements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dungeonfinder_requirements` (
  `mapId` mediumint(8) unsigned NOT NULL,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `min_item_level` smallint(5) unsigned NOT NULL DEFAULT '0',
  `item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `item_2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `alliance_quest` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `horde_quest` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `achievement` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `quest_incomplete_text` text,
  `comment` text,
  PRIMARY KEY (`mapId`,`difficulty`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Dungeon Finder Requirements';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dungeonfinder_requirements`
--

INSERT INTO `dungeonfinder_requirements` (`mapId`, `difficulty`, `min_item_level`, `item`, `item_2`, `alliance_quest`, `horde_quest`, `achievement`, `quest_incomplete_text`, `comment`) VALUES
(269,0,0,0,0,10285,10285,0,'You must complete the quest \"Return to Andormu\" before entering the Black Morass.','Caverns Of Time,Black Morass (Entrance)'),
(269,1,0,0,0,10285,10285,0,'You must complete the quest \"Return to Andormu\" and be level 70 before entering the Heroic difficulty of the Black Morass.','Caverns Of Time,Black Morass (Entrance)'),
(540,1,0,0,0,0,0,0,NULL,'The Shattered Halls (Entrance)'),
(542,1,0,0,0,0,0,0,NULL,'The Blood Furnace (Entrance)'),
(543,1,0,0,0,0,0,0,NULL,'Hellfire Ramparts (Entrance)'),
(545,1,0,0,0,0,0,0,NULL,'The Steamvault (Entrance)'),
(546,1,0,0,0,0,0,0,NULL,'The Underbog (Entrance)'),
(547,1,0,0,0,0,0,0,NULL,'The Slave Pens (Entrance)'),
(552,1,0,0,0,0,0,0,NULL,'The Arcatraz (Entrance)'),
(553,1,0,0,0,0,0,0,NULL,'The Botanica (Entrance)'),
(554,1,0,0,0,0,0,0,NULL,'The Mechanar (Entrance)'),
(555,1,0,0,0,0,0,0,NULL,'Shadow Labyrinth (Entrance)'),
(556,1,0,0,0,0,0,0,NULL,'Sethekk Halls (Entrance)'),
(557,1,0,0,0,0,0,0,NULL,'Mana Tombs (Entrance)'),
(558,1,0,0,0,0,0,0,NULL,'Auchenai Crypts (Entrance)'),
(560,1,0,0,0,0,0,0,NULL,'Caverns Of Time,Old Hillsbrad Foothills (Entrance)'),
(574,1,180,0,0,0,0,0,NULL,'Utgarde Keep (entrance)'),
(575,1,180,0,0,0,0,0,NULL,'Utgarde Pinnacle (entrance)'),
(576,1,180,0,0,0,0,0,NULL,'The Nexus (entrance)'),
(578,1,180,0,0,0,0,0,NULL,'The Oculus (entrance)'),
(585,1,0,0,0,11492,11492,0,NULL,'Magisters\' Terrace (Entrance)'),
(595,1,180,0,0,0,0,0,NULL,'Culling of Stratholme (entrance)'),
(599,1,180,0,0,0,0,0,NULL,'Ulduar,Halls of Stone (entrance)'),
(600,1,180,0,0,0,0,0,NULL,'Drak\'Tharon Keep (entrance)'),
(601,1,180,0,0,0,0,0,NULL,'Azjol-Nerub (entrance)'),
(602,1,180,0,0,0,0,0,NULL,'Ulduar,Halls of Lightning (entrance)'),
(604,1,180,0,0,0,0,0,NULL,'Gundrak (entrance north)'),
(608,1,180,0,0,0,0,0,NULL,'Violet Hold (entrance)'),
(619,1,180,0,0,0,0,0,NULL,'Ahn\'Kahet (entrance)'),
(631,2,0,0,0,0,0,4530,NULL,'IceCrown Citadel (Entrance)'),
(631,3,0,0,0,0,0,4597,NULL,'IceCrown Citadel (Entrance)'),
(632,0,200,0,0,0,0,0,NULL,'Forge of Souls (Entrance)'),
(632,1,200,0,0,0,0,0,NULL,'Forge of Souls (Entrance)'),
(649,3,0,0,0,0,0,0,NULL,'Trial of the Crusader'),
(650,0,200,0,0,0,0,0,NULL,'Trial of the Champion'),
(650,1,200,0,0,0,0,0,NULL,'Trial of the Champion'),
(658,0,200,0,0,24499,24511,0,NULL,'Pit of Saron (Entrance)'),
(658,1,200,0,0,24499,24511,0,NULL,'Pit of Saron (Entrance)'),
(668,0,219,0,0,24710,24712,0,NULL,'Halls of Reflection (Entrance)'),
(668,1,219,0,0,24710,24712,0,NULL,'Halls of Reflection (Entrance)');

--
-- dungeonfinder_rewards
--

DROP TABLE IF EXISTS `dungeonfinder_rewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dungeonfinder_rewards` (
  `id` int(10) NOT NULL,
  `level` mediumint(8) unsigned NOT NULL COMMENT 'uint32',
  `base_xp_reward` mediumint(8) unsigned NOT NULL COMMENT 'uint32',
  `base_monetary_reward` int(10) NOT NULL COMMENT 'int32',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=67 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dungeonfinder_rewards`
--

INSERT INTO `dungeonfinder_rewards` (`id`, `level`, `base_xp_reward`, `base_monetary_reward`) VALUES
(1,15,155,1750),
(2,16,1525,7650),
(3,17,1525,7650),
(4,18,1525,7650),
(5,19,1525,7650),
(6,20,1525,7650),
(7,21,155,1750),
(8,22,155,1750),
(9,23,155,1750),
(10,24,155,1750),
(11,25,155,1750),
(12,26,235,3500),
(13,27,235,3500),
(14,28,235,3500),
(15,29,235,3500),
(16,30,235,3500),
(17,31,235,3500),
(18,32,235,3500),
(19,33,235,3500),
(20,34,412,6500),
(21,35,412,6500),
(22,36,412,6500),
(23,37,412,6500),
(24,38,412,6500),
(25,39,412,6500),
(26,40,4150,20700),
(27,41,412,6500),
(28,42,412,6500),
(29,43,625,6500),
(30,44,625,6500),
(31,45,625,6500),
(32,46,625,8250),
(33,47,625,8250),
(34,48,6125,30600),
(35,49,6125,30600),
(36,50,6125,30600),
(37,51,6125,30600),
(38,52,6125,30600),
(39,53,6125,30600),
(40,54,725,9000),
(41,55,725,9000),
(42,56,725,9000),
(43,57,725,9000),
(44,58,7150,35700),
(45,59,800,31000),
(46,60,800,31000),
(47,61,800,31000),
(48,62,800,31000),
(49,63,800,31000),
(50,64,800,31000),
(51,65,550,15500),
(52,66,550,15500),
(53,67,9500,47400),
(54,68,950,44000),
(55,69,16550,74000),
(56,70,16550,74000),
(57,71,16550,74000),
(58,72,16550,74000),
(59,73,16550,74000),
(60,74,16550,74000),
(61,75,16550,74000),
(62,76,16550,74000),
(63,77,16550,74000),
(64,78,16550,74000),
(65,79,16550,74000),
(66,80,0,99300);

--
-- gossip_texts
--

DROP TABLE IF EXISTS `gossip_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gossip_texts` (
  `entry` mediumint(8) NOT NULL,
  `content_default` text NOT NULL,
  `content_loc1` text,
  `content_loc2` text,
  `content_loc3` text,
  `content_loc4` text,
  `content_loc5` text,
  `content_loc6` text,
  `content_loc7` text,
  `content_loc8` text,
  `comment` text,
  PRIMARY KEY (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Gossip Texts';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gossip_texts`
--

INSERT INTO `gossip_texts` (`entry`, `content_default`, `content_loc1`, `content_loc2`, `content_loc3`, `content_loc4`, `content_loc5`, `content_loc6`, `content_loc7`, `content_loc8`, `comment`) VALUES
(-3000000,'[PH] SD2 unknown text',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ID_UNKNOWN_TEXT'),
(-3000101,'Taruk send me to collect what you owe.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'silvermoon harry GOSSIP_ITEM_GAMBLING_DEBT'),
(-3000102,'Pay up, Harry!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'silvermoon harry GOSSIP_ITEM_PAYING'),
(-3000103,'I am ready to travel to you village now.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'rainspeaker GOSSIP_ITEM_READY'),
(-3000104,'<Check for pulse...>',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'mosswalker victim GOSSIP_ITEM_PULSE'),
(-3000105,'Ezekiel said that you might have a certain book...',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'dirty larry GOSSIP_ITEM_BOOK'),
(-3000106,'Let Marshal Windsor know that I am ready.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'squire rowe GOSSIP_ITEM_WINDSOR'),
(-3000107,'I am ready, as are my forces. Let us end this masquerade!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'reginald windsor GOSSIP_ITEM_START'),
(-3000108,'I need a moment of your time, sir.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'prospector anvilward GOSSIP_ITEM_MOMENT'),
(-3000109,'I am ready, Oronok. Let us destroy Cyrukh and free the elements!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'oronok torn-heart GOSSIP_ITEM_FIGHT'),
(-3000110,'Why... yes, of course. I\'ve something to show you right inside this building, Mr. Anvilward.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'prospector anvilward GOSSIP_ITEM_SHOW'),
(-3000111,'I am ready, Anchorite. Let us begin the exorcism.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'anchorite barada GOSSIP_ITEM_EXORCISM'),
(-3000112,'I\'m ready - let\'s get out of here.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'injured goblin miner GOSSIP_ITEM_ESCORT_READY'),
(-3000113,'Go on, you\'re free. Get out of here!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'saronite mine slave GOSSIP_ITEM_SLAVE_FREE'),
(-3000114,'I\'m ready to start the distillation, uh, Tipsy.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'tipsy mcmanus GOSSIP_ITEM_START_DISTILLATION'),
(-3000115,'Turn the key to start the machine.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'threshwackonator  GOSSIP_ITEM_TURN_KEY'),
(-3033000,'Please unlock the courtyard door.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'deathstalker adamant/ sorcerer ashcrombe - GOSSIP_ITEM_DOOR'),
(-3043000,'Let the event begin!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Disciple of Naralex - GOSSIP_ITEM_BEGIN'),
(-3090000,'I am ready to begin.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'emi shortfuse GOSSIP_ITEM_START'),
(-3230000,'You\'re free, Dughal! Get out of here!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'dughal GOSSIP_ITEM_DUGHAL'),
(-3230001,'Get out of here, Tobias, you\'re free!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'tobias GOSSIP_ITEM_TOBIAS'),
(-3230002,'Your bondage is at an end, Doom\'rel. I challenge you!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'doomrel GOSSIP_ITEM_CHALLENGE'),
(-3230003,'Why don\'t you and Rocknot go find somewhere private...',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'nagmara GOSSIP_ITEM_NAGMARA'),
(-3409000,'Tell me more.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'majordomo_executus GOSSIP_ITEM_SUMMON_1'),
(-3409001,'What else do you have to say?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'majordomo_executus GOSSIP_ITEM_SUMMON_2'),
(-3409002,'You challenged us and we have come. Where is this master you speak of?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'majordomo_executus GOSSIP_ITEM_SUMMON_3'),
(-3469000,'I\'ve made no mistakes.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'victor_nefarius GOSSIP_ITEM_NEFARIUS_1'),
(-3469001,'You have lost your mind, Nefarius. You speak in riddles.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'victor_nefarius GOSSIP_ITEM_NEFARIUS_2'),
(-3469002,'Please do.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'victor_nefarius GOSSIP_ITEM_NEFARIUS_3'),
(-3469003,'I cannot, Vaelastrasz! Surely something can be done to heal you!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vaelastrasz GOSSIP_ITEM_VAEL_1'),
(-3469004,'Vaelastrasz, no!!!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'vaelastrasz GOSSIP_ITEM_VAEL_2'),
(-3509000,'Let\'s find out.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'andorov GOSSIP_ITEM_START'),
(-3509001,'Let\'s see what you have.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'andorov GOSSIP_ITEM_TRADE'),
(-3532000,'Teleport me to the Guardian\'s Library',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'berthold GOSSIP_ITEM_TELEPORT'),
(-3532001,'I\'m not an actor.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barnes GOSSIP_ITEM_OPERA_1'),
(-3532002,'Ok, I\'ll give it a try, then.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barnes GOSSIP_ITEM_OPERA_2'),
(-3532003,'I\'ve never been more ready.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barnes GOSSIP_ITEM_OPERA_JULIANNE_WIPE'),
(-3532004,'The wolf\'s going down.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barnes GOSSIP_ITEM_OPERA_WOLF_WIPE'),
(-3532005,'What phat lewtz you have grandmother?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'grandma GOSSIP_ITEM_GRANDMA'),
(-3532006,'Control Orc Grunt',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'orc grunt GOSSIP_ITEM_ORC_GRUNT'),
(-3532007,'Control Orc Wolf',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'orc wolf GOSSIP_ITEM_ORC_WOLF'),
(-3532008,'Control Summoned Daemon',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'summoned deamon GOSSIP_ITEM_SUMMONED_DEAMON'),
(-3532009,'Control Orc Warlock',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'orc warlock GOSSIP_ITEM_ORC_WARLOCK'),
(-3532010,'Control Orc Necrolyte',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'orc necrolyte GOSSIP_ITEM_ORC_NECROLYTE'),
(-3532011,'Control Warchief Blackhand',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'warchief blackhand GOSSIP_ITEM_WARCHIEF_BLACKHAND'),
(-3532012,'Control Human Footman',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'human footman GOSSIP_ITEM_HUMAN_FOOTMAN'),
(-3532013,'Control Human Charger',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'human charger GOSSIP_ITEM_HUMAN_CHARGER'),
(-3532014,'Control Conjured Water Elemental',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'conjured water elemental GOSSIP_ITEM_WATER_ELEMENTAL'),
(-3532015,'Control Human Conjurer',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'human conjurer GOSSIP_ITEM_HUMAN_CONJURER'),
(-3532016,'Control Human Cleric',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'human cleric GOSSIP_ITEM_HUMAN_CLERIC'),
(-3532017,'Control King Llane',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'king llane GOSSIP_ITEM_KING_LLANE'),
(-3532018,'Please reset the chess board, we would like to play again.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'medivh GOSSIP_ITEM_RESET_BOARD'),
(-3534000,'My companions and I are with you, Lady Proudmoore.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'jaina GOSSIP_ITEM_JAIN_START'),
(-3534001,'We are ready for whatever Archimonde might send our way, Lady Proudmoore.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'jaina GOSSIP_ITEM_ANATHERON'),
(-3534002,'Until we meet again, Lady Proudmoore.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'jaina GOSSIP_ITEM_SUCCESS'),
(-3534003,'I am with you, Thrall.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_THRALL_START'),
(-3534004,'We have nothing to fear.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_AZGALOR'),
(-3534005,'Until we meet again, Thrall.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_SUCCESS'),
(-3534006,'I would be grateful for any aid you can provide, Priestess.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'tyrande GOSSIP_ITEM_AID'),
(-3560000,'We are ready to get you out of here, Thrall. Let\'s go!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_START'),
(-3560001,'I need a pack of Incendiary Bombs.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'erozion GOSSIP_ITEM_NEED_BOMBS'),
(-3560002,'Taretha cannot see you, Thrall.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_SKARLOC1'),
(-3560003,'The situation is rather complicated, Thrall. It would be best for you to head into the mountains now, before more of Blackmoore\'s men show up. We\'ll make sure Taretha is safe.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_SKARLOC2'),
(-3560004,'We\'re ready, Thrall.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_TARREN_2'),
(-3560005,'Strange wizard?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taretha GOSSIP_ITEM_EPOCH1'),
(-3560006,'We\'ll get you out. Taretha. Don\'t worry. I doubt the wizard would wander too far away.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'taretha GOSSIP_ITEM_EPOCH2'),
(-3560007,'Tarren Mill.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'thrall GOSSIP_ITEM_TARREN_1'),
(-3564000,'I\'m with you, Akama.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'akama(shade) GOSSIP_ITEM_START_ENCOUNTER'),
(-3564001,'I\'m ready, Akama.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'akama(illidan) GOSSIP_ITEM_PREPARE'),
(-3564002,'We\'re ready to face Illidan.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'akama(illidan) GOSSIP_ITEM_START_EVENT'),
(-3568000,'Thanks for the concern, but we intend to explore Zul\'Aman.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'harrison jones GOSSIP_ITEM_BEGIN'),
(-3595000,'What do you think they\'re up to?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_ENTRANCE_1'),
(-3595001,'You want me to do what?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_ENTRANCE_2'),
(-3595002,'Very well, Chromie.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_ENTRANCE_3'),
(-3595003,'Why have I been sent back to this particular place and time?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_INN_1'),
(-3595004,'What was this decision?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_INN_2'),
(-3595005,'So how does the Infinite Dragonflight plan to interfere?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_INN_3'),
(-3595006,'Chromie, you and I both know what\'s going to happen in this time stream. We\'ve seen this all before. Can you just skip us ahead to all the real action?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_INN_SKIP'),
(-3595007,'Yes, please!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'chromie GOSSIP_ITEM_INN_TELEPORT'),
(-3595008,'Yes, my Prince. We are ready.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_CITY_GATES'),
(-3595009,'We\'re only doing what is best for Lordaeron, your Highness.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_TOWN_HALL'),
(-3595010,'Lead the way, Prince Arthas',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_TOWN_HALL_2'),
(-3595011,'I\'m ready.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_EPOCH'),
(-3595012,'For Lordaeron!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_ESCORT'),
(-3595013,'I\'m ready to battle the dreadlord, sire.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'arthas GOSSIP_ITEM_DREADLORD'),
(-3599000,'Brann, it would be our honor!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'brann GOSSIP_ITEM_ID_START'),
(-3599001,'Let\'s move Brann, enough of the history lessons!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'brann GOSSIP_ITEM_ID_PROGRESS'),
(-3603000,'Teleport to the Expedition Base Camp.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_BASE_CAMP'),
(-3603001,'Teleport to the Formation Grounds.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_FORMATION_GROUNDS'),
(-3603002,'Teleport to the Colossal Forge.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_COLOSSAR_FORGE'),
(-3603003,'Teleport to the Scrapyard.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_SCRAPYARD'),
(-3603004,'Teleport to the Antechamber of Ulduar.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_ANTECHAMBER'),
(-3603005,'Teleport to the Shattered Walkway.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_WALKWAY'),
(-3603006,'Teleport to the Conservatory of Life.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_CONSERVATORY'),
(-3603007,'Teleport to the Spark of Imagination.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_SPARK_IMAGINATION'),
(-3603008,'Teleport to the Prison of Yogg-Saron.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'GOSSIP_ITEM_TELE_YOGG_SARON'),
(-3603009,'We are ready to help!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Expedition Commander GOSSIP_ITEM_START_RAZORSCALE'),
(-3603010,'Activate secondary defensive systems.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Lore Keeper of Norgannon GOSSIP_ITEM_ACTIVATE_SYSTEMS'),
(-3603011,'Confirmed.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Lore Keeper of Norgannon GOSSIP_ITEM_CONFIRMED'),
(-3603012,'We\'re ready. Begin the assault!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Brann Bronzebeard GOSSIP_ITEM_BEGIN_ASSAULT'),
(-3603013,'Lend us your aid, keeper. Together we will defeat Yogg-Saron.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Ulduar Keeper GOSSIP_ITEM_LEND_AID'),
(-3603014,'Yes.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Ulduar Keeper GOSSIP_ITEM_KEEPER_CONFIRM'),
(-3608000,'Activate the crystals when we get in trouble, right?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sinclari GOSSIP_ITEM_INTRO'),
(-3608001,'Get your people to safety, we\'ll keep the Blue Dragonflight\'s forces at bay.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sinclari GOSSIP_ITEM_START'),
(-3608002,'I\'m not fighting, so send me in now!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'sinclari GOSSIP_ITEM_TELEPORT'),
(-3609000,'I challenge you, death knight!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Death Knight Initiate GOSSIP_ITEM_ACCEPT_DUEL'),
(-3609001,'I am ready, Highlord. Let the siege of Light\'s Hope begin!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Highlord Darion Mograine GOSSIP_ITEM_READY'),
(-3649000,'Yes. We are prepared for the challenges ahead of us.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_BEAST_INIT'),
(-3649001,'Bring forth the first challenge!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_BEAST_START'),
(-3649002,'We want another shot at those beasts!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_BEAST_WIPE_INIT'),
(-3649003,'What new challenge awaits us?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_JARAXXUS_INIT'),
(-3649004,'We\'re ready to fight the sorceror again.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_JARAXXUS_WIPE_INIT'),
(-3649005,'Of course!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_PVP_INIT'),
(-3649006,'Give the signal! We\'re ready to go!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_PVP_START'),
(-3649007,'That tough, huh?',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_TWINS_INIT'),
(-3649008,'Val\'kyr? We\'re ready for them',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_TWINS_START'),
(-3649009,'Your words of praise are appreciated, Coliseum Master.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_ANUB_INIT'),
(-3649010,'That is strange...',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_ANUB_START'),
(-3649011,'We\'re ready for the next challenge.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_JARAXXUS_START'),
(-3649012,'You\'ll be even more amazed after we take them out!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_PVP_WIPE_INIT'),
(-3649013,'We\'re ready for anything!',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_PVP_WIPE_START'),
(-3649014,'We\'re ready. This time things will be different.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_BEAST_WIPE_START'),
(-3649015,'Now.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_JARAXXUS_WIPE_START'),
(-3649016,'We\'ll just have to improve our teamwork to match the two of them.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_TWINS_WIPE_INIT'),
(-3649017,'Just bring them out again, then watch.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'barrett GOSSIP_ITEM_TWINS_WIPE_START'),
(-3650000,'I am ready.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'herald GOSSIP_ITEM_READY'),
(-3650001,'I am ready.  However, I\'d like to skip the pageantry.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'herald GOSSIP_ITEM_READY_SKIP_INTRO'),
(-3650002,'I am ready for the next challenge.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'herald GOSSIP_ITEM_READY_NEXT_CHALLENGE');


--

-- script_binding
--
-- this table has been implemented in previous updates:
-- Rel21_02_00_Script_refactoring.sql
-- Rel21_02_01_script_binding_populated.sql


--
-- warden_build_specific
--

DROP TABLE IF EXISTS `warden_build_specific`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warden_build_specific` (
  `id` smallint(5) unsigned NOT NULL COMMENT 'Check ID from warden_checks',
  `build` smallint(5) unsigned NOT NULL COMMENT 'Client build',
  `data` varchar(48) NOT NULL DEFAULT '',
  `str` varchar(20) NOT NULL DEFAULT '',
  `address` int(10) unsigned NOT NULL DEFAULT '0',
  `length` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `result` varchar(24) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`build`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- warden_checks
--

DROP TABLE IF EXISTS `warden_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `warden_checks` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned DEFAULT NULL,
  `data` varchar(48) DEFAULT '',
  `str` varchar(20) DEFAULT '',
  `address` int(10) unsigned DEFAULT NULL,
  `length` tinyint(3) unsigned DEFAULT NULL,
  `result` varchar(24) DEFAULT '',
  `comment` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
 

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
            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@cNewResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @cNewResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
	    IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
	    ELSE
                SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cOldResult AS `=== Expected ===`,@cCurResult AS `===== Found Version =====`;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;      