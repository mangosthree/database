-- ----------------------------------------------------------------
-- This is an attempt to create a full transactional MaNGOS update
-- Now compatible with newer MySql Databases (v1.5)
-- ----------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mangos`()
BEGIN
    DECLARE bRollback BOOL  DEFAULT FALSE ;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `bRollback` = TRUE;

    -- Current Values (TODO - must be a better way to do this)
    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);

    -- Expected Values
    SET @cOldVersion = '22';
    SET @cOldStructure = '11';
    SET @cOldContent = '020';

    -- New Values
    SET @cNewVersion = '22';
    SET @cNewStructure = '11';
    SET @cNewContent = '021';
                            -- DESCRIPTION IS 30 Characters MAX
    SET @cNewDescription = 'Save_Krennan_Ride';

                        -- COMMENT is 150 Characters MAX
    SET @cNewComment = 'Wire up Save Krennan Aranas: mount the player on accept, give the rescue summon a target position, add the scene texts and bind the ride script';

    -- Evaluate all settings
    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
    SET @oldResult := (SELECT `description` FROM `db_version` WHERE `version`=@cOldVersion AND `structure`=@cOldStructure AND `content`=@cOldContent);
    SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

    IF (@cCurResult = @oldResult) THEN    -- Does the current version match the expected version
        -- APPLY UPDATE
        START TRANSACTION;
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
        -- -- PLACE UPDATE SQL BELOW -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- Save Krennan Aranas: the rescue ride, its flags and health.


        -- ---- from Save_Krennan_Aranas ----
        -- `Save Krennan Aranas` (14293) had none of its moving parts wired, even though
        -- almost all of the data for it was already present:
        --   68232/68221 `Summon Greymane's Horse` summons 35905 under SummonProperties
        --     488, a vehicle group, and `Spell::DoSummonVehicle` boards the caster;
        --   35905 carries VehicleTemplateId 494, whose two seats are 5548 and 5549;
        --   `creature_template_spells` already puts 68219 `Rescue Krennan` on its bar;
        --   68219 triggers 68228, which summons 35907 and asks for credit on 35753 -
        --     the very id `quest_template`.ReqCreatureOrGOId1 wants;
        --   `spell_area` already swaps the phase aura 72870 for 72872 on completion.
        -- Nothing joined them: the quest cast nothing on accept, the horse had no path,
        -- and the summon had nowhere to put Krennan.

        -- 1. Accepting the quest hands over the horse.
        --    `Player::AddQuest` starts this as
        --        ScriptsStart(DBS_ON_QUEST_START, id, questGiver, this, ...)
        --    so the questgiver is the SOURCE and the player only the target. The
        --    summoner has to be the player - `DoSummonVehicle` boards whoever cast it -
        --    so SCRIPT_FLAG_REVERSE_DIRECTION (2) swaps the pair, and
        --    SCRIPT_FLAG_COMMAND_ADDITIONAL (8) makes it triggered. 2 + 8 = 10.
        UPDATE `quest_template` SET `StartScript` = 14293 WHERE `entry` = 14293;

        DELETE FROM `db_scripts` WHERE `script_type` = 0 AND `id` = 14293;
        INSERT INTO `db_scripts`
            (`script_type`, `id`, `delay`, `command`, `datalong`, `datalong2`, `buddy_entry`, `search_radius`, `data_flags`, `x`, `y`, `z`, `o`, `comments`) VALUES
        (0, 14293, 0, 15, 68221, 0, 0, 0, 10, 0, 0, 0, 0, 'The player mounts King Greymanes Horse');

        -- 2. Give 68228 somewhere to put Krennan.
        --    Its summon effect is TARGET_SCRIPT_COORDINATES (46), which reads this
        --    table and finds nothing, so the rescue produced no Krennan at all. A fixed
        --    point is right here rather than a limitation: the horse always stops at
        --    the same place under the tree, which is where it lands after its jump.
        DELETE FROM `spell_target_position` WHERE `id` = 68228;
        INSERT INTO `spell_target_position`
            (`id`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES
        (68228, 654, -1676.16, 1346.19, 15.1349, 0);

        -- 3. The three lines of the scene, from the retail texts.
        DELETE FROM `script_texts` WHERE `entry` IN (-1999944, -1999945, -1999946);
        INSERT INTO `script_texts` (`entry`, `content_default`, `sound`, `type`, `language`, `emote`, `comment`) VALUES
        (-1999944, 'Rescue Krennan Aranas by using your vehicle''s ability.', 0, 5, 0, 0, 'greymanes horse - announce the rescue to the rider'),
        (-1999945, 'Help!  Up here!', 0, 1, 0, 0, 'krennan aranas - trapped in the tree'),
        (-1999946, 'Thank you!  I owe you my life.', 20922, 0, 0, 0, 'krennan aranas - set down safely');

        -- 4. The horse standing in the Military District was on MovementType 1, wandering
        --    off on random movement. It is a two seat vehicle anyone can board; it should
        --    hold its ground.
        UPDATE `creature` SET `MovementType` = 0 WHERE `id` = 35905;

        -- 5. Bind the ride script.
        DELETE FROM `script_binding` WHERE `ScriptName` = 'npc_greymanes_horse';
        INSERT INTO `script_binding` (`type`, `ScriptName`, `bind`, `data`) VALUES
        (0, 'npc_greymanes_horse', 35905, 0);

        -- ---- from Krennan_Rescue_Target ----
        -- 1. The rescue button did nothing because the summon behind it never had a
        --    target, and the row added for it in Rel22_07_037 was rejected at load:
        --        ERROR:Spell (Id: 68228) listed in `spell_target_position` does not
        --        have target TARGET_TABLE_X_Y_Z_COORDINATES (17).
        --    Wrong table. `spell_target_position` serves TARGET_TABLE_X_Y_Z_COORDINATES
        --    (17); 68228 carries TARGET_SCRIPT_COORDINATES (46), which resolves through
        --    `spell_script_target` instead - it finds the nearest listed creature or
        --    object and summons at ITS position. `Spell::CheckCast` says as much when
        --    the row is missing:
        --        "has EffectImplicitTargetA/B = TARGET_SCRIPT_COORDINATES, but
        --         gameobject or creature are not defined in `spell_script_target`"
        --    and refuses the cast outright, which is exactly a button that does nothing.
        --
        --    The creature to name is 35753, the trapped Krennan hanging in the tree. He
        --    is spawned at -1673.24 1344.80, about three yards from where the horse
        --    lands, so the rescued Krennan (35907) appears at the man being rescued -
        --    which is both correct and self-maintaining if the spawn ever moves.
        DELETE FROM `spell_target_position` WHERE `id` = 68228;

        DELETE FROM `spell_script_target` WHERE `entry` = 68228;
        INSERT INTO `spell_script_target` (`entry`, `type`, `targetEntry`, `inverseEffectMask`) VALUES
        (68228, 1, 35753, 0);

        -- 2. King Greymane's Horse is a level 4 creature with no health multiplier and
        --    no protection, and the ride crosses ground held by 67 Bloodfang Rippers
        --    with every Gilneas City Guard 100+ yards behind at the barricade. The
        --    mount was simply killed underneath the player, ending a scripted sequence
        --    that has no business being interruptible. UNIT_FLAG_NON_ATTACKABLE (0x2)
        --    is added to the existing 0x8 so nothing can swing at the horse itself;
        --    the rider is still a target, and the ride script keeps a few attackers on
        --    them and evades the rest.
        UPDATE `creature_template` SET `UnitFlags` = 10 WHERE `entry` = 35905;

        -- ---- from Horse_Attackable_Again ----
        -- Rel22_07_038 put UNIT_FLAG_NON_ATTACKABLE (0x2) on King Greymane's Horse to
        -- stop the Bloodfang Rippers killing the mount out from under the rider. It
        -- stopped the quest instead: the horse no longer appeared at all.
        --
        -- `Spell::DoSummonVehicle` boards the summoner by casting the ride spell AT the
        -- freshly summoned vehicle, and then checks its work:
        --     if (!spawnCreature->HasAuraType(SPELL_AURA_CONTROL_VEHICLE))
        --     {
        --         spawnCreature->ForcedDespawn();
        --         return false;
        --     }
        -- `Unit::IsTargetableForAttack` returns false for anything carrying
        -- UNIT_FLAG_NON_ATTACKABLE, so the ride spell could not resolve the horse, the
        -- CONTROL_VEHICLE aura never landed, and the vehicle was despawned one line
        -- later. The flag made the mount unattackable by the very spell that mounts it.
        --
        -- The template goes back to what it was. The protection now goes on at runtime
        -- in `npc_greymanes_horse`, once the rider is actually aboard and the boarding
        -- spell has no further use for the horse as a target.
        UPDATE `creature_template` SET `UnitFlags` = 8 WHERE `entry` = 35905;

        -- ---- from Krennan_Focus_And_Hang ----
        -- 1. THE RESCUE BUTTON. Pressing it produced "Requires you to be closer to
        --    Krennan Aranas." The packet the server sent says exactly what it meant:
        --        SMSG_PET_CAST_FAILED  spell 68219  result 0x68 (104)  data 1630
        --    104 is SPELL_FAILED_REQUIRES_SPELL_FOCUS and 1630 is the SpellFocusObject
        --    it wants. 68219 carries RequiresSpellFocus 1630 in SpellCastingRequirements,
        --    and SpellFocusObject.dbc names 1630 "you to be closer to Krennan Aranas." -
        --    Blizzard stored the tail of the error message as the object's name, which
        --    is why the client prints that sentence.
        --
        --    The focus is gameobject 301027, type 8 with data0 1630 and a 20 yard
        --    radius, and it IS spawned - guid 217502, only 2.1 yards from where the
        --    horse lands. It was never a distance problem. It sits on `phaseMask` 1,
        --    while the player doing this quest is in phase 4: `spell_area` gives them
        --    72870, whose SPELL_AURA_PHASE effect carries phasemask 4, which is also
        --    the phase Krennan himself (35753) is spawned in. The one object needed to
        --    rescue him was in a different phase from the man being rescued.
        --
        --    Phase 1 is left in place rather than replaced - 1|4 = 5 - so this only
        --    adds the quest's phase and takes nothing away.
        UPDATE `gameobject` SET `phaseMask` = 5 WHERE `guid` = 217502 AND `id` = 301027;

        -- 2. Krennan is supposed to be hanging in the tree, and the data already says
        --    so: `creature_template_addon` gives him emote 472 and bytes1 0x03000100,
        --    an animation tier that keeps him off the ground. What it never gave him
        --    was a reason to stay there, so he dropped out of the tree to melee the
        --    Bloodfang Rippers around it.
        --
        --    UNIT_FLAG_PASSIVE (0x200) stops him picking fights, and
        --    UNIT_FLAG_NON_ATTACKABLE (0x2) stops the Rippers pulling him into one -
        --    either would drag him out of his animation. He stays selectable, so his
        --    nameplate and the "Help! Up here!" still read as they should. Added to
        --    the existing 0x8000: 0x8000 | 0x200 | 0x2 = 33282.
        --
        --    Nothing that matters is blocked by this: 68228 finds him through
        --    `spell_script_target`, whose search tests entry, alive and range only.
        UPDATE `creature_template` SET `UnitFlags` = 33282 WHERE `entry` = 35753;

        -- 3. Tidy the warning left by Rel22_07_037, which stopped the spawned horse
        --    wandering but left its old wander distance behind:
        --        Table `creature` have creature (GUID: 371579 Entry: 35905) with
        --        `MovementType`=0 (idle) have `spawndist`<>0, set to 0.
        UPDATE `creature` SET `spawndist` = 0 WHERE `id` = 35905 AND `MovementType` = 0;

        -- ---- from Krennan_Rides_Along ----
        -- 1. Krennan is meant to be stuck up in the tree calling for help, but his spawn
        --    sat at Z 18.98 with the ground beneath him at 15.13 - barely a body's
        --    height up, which reads as standing in the courtyard rather than hanging
        --    out of reach. Lifted to 24.0, about nine yards above the cobbles and into
        --    the branches the horse jumps beneath.
        --
        --    Nothing this quest needs is broken by the height: 68219's spell focus has
        --    a 20 yard radius and sits at ground level, and 68228 finds him through
        --    `spell_script_target`, whose search allows 30 yards.
        UPDATE `creature` SET `position_z` = 24.0 WHERE `guid` = 219595 AND `id` = 35753;

        -- 2. The rescued Krennan (35907) is summoned by 68228 under SummonProperties 61,
        --    which makes him the player's guardian - the client even labels him
        --    "<name>'s Guardian" - and a guardian arrives looking for something to hit.
        --    With the tree ringed by Bloodfang Rippers he went and fought them instead
        --    of climbing aboard.
        --
        --    UNIT_FLAG_PASSIVE (0x200) stops him starting fights and
        --    UNIT_FLAG_NON_ATTACKABLE (0x2) stops the Rippers starting one with him,
        --    on top of his existing 0x8008: 0x8008 | 0x202 = 33290. The ride script
        --    also stops his attack and applies the same flags as it seats him, so a
        --    guardian already swinging when the button is pressed still settles down.
        UPDATE `creature_template` SET `UnitFlags` = 33290 WHERE `entry` = 35907;

        -- 3. The horse must survive the ride without being untouchable. Rel22_07_038
        --    made it NON_ATTACKABLE, and Rel22_07_039 moved that to runtime, but either
        --    way nothing could engage the ride at all - no Rippers ever attacked, which
        --    is as wrong as being killed by them. That flag is gone from the script; the
        --    mount is a normal target again and the ride script now caps attackers on
        --    the rider AND the mount as one pool of three, evading the rest.
        --
        --    What keeps it alive is health rather than immunity. A level 4 creature on
        --    HealthMultiplier 1 dies to a couple of Rippers in seconds; 25 gives it
        --    enough to carry a rider through a thirty second ride with three of them
        --    chewing on it, while still being a creature they can meaningfully fight.
        UPDATE `creature_template` SET `HealthMultiplier` = 25 WHERE `entry` = 35905;

        -- ---- from Krennan_Stays_Aloft ----
        -- 1. Krennan would not stay up the tree. Rel22_07_041 lifted his spawn to Z 24,
        --    but `Creature::InitEntry` decides whether a creature can hold height from
        --    its template, not its spawn:
        --        SetLevitate((cinfo->InhabitType & INHABIT_AIR) != 0);
        --    and 35753 was InhabitType 3 (ground | water). Without INHABIT_AIR he is
        --    never levitated, so he simply fell back to the cobbles whatever Z the
        --    spawn asked for. He is meant to be hanging out of reach and never walks
        --    anywhere, so air alone is right for him.
        UPDATE `creature_template` SET `InhabitType` = 4 WHERE `entry` = 35753;

        -- 2. The rescued Krennan is created through `Spell::DoSummonGuardian`, which
        --    makes him a Pet, and a Pet with no `pet_levelstats` gets the weakify
        --    fallback and this in the log every single rescue:
        --        Pet::InitStatsForLevel> Error trying to set stats for creature
        --        Pet (entry: 35907) using ClassLevelStats; not enough data to do it!
        --    Same gap the Gilnean Mastiff had in Rel22_07_035, same shape of fix. He is
        --    a passenger rather than a fighter, so these only need to be sane.
        DELETE FROM `pet_levelstats` WHERE `creature_entry` = 35907;
        INSERT INTO `pet_levelstats`
            (`creature_entry`, `level`, `hp`, `mana`, `armor`, `str`, `agi`, `sta`, `inte`, `spi`)
        SELECT 35907, `level`, `hp`, `mana`, `armor`, `str`, `agi`, `sta`, `inte`, `spi`
        FROM `pet_levelstats` WHERE `creature_entry` = 35631;

        -- ---- from Greymanes_Horse_Health ----
        -- King Greymane's Horse (35905), the Save Krennan Aranas (14293) mount.
        --
        -- Decoded from the 18019 Gilneas capture: the horse is created with
        -- UNIT_FIELD_MAXHEALTH 1224 at level 5, Run Speed 9 (which matches our
        -- SpeedRun 1.28571 - the template speed was never wrong; the ride spline simply
        -- runs faster than the creature, and the script now does the same). Over the
        -- 37 s ride the Bloodfang Rippers hit the HORSE - never the rider, whose seat
        -- is NOT_SELECTABLE - sixteen times for 6-9 each, up to four at once, and it
        -- came home at 1152/1224. Ours had 498, which is why the ride first needed a
        -- non-attackable flag and then an attacker cull to survive; with retail health
        -- it simply takes the bites.
        UPDATE `creature_template`
        SET `MinLevelHealth` = 1224,
            `MaxLevelHealth` = 1224
        WHERE `Entry` = 35905;

        -- -- PLACE UPDATE SQL ABOVE -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

        -- If we get here ok, commit the changes
        IF bRollback = TRUE THEN
            ROLLBACK;
            SHOW ERRORS;
            SELECT '* UPDATE FAILED *' AS `===== Status =====`,@cCurResult AS `===== DB is on Version: =====`;
        ELSE
            COMMIT;
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            -- UPDATE THE DB VERSION
            -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
            INSERT INTO `db_version` VALUES (@cNewVersion, @cNewStructure, @cNewContent, @cNewDescription, @cNewComment);
            SET @newResult := (SELECT `description` FROM `db_version` WHERE `version`=@cNewVersion AND `structure`=@cNewStructure AND `content`=@cNewContent);

            SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,@newResult AS `===== DB is now on Version =====`;
        END IF;
    ELSE    -- Current version is not the expected version
        IF (@cCurResult = @newResult) THEN    -- Does the current version match the new version
            SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@cCurResult AS `===== DB is already on Version =====`;
        ELSE    -- Current version is not one related to this update
            IF(@cCurResult IS NULL) THEN    -- Something has gone wrong
                SELECT '* UPDATE FAILED *' AS `===== Status =====`,'Unable to locate DB Version Information' AS `============= Error Message =============`;
            ELSE
                IF(@oldResult IS NULL) THEN    -- Something has gone wrong
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SET @oldResult = CONCAT('Rel',@cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - ','IS NOT APPLIED');
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                ELSE
                    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurStructure := (SELECT `STRUCTURE` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurContent := (SELECT `Content` FROM `db_version` ORDER BY `version` DESC, `STRUCTURE` DESC, `CONTENT` DESC LIMIT 0,1);
                    SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ',@cCurResult);
                    SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,@oldResult AS `=== Expected ===`,@cCurOutput AS `===== Found Version =====`;
                END IF;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Execute the procedure
CALL update_mangos();

-- Drop the procedure
DROP PROCEDURE IF EXISTS `update_mangos`;
