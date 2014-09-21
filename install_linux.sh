#!/usr/bin/env bash

# Quick install section
# This will automatically use the variables below to install the world databases without prompting then optimize them and exit
# To use: Set your environment variables below and change 'set quick=off' to 'set quick=on'
# -- Change the values below to match your server --

svr=localhost;
user=mangos;
pass=mangos;
port=3306;
wdb=mangos;

# -- Don't change past this point --
yesno=y;
dbpath=full_db;
updates_path=under_dev;

standart()
{
# Standard install section

echo ""
echo "MM   MM         MM   MM  MMMMM   MMMM   MMMMM"
echo "MM   MM         MM   MM MMM MMM MM  MM MMM MMM"
echo "MMM MMM         MMM  MM MMM MMM MM  MM MMM"
echo "MM M MM         MMMM MM MMM     MM  MM  MMM"
echo "MM M MM  MMMMM  MM MMMM MMM     MM  MM   MMM"
echo "MM M MM M   MMM MM  MMM MMMMMMM MM  MM    MMM"
echo "MM   MM     MMM MM   MM MM  MMM MM  MM     MMM"
echo "MM   MM MMMMMMM MM   MM MMM MMM MM  MM MMM MMM"
echo "MM   MM MM  MMM MM   MM  MMMMMM  MMMM   MMMMM"
echo "        MM  MMM http://getmangos.com"
echo "        MMMMMM"
echo ""
echo "Credits to: Factionwars, Nemok, BrainDedd and Antz"
echo "=================================================="
echo ""
read -p "What is your MySQL host name? [localhost] :"   svr 
if [ "$svr" = "" ]; then svr="localhost"; fi
read -p "What is your MySQL port? [3306] : "            port
if [ "$port" = "" ]; then port="3306"; fi
read -p "What is your MySQL user name? [mangos] : "     user
if [ "$user" = "" ]; then user="mangos"; fi
read -p "What is your MySQL password? [mangos] : "      pass
if [ "$pass" = "" ]; then pass="mangos"; fi
read -p "What is your World database name? [mangos] : " wdb
if [ "$wdb" = "" ]; then wdb="mangos"; fi
read -p "What is the name of a user that can create databases? [root] : " admin
if [ "$admin" = "" ]; then admin="root"; fi
read -p "What is the password of your user that can create databases? [root] : " adminpass
if [ "$adminpass" = "" ]; then adminpass="root"; fi
}

world()
{
echo "";
echo "This will wipe out your current World database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno

if [$yesno = "n"]; then 
echo "Installations has been interrupted"
echo "Press any key to continue"
read -p
exit; 
fi

echo ""
echo "Droping World database"
mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port -e "drop database $wdb;"
echo ""
echo "Creating World database"
mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port -e "CREATE DATABASE $wdb DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, LOCK TABLES ON $wdb.* TO '$user'@'$svr'";

echo ""
echo "Importing World database"

for sql in $dbpath/*.sql
do 
	echo $sql
	mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $sql
done
echo "Done"
echo ""
echo "Before importing the World (mangos) database updates, we need to import some core World database updates"
read -p "Please enter the path to your Mangos Three repository: " serverrepo
echo "Importing core updates"
mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $serverrepo/sql/updates/12741_01_mangos.sql
echo $serverrepo/sql/updates/12741_01_mangos.sql
mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $serverrepo/sql/updates/12751_01_mangos_phase.sql
echo $serverrepo/sql/updates/12751_01_mangos_phase.sql
mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $serverrepo/sql/updates/12752_01_mangos_reputation_spillover_template.sql
echo $serverrepo/sql/updates/12752_01_mangos_reputation_spillover_template.sql
echo "Importing data updates"
for sql in $updates_path/*.sql
do
	echo $sql
	mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $sql
done
echo "Done"

}

echo "(( Mangos World Database Quick Installer ))"
standart;
world;
