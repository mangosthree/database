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
-- Table structure for table `game_event`
--

DROP TABLE IF EXISTS `game_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `game_event` (
  `entry` mediumint(8) unsigned NOT NULL COMMENT 'Entry of the game event',
  `start_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Absolute start date, the event will never start before',
  `end_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT 'Absolute end date, the event will never start afler',
  `occurence` bigint(20) unsigned NOT NULL DEFAULT '86400' COMMENT 'Delay in minutes between occurences of the event',
  `length` bigint(20) unsigned NOT NULL DEFAULT '43200' COMMENT 'Length in minutes of the event',
  `holiday` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Client side holiday id',
  `description` varchar(255) DEFAULT NULL COMMENT 'Description of the event displayed in console',
  PRIMARY KEY (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_event`
--

LOCK TABLES `game_event` WRITE;
/*!40000 ALTER TABLE `game_event` DISABLE KEYS */;
INSERT INTO `game_event` (`entry`, `start_time`, `end_time`, `occurence`, `length`, `holiday`, `description`) VALUES
(1,'2013-06-20 20:00:00','2020-12-29 21:00:00',525600,20160,341,'Midsummer Fire Festival'),
(2,'2013-12-15 03:00:00','2020-12-30 17:00:00',525600,25920,141,'Feast of Winter Veil'),
(3,'2013-08-31 18:01:00','2012-12-30 14:00:00',131040,8639,376,'Darkmoon Faire (Terokkar Forest)'),
(4,'2013-10-05 18:01:00','2012-12-30 14:00:00',131040,8639,374,'Darkmoon Faire (Elwynn Forest)'),
(5,'2013-08-03 18:01:00','2012-12-30 14:00:00',131040,8639,375,'Darkmoon Faire (Mulgore)'),
(6,'2010-12-31 17:00:00','2010-12-31 17:00:00',525600,120,0,'New Year\'s Eve'),
(7,'2013-01-22 03:00:00','2020-12-30 17:00:00',525600,30240,327,'Lunar Festival'),
(8,'2013-02-04 19:01:00','2020-12-20 15:00:00',525600,20160,423,'Love is in the Air'),
(9,'2013-03-31 18:01:00','2020-12-30 17:00:00',525600,10078,181,'Noblegarden'),
(10,'2013-04-28 18:01:00','2020-12-30 17:00:00',525600,10078,201,'Children\'s Week '),
(11,'2013-09-05 18:01:00','2020-12-29 21:00:00',525600,10080,321,'Harvest Festival'),
(12,'2013-10-17 18:00:00','2020-12-31 04:00:00',525600,20160,324,'Hallow\'s End'),
(22,'0000-00-00 00:00:00','0000-00-00 00:00:00',482400,43200,0,'AQ War Effort'),
(17,'0000-00-00 00:00:00','0000-00-00 00:00:00',525600,28800,0,'Scourge Invasion'),
(13,'0000-00-00 00:00:00','0000-00-00 00:00:00',525600,28800,0,'Elemental Invasions'),
(14,'2010-12-19 13:50:00','2020-12-30 11:00:00',10080,130,0,'Fishing Extravaganza Announce'),
(16,'2010-11-30 19:00:00','2020-12-30 14:00:00',180,120,0,'Gurubashi Arena Booty Run'),
(15,'2010-12-19 14:00:00','2020-12-27 11:00:00',10080,120,301,'Fishing Extravaganza'),
(18,'2012-11-15 19:01:00','2020-11-19 17:00:00',60480,5758,283,'Call to Arms: Alterac Valley!'),
(19,'2012-11-22 19:01:00','2020-11-26 17:00:00',60480,5758,284,'Call to Arms: Warsong Gulch!'),
(20,'2012-11-26 19:01:00','2020-11-30 17:00:00',60480,5758,285,'Call to Arms: Arathi Basin!'),
(21,'2012-11-08 19:01:00','2020-11-12 17:00:00',60480,5758,353,'Call to Arms: Eye of the Storm!'),
(24,'2009-03-05 23:05:00','2011-12-30 20:00:00',7200,60,0,'Wolfs Attack to the Orgrimmar (Wolfs Group Two)'),
(23,'2009-03-06 02:00:00','2011-12-30 20:00:00',1440,60,0,'Wolfs Attack to the Orgrimmar (Wolfs Group One)'),
(26,'2013-09-19 20:00:00','2020-12-30 15:00:00',525600,24478,372,'Brewfest'),
(28,'2007-08-12 15:59:59','2011-12-30 20:00:00',7200,60,0,'Death Legion Attack Stormwind City (Undead Attack)'),
(25,'2007-08-12 10:00:07','2020-12-30 20:00:00',7200,60,0,'Orgrimmar Grunts Start Defend'),
(34,'2010-09-18 08:00:00','2019-12-31 19:00:00',10080,5,0,'L70ETC Concert'),
(35,'2010-09-05 18:01:00','2020-12-30 17:00:00',80640,20160,0,'Edge of Madness, Gri\'lek'),
(36,'2010-09-19 18:01:00','2020-12-30 17:00:00',80640,20160,0,'Edge of Madness, Hazza\'rah'),
(37,'2010-10-03 18:01:00','2020-12-30 17:00:00',80640,20160,0,'Edge of Madness, Renataki'),
(38,'2010-10-17 18:01:00','2020-12-30 17:00:00',80640,20160,0,'Edge of Madness, Wushoolay'),
(29,'2010-12-01 16:00:00','2020-12-30 17:00:00',1440,540,0,'Nights'),
(32,'2013-09-18 18:01:00','2020-12-30 17:00:00',525600,1440,398,'Pirates\' Day'),
(40,'2013-10-31 20:00:00','2020-12-30 17:00:00',525600,1440,409,'Day of the Dead'),
(41,'2013-11-17 20:00:00','2020-12-30 17:00:00',545760,10019,404,'Pilgrim\'s Bounty'),
(42,'2012-12-06 19:01:00','2020-12-10 17:00:00',60480,5758,420,'Call to Arms: Isle of Conquest!'),
(43,'2010-11-30 19:15:00','2020-12-30 17:00:00',60,5,0,'Hammerfall Under Attack'),
(44,'2010-11-30 19:00:00','2020-12-30 17:00:00',5,5,0,'Thrallmar Demon Attack'),
(45,'2010-12-18 09:00:00','2020-12-26 10:00:00',10080,60,424,'Kalu\'ak Fishing Derby'),
(30,'2012-11-29 19:01:00','2020-11-03 17:00:00',60480,5758,400,'Call to Arms: Strand of the Ancients!'),
(50,'2009-12-31 19:01:00','2020-01-31 18:59:00',525600,44640,0,'January'),
(51,'2010-01-31 19:01:00','2020-02-29 18:59:00',525600,40320,0,'February'),
(52,'2010-02-28 19:01:00','2020-03-31 17:59:00',525600,44640,0,'March'),
(53,'2010-03-31 18:01:00','2020-04-30 17:59:00',525600,43200,0,'April'),
(54,'2010-04-30 18:01:00','2020-05-31 17:59:00',525600,44640,0,'May'),
(55,'2010-05-31 18:01:00','2020-06-30 17:59:00',525600,43200,0,'June'),
(56,'2010-06-30 18:01:00','2020-07-31 17:59:00',525600,44640,0,'July'),
(57,'2010-07-31 18:01:00','2020-08-31 17:59:00',525600,44640,0,'August'),
(58,'2010-08-31 18:01:00','2020-09-30 17:59:00',525600,43200,0,'September'),
(59,'2010-09-30 18:01:00','2020-10-31 18:59:00',525600,44640,0,'October'),
(60,'2010-10-31 19:01:00','2020-11-30 18:59:00',525600,43200,0,'November'),
(61,'2010-11-30 19:01:00','2020-12-31 18:59:00',525600,44640,0,'December'),
(46,'2010-09-07 18:00:01','2010-12-07 06:00:01',432000,86400,0,'Zalazane\'s Fall'),
(47,'2010-09-07 18:00:01','2010-12-07 06:00:01',432000,86400,0,'Operation: Gnomeregan'),
(64,'2010-09-22 18:01:00','2020-12-30 17:00:00',525600,256320,0,'Fishing (winter season)'),
(65,'2011-03-19 19:01:00','2020-12-30 17:00:00',525600,269280,0,'Fishing (summer season)'),
(66,'2010-10-31 19:00:00','2020-12-30 17:00:00',1440,360,0,'Fishing (00.00-06.00)'),
(67,'2010-11-01 01:00:00','2020-12-30 17:00:00',1440,360,0,'Fishing (06.00-12.00)'),
(68,'2010-11-01 07:00:00','2020-12-30 17:00:00',1440,360,0,'Fishing (12.00-18.00)'),
(69,'2010-11-01 13:00:00','2020-12-30 17:00:00',1440,360,0,'Fishing (18.00-00.00)'),
(48,'2010-11-01 05:00:01','2010-12-07 06:00:01',432000,86400,0,'Twilight\'s Cult & Elemental Invasion'),
(27,'2010-12-05 19:10:00','2020-12-30 18:00:00',30,10,0,'Leader of Jin\'Alai, Kutube\'sa'),
(33,'2010-12-05 19:20:00','2020-12-30 18:00:00',30,10,0,'Leader of Jin\'Alai, Gawanil'),
(39,'2010-12-05 19:30:00','2020-12-30 18:00:00',30,10,0,'Leader of Jin\'Alai, Chulo'),
(49,'2013-12-25 00:00:00','2020-12-31 00:00:00',525600,11700,0,'Winter Veil: Gifts'),
(62,'2010-12-31 21:48:00','2020-12-30 19:00:00',180,24,0,'World\'s End Tavern - Perry Gatner Announce'),
(63,'2010-12-31 22:00:00','2020-12-30 19:00:00',180,5,0,'World\'s End Tavern - Perry Gatner Standup Comedy'),
(70,'2010-12-31 22:48:00','2020-12-30 19:00:00',180,24,0,'World\'s End Tavern - L70ETC Concert Announce'),
(71,'2010-12-31 23:00:00','2020-12-30 19:00:00',180,5,0,'World\'s End Tavern - L70ETC Concert'),
(72,'2010-12-31 19:58:00','2020-12-30 19:00:00',30,10,0,'Stormwind City - Stockades Jail Break'),
(31,'2011-01-01 16:00:00','2020-12-30 19:00:00',1440,5,0,'Dalaran - Invitation to the Argent Crusade'),
(73,'0000-00-00 00:00:00','0000-00-00 00:00:00',60,60,0,'Night Elf Mohawk'),
(75,'2013-08-03 19:01:00','2020-12-30 14:00:00',43680,8639,479,'Darkmoon Faire'),
(132,'0000-00-00 00:00:00','0000-00-00 00:00:00',5184000,2592000,0,'Arena Season 9'),
(133,'0000-00-00 00:00:00','0000-00-00 00:00:00',5184000,2592000,0,'Arena Season 10'),
(134,'0000-00-00 00:00:00','0000-00-00 00:00:00',5184000,2592000,0,'Arena Season 11'),
(76,'2012-10-18 18:01:00','2020-10-22 16:00:00',60480,5758,435,'Call to Arms: The Battle for Gilneas'),
(77,'2012-10-25 18:01:00','2020-10-29 17:00:00',60480,5758,436,'Call to Arms: Twin Peaks'),
(78,'2012-11-22 19:01:00','2012-11-29 17:00:00',60480,10080,0,'Rated Battleground 10x10'),
(79,'2012-11-29 19:01:00','2012-12-06 17:00:00',60480,10080,442,'Rated Battleground 15x15'),
(80,'2012-12-06 19:01:00','2012-12-13 17:00:00',60480,10080,443,'Rated Battleground 25x25');
/*!40000 ALTER TABLE `game_event` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

