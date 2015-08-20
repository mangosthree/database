-- MySQL dump 10.13  Distrib 5.5.34, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: realmd
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.13.10.1


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
-- Table structure for table `dbdocsfields` 
--

DROP TABLE IF EXISTS `dbdocsfields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbdocsfields` (
  `fieldId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique Id for this field',
  `languageId` int(11) NOT NULL DEFAULT '0' COMMENT 'dbdocsLanguageId to link to. (Normallu 0 = English)',
  `tableName` varchar(80) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name of the table to link to',
  `fieldName` varchar(80) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name of the field to link the note to',
  `fieldComment` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Main field Note',
  `fieldNotes` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Additional Field Notes',
  PRIMARY KEY (`fieldId`,`languageId`),
  KEY `fieldId` (`fieldId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Data for the table `dbdocsfields`
--

LOCK TABLES `dbdocsfields` WRITE;
/*!40000 ALTER TABLE `dbdocsfields` DISABLE KEYS */;
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','active_realm_id','The realmlist uniqui ID of realm server','This references the realmlist tables unique ID of the realm server on which the account is currently active. This will allow the game client to connect to the realm the account was active on at the last login.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','email','The e-mail address associated with this account.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','expansion','The field controls to which expansion\'s content a user has access.','By default this is set to 0, allowing access to vanilla WoW content. In mangos-zero, other values can be ignored, since there is no expansion.<br />\r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Value</b></th>\r\n<th align=\'left\'><b>Expansion</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0</td><td align=\'left\' valign=\'middle\'>World of Warcraft *</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n1</td><td align=\'left\' valign=\'middle\'>Burning Crusade </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n2</td><td align=\'left\' valign=\'middle\'>Wrath of the Lich King </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n3</td><td align=\'left\' valign=\'middle\'>Cataclysm </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n4</td><td align=\'left\' valign=\'middle\'>Mists of Pandaria</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n5</td><td align=\'left\' valign=\'middle\'>Warlords of Draenor</td></tr>\r\n</table>\r\n<br />\r\n* Base Game Version of World of Warcraft, otherwise known as Vanilla.\r\n<br />\r\nThe world server will block access to accounts with 0 in this field from accessing the TBC and WotLK areas in-game.\r\n<br />\r\nThe world server will block access to accounts with 1 in this field from accessing the WotLK areas in-game and so on.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','failed_logins','The number of failed logins attempted on the account.','Monitoring this field may help spotting users who try to gain access to accounts which are not their own, or who have forgotten their passwords.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','gmlevel','The account security level. Different levels have access to different commands.','The individual level required for a command is defined in the Mangos command table. Valid values are:<br />\r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Value</b></th>\r\n<th align=\'left\'><b>Description</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0</td><td align=\'left\' valign=\'middle\'>Player </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n1</td><td align=\'left\' valign=\'middle\'>Moderator </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n2</td><td align=\'left\' valign=\'middle\'>Gamemaster </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n3</td><td align=\'left\' valign=\'middle\'>Administrator </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n4</td><td align=\'left\' valign=\'middle\'>Access control within the world server console only </td></tr>\r\n</table>');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','id','The unique account ID.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','joindate','The date when the account was created.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','last_ip','The last IP used by the person who last logged into the account.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','last_login','The date when the account was last logged into.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','locale','The locale used by the client logged into this account.','If multiple locale data has been configured and added to the world servers, the world servers will return the proper locale strings to the client. \r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Value</b></th>\r\n<th align=\'left\'><b>Language</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0</td><td align=\'left\' valign=\'middle\'>English </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n1</td><td align=\'left\' valign=\'middle\'>Korean </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n2</td><td align=\'left\' valign=\'middle\'>French </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n3</td><td align=\'left\' valign=\'middle\'>German </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n4</td><td align=\'left\' valign=\'middle\'>Chinese </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n5</td><td align=\'left\' valign=\'middle\'>Taiwanese </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n6</td><td align=\'left\' valign=\'middle\'>Spanish Spain </td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>\r\n7</td><td align=\'left\' valign=\'middle\'>Spanish Latin America </td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>\r\n8</td><td align=\'left\' valign=\'middle\'>Russian </td></tr>\r\n</table>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','locked','Boolean 0 or 1 controlling if the account has been locked or not.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','mutetime','The time, in Unix time, when the account will be unmuted.','<pre>SELECT `username`, FROM_UNIXTIME(`mutetime`) FROM `account`;</pre>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','s','Session \'Salt\' Value.','Initially a randomly generated value, which when applied against the SHA1 hash of the username / password combo (See account.sha_pass_hash) produces the validation hash (See account.v).\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','sessionkey','The SessionKey - this is the validated result of the login negotiation.','This allows disconnected clients to reconnection to their previous session.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','sha_pass_hash','This field contains the encrypted password.','The encryption is SHA1 and is in the following format: username:password. The SQL to create the password (or to compare with the current hash) is:\r\n<pre>SELECT SHA1(CONCAT(UPPER(`username`), \':\', UPPER({pass})));</pre>');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account','username','The account user name.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account','v','The validated Hash Value','This is created by using the \'Salt\' value (See account.s) applied to the username/password SHA1 hash (See account.sha_pass_hash).');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account_banned','active','This is a Boolean field controlling if the ban is currently active or not.<br />\r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Value</b></th>\r\n<th align=\'left\'><b>Meaning</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0</td><td align=\'left\' valign=\'middle\'>Ban Active</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>1</td><td align=\'left\' valign=\'middle\'>Ban Inactive</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'></tr>\r\n</table>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account_banned','bandate','The date when the account was banned, in Unix time.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account_banned','bannedby','The character with the rights to the .ban command that banned the account.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account_banned','banreason','The reason for the ban.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('account_banned','id','The account ID (See account.id).');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('account_banned','unbandate','The date when the account will be automatically unbanned, in Unix time.','A value less than the current date means, in effect, a permanent ban.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('dbdocsfields','fieldName','The fieldname in the table to link the note to.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('dbdocsfields','fieldNotes','The Field Note text');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('dbdocsfields','tableName','The table name to link the note to.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('dbdocstable','tableName','The table name to link the note to.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('dbdocstable','tableNotes','The table note text.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('ip_banned','bandate','The date when the IP was first banned, in Unix time.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('ip_banned','bannedby','The name of the character that banned the IP.','The character should belong to an account with the rights to the .ban command in-game.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('ip_banned','banreason','The reason given for the IP ban.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('ip_banned','ip','The IP address that is banned.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('ip_banned','unbandate','The date when the IP will be unbanned in Unix time.','Any date that is set lower than the current date basically classifies as a permanent ban as it will never auto expire.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('realmcharacters','acctid','The account ID (See account.id).');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('realmcharacters','numchars','The number of characters the account has on the realm.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('realmcharacters','realmid','The ID of the realm (See realmlist.id).');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('realmd_db_version','required_update_file','The Version of the Realm Database');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','address','The public IP address of the world server.','127.0.0.1 works for LAN play only.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','allowedSecurityLevel','The minimum account gmlevel required to log in (See account.gmlevel).','The minimum account (See account.gmlevel) required for accounts to log in to this realm. Normally 0 - that means normal players allowed on this realm. Just useful if you make a GM-only developement realm.<br />\nChanging this value will automatically update the visible in-game realm list, but the realm server must be restarted for it to take effect.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','icon','The icon of the realm.','<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Icon</b></th>\r\n<th align=\'left\'><b>Meaning</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0</td><td align=\'left\' valign=\'middle\'>Normal</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>1</td><td align=\'left\' valign=\'middle\'>PvP</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>4</td><td align=\'left\' valign=\'middle\'>Normal</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>6</td><td align=\'left\' valign=\'middle\'>RP</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>8</td><td align=\'left\' valign=\'middle\'>RP PvP</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'></tr>\r\n</table>');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','id','The realm ID.','This number is unique for every realm and it MUST correlate with the RealmID configuration value in mangosd.conf.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','name','The name of the realm.','This will appear in the realm selection list as well as in the character selection screen.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','population','Show the current population level.','This field is automatically updated at regular intervals and will show the current population. The formula to calculate the value in this field is:<br />\r\n<pre>playerCount / maxPlayerCount * 2</pre><br />\r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Population</b></th>\r\n<th align=\'left\'><b>Displayed Population Level</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0.5</td><td align=\'left\' valign=\'middle\'>Low</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>1.0</td><td align=\'left\' valign=\'middle\'>Medium</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>2.0</td><td align=\'left\' valign=\'middle\'>High</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'></tr>\r\n</table>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','port','The port that the world server is running on.','Default is 8085. If you will run more than one world server on the same machine, e.g. develop and production, they will all need to use a different port.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','realmbuilds','The accepted client builds that the realm will accept.','(You can see this version at the clients left lower corner when starting.)<br />\r\nThe format is version No. {space} version No. (i.e. space separated) <pre>xxxx xxxx xxxx</pre><br />\r\nAcceptable values are:\r\n<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Core</b></th>\r\n<th align=\'left\'><b>Build Number(s)</b></th>\r\n<th align=\'left\'><b>Version Number</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>MangosZero</td><td align=\'left\' valign=\'middle\'>5875 6005 6141</td><td align=\'left\' valign=\'middle\'>Vanila 1.12.x</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>MangosOne</td><td align=\'left\' valign=\'middle\'>8606</td><td align=\'left\' valign=\'middle\'>TBC 2.4.3</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>MangosTwo</td><td align=\'left\' valign=\'middle\'>12340</td><td align=\'left\' valign=\'middle\'>WOTLK 3.3.5a</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>MangosThree</td><td align=\'left\' valign=\'middle\'>15595</td><td align=\'left\' valign=\'middle\'>Cataclysm 4.3.4</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>MangosFour</td><td align=\'left\' valign=\'middle\'>18414</td><td align=\'left\' valign=\'middle\'>Mists of Pandaria 5.4.8</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'></tr>\r\n</table>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','realmflags','Supported masks for the realm, based on the table below.','<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>Value</b></th>\r\n<th align=\'left\'><b>Meaning</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0x1</td><td align=\'left\' valign=\'middle\'>Invalid - Do Not show in Realm List</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>0x2</td><td align=\'left\' valign=\'middle\'>Offline - Set by mangosd</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0x4</td><td align=\'left\' valign=\'middle\'>Show version and build in Realm List</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>0x20</td><td align=\'left\' valign=\'middle\'>New Players - New Players Only</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>0x40</td><td align=\'left\' valign=\'middle\'>Recommended - sets the recommended option</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'></tr>\r\n</table>');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`,`fieldNotes`) values ('realmlist','timezone','The realm timezone, it will be displayed in the tabs of the realmlist.','<table border=\'1\' cellspacing=\'1\' cellpadding=\'3\' bgcolor=\'#f0f0f0\'>\r\n<tr bgcolor=\'#f0f0ff\'>\r\n<th><b>TimezoneId</b></th>\r\n<th align=\'left\'><b>Displayed Name</b></th>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>1</td><td align=\'left\' valign=\'middle\'>Development</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>2</td><td align=\'left\' valign=\'middle\'>United States</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>3</td><td align=\'left\' valign=\'middle\'>Oceanic</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>4</td><td align=\'left\' valign=\'middle\'>Latin America</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>5</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>6</td><td align=\'left\' valign=\'middle\'>Korea</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>7</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>8</td><td align=\'left\' valign=\'middle\'>English</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>9</td><td align=\'left\' valign=\'middle\'>German</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>10</td><td align=\'left\' valign=\'middle\'>French</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>11</td><td align=\'left\' valign=\'middle\'>Spanish</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>12</td><td align=\'left\' valign=\'middle\'>Russian</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>13</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>14</td><td align=\'left\' valign=\'middle\'>Taiwan</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>15</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>16</td><td align=\'left\' valign=\'middle\'>China</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>17</td><td align=\'left\' valign=\'middle\'>CN1</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>18</td><td align=\'left\' valign=\'middle\'>CN2</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>19</td><td align=\'left\' valign=\'middle\'>CN3</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>20</td><td align=\'left\' valign=\'middle\'>CN4</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>21</td><td align=\'left\' valign=\'middle\'>CN5</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>22</td><td align=\'left\' valign=\'middle\'>CN6</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>23</td><td align=\'left\' valign=\'middle\'>CN7</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>24</td><td align=\'left\' valign=\'middle\'>CN8</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>25</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>26</td><td align=\'left\' valign=\'middle\'>Test Server</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>27</td><td align=\'left\' valign=\'middle\'>Tournament</td></tr>\r\n<tr bgcolor=\'#FEFEFF\'><td align=\'center\' valign=\'middle\'>28</td><td align=\'left\' valign=\'middle\'>QA Server</td></tr>\r\n<tr bgcolor=\'#FFFFEE\'><td align=\'center\' valign=\'middle\'>29</td><td align=\'left\' valign=\'middle\'>CN9</td></tr>\r\n</table>\r\n');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('uptime','maxplayers','The maximum number of players connected');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('uptime','realmid','The realm id (See realmlist.id).');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('uptime','startstring','The time when the server started, formated as a readable string.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('uptime','starttime','The time when the server was started, in Unix time.');
insert  into `dbdocsfields`(`tableName`,`fieldName`,`fieldComment`) values ('uptime','uptime','The uptime of the server, in seconds.');
/*!40000 ALTER TABLE `dbdocsfields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dbdocstable`
--

DROP TABLE IF EXISTS `dbdocstable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dbdocstable` (
  `tableId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique ID of this entry',
  `languageId` int(11) NOT NULL DEFAULT '0' COMMENT 'The Language Id for the Notes (Normally 0 for English)',
  `tableName` varchar(80) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Name of the table to add additional notes to',
  `tableNotes` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'The additional note to be added to the table',
  PRIMARY KEY (`tableId`,`languageId`,`tableName`),
  KEY `tableId` (`tableId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Data for the table `dbdocstable`
--

LOCK TABLES `dbdocstable` WRITE;
/*!40000 ALTER TABLE `dbdocstable` DISABLE KEYS */;

insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('account','This table holds information on all available accounts.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('account_banned','This table lists all of the accounts that have been banned along with the date when (or if) the ban will expire.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('dbdocsfields','This table is part of the implementation of the \'Mangos Database Documentation\' (MDD) Project.\r\n\r\nAn entry in this table provides a link to the table and field to allow additional notes to describe the field in the Wiki.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('dbdocstable','This table is part of the implementation of the \'Mangos Database Documentation\' (MDD) Project.\r\n\r\nAn entry in this table provides a additional notes field to describe the database in the Wiki.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('ip_banned','This table contains all of the banned IPs and the date when (or if) the ban will expire.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('realmcharacters','This table holds information on the number of characters each account has for each realm.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('realmlist','This table holds information for the realms.');
insert  into `dbdocstable`(`tableName`,`tableNotes`) values ('uptime','This table holds the uptime of all realms. Each realm will automatically update it\'s latest entry\'s value until it crashes and a new record is added. Doing so also some statistical/historical information is collected - about the availability of your machine.');
/*!40000 ALTER TABLE `dbdocstable` ENABLE KEYS */;
UNLOCK TABLES;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;