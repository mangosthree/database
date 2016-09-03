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
-- Table structure for table `skill_fishing_base_level`
--

DROP TABLE IF EXISTS `skill_fishing_base_level`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skill_fishing_base_level` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Area identifier',
  `skill` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Base skill level requirement',
  PRIMARY KEY (`entry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Fishing system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skill_fishing_base_level`
--

LOCK TABLES `skill_fishing_base_level` WRITE;
/*!40000 ALTER TABLE `skill_fishing_base_level` DISABLE KEYS */;
INSERT INTO `skill_fishing_base_level` (`entry`, `skill`) VALUES
(130,-20),
(305,-20),
(702,-70),
(44,55),
(141,-70),
(493,205),
(3691,405),
(3519,355),
(148,-20),
(38,-20),
(1537,-20),
(3317,205),
(456,-20),
(718,-20),
(719,-20),
(307,205),
(47,205),
(1581,-20),
(445,-20),
(448,-20),
(449,-20),
(3636,395),
(3614,395),
(896,55),
(295,55),
(294,55),
(267,55),
(454,-20),
(2077,-20),
(12,-70),
(385,-20),
(139,330),
(10,55),
(1,-70),
(720,-20),
(401,-20),
(796,130),
(392,-20),
(41,330),
(249,330),
(17,-20),
(391,-20),
(382,-20),
(386,5),
(387,5),
(388,5),
(2100,205),
(3621,395),
(3625,280),
(3518,380),
(46,330),
(2717,330),
(328,130),
(3586,-20),
(1637,-20),
(1977,330),
(2017,330),
(2057,330),
(3805,330),
(3483,280),
(3433,-20),
(3514,-20),
(3515,-20),
(327,130),
(3513,-20),
(1638,-20),
(1657,-20),
(331,55),
(414,55),
(3508,-20),
(3430,-70),
(3472,-70),
(3470,-70),
(3558,-70),
(3482,-70),
(3473,-70),
(3460,-70),
(3911,-70),
(3607,305),
(4058,380),
(4479,380),
(495,380),
(4646,380),
(394,380),
(210,455),
(67,455),
(66,380),
(4151,380),
(4257,380),
(4166,380),
(4256,380),
(3461,-70),
(45,130),
(65,380),
(4813,455),
(36,130),
(3692,405),
(3690,405),
(3859,405),
(3520,280),
(3716,305),
(3521,305),
(3656,305),
(3658,305),
(3653,305),
(3659,355),
(3655,355),
(3523,380),
(3524,-70),
(3528,-70),
(3525,-20),
(3595,-20),
(4080,355),
(4055,380),
(3980,380),
(2817,405),
(3537,380),
(4109,380),
(4022,380),
(4123,380),
(4113,380),
(4039,380),
(4134,380),
(4043,380),
(3711,435),
(3979,485),
(4197,435),
(4560,435),
(4567,435),
(4395,435),
(4742,460),
(3456,460),
(4493,460),
(4273,460),
(4722,460),
(306,-20),
(1519,-20),
(4411,-20),
(297,205),
(33,130),
(37,130),
(300,130),
(2403,130),
(8,130),
(1477,205),
(85,-70),
(1497,-20),
(28,205),
(2,-20),
(115,-20),
(40,-20),
(298,55),
(299,55),
(11,55),
(150,55),
(1039,55),
(400,130),
(618,330),
(361,205),
(215,-70),
(1377,330),
(14,-70),
(374,-70),
(375,-70),
(373,-70),
(368,-70),
(393,-70),
(15,130),
(513,130),
(518,130),
(2079,130),
(2318,130),
(490,205),
(537,205),
(405,130),
(598,130),
(2406,130),
(2408,130),
(440,205),
(636,55),
(463,55),
(406,55),
(1112,330),
(357,205),
(1108,205),
(1121,205),
(1120,205),
(1117,205),
(1116,205),
(2521,205),
(1227,330),
(1222,330),
(3140,330),
(16,205),
(1234,205),
(878,205),
(3479,-70),
(2597,330),
(1417,205),
(4374,395),
(214,55),
(3455,250),
(4258,430),
(5034,430),
(35,55),
(1578,55),
(4747,55),
(5031,350),
(5038,350),
(5044,350),
(5389,350),
(5534,350),
(5535,350),
(5536,350),
(5538,350),
(5545,350),
(5546,350),
(4290,435);
/*!40000 ALTER TABLE `skill_fishing_base_level` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

