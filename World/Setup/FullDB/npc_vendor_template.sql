-- MySQL dump 10.13  Distrib 5.5.37, for Win32 (x86)
--
-- Host: localhost    Database: mangos3
-- ------------------------------------------------------
-- Server version	5.5.37

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
-- Table structure for table `npc_vendor_template`
--

DROP TABLE IF EXISTS `npc_vendor_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `npc_vendor_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `item` mediumint(8) NOT NULL DEFAULT '0',
  `maxcount` smallint(5) unsigned NOT NULL DEFAULT '0',
  `incrtime` int(10) unsigned NOT NULL DEFAULT '0',
  `ExtendedCost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `condition_id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`,`item`,`ExtendedCost`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Npc System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `npc_vendor_template`
--

LOCK TABLES `npc_vendor_template` WRITE;
/*!40000 ALTER TABLE `npc_vendor_template` DISABLE KEYS */;
INSERT INTO `npc_vendor_template` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `condition_id`) VALUES (33238,44605,0,0,0,0),
(33238,33451,0,0,0,0),
(33238,33454,0,0,0,0),
(33238,35954,0,0,0,0),
(33238,33443,0,0,0,0),
(33238,33449,0,0,0,0),
(33238,33452,0,0,0,0),
(33238,35949,0,0,0,0),
(33238,22148,0,0,0,0),
(33238,16583,0,0,0,0),
(33238,21177,0,0,0,0),
(33238,17026,0,0,0,0),
(33238,17020,0,0,0,0),
(33238,5565,0,0,0,0),
(33238,37201,0,0,0,0),
(33238,17021,0,0,0,0),
(33238,17028,0,0,0,0),
(33238,17032,0,0,0,0),
(33238,17030,0,0,0,0),
(33238,17033,0,0,0,0),
(33238,17034,0,0,0,0),
(33238,17031,0,0,0,0),
(33238,4470,0,0,0,0),
(33239,44605,0,0,0,0),
(33239,33451,0,0,0,0),
(33239,33454,0,0,0,0),
(33239,35954,0,0,0,0),
(33239,33443,0,0,0,0),
(33239,33449,0,0,0,0),
(33239,33452,0,0,0,0),
(33239,35949,0,0,0,0),
(33239,22148,0,0,0,0),
(33239,16583,0,0,0,0),
(33239,21177,0,0,0,0),
(33239,17026,0,0,0,0),
(33239,17020,0,0,0,0),
(33239,5565,0,0,0,0),
(33239,37201,0,0,0,0),
(33239,17021,0,0,0,0),
(33239,17028,0,0,0,0),
(33239,17032,0,0,0,0),
(33239,17030,0,0,0,0),
(33239,17033,0,0,0,0),
(33239,17034,0,0,0,0),
(33239,17031,0,0,0,0),
(33239,4470,0,0,0,0);
/*!40000 ALTER TABLE `npc_vendor_template` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-24 21:54:27
