-- ---------------------------------------- 
-- --        CLEAR DOWN THE TABLE        -- 
-- ---------------------------------------- 
TRUNCATE TABLE `instance_template`; 
-- ---------------------------------------- 
-- MySQL dump 10.13  Distrib 5.5.37, for Win32 (x86)
--
-- Host: localhost    Database: mangos3
-- ------------------------------------------------------
-- Server version	11.5.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@SESSION.TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `instance_template`
--

LOCK TABLES `instance_template` WRITE;
/*!40000 ALTER TABLE `instance_template` DISABLE KEYS */;
INSERT INTO `instance_template` (`map`, `parent`, `levelMin`, `levelMax`) VALUES 
(30,0,10,0),
(33,0,10,0),
(34,0,15,0),
(36,0,10,0),
(43,0,10,0),
(44,0,1,0),
(47,0,15,0),
(48,0,10,0),
(70,0,30,0),
(90,0,15,0),
(109,0,35,0),
(129,0,25,0),
(169,0,1,0),
(189,0,20,0),
(209,0,35,0),
(229,0,45,0),
(230,0,40,0),
(249,0,80,0),
(269,0,66,0),
(289,0,45,0),
(309,0,50,0),
(329,0,45,0),
(349,0,30,0),
(389,0,8,0),
(409,0,50,0),
(429,0,45,0),
(469,0,60,0),
(489,0,10,0),
(509,0,60,0),
(529,0,10,0),
(531,0,60,0),
(532,0,68,0),
(533,0,80,0),
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
(559,0,10,0),
(560,0,66,0),
(562,0,10,0),
(564,0,70,0),
(565,0,65,0),
(566,0,10,0),
(568,0,85,0),
(572,0,10,0),
(574,0,70,72),
(575,0,80,80),
(576,0,70,72),
(578,0,80,80),
(580,0,70,0),
(585,0,70,0),
(595,0,74,80),
(598,0,0,0),
(599,0,70,0),
(600,0,70,0),
(601,0,80,80),
(602,0,70,0),
(603,0,80,0),
(604,0,71,80),
(607,0,71,0),
(608,0,70,80),
(615,0,80,0),
(616,0,80,0),
(617,0,80,80),
(618,0,80,80),
(619,0,68,80),
(624,0,80,0),
(631,0,80,0),
(632,0,75,0),
(643,0,77,0),
(644,0,83,0),
(645,0,77,0),
(649,0,80,0),
(650,0,75,0),
(657,0,80,0),
(658,0,75,0),
(668,0,75,0),
(669,0,85,0),
(670,0,83,0),
(671,0,85,0),
(720,0,85,0),
(724,0,80,80),
(725,0,80,0),
(754,0,85,0),
(755,0,83,0),
(757,0,85,0),
(859,0,85,0),
(938,0,85,0),
(939,0,85,0),
(940,0,85,0),
(967,0,85,0);
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

-- Dump completed on 2024-08-31 20:16:57
