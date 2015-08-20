#!/usr/bin/env bash

# Quick install section
# This will automatically use the variables below to install the world databases without prompting then optimize them and exit
# To use: Set your environment variables below and change 'set quick=off' to 'set quick=on'
# -- Change the values below to match your server --

svr=localhost;
user=mangos;
pass=mangos;
port=3306;
admin=root;
adminpass=yourpassword;

# -- Don't change after this point --
wdb=mangos;
cdb=characters;
rdb=realmd;
sdb=scriptdev2;
#ddb=dbc;

yesno=y;
yesnoDefault=y;
dbpath=full_db;
worldPath=World/Setup;
worldUpdates=World/Updates;
charPath=Character/Setup;
realmPath=Realm/Setup;
realmUpdates=Realm/Updates;
dbcPath=DBC/Setup;
updates_path=under_dev;
sd2Path=../server/src/bindings/scripts/sql
RED='\e[0;31m'
GRE='\e[0;32m'
NC='\e[0m' # No Color

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
echo "        MM  MMM http://getmangos.eu"
echo "        MMMMMM"
echo ""
echo "Credits to: Factionwars, Nemok, BrainDedd, Antz and Corsol"
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
read -p "What is the name of a user that can create databases? [root] : " admin
if [ "$admin" = "" ]; then admin="root"; fi
read -p "What is the password of your user that can create databases? [root] : " adminpass
if [ "$adminpass" = "" ]; then adminpass="root"; fi
}

dbCreation()
{
	echo ""
	echo "Creating all databases... "
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < World/Setup/mangosdCreateDB.sql
}

world()
{

echo "";
echo "This will wipe out your current World database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	echo ""
	echo -e "Importing World database... " ${GRE} $worldPath/mangosdLoadDB.sql ${NC}

	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $worldPath/mangosdLoadDB.sql
	echo ""
	for sql in $worldPath/FullDB/*.sql
	do 
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done
	echo "Done"


	echo "Importing Rel18 updates..."
	for sql in $worldUpdates/Rel18/*.sql
	do 
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done
	echo "Done"

	echo ""
	echo "Importing Rel19 updates... "
	for sql in $worldUpdates/Rel19/*.sql
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done
	
	echo ""
	echo "Importing under_dev updates... "
	for sql in $updates_path/*.sql
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done
	echo "Done"
else
	echo "World installations has been skipped."
	#exit; 
fi

}

#dbc()
#{
#echo "";
#read -p "Do you want to install additional DBC-files tables? (y/n, default: y) " yesno
#yesno=${yesno:-$yesnoDefault}
#if [ "$yesno" == "y" ]; then 
	#echo "Dropping DBC database"
	#mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < drop_dbc.sql
	#echo ""
#	echo "Creating DBC database"
#	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < $dbcPath/dbcCreateDB.sql
	
#	echo ""
#	for sql in $dbcPath/DataFiles/*.sql
#	do
#		echo -e ${GRE}$sql ${NC}
#		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $ddb < $sql
#	done
#	echo "Done"
#else
#	echo "DBC installations has been skipped"
	#exit; 
#fi
#}

character()
{

echo "";
echo "This will wipe out your current Character database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	echo ""
	echo -e "Importing Character database from " ${GRE} $charPath/characterLoadDB.sql ${NC}
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $cdb < $charPath/characterLoadDB.sql
	
	echo "Done"
else
	echo "Character installations has been skipped"
	#exit; 
fi
}

realm() 
{

echo "";
echo "This will wipe out your current Realm database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	echo ""

	echo ""
	echo -e "Importing Realm database from " ${GRE} $realmPath/realmdLoadDB.sql ${NC}
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $rdb < $realmPath/realmdLoadDB.sql


	echo ""
	echo "Importing dbdocs updates... "
	for sql in Realm/Updates/Rel20/*.sql
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $rdb < $sql
	done
	
	echo ""
	echo "Importing Rel21 updates... "
	for sql in $realmUpdates/Rel21/*.sql
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $rdb < $sql
	done
	echo "Done"
else
	echo "Realm installations has been skipped"
	#exit; 
fi

}

sd2()
{

echo "";
echo "This will wipe out your current ScriptDev2 database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	echo ""
	echo -e "Creating database from " ${GRE}$sd2Path/scriptdev2_create_database.sql${NC}
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < $sd2Path/scriptdev2_create_database.sql
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $sdb < $sd2Path/scriptdev2_create_structure_mysql.sql

	echo ""
	echo -e "Importing ScriptDev2 database from " ${GRE}$sd2Path/scriptdev2_script_full.sql${NC}
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $sdb < $sd2Path/scriptdev2_script_full.sql
	
	echo ""
	echo -e "Reset Mangos scriptName information from " ${GRE}$sd2Path/mangos_scriptname_full.sql${NC}
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sd2Path/mangos_scriptname_clear.sql
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sd2Path/mangos_scriptname_full.sql

	echo ""
	echo "Importing updates... "
	for sql in $sd2Path/updates/*.sql
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done

	echo ""
	echo "Importing extra creature scripts... "
	for sql in $sd2Path/optional/*.sql
	
	do
		echo -e ${GRE}$sql ${NC}
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done

	echo "Done"
else
	echo "Character installations has been skipped"

	#exit; 
fi
}


echo ""
echo -e ${RED}"((--- Mangos World Database Quick Installer ---))" ${NC}
standart;
echo "";
read -p "Is your first installation? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	dbCreation;
fi
realm;
character;
world;
sd2;
#dbc;
echo "Press any key to continue"
read 
