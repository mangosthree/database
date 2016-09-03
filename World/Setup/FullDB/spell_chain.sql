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
-- Table structure for table `spell_chain`
--

DROP TABLE IF EXISTS `spell_chain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spell_chain` (
  `spell_id` mediumint(9) NOT NULL DEFAULT '0',
  `prev_spell` mediumint(9) NOT NULL DEFAULT '0',
  `first_spell` mediumint(9) NOT NULL DEFAULT '0',
  `rank` tinyint(4) NOT NULL DEFAULT '0',
  `req_spell` mediumint(9) NOT NULL DEFAULT '0',
  PRIMARY KEY (`spell_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Spell Additinal Data';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spell_chain`
--

LOCK TABLES `spell_chain` WRITE;
/*!40000 ALTER TABLE `spell_chain` DISABLE KEYS */;
INSERT INTO `spell_chain` (`spell_id`, `prev_spell`, `first_spell`, `rank`, `req_spell`) VALUES
(34767,34769,34769,2,33391),
(13819,0,13819,1,0),
(587,0,587,1,0),
(597,587,587,2,0),
(990,597,587,3,0),
(6129,990,587,4,0),
(10144,6129,587,5,0),
(10145,10144,587,6,0),
(28612,10145,587,7,0),
(33717,28612,587,8,0),
(759,0,759,1,0),
(3552,759,759,2,0),
(10053,3552,759,3,0),
(10054,10053,759,4,0),
(27101,10054,759,5,0),
(42985,27101,759,6,0),
(42955,0,42955,1,0),
(42956,42955,42955,2,0),
(5504,0,5504,1,0),
(5505,5504,5504,2,0),
(5506,5505,5504,3,0),
(6127,5506,5504,4,0),
(10138,6127,5504,5,0),
(10139,10138,5504,6,0),
(10140,10139,5504,7,0),
(37420,10140,5504,8,0),
(27090,37420,5504,9,0),
(339,0,339,1,0),
(16689,0,16689,1,339),
(26573,0,26573,1,0),
(20116,26573,26573,2,0),
(34769,0,34769,1,0),
(23214,13819,13819,2,33391),
(28672,11611,2259,5,0),
(28675,11611,2259,5,0),
(28677,11611,2259,5,0),
(9787,9785,2018,5,0),
(9788,9785,2018,5,0),
(17039,9787,2018,6,0),
(17040,9787,2018,6,0),
(17041,9787,2018,6,0),
(20219,12656,4036,5,0),
(20222,12656,4036,5,0),
(10656,10662,2108,5,0),
(10658,10662,2108,5,0),
(10660,10662,2108,5,0),
(26797,12180,3908,5,0),
(26798,12180,3908,5,0),
(26801,12180,3908,5,0),
(27813,0,27813,1,0),
(27817,27813,27813,2,0),
(27818,27817,27813,3,0),
(53672,0,53672,1,0),
(54149,53672,53672,2,0);
/*!40000 ALTER TABLE `spell_chain` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

