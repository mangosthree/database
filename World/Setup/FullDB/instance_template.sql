--
-- Copyright (C) 2005-2016 MaNGOS <http://getmangos.eu/>
-- Copyright (C) 2009-2016 MaNGOSZero <https://github.com/mangosthree>
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
  PRIMARY KEY (`map`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instance_template`
--

LOCK TABLES `instance_template` WRITE;
/*!40000 ALTER TABLE `instance_template` DISABLE KEYS */;
INSERT INTO `instance_template` (`map`, `parent`, `levelMin`, `levelMax`) VALUES
(269,0,66,0),
(532,0,68,0),
(534,0,70,0),
(540,0,55,0),
(542,0,55,0),
(543,0,55,0),
(544,0,65,0),
(545,0,55,0),
(546,0,55,0),
(547,0,55,0),
(548,0,70,0),
(550,0,70,0),
(552,0,68,0),
(553,0,68,0),
(554,0,68,0),
(555,0,65,0),
(556,0,55,0),
(557,0,55,0),
(558,0,55,0),
(560,0,66,0),
(564,0,70,0),
(565,0,65,0),
(624,0,80,0),
(531,0,60,0),
(509,0,60,0),
(469,0,60,0),
(429,0,45,0),
(409,0,50,0),
(389,0,8,0),
(349,0,30,0),
(329,0,45,0),
(309,0,50,0),
(289,0,45,0),
(249,0,80,0),
(230,0,40,0),
(229,0,45,0),
(209,0,35,0),
(189,0,20,0),
(129,0,25,0),
(109,0,35,0),
(90,0,15,0),
(70,0,30,0),
(48,0,10,0),
(47,0,15,0),
(43,0,10,0),
(36,0,10,0),
(34,0,15,0),
(33,0,10,0),
(568,0,85,0),
(30,0,10,0),
(580,0,70,0),
(585,0,70,0),
(566,0,10,0),
(529,0,10,0),
(489,0,10,0),
(576,0,70,72),
(601,0,80,80),
(574,0,70,72),
(575,0,80,80),
(578,0,80,80),
(595,0,74,80),
(608,0,70,80),
(615,0,80,0),
(617,0,80,80),
(618,0,80,80),
(619,0,68,80),
(604,0,71,80),
(533,0,80,0),
(559,0,10,0),
(562,0,10,0),
(572,0,10,0),
(169,0,1,0),
(724,0,80,80),
(44,0,1,0),
(598,0,0,0),
(599,0,70,0),
(600,0,70,0),
(602,0,70,0),
(603,0,80,0),
(607,0,71,0),
(616,0,80,0),
(650,0,75,0),
(649,0,80,0),
(631,0,80,0),
(658,0,75,0),
(668,0,75,0),
(632,0,75,0),
(643,0,77,0),
(645,0,77,0),
(670,0,83,0),
(644,0,83,0),
(725,0,80,0),
(657,0,80,0),
(755,0,83,0),
(967,0,85,0),
(859,0,85,0),
(939,0,85,0),
(940,0,85,0),
(669,0,85,0),
(671,0,85,0),
(754,0,85,0),
(757,0,85,0),
(938,0,85,0),
(720,0,85,0);
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

