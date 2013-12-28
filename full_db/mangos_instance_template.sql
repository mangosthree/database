

-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: mangos
-- ------------------------------------------------------
-- Server version	5.6.15

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
-- Table structure for table `instance_template`
--

DROP TABLE IF EXISTS `instance_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_template` (
  `map` smallint(5) unsigned NOT NULL,
  `parent` smallint(5) unsigned NOT NULL DEFAULT '0',
  `levelMin` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `levelMax` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ScriptName` varchar(128) NOT NULL DEFAULT '',
  PRIMARY KEY (`map`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instance_template`
--

LOCK TABLES `instance_template` WRITE;
/*!40000 ALTER TABLE `instance_template` DISABLE KEYS */;
INSERT INTO `instance_template` VALUES (269,0,66,0,'instance_dark_portal'),(532,0,68,0,'instance_karazhan'),(534,0,70,0,'instance_hyjal'),(540,0,55,0,'instance_shattered_halls'),(542,0,55,0,'instance_blood_furnace'),(543,0,55,0,'instance_ramparts'),(544,0,65,0,'instance_magtheridons_lair'),(545,0,55,0,'instance_steam_vault'),(546,0,55,0,''),(547,0,55,0,''),(548,0,70,0,'instance_serpent_shrine'),(550,0,70,0,'instance_the_eye'),(552,0,68,0,'instance_arcatraz'),(553,0,68,0,''),(554,0,68,0,'instance_mechanar'),(555,0,65,0,'instance_shadow_labyrinth'),(556,0,55,0,'instance_sethekk_halls'),(557,0,55,0,''),(558,0,55,0,''),(560,0,66,0,'instance_old_hillsbrad'),(564,0,70,0,'instance_black_temple'),(565,0,65,0,'instance_gruuls_lair'),(624,0,80,0,''),(531,0,60,0,'instance_temple_of_ahnqiraj'),(509,0,60,0,'instance_ruins_of_ahnqiraj'),(469,0,60,0,'instance_blackwing_lair'),(429,0,45,0,'instance_dire_maul'),(409,0,50,0,'instance_molten_core'),(389,0,8,0,''),(349,0,30,0,''),(329,0,45,0,'instance_stratholme'),(309,0,50,0,'instance_zulgurub'),(289,0,45,0,'instance_scholomance'),(249,0,80,0,'instance_onyxias_lair'),(230,0,40,0,'instance_blackrock_depths'),(229,0,45,0,'instance_blackrock_spire'),(209,0,35,0,'instance_zulfarrak'),(189,0,20,0,'instance_scarlet_monastery'),(129,0,25,0,''),(109,0,35,0,'instance_sunken_temple'),(90,0,15,0,'instance_gnomeregan'),(70,0,30,0,'instance_uldaman'),(48,0,10,0,'instance_blackfathom_deeps'),(47,0,15,0,'instance_razorfen_kraul'),(43,0,10,0,'instance_wailing_caverns'),(36,0,10,0,'instance_deadmines'),(34,0,15,0,''),(33,0,10,0,'instance_shadowfang_keep'),(568,0,85,0,'instance_zulaman'),(30,0,10,0,''),(580,0,70,0,'instance_sunwell_plateau'),(585,0,70,0,'instance_magisters_terrace'),(566,0,10,0,''),(529,0,10,0,''),(489,0,10,0,''),(576,0,70,72,'instance_nexus'),(601,0,80,80,'instance_azjol-nerub'),(574,0,70,72,'instance_utgarde_keep'),(575,0,80,80,'instance_pinnacle'),(578,0,80,80,'instance_oculus'),(595,0,74,80,'instance_culling_of_stratholme'),(608,0,70,80,'instance_violet_hold'),(615,0,80,0,'instance_obsidian_sanctum'),(617,0,80,80,''),(618,0,80,80,''),(619,0,68,80,'instance_ahnkahet'),(604,0,71,80,'instance_gundrak'),(533,0,80,0,'instance_naxxramas'),(559,0,10,0,''),(562,0,10,0,''),(572,0,10,0,''),(169,0,1,0,''),(724,0,80,80,'instance_ruby_sanctum'),(44,0,1,0,''),(598,0,0,0,''),(599,0,70,0,'instance_halls_of_stone'),(600,0,70,0,'instance_draktharon_keep'),(602,0,70,0,'instance_halls_of_lightning'),(603,0,80,0,'instance_ulduar'),(607,0,71,0,''),(616,0,80,0,'instance_eye_of_eternity'),(650,0,75,0,''),(649,0,80,0,'instance_trial_of_the_crusader'),(631,0,80,0,'instance_icecrown_citadel'),(658,0,75,0,'instance_pit_of_saron'),(668,0,75,0,''),(632,0,75,0,'instance_forge_of_souls'),(643,0,77,0,''),(645,0,77,0,'instance_blackrock_caverns'),(670,0,83,0,''),(644,0,83,0,''),(725,0,80,0,''),(657,0,80,0,''),(755,0,83,0,''),(967,0,85,0,''),(859,0,85,0,''),(939,0,85,0,''),(940,0,85,0,''),(669,0,85,0,''),(671,0,85,0,''),(754,0,85,0,''),(757,0,85,0,''),(938,0,85,0,''),(720,0,85,0,'');
/*!40000 ALTER TABLE `instance_template` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-28 15:24:54
