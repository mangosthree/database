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
-- Table structure for table `areatrigger_involvedrelation`
--

DROP TABLE IF EXISTS `areatrigger_involvedrelation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `areatrigger_involvedrelation` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `quest` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Trigger System';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `areatrigger_involvedrelation`
--

LOCK TABLES `areatrigger_involvedrelation` WRITE;
/*!40000 ALTER TABLE `areatrigger_involvedrelation` DISABLE KEYS */;
INSERT INTO `areatrigger_involvedrelation` (`id`, `quest`) VALUES
(342,76),
(231,984),
(230,954),
(216,870),
(197,62),
(196,578),
(98,201),
(88,62),
(87,76),
(1205,2989),
(2327,4842),
(3366,6025),
(2486,4811),
(482,1699),
(3986,8286),
(2946,6421),
(78,155),
(822,2240),
(302,1265),
(4071,9193),
(4064,9160),
(4291,9701),
(4301,9786),
(4170,9400),
(4293,9716),
(4201,9608),
(4200,9607),
(175,455),
(1388,3505),
(168,287),
(178,503),
(4298,9731),
(4300,9752),
(246,1149),
(4473,10269),
(4475,10275),
(2926,25),
(2206,5156),
(4280,9700),
(522,1719),
(171,273),
(173,437),
(2207,5156),
(4581,10750),
(4588,10772),
(4963,11652),
(4899,11890),
(4950,12036),
(4986,12263),
(5003,12506),
(4345,9958),
(5400,13816),
(5401,13607),
(4894,11878),
(5500,14016),
(3991,1658),
(6327,27704),
(5030,12575);
/*!40000 ALTER TABLE `areatrigger_involvedrelation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

