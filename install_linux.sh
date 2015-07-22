#!/usr/bin/env bash

# Quick install section
# This will automatically use the variables below to install the world databases without prompting then optimize them and exit
# To use: Set your environment variables below and change 'set quick=off' to 'set quick=on'
# -- Change the values below to match your server --

svr=localhost;
user=mangos;
pass=mangos;
port=3306;
#ddb=dbc;
admin=root;
adminpass=yourpassword;

# -- Don't change after this point --
wdb=mangos;
cdb=characters;
rdb=realmd;

yesno=y;
yesnoDefault=y;
dbpath=full_db;
worldPath=World/Setup/FullDB;
charPath=Character/Setup;
realmPath=Realm/Setup;
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
	echo "Creating all database"
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
	echo "Importing World database"

	for sql in $worldPath/*.sql
	do 
		echo $sql
		mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $sql
	done
	echo "Done"

	echo ""
	echo "Importing Rel18 updates"
	for sql in World/Updates/Rel18/*.sql
	do
		echo $sql
		mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $wdb < $sql
	done
	echo ""
	echo "Importing Rel19 updates"
	for sql in World/Updates/Rel19/*.sql
	do
		echo $sql
		mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $sql
	done
	echo ""
	echo "Importing under_dev updates"
	for sql in $updates_path/*.sql
	do
		echo $sql
		mysql -q -s -h $svr --user=$user --password=$pass --port=$port $wdb < $sql
	done
else
	echo "World installations aborted."
	#exit; 
fi

echo "";
#read -p "Do you want to install additional DBC-files tables? (y/n, default: y) " yesno
#yesno=${yesno:-$yesnoDefault}
#if [ "$yesno" == "y" ]; then 
#	echo "Dropping DBC database"
#	#mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < drop_dbc.sql
#	echo ""
#	echo "Creating DBC database"
#	#mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port < create_dbc.sql

#	for sql in ./dbc/*.sql
#	do
#		echo $sql
#		mysql -q -s -h $svr --user=$user --password=$pass --port=$port $ddb < $sql
#	done
#else
	#echo "DBC installations has been ended"
	#exit; 
#fi

echo "Press any key to continue"
read 

}

character()
{

echo "";
echo "This will wipe out your current Character database and replace it."; 
read -p "Do you wish to continue? (y/n, default: y) " yesno
yesno=${yesno:-$yesnoDefault}
if [ "$yesno" == "y" ]; then 
	echo ""
	echo "Importing Character database"
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
	echo "Importing Realm database"
	mysql -q -s -h $svr --user=$admin --password=$adminpass --port=$port $rdb < $realmPath/realmdLoadDB.sql
	echo "Importing updates"
	echo Realm/Updates/Rel20/20000_dbdocs_Initial.sql
	mysql -q -s -h $svr --user=$user --password=$pass --port=$port $rdb < Realm/Updates/Rel20/20000_dbdocs_Initial.sql
	echo Realm/Updates/Rel20/20001_dbdocs_Update.sql
	mysql -q -s -h $svr --user=$user --password=$pass --port=$port $rdb < Realm/Updates/Rel20/20001_dbdocs_Update.sql
	
	echo "Done"
else
	echo "Realm installations has been skipped"
	#exit; 
fi

}

echo ""
echo "((--- Mangos World Database Quick Installer ---))"
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
