delete from creature where id=35536 and `map`=36; -- sticky bombs are being spawned in boss fight event
DELETE FROM gameobject WHERE guid = '187631'; -- dublicate "Foundry Door" object (entry: 16399) spawn 

-- deleted all dead npcs, from past expansions (last encounters)
DELETE FROM creature WHERE guid=327407;
DELETE FROM creature WHERE guid=327363;
DELETE FROM creature WHERE guid=327355;
DELETE FROM creature WHERE guid=327383;
DELETE FROM creature WHERE guid=327396;
DELETE FROM creature WHERE guid=327360;
DELETE FROM creature WHERE guid=327402;
DELETE FROM creature WHERE guid=327393;
DELETE FROM creature WHERE guid=327401;
DELETE FROM creature WHERE guid=327379;
DELETE FROM creature WHERE guid=327370;
DELETE FROM creature WHERE guid=327371;
DELETE FROM creature WHERE guid=327369;
DELETE FROM creature WHERE guid=327412;
DELETE FROM creature WHERE guid=327403;
DELETE FROM creature WHERE guid=327384;
DELETE FROM creature WHERE guid=327390;
DELETE FROM creature WHERE guid=327413;
DELETE FROM creature WHERE guid=327397;
DELETE FROM creature WHERE guid=327364;
DELETE FROM creature WHERE guid=327381;
DELETE FROM creature WHERE guid=327374;
DELETE FROM creature WHERE guid=327358;
DELETE FROM creature WHERE guid=327387;
DELETE FROM creature WHERE guid=327362;
DELETE FROM creature WHERE guid=327388;
DELETE FROM creature WHERE guid=327368;
DELETE FROM creature WHERE guid=327377;
DELETE FROM creature WHERE guid=327376;
DELETE FROM creature WHERE guid=327394;
DELETE FROM creature WHERE guid=327411;
DELETE FROM creature WHERE guid=327385;
DELETE FROM creature WHERE guid=327380;
DELETE FROM creature WHERE guid=327378;
DELETE FROM creature WHERE guid=327409;
DELETE FROM creature WHERE guid=327361;
DELETE FROM creature WHERE guid=327391;
DELETE FROM creature WHERE guid=327405;
DELETE FROM creature WHERE guid=327386;
DELETE FROM creature WHERE guid=327395;
DELETE FROM creature WHERE guid=327392;
DELETE FROM creature WHERE guid=327399;
DELETE FROM creature WHERE guid=327372;
DELETE FROM creature WHERE guid=327410;
DELETE FROM creature WHERE guid=327356;
DELETE FROM creature WHERE guid=327367;
DELETE FROM creature WHERE guid=327365;
DELETE FROM creature WHERE guid=327366;
DELETE FROM creature WHERE guid=327419;
DELETE FROM creature WHERE guid=327400;
DELETE FROM creature WHERE guid=327408;
DELETE FROM creature WHERE guid=327375;
DELETE FROM creature WHERE guid=327398;
DELETE FROM creature WHERE guid=327404;
DELETE FROM creature WHERE guid=327373;
DELETE FROM creature WHERE guid=327389;

-- removed chest, which was used on mr smite event
DELETE FROM gameobject WHERE guid = '189815';
DELETE FROM game_event_gameobject WHERE guid = '189815';
DELETE FROM gameobject_battleground WHERE guid = '189815';

-- clean up
DELETE FROM creature_addon WHERE guid not in (select guid from creature);
DELETE FROM creature_movement WHERE id not in (select guid from creature);
DELETE FROM game_event_creature WHERE guid not in (select guid from creature);
DELETE FROM game_event_creature_data WHERE guid not in (select guid from creature);
DELETE FROM creature_battleground WHERE guid not in (select guid from creature);
DELETE FROM creature_linking WHERE guid not in (select guid from creature) OR master_guid not in (select guid from creature);
