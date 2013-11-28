mangos_ytdb
===========

Initial port of ytdb over to mangos

Installation Instructions
-------------------------
 - Do everything as normal for the characters and realmd databases.
 - Drop your mangos database if you already have one.
 - Create an empty mangos db and give your mangos user permissions on it
 - Unzip the database file
 - Import full_db.sql (mysql -u root -p mangos < full_db.sql)
 - Import all the updates in the updates folder
