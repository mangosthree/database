-- Contributed by GiantCrocodile
-- Fixes an incorrect drop for Northwatch Scouts in Durotar

DELETE FROM `creature_loot_template` WHERE `entry` = 39317 AND `item` = 3264;

-- Removes a duplicate Wonderform Operator in Orgrimmar

DELETE FROM `creature` WHERE `guid` = 354064;
