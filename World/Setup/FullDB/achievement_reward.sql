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
-- Table structure for table `achievement_reward`
--

DROP TABLE IF EXISTS `achievement_reward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `achievement_reward` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `gender` tinyint(3) NOT NULL DEFAULT '2',
  `title_A` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `title_H` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `item` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `sender` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `subject` varchar(255) DEFAULT NULL,
  `text` text,
  PRIMARY KEY (`entry`,`gender`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Achievment system';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `achievement_reward`
--

LOCK TABLES `achievement_reward` WRITE;
/*!40000 ALTER TABLE `achievement_reward` DISABLE KEYS */;
INSERT INTO `achievement_reward` (`entry`, `gender`, `title_A`, `title_H`, `item`, `sender`, `subject`, `text`) VALUES
(45,2,0,0,43348,28070,'You\'ve Been Around!','Well, look at ye!$b$bAnd I thought I had seen some things in this icy place! It seems obvious to this dwarf that you have the fire of the explorer burning in your eyes.$b$bWear this tabard with pride. That way your friends will know who to ask for directions when the time comes!$b$bKeep on the move!$b$b-Brann Bronzebeard'),
(46,2,78,78,0,0,NULL,NULL),
(230,2,72,72,0,0,NULL,NULL),
(456,2,139,139,0,0,NULL,NULL),
(614,2,0,0,44223,29611,'For the Alliance!','War rages throughout our lands. Only the bravest heroes dare challenge strike the Horde where it hurts them most. You are among such heroes.$b$bThe blows you have delivered to the leadership of the Horde will open the door for our final assault. The Horde will bow down to the might of the Alliance.$b$bYour deeds will not go unrewarded. Ride on proudly!$b$b--Your King'),
(619,2,0,0,44224,4949,'For The Horde!','In this time of great turmoil true heroes rise from the misery. You are one such great hero.$b$bWar is upon us. Your efforts will further our cause on Azeroth. Your great feats shall go rewarded. Take this prize of Orgrimmar and ride to glory.$b$bFor the Horde!$b$bWarchief Thrall'),
(714,2,47,47,0,0,NULL,NULL),
(762,2,130,130,0,0,NULL,NULL),
(870,2,126,127,0,0,NULL,NULL),
(871,2,144,144,0,0,NULL,NULL),
(907,2,48,48,0,0,NULL,NULL),
(913,2,74,74,0,0,NULL,NULL),
(942,2,79,79,0,0,NULL,NULL),
(943,2,79,79,0,0,NULL,NULL),
(945,2,131,131,0,0,NULL,NULL),
(948,2,130,130,0,0,NULL,NULL),
(953,2,132,132,0,0,NULL,NULL),
(978,2,81,81,0,0,NULL,NULL),
(1015,2,77,77,0,0,NULL,NULL),
(1021,2,0,0,40643,29261,'Quite the Achiever','I couldn\'t help but notice what a fine collection of Tabards you\'ve managed to collect over the seasons. You might as well add this one to your collection. It\'s simply been gathering dust in my wardrobe.'),
(1038,2,75,75,0,0,NULL,NULL),
(1039,2,76,76,0,0,NULL,NULL),
(1174,2,82,82,0,0,NULL,NULL),
(1175,2,72,72,0,0,NULL,NULL),
(1250,2,0,0,40653,28951,'Stinker\'s New Home','I\'ve heard how well you take care of our furry friends. I hope you don\'t mind but I must get Stinker a new home. He just refuses to play nice with others.$b$bPlease make sure to feed him twice a day. And um... he has a thing for black cats.$b$b--Breanni'),
(1400,2,120,120,0,0,NULL,NULL),
(1402,2,122,122,0,0,NULL,NULL),
(1516,2,83,83,0,0,NULL,NULL),
(1563,2,84,84,0,0,NULL,NULL),
(1656,2,124,124,0,0,NULL,NULL),
(1657,2,124,124,0,0,NULL,NULL),
(1658,2,129,129,0,0,NULL,NULL),
(1681,2,125,125,43300,7999,'Greetings From Darnassus','Your accomplishments have been profound and far-reaching. Azeroth, with all of the recent turmoil, benefits greatly from those who seek to rid the land of evil.$b$bOnly those who take the time to know our lands understand the sacrifices of the fallen and the valor of our heroes. You are one such hero. Hopefully, you will recant the tales of your adventures for years to come.$b$bOn behalf of the Alliance, I thank you, Loremaster.'),
(1682,2,125,125,43300,3057,'Greetings From Thunder Bluff','News of your accomplishments has traveled far. The winds of turmoil howl through our lands. Those who stand to challenge evil are our only hope.$b$bOnly those who listen to the winds understand the debts our fallen heroes have paid to protect our people. May a hero such as yourself live long to tell the tales of your adventures. For only then will we remember how much we have to be thankful for.$b$bOur appreciation runs deep, Loremaster.$b$bFor the Horde!$b$b--Cairne Bloodhoof'),
(1683,2,133,133,0,0,NULL,NULL),
(1684,2,133,133,0,0,NULL,NULL),
(1691,2,134,134,0,0,NULL,NULL),
(1692,2,134,134,0,0,NULL,NULL),
(1693,2,135,135,0,0,NULL,NULL),
(1707,2,135,135,0,0,NULL,NULL),
(1784,2,84,84,0,0,NULL,NULL),
(1793,0,138,138,0,22914,'Thank you!','Dear $N.$b$bThank you for taking me out during Children\'s Week. Lady Liadrin, the leader of the Blood Knights, has asked that I be released to her custody for training in Silvermoon City!$b$bI just wanted to thank you for taking me to see my friend, Hch\'uu, as well as the Dark Portal, the Throne of the Elements and the Caverns of Time. I like my toy dragon very much!$b$bI\'m sure that you\'re taking good care of my pet. Please tell him that I miss him!$b$bSincerely,$bSalandria.'),
(1956,2,0,0,43824,16128,'Higher Learning','Congratulations on completing your studies on The Schools of Arcane Magic. In recognition of your dedication. I\'m enclosing this special volume completing the series.$b$bI believe you\'ll find this tome particularly entertaining. But I\'ll leave that for your discovery.$b$bSincerely,$b$bRhonin'),
(2051,2,140,140,0,0,NULL,NULL),
(2054,2,121,121,0,0,NULL,NULL),
(2096,2,0,0,44430,29478,'The Coin Master','Greetings and congratulations on collecting the full set of Dalaran coins! As a reward for all your hard work I have enclosed a freshly minted Titanium Seal of Dalaran. This is a special coin that we only grant to the most ardent of collectors.$b$bI hope you enjoy this special reward. You\'ve earned it!$b$bSincerely,$b$bJepetto Joybuzz'),
(2136,2,0,0,44160,26917,'Glory of the Hero','Champion,$b$bWord has traveled to Wyrmrest Temple of the great heroic deeds you have accomplished since arriving in Northrend.$b$bYour bravery should not go unrecognized. Please accept this gift on behalf of the Aspects. Together we shall rid Azeroth of evil, once and for eternity.$b$bAlexstrasza the Life-Binder'),
(2143,2,0,0,44178,32216,'Leading the Cavalry','I couldn\'t help but to notice how good you are with the livestock. With all the activity around here, business has been better than ever for me. I don\'t suppose you\'d mind looking after this Albino Drake for me? I simply don\'t have enough spare minutes in the day to care for all of these animals.$b$bYours,$bMei'),
(2186,2,141,141,0,0,NULL,NULL),
(2187,2,142,142,0,0,NULL,NULL),
(2188,2,143,143,0,0,NULL,NULL),
(2516,2,0,0,44841,28951,'Lil\' Game Hunter','Hello!$b$bI understand you\'ve managed to give even that mischievous Stinker a warm and loving home... I was hoping you might consider taking in another wayward orphan?$b$bThis little fawn is a shy one, but you\'ll have no trouble winning her friendship with the enclosed: her favorite salt lick!$b$b--Breanni'),
(2769,2,154,154,0,0,NULL,NULL),
(2765,2,150,150,0,0,NULL,NULL),
(2763,2,148,148,0,0,NULL,NULL),
(2766,2,151,151,0,0,NULL,NULL),
(2764,2,149,149,0,0,NULL,NULL),
(2761,2,146,146,0,0,NULL,NULL),
(2768,2,153,153,0,0,NULL,NULL),
(2760,2,147,147,0,0,NULL,NULL),
(2767,2,152,152,0,0,NULL,NULL),
(2816,2,156,156,0,0,NULL,NULL),
(2817,2,156,156,0,0,NULL,NULL),
(2536,2,0,0,44843,32216,'Mountain o\' Mounts','I\'ve heard your stables are nearly as extensive as mine, now. Impressive! Perhaps we can help one another...$b$bI\'ve one too many dragonhawks, and hoped you could give this one a home. Naturally it\'s been trained as a mount and not a hunting pet, and you\'ll find it as loyal and tireless as any other steed I raise.$b$bYours again,$bMei'),
(2537,2,0,0,44842,32216,'Mountain o\' Mounts','I\'ve heard your stables are nearly as extensive as mine, now. Impressive! Perhaps we can help one another...$b$bI\'ve one too many dragonhawks, and hoped you could give this one a home. Naturally it\'s been trained as a mount and not a hunting pet, and you\'ll find it as loyal and tireless as any other steed I raise.$b$bYours again,$bMei'),
(876,2,0,0,43349,29533,'Brutally Dedicated','I\'ve been watching you, kid.$b$bYou\'ve got quite a knack for throwing down in that arena. Keep this. Wear it with pride. Now get back in there and show them how it\'s done!$b$bUncle Sal'),
(2336,2,145,145,0,0,NULL,NULL),
(2762,2,113,113,0,0,NULL,NULL),
(2797,2,155,155,0,0,NULL,NULL),
(2798,2,155,155,0,0,NULL,NULL),
(3117,2,158,158,0,0,NULL,NULL),
(3259,2,159,159,0,0,NULL,NULL),
(2904,2,160,160,0,0,NULL,NULL),
(2903,2,161,161,0,0,NULL,NULL),
(3036,2,164,164,0,0,NULL,NULL),
(3037,2,165,165,0,0,NULL,NULL),
(3316,2,166,166,0,0,NULL,NULL),
(3478,2,168,168,44810,28951,'A Gobbler not yet Gobbled','Can you believe this Plump Turkey made it through November alive?$b$bSince all this friends have been served up on Bountiful Tables with sides of Cranberry Chutney and Spice Bread Stuffing and... ooo... I\'m getting hungry. But anyhow! He\'s all alone, now, so I was hoping you might be willing to take care of him. There simply isn\'t enough room left in my shop!$b$bJust keep him away from cooking fires, please. He gets this strange look in his eyes around them...'),
(4078,2,170,170,0,0,NULL,NULL),
(4080,2,171,171,0,0,NULL,NULL),
(2957,2,0,0,45802,30405,'Glory of the Ulduar Raider','Dear $N,$b$bI hope ye\'re doing well and that ye\'ve had time to recover from our shenanigans in Ulduar$b$bMe lads from the prospecting team happened upon this poor \'alf dead riding-drake hatchling. Must\'ve been an Iron Dwarf experiment of some sort.$b$bWe\'ve patched him back to health and you\'ll find he\'s not so wee anymore! None of us knows much about riding anything but rams and pack mules and since we owed ye one for what ye did back there... We thought perhaps you\'d accept him as a gift.$b$bYours,$bBrann Bronzebeard'),
(2958,2,0,0,45801,30405,'Heroic: Glory of the Ulduar Raider','Dear $N,$b$bI hope ye\'re doing well and that ye\'ve had time to recover from our shenanigans in Ulduar.$b$bMe lads from the prospecting team happened upon this poor \'alf dead riding-drake hatchling. Must\'ve been an Iron Dwarf experiment of some sort.$b$bWe\'ve patched him back to health and you\'ll find he\'s not so wee anymore! None of us knows much about riding anything but rams and pack mules and since we owed ye one for what ye did back there... We thought perhaps you\'d accept him as a gift.$b$bYours,$bBrann Bronzebeard'),
(2144,2,0,0,44177,26917,'What A Long, Strange Trip It\'s Been','With the drums of war pounding in the distance, it is easy for the denizens of Azeroth to forget all that life has to offer. You, on the other hand, have maintained the dignity of the good races of Azeroth with your ability to remeber what we fight for. To not celebrate our victories is another form of defeat. Remeber that well, reveler. May others be inspired by your good cheer, Alexstrasza the Life-Binder'),
(2145,2,0,0,44177,26917,'What A Long, Strange Trip It\'s Been','With the drums of war pounding in the distance, it is easy for the denizens of Azeroth to forget all that life has to offer. You, on the other hand, have maintained the dignity of the good races of Azeroth with your ability to remeber what we fight for. To not celebrate our victories is another form of defeat. Remeber that well, reveler. May others be inspired by your good cheer, Alexstrasza the Life-Binder'),
(3957,2,0,0,49054,34922,'Master of Isle of Conquest','Honorable $N,$b$bFor your deeds upon the Isle of Conquest, it is my honor to present you with this tabard. Wear it proudly.$b$bOverlord Agmar'),
(4477,2,172,172,0,0,NULL,NULL),
(4530,2,175,175,0,0,NULL,NULL),
(4583,2,174,174,0,0,NULL,NULL),
(4584,2,173,173,0,0,NULL,NULL),
(4597,2,175,175,0,0,NULL,NULL),
(4598,2,176,176,0,0,NULL,NULL),
(3857,2,0,0,49052,34924,'Master of Isle of Conquest','Honorable $N,$b$bFor your deeds upon the Isle of Conquest, it is my honor to present you with this tabard. Wear it proudly.$b$bHigh Commander Halford Wyrmbane'),
(3656,2,168,168,44810,28951,'A Gobbler not yet Gobbled','Can you believe this Plump Turkey made it through November alive?$b$bSince all this friends have been served up on Bountiful Tables with sides of Cranberry Chutney and Spice Bread Stuffing and... ooo... I\'m getting hungry. But anyhow! He\'s all alone, now, so I was hoping you might be willing to take care of him. There simply isn\'t enough room left in my shop!$b$bJust keep him away from cooking fires, please. He gets this strange look in his eyes around them...'),
(4478,2,0,0,49912,32842,'P.U.G.','Dear very patient individual,$b$bWe\'d like to recognize your tenacity in running dungeons with people you probably haven\'t met before. Hopefully you even showed some rookies the ropes in your pick-up groups.$b$bIn short, we heard you like pugs. So here\'s a pug for your pug, so you can pug while you pug. Or something.$b$bHugs,$b$bYour friends on the WoW Dev Team.'),
(4602,2,0,0,51954,37120,'Glory of the Icecrown Raider','$N,$b$bAs the Lich King\'s influence wanes, some of his more powerful, minions have wrested free of his grasp.$b$bThis frost wyrm drake my men captured is a prime example. She has a will of her own and then some.$b$bOne of my men lost an arm breaking her in, but she how takes to riders fairly well - provided they themselves are skilled and strong willed.$b$bPlease accept this magnificent beast as a gift from the knights of the Ebon Blade. It was a honor to fight along your side in this greatest of battles.$b$bWith honor,$bDarion Mograine'),
(1793,1,137,137,0,22914,'Thank you!','Dear $N.$b$bThank you for taking me out during Children\'s Week. Lady Liadrin, the leader of the Blood Knights, has asked that I be released to her custody for training in Silvermoon City!$b$bI just wanted to thank you for taking me to see my friend, Hch\'uu, as well as the Dark Portal, the Throne of the Elements and the Caverns of Time. I like my toy dragon very much!$b$bI\'m sure that you\'re taking good care of my pet. Please tell him that I miss him!$b$bSincerely,$bSalandria.'),
(13,2,0,0,41426,16128,'Level 80','Congratulations on your conviction to reach the 80th season of adventure. You are undoubtedly dedicated to the cause of ridding Azeroth of the evils which have plagued us.$b$bAnd while the journey thus far has been no minor feat, the true battle lies ahead.$b$bFight on!$b$bRhonin'),
(4603,2,0,0,51955,37120,'Heroic: Glory of the Icecrown Raider','$N,$b$bAs the Lich King\'s influence wanes, some of his more powerful, minions have wrested free of his grasp.$b$bThis frost wyrm drake my men captured is a prime example. She has a will of her own and then some.$b$bOne of my men lost an arm breaking her in, but she how takes to riders fairly well - provided they themselves are skilled and strong willed.$b$bPlease accept this magnificent beast as a gift from the knights of the Ebon Blade. It was a honor to fight along your side in this greatest of battles.$b$bWith honor,$bDarion Mograine'),
(4079,2,0,0,49098,36095,'A Tribute to Immortality','Dear $N.$b$bTales of your recent performance in the Trial of the Grand Crusader will be told, and retold, for ages to come. As the Argent Crusade issued its call for the greatest champions of Azeroth to test their mettle in the crucible of the Coliseum. I hoped against hope that beacons of light such as you and your companions might emerge from the fray.$b$bWe will need your direly in the coming battle against the Lich King. But on this day, rejoice and celebrate your glorious accomplishment, and accept this gift of one of our very finest warhorses. When the Scourge see its banner looming on thee horizon. Hero, their end shall be nigh!$b$bYours with Honor.$bTirion Fordring'),
(4156,2,0,0,49096,36095,'A Tribute to Immortality','Dear $N.$b$bTales of your recent performance in the Trial of the Grand Crusader will be told, and retold, for ages to come. As the Argent Crusade issued its call for the greatest champions of Azeroth to test their mettle in the crucible of the Coliseum. I hoped against hope that beacons of light such as you and your companions might emerge from the fray.$b$bWe will need your direly in the coming battle against the Lich King. But on this day, rejoice and celebrate your glorious accomplishment, and accept this gift of one of our very finest warhorses. When the Scourge see its banner looming on thee horizon. Hero, their end shall be nigh!$b$bYours with Honor.$bTirion Fordring'),
(5123,2,226,226,0,0,NULL,NULL),
(5803,2,278,278,0,0,NULL,NULL),
(5116,2,229,229,0,0,NULL,NULL),
(5121,2,228,228,0,0,NULL,NULL),
(5879,2,276,276,0,0,NULL,NULL),
(5827,2,267,267,0,0,NULL,NULL),
(5767,2,258,258,0,0,NULL,NULL),
(5343,2,208,208,0,0,NULL,NULL),
(5330,2,195,195,0,0,NULL,NULL),
(5332,2,197,197,0,0,NULL,NULL),
(5334,2,199,199,0,0,NULL,NULL),
(5350,2,214,214,0,0,NULL,NULL),
(5347,2,211,211,0,0,NULL,NULL),
(5348,2,212,212,0,0,NULL,NULL),
(5345,2,209,209,0,0,NULL,NULL),
(5363,2,225,225,0,0,NULL,NULL),
(5506,2,227,227,0,0,NULL,NULL),
(5357,2,207,207,0,0,NULL,NULL),
(5349,2,213,213,0,0,NULL,NULL),
(5346,2,210,210,0,0,NULL,NULL),
(5355,2,220,220,0,0,NULL,NULL),
(5356,2,222,222,0,0,NULL,NULL),
(5335,2,200,200,0,0,NULL,NULL),
(5337,2,202,202,0,0,NULL,NULL),
(5336,2,201,201,0,0,NULL,NULL),
(5339,2,204,204,0,0,NULL,NULL),
(5333,2,198,198,0,0,NULL,NULL),
(5341,2,206,206,0,0,NULL,NULL),
(5352,2,216,216,0,0,NULL,NULL),
(5354,2,219,219,0,0,NULL,NULL),
(5359,2,203,203,0,0,NULL,NULL),
(5331,2,196,196,0,0,NULL,NULL),
(5340,2,205,205,0,0,NULL,NULL),
(5338,2,217,217,0,0,NULL,NULL),
(5353,2,218,218,0,0,NULL,NULL),
(5351,2,215,215,0,0,NULL,NULL),
(4856,2,191,191,0,0,NULL,NULL),
(4855,2,190,190,0,0,NULL,NULL),
(4854,2,189,189,0,0,NULL,NULL),
(6116,2,285,285,0,0,NULL,NULL),
(6177,2,287,287,0,0,NULL,NULL),
(5860,2,0,0,69838,40578,'Please... Just Take It','Ever since his brother was taken away. This little creature has been nothing short of a handful. The guardians and I have done everything we can to contain his energy, but our efforts have fallen depressingly short. It is now clear.$b$bHe wants to be with his brother.$b$bIt took us nearly an hour to get him contained. Please, take him with you. Perhaps some time outside of this cavern will do him good.$b$b-Farden Talonshrike'),
(5859,2,0,0,69854,52825,'Left Behind','I found this locket in the Igneous Depths, near the lava\'s edge. It is not mine, and I know that it does not belong to either of the Arch Druids. Perhaps it belonged to one of the fire druids.$b$bNo matter who its owner, I have no use for it. Please take it as a small token of our appreciation for all you\'ve done for us.'),
(5866,2,0,0,69213,52135,'A Gift From the Arch Druid','Never again will Hyjal shudder beneath the endless forces of flame. Never again shall the mortal races of the world tremble before the minions of Ragnaros.$b$bNow, thanks to your efforts, they will tremble before us.$b$bYour heroism on the Molten Front has been instrumental in the fight against the Firelord. You have gathered allies from all over Kalimdor and turned them into an army. You have fought the minions of Ragnaros... And prevailed. And for that, you have our deepest thanks.'),
(5449,2,0,0,60869,34337,'Recovered Item','We recovered a lost item in the Twisting Nether and noted that it was yours.$b$bPlease find said object enclosed.'),
(4845,2,0,0,62900,53905,'Glory of the Cataclysm Hero','Champion,$b$bI have received word of your great deeds from my allies in the Earthen Ring. Many have taken up arms in defense of our troubled world, but your achievements are of particular note.$b$bPlease accept this gift in recognition of your skill and bravery. With heroes like you and your comrades assisting our cause, we may yet prevail.$b$bThrall'),
(5877,2,0,0,71387,28951,'Keep Collecting!','Hello!$b$bWow, you\'re becoming quite the collector of cute critters, aren\'t you?$b$bI thought I\'d write a small note and send a small gift to encourage your efforts. Keep it up!$b$b--Breanni'),
(5876,2,0,0,71140,28951,'I\'m Going Nuts!','Hello again. Friend!$b$bThis mischievous little fellow is driving everyone in the pet store nuts!$b$bI thought you might take him along on some of your adventures... Perhaps he\'ll calm down after he\'s seen a bit of the world.$b$bYou DO wear a helmet, right... ?$b$b--Breanni'),
(5875,2,0,0,54810,28951,'Keep Collecting!','Hello!$b$bWow, you\'re becoming quite the collector of cute critters, aren\'t you?$b$bI thought I\'d write a small note and send a small gift to encourage your efforts. Keep it up!$b$b--Breanni'),
(4853,2,0,0,62901,53905,'Glory of the Cataclysm Raider','Champion,$b$bI have received word of your great deeds from my allies in the Earthen Ring. Many have taken up arms in defense of our troubled world, but your achievements are of particular note.$b$bYour bravery should not go unrecognized. Please accept this gift on behalf of the Earthen Ring. With heroes like you and your comrades assisting our cause, we may yet prevail.$b$bThrall'),
(6169,2,0,0,77068,53905,'Glory of the Dragon Soul Raider','Champion,$b$bYour actions turned the tide in the great battle against Deathwing, and we could not have succeeded without your aid. You battled with bravery and valor, overcoming the Destroyer\'s armies though you were beset with adversity at every turn.$b$bWith the fall of Deathwing and the Twilight Hammer, a new age dawns. The future remains uncertain, but it is assuredly a better one thanks to your efforts. Enclosed is a small token of our profound appreciation.$b$bThrall'),
(5828,2,0,0,69230,53385,'Glory of the Firelands Raider','Champion,$b$bWhen the world\'s strongest rose to the rallying call of the Avengers of Hyjal, you stood among the very greatest of them, the best and the bravest who dared all in that maw of fire and hatred.$b$bIt is for this reason that I ask a boon of you:$b$bA clutch of Millagazor\'s eggs has been discovered, tainted by the otherworldly vileness of the Twilight\'s Hammer. Rather than destroying what remains of her brood, it is my hope that champions such as you, through strength of character and force of will, can tame the ill-fated hatchlings, offering them lives as noble steeds and companions rather than doomed monstrosities.$b$bWill you honor my humble request and take this egg, to raise it as your own...?$b$bMalfurion Stormrage'),
(5824,2,0,0,70910,39605,'Horde War Wolf','How many Alliance heads have fallen into the dust by your hand? How many Victories won, enemies crushed, battefields(sic) taken?$b$bThe eyes of Hellscream have been upon you, and they are pleased. Ride on proudly, for the Horde!$b$b--Warchief Garrosh Hellscream'),
(5823,2,0,0,70909,29611,'Alliance War Steed','Time and again your skill and bravery have been proven on the field of battle.$b$bYour deeds will not go unrewarded. Ride on proudly, for the Alliance!$b$b--Your King'),
(5325,2,194,194,70910,39605,'Horde War Wolf','How many Alliance heads have fallen into the dust by your hand? How many Victories won, enemies crushed, battefields(sic) taken?$b$bThe eyes of Hellscream have been upon you, and they are pleased. Ride on proudly, for the Horde!$b$b--Warchief Garrosh Hellscream'),
(5328,2,193,193,70909,29611,'Alliance War Steed','Time and again your skill and bravery have been proven on the field of battle.$b$bYour deeds will not go unrewarded. Ride on proudly, for the Alliance!$b$b--Your King'),
(5326,2,259,259,70910,39605,'Horde War Wolf','How many Alliance heads have fallen into the dust by your hand? How many Victories won, enemies crushed, battefields(sic) taken?$b$bThe eyes of Hellscream have been upon you, and they are pleased. Ride on proudly, for the Horde!$b$b--Warchief Garrosh Hellscream'),
(5329,2,260,260,70909,29611,'Alliance War Steed','Time and again your skill and bravery have been proven on the field of battle.$b$bYour deeds will not go unrewarded. Ride on proudly, for the Alliance!$b$b--Your King');
/*!40000 ALTER TABLE `achievement_reward` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

