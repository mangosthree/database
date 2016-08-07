--
-- Copyright (C) 2005-2015 MaNGOS <http://getmangos.eu/>
-- Copyright (C) 2009-2015 MaNGOSZero <https://github.com/mangoszero>
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
--

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pool_gameobject_template`
--

DROP TABLE IF EXISTS `pool_gameobject_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool_gameobject_template` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `pool_entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `chance` float unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pool_idx` (`pool_entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pool_gameobject_template`
--

LOCK TABLES `pool_gameobject_template` WRITE;
/*!40000 ALTER TABLE `pool_gameobject_template` DISABLE KEYS */;
INSERT INTO `pool_gameobject_template` (`id`, `pool_entry`, `chance`, `description`) VALUES
(186684,1132,0,'Iron Rune Carving Tools'),
(187264,1129,0,'Darkspine Ore Chest'),
(187333,1130,0,'Bloodberry Bush'),
(171938,1131,0,'Cactus Apple'),
(185939,1133,0,'Nethermine Cargo'),
(182139,1227,0,'Feralfen Idol'),
(164,1228,0,'Scaber Stalk'),
(333,1229,0,'Ancient Relic'),
(334,1230,0,'Ancient Relic'),
(35252,1231,0,'Ancient Relic'),
(337,1232,0,'Water Pitcher'),
(1673,1233,0,'Fel Cone'),
(2724,1234,0,'Sack of Oats'),
(2912,1235,0,'Ambercor'),
(2910,1236,0,'Well Stone'),
(140971,1241,0,'Gahz\'ridian'),
(183945,1237,0,'Energy Isolation Cube'),
(186938,2686,0,'Loose Rock'),
(182265,13671,0,'Bleeding Hollow Supply Crate'),
(192818,13672,0,'Infused Mushroom'),
(193610,13673,0,'Underbelly Elixir'),
(184793,14135,0,'Primitive Chest'),
(181250,14136,0,'Raw Meat Rack'),
(181251,14137,0,'Smoked Meat Rack'),
(181252,14138,0,'Fresh Fish Rack'),
(182355,14139,0,'Kil\'sorrow Armaments'),
(191568,14140,0,'K3 Equipment'),
(157936,1102,0,'Un\'Goro Dirt Pile'),
(202080,1104,0,'Dart\'s Nest'),
(202081,14141,0,'Takk\'s Nest'),
(202083,14142,0,'Razormaw Matriarch\'s Nest'),
(202082,14143,0,'Ravasaur Matriarch\'s Nest'),
(181107,14144,0,'Weapon Container'),
(182069,14145,0,'Mature Spore Sac'),
(182053,14146,0,'Glowcap'),
(2712,14148,0,'Calcified Elven Gem'),
(182941,14149,0,'Grishnath Orb'),
(187039,14150,0,'Smuggled Mana Cell'),
(180654,14151,0,'Hardpacked Snowdrift'),
(187367,14152,0,'Winterfin Clam'),
(181098,14153,0,'Volcanic Ash'),
(161527,14154,0,'Dinosaur Bone'),
(175324,14174,0,'Frostmaul Shards'),
(194213,14175,0,'Winter Hyacinth'),
(1610,14177,0,'Incendicite Mineral Vein 1'),
(2653,14179,0,'Lesser Bloodstone Ore'),
(1667,14178,0,'Incendicite Mineral Vein 2'),
(186301,14344,0,'Blackhoof Armaments'),
(189992,14345,0,'Ruby Acorn'),
(192676,14347,0,'Emerald Acorn'),
(182799,14354,0,'Salvageable Wood (A)'),
(182936,14355,0,'Salvageable Wood (H)'),
(176213,14356,0,'Blood of Heroes'),
(185182,14359,0,'Nethervine Crystal'),
(185915,14360,0,'Netherwing Egg'),
(185877,14363,0,'Nethercite Deposit'),
(188164,14364,0,'Kaskala Supplies'),
(185911,14365,0,'Apexis Shard Formation'),
(2560,14366,0,'Half-Buried Bottle'),
(176224,14367,0,'Supply Crate'),
(153123,14368,0,'Kim\'jael\'s Equipment'),
(153556,14369,0,'Thaurissan Relic'),
(184948,14370,0,'Ever-burning Ash'),
(186591,14384,0,'Spotted Hippogryph Down'),
(182050,14810,0,'Box of Mushrooms'),
(182031,14408,0,'Discarded Nutriment'),
(182256,14409,0,'Discarded Nutriment'),
(181981,14410,0,'Dragon Bone'),
(188441,14411,0,'Splintered Bone Chunk'),
(182116,14413,0,'Fulgor Spore'),
(142189,14414,0,'Inconspicuous Landmark'),
(17783,14427,0,'Ancient Statuette'),
(154357,14452,0,'Glinting Mud'),
(179494,14453,0,'Dented Footlocker'),
(181283,14454,0,'Emitter Spare Part'),
(19868,14455,0,'Rocket Car Rubble'),
(19869,14456,0,'Rocket Car Rubble'),
(19870,14457,0,'Rocket Car Rubble'),
(19871,14458,0,'Rocket Car Rubble'),
(19872,14459,0,'Rocket Car Rubble'),
(19873,14460,0,'Rocket Car Rubble'),
(164958,14461,0,'Bloodpetal Sprout'),
(181665,14462,0,'Burial Chest'),
(184867,14468,0,'Nether Drake Egg'),
(195022,14472,0,'Venomhide Egg'),
(182127,14482,0,'Corrupted Flower'),
(181696,14483,0,'Hollowed Out Tree'),
(181697,14484,0,'Pile of Leaves'),
(3685,14485,0,'Silithid Mound'),
(180248,1095,0,'School of Tastyfish'),
(191843,14498,0,'Dried Gnoll Rations'),
(190500,14501,0,'Skyreach Crystal Formation'),
(190702,14502,0,'Lifeblood Shard'),
(184906,14504,0,'Power Converter'),
(184716,14539,0,'Coilskar Chest'),
(186912,14587,0,'Valgarde Supply Crate'),
(186729,14588,0,'Mana Berry Bush'),
(192827,14589,0,'Wild Mustard'),
(192823,14590,0,'Full Jug of Wine'),
(192825,14591,0,'Aged Dalaran Limburger'),
(192824,14592,0,'Half Full Glass of Wine'),
(192828,14593,0,'Crystalsong Carrot'),
(191543,14594,0,'Scarlet Onslaught Trunk'),
(186662,14595,0,'Reagent Pouch'),
(2068,14596,0,'Pupellyverbos Port'),
(184689,14597,0,'Draenethyst Mine Crystal'),
(181372,14598,0,'Hellfire Spineleaf'),
(183767,14599,0,'Etherlithium Matrix Crystal'),
(22246,14600,0,'Tear of Theradras'),
(22245,14601,0,'Sack of Meat'),
(192058,14675,0,'Ore Cart'),
(271,14776,0,'Miners\' League Crates'),
(193997,14644,0,'Everfrost Chip'),
(175966,14645,0,'Enchanted Scarlet Thread (175966)'),
(175928,14672,0,'Incendia Agave'),
(181616,14673,0,'School of Red Snapper'),
(181151,14676,0,'Glistening Mud'),
(181644,14677,0,'Azure Snapdragon'),
(182541,14678,0,'Olemba Cone'),
(186463,14679,0,'Wyrmtail'),
(182584,14680,0,'Restless Bones'),
(186632,14681,0,'Dwarven Keg'),
(189983,14682,0,'Wild Carrot'),
(192908,14683,0,'Crystalline Heartwood'),
(182601,14684,0,'Olemba Root'),
(182606,14685,0,'Dragonspine'),
(182599,14686,0,'Telaari Frond'),
(182600,14687,0,'Marshberry'),
(186619,14688,0,'Sprung Trap'),
(181854,14689,0,'Sand Pear'),
(188260,14690,0,'Boulder'),
(185130,14691,0,'Sketh\'lon Feather'),
(186450,14692,0,'Zeppelin Cargo'),
(182520,14693,0,'Telaar Supply Crate'),
(186423,14694,0,'Witchbane'),
(180600,14695,0,'Unstable Mana Crystal Crate'),
(184077,14696,0,'Nether Dragonkin Egg'),
(193059,14697,0,'Vrykul Weapons'),
(192941,14698,0,'Untarnished Silver Bar'),
(192945,14699,0,'Jade Statue'),
(192944,14700,0,'Golden Goblet'),
(153239,14701,0,'Wildkin Feather'),
(184443,14703,0,'Ivory Bell'),
(194126,14704,0,'Gundrak Raptor Egg'),
(195037,14705,0,'Silithid Egg'),
(188113,14706,0,'Frostberry Bush'),
(190534,14707,0,'Mature Water-Poppy'),
(24798,14708,0,'Sundried Driftwood'),
(190533,14710,0,'Sandfern'),
(185497,14711,0,'Bogblossom'),
(190836,14712,0,'Zol\'Maz Stronghold Cache'),
(182128,14713,0,'Dung'),
(188359,14714,0,'Tua\'kea Crab Trap'),
(4608,14715,0,'Timberling Sprout'),
(188600,14717,0,'Hazewood Bush'),
(183441,14718,0,'Soul Mirror'),
(181897,344,0,'Ysera\'s Tear'),
(181683,14720,0,'Ancient Relic'),
(177464,14721,0,'Large Termite Mound'),
(2087,14723,0,'Bloodsail Orders'),
(181771,14842,0,'181771 - Corrupted Crystal'),
(11713,14726,0,'Death Cap'),
(181680,14727,0,'Drycap Mushroom'),
(186954,14728,0,'Large Barrel'),
(186955,14729,0,'Industrial Strength Rope'),
(175708,14730,0,'Crossroads\' Supply Crates'),
(331,14731,0,'Loose Soil'),
(181757,14732,0,'Stillpine Grain'),
(181770,14841,0,'181770 - Corrupted Crystal'),
(190479,14737,0,'Spiky Spider Eggs'),
(188345,14738,0,'Shimmering Snowcaps'),
(188601,14739,0,'Sweetroot'),
(164662,14740,0,'Equipment Boxes'),
(182119,14741,0,'Dead Mire Soil'),
(184607,14742,0,'Dome Generator Segment'),
(175785,14743,0,'Inconspicuous Documents'),
(187897,14744,0,'Fizzcrank Spare Parts'),
(187898,14745,0,'Fizzcrank Spare Parts'),
(187899,14746,0,'Fizzcrank Spare Parts'),
(187900,14747,0,'Fizzcrank Spare Parts'),
(187901,14748,0,'Fizzcrank Spare Parts'),
(187902,14750,0,'Bloodspore Carpel'),
(192826,14751,0,'Drakkari History Tablet'),
(187659,14752,0,'Warsong Munitions'),
(187660,14753,0,'Warsong Munitions'),
(187661,14754,0,'Warsong Munitions'),
(187677,14756,0,'Scourged Earth'),
(188262,14757,0,'Missing Journal Page'),
(188263,14758,0,'Missing Journal Page'),
(142344,14760,0,'Artificial Extrapolator'),
(195274,14761,0,'Stolen Tallstrider Leg'),
(190032,14762,0,'Wintergarde Munitions Crate'),
(175566,14763,0,'Gloom Weed'),
(179922,14764,0,'Vessel of Tainted Blood'),
(190584,14765,0,'Battle-worn Sword'),
(3240,14766,0,'Taillasher Eggs'),
(3640,14767,0,'Laden Mushroom'),
(181645,14768,0,'Gryphon Egg'),
(183813,14770,0,'Ethereal Technology'),
(183814,14769,0,'Ethereal Technology'),
(186403,14772,0,'Whisper Gulch Ore'),
(183935,14773,0,'Fel Reaver Part'),
(190660,14774,0,'Roc Egg'),
(375,14775,0,'Tirisfal Pumpkin'),
(3290,14777,0,'Stolen Supply Sack'),
(3236,14780,0,'Webwood Eggs'),
(19541,14781,0,'Deepmoss Eggs'),
(37099,14782,0,'Atal\'ai Tablet'),
(276,14784,0,'Shimmerweed Basket'),
(1723,14785,0,'Mudsnout Blossom'),
(181686,14786,0,'Lumber Pile'),
(181746,14840,0,'181746 - Clopper\'s Equipment'),
(181916,14789,0,'Tainted Wood'),
(181891,14790,0,'Blood Mushroom'),
(181892,14791,0,'Aquatic Stinkhorn'),
(181893,14792,0,'Ruinous Polyspore'),
(181894,14793,0,'Fel Cone Fungus'),
(191770,14794,0,'Eagle Egg'),
(191773,14795,0,'Eagle Egg'),
(22550,14797,0,'Draenethyst Crystals'),
(19016,14798,0,'Stardust Covered Bush'),
(148513,14799,0,'Tablet of Jin\'yael'),
(148514,14800,0,'Tablet of Markri'),
(148515,14801,0,'Tablet of Sael\'hai'),
(148516,14802,0,'Tablet of Beth\'Amara'),
(181626,14803,0,'Warped Crates'),
(141853,14805,0,'Violet Tragan'),
(190399,14806,0,'Muddlecap Fungus'),
(189295,14807,0,'Murkweed'),
(176793,14808,0,'Bundle of Wood'),
(188691,14809,0,'Vordrassil\'s Seed'),
(182940,14811,0,'Soul Device'),
(187689,14812,0,'Crafty\'s Stuff'),
(186587,14813,0,'Wyrmskull Tablet'),
(186595,14814,0,'Wyrmskull Tablet');
/*!40000 ALTER TABLE `pool_gameobject_template` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

