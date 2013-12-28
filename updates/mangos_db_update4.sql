# Contributed by GiantCrocodile
# Fixes an incorrect drop for Northwatch Scouts in Durotar

DELETE FROM `mangos`.`creature_loot_template` WHERE `creature_loot_template`.`entry` = 39317 AND `creature_loot_template`.`item` = 3264;
