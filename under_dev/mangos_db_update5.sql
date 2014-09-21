
-- phase definitions
-- removing the primary keys because the phase definitions have duplicate values in the zoneId and entry columns.
-- might want to relook at a real primary key column that would be unique

alter table phase_definitions modify column entry smallint(5);
alter table phase_definitions drop primary key;

insert into `phase_definitions` (`zoneId`, `entry`, `phasemask`, `phaseId`, `terrainswapmap`, `flags`, `comment`) values
('1519','1','129','0','0','0','Stormwind: [A] Heros Call: Vashj\'ir'),
('1519','2','257','0','0','0','Stormwind: [A] Heros Call: Hyjal'),
('1519','3','513','0','0','0','Stormwind: [A] Heros Call: Deepholm'),
('1519','4','1025','0','0','0','Stormwind: [A] Heros Call: Uldum'),
('1519','5','2049','0','0','0','Stormwind: [A] Heros Call: Twilight Highlands'),
('1637','1','129','0','0','0','Orgrimmar: [H] Warchiefs Command: Vashj\'ir'),
('1637','2','257','0','0','0','Orgrimmar: [H] Warchiefs Command: Hyjal'),
('1637','3','513','0','0','0','Orgrimmar: [H] Warchiefs Command: Deepholm'),
('1637','4','1025','0','0','0','Orgrimmar: [H] Warchiefs Command: Uldum'),
('1637','5','2049','0','0','0','Orgrimmar: [H] Warchiefs Command: Twilight Highlands'),
('616','1','0','165','719','0','Mount Hyjal: Default Terrainswap');

-- cata zone portals (alliance)
UPDATE `gameobject_template` SET `data0` = '85040' , `data5` = '0' WHERE `entry` = '207691'; -- teleport to vashj'ir



UPDATE `db_version` SET `version` = 'YTDB_0.16.9_R722_MaNGOS3_R12751_SD2_R2928_ACID_R310_RuDB_R63_+_mangosdb_update_5';
