

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
-- Table structure for table `scripted_event_id`
--

DROP TABLE IF EXISTS `scripted_event_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `scripted_event_id` (
  `id` mediumint(8) NOT NULL,
  `ScriptName` char(64) NOT NULL,
  PRIMARY KEY (`id`)
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scripted_event_id`
--

LOCK TABLES `scripted_event_id` WRITE;
/*!40000 ALTER TABLE `scripted_event_id` DISABLE KEYS */;
INSERT INTO `scripted_event_id` VALUES (11225,'event_taxi_stormcrow'),(2228,'event_spell_altar_boss_aggro'),(2268,'event_spell_altar_boss_aggro'),(8328,'npc_kroshius'),(2488,'event_go_zulfarrak_gong'),(13513,'event_spell_soul_captured_credit'),(13514,'event_spell_soul_captured_credit'),(13515,'event_spell_soul_captured_credit'),(13516,'event_spell_soul_captured_credit'),(5618,'event_spell_gandling_shadow_portal'),(5619,'event_spell_gandling_shadow_portal'),(5620,'event_spell_gandling_shadow_portal'),(5621,'event_spell_gandling_shadow_portal'),(5622,'event_spell_gandling_shadow_portal'),(5623,'event_spell_gandling_shadow_portal'),(3094,'event_antalarion_statue_activation'),(3095,'event_antalarion_statue_activation'),(3097,'event_antalarion_statue_activation'),(3098,'event_antalarion_statue_activation'),(3099,'event_antalarion_statue_activation'),(3100,'event_antalarion_statue_activation'),(8502,'event_avatar_of_hakkar'),(9735,'event_spell_saronite_barrier'),(4884,'event_spell_altar_emberseer'),(23426,'event_gameobject_citadel_valve'),(23438,'event_gameobject_citadel_valve'),(16547,'event_go_scrying_orb'),(20651,'event_achiev_kings_bane'),(17728,'event_spell_gortok_event'),(14797,'event_spell_summon_raven_god'),(20711,'event_go_focusing_iris'),(11111,'event_go_barrel_old_hillsbrad'),(10951,'event_spell_medivh_journal'),(10591,'event_spell_summon_nightbane'),(10665,'event_spell_call_captain'),(12229,'event_spell_call_captain'),(18454,'event_spell_call_captain'),(18455,'event_spell_call_captain'),(2609,'event_spell_unlocking'),(21620,'event_ulduar');
/*!40000 ALTER TABLE `scripted_event_id` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-28 15:25:18
