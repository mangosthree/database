-- SPDX-License-Identifier: GPL-3.0-or-later
--
-- MaNGOS is a full featured server for World of Warcraft, supporting
-- the following clients: 1.12.x, 2.4.3, 3.3.5a, 4.3.4a and 5.4.8
--
-- Copyright (C) 2005-2026 MaNGOS <https://www.getmangos.eu>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <https://www.gnu.org/licenses/>.
--
-- World of Warcraft, and all World of Warcraft or Warcraft art, images,
-- and lore are copyrighted by Blizzard Entertainment, Inc.

-- -------------------------------------------------------------------------
-- Version the legacy x86 Grunt profile, publish the exact current-Grunt
-- discriminator, and add locale-stable corroboration-only archive digests.
-- -------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `update_mangos`;

DELIMITER $$

CREATE PROCEDURE `update_mangos`()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SHOW ERRORS;
        SELECT '* UPDATE FAILED *' AS `===== Status =====`,
               @cCurResult AS `===== DB is on Version: =====`;
        RESIGNAL;
    END;

    SET @cCurVersion := (SELECT `version` FROM `db_version`
        ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version`
        ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version`
        ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cCurResult := (SELECT `description` FROM `db_version`
        ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);

    SET @cOldVersion = '22';
    SET @cOldStructure = '10';
    SET @cOldContent = '002';
    SET @cOldDescription = 'Cata_Warden_X64_Checks';

    SET @cNewVersion = '22';
    SET @cNewStructure = '10';
    SET @cNewContent = '003';
    SET @cNewDescription = 'Cata_Warden_MPQ_Checks';
    SET @cNewComment = 'Redesign Cata 4.3.4.15595 Grunt profiles and MPQ checks';

    SET @cOldResult := (SELECT `description` FROM `db_version`
        WHERE `version` = @cOldVersion
          AND `structure` = @cOldStructure
          AND `content` = @cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version`
        WHERE `version` = @cNewVersion
          AND `structure` = @cNewStructure
          AND `content` = @cNewContent);

    IF (@cCurVersion = @cOldVersion
        AND @cCurStructure = @cOldStructure
        AND @cCurContent = @cOldContent
        AND @cCurResult = @cOldResult
        AND @cOldResult = @cOldDescription) THEN
        START TRANSACTION;

        -- Refuse partial, foreign, or operator-modified predecessor data.
        IF (SELECT COUNT(*) FROM `warden_checks`) <> 252
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `enabled` = 1) <> 252
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `architecture` = 0x783836) <> 126
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `architecture` = 0x783634) <> 126
           OR (SELECT COUNT(DISTINCT `architecture`)
               FROM `warden_checks`) <> 2
           OR (SELECT COUNT(DISTINCT `locale`)
               FROM `warden_checks`) <> 14
           OR (SELECT COUNT(DISTINCT `variant`)
               FROM `warden_checks`) <> 3
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `build` <> 15595
                  OR `architecture` NOT IN (0x783836,0x783634)
                  OR `locale` NOT IN
                     (0x64654445,0x656E434E,0x656E4742,0x656E5457,
                      0x656E5553,0x65734553,0x65734D58,0x66724652,
                      0x6B6F4B52,0x70744252,0x70745054,0x72755255,
                      0x7A68434E,0x7A685457)
                  OR `variant` NOT IN
                     (0x756E636C6173736966696564,0x73746F636B,0x6772756E74))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               GROUP BY `architecture`,`locale`,`variant`
               HAVING COUNT(*) <> 3)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE NOT (
                   (`architecture` = 0x783836 AND (
                       (`variant` = 0x756E636C6173736966696564
                        AND `type` = 3 AND `evidence_class` = 3
                        AND `phase_mask` = 0x01 AND `address_kind` = 1
                        AND `module` = 0x576F772E657865
                        AND OCTET_LENGTH(`request`) = 0
                        AND OCTET_LENGTH(`expected`) = 0
                        AND ((`check_id` = 1001 AND `sort_order` = 10
                              AND `address` = 0x00007F7A AND `length` = 5
                              AND BINARY `comment` = BINARY
                                  'Exact x86 stock/grunt profile probe 1')
                          OR (`check_id` = 1002 AND `sort_order` = 20
                              AND `address` = 0x00088FAE AND `length` = 1
                              AND BINARY `comment` = BINARY
                                  'Exact x86 stock/grunt profile probe 2')
                          OR (`check_id` = 1003 AND `sort_order` = 30
                              AND `address` = 0x000895CA AND `length` = 7
                              AND BINARY `comment` = BINARY
                                  'Exact x86 stock/grunt profile probe 3')))
                       OR (`variant` IN (0x73746F636B,0x6772756E74) AND (
                           (`check_id` = 2001 AND `type` = 0
                            AND `sort_order` = 10 AND `evidence_class` = 0
                            AND `phase_mask` = 0x06 AND `address_kind` = 0
                            AND OCTET_LENGTH(`module`) = 0
                            AND `address` = 0 AND `length` = 0
                            AND OCTET_LENGTH(`request`) = 0
                            AND OCTET_LENGTH(`expected`) = 0
                            AND BINARY `comment` = BINARY
                                'Delivered-module timing health')
                        OR (`check_id` = 2003 AND `type` = 1
                            AND `sort_order` = 30 AND `evidence_class` = 3
                            AND `phase_mask` = 0x06 AND `address_kind` = 0
                            AND OCTET_LENGTH(`module`) = 0
                            AND `address` = 0 AND `length` = 0
                            AND `request` = 0x4F4B4159
                            AND `expected` = CASE `locale`
                                WHEN 0x64654445 THEN 0x4F4B
                                WHEN 0x656E434E THEN 0xE7A1AEE5AE9A
                                WHEN 0x656E4742 THEN 0x4F6B6179
                                WHEN 0x656E5457 THEN 0xE7A2BAE5AE9A
                                WHEN 0x656E5553 THEN 0x4F6B6179
                                WHEN 0x65734553 THEN 0x41636570746172
                                WHEN 0x65734D58 THEN 0x41636570746172
                                WHEN 0x66724652 THEN 0x4F4B
                                WHEN 0x6B6F4B52 THEN 0xED9995EC9DB8
                                WHEN 0x70744252 THEN 0x4F6B
                                WHEN 0x70745054 THEN 0x4F6B
                                WHEN 0x72755255 THEN 0xD09ED09A
                                WHEN 0x7A68434E THEN 0xE7A1AEE5AE9A
                                WHEN 0x7A685457 THEN 0xE7A2BAE5AE9A
                            END
                            AND BINARY `comment` = BINARY
                                'Localized OKAY callback; corroboration only')
                        OR (`check_id` = 2004 AND `type` = 3
                            AND `sort_order` = 40 AND `evidence_class` = 1
                            AND `phase_mask` = 0x0E AND `address_kind` = 1
                            AND `module` = 0x576F772E657865
                            AND `address` = 0x0043C257 AND `length` = 12
                            AND OCTET_LENGTH(`request`) = 0
                            AND `expected` = 0x538B5D08568BC3578D50018A
                            AND BINARY `comment` = BINARY
                                'FrameScript execution integrity invariant')))))
                   OR (`architecture` = 0x783634 AND (
                       (`variant` = 0x756E636C6173736966696564
                        AND `type` = 3 AND `evidence_class` = 3
                        AND `phase_mask` = 0x01 AND `address_kind` = 1
                        AND `module` = 0x576F772D36342E657865
                        AND OCTET_LENGTH(`request`) = 0
                        AND OCTET_LENGTH(`expected`) = 0
                        AND ((`check_id` = 1001 AND `sort_order` = 10
                              AND `address` = 0x000AB76F AND `length` = 5
                              AND BINARY `comment` = BINARY
                                  'Exact x64 stock/grunt profile probe 1')
                          OR (`check_id` = 1002 AND `sort_order` = 20
                              AND `address` = 0x000AABAB AND `length` = 2
                              AND BINARY `comment` = BINARY
                                  'Exact x64 stock/grunt profile probe 2')
                          OR (`check_id` = 1003 AND `sort_order` = 30
                              AND `address` = 0x000AA6D3 AND `length` = 2
                              AND BINARY `comment` = BINARY
                                  'Exact x64 stock/grunt profile probe 3')))
                       OR (`variant` IN (0x73746F636B,0x6772756E74) AND (
                           (`check_id` = 2001 AND `type` = 0
                            AND `sort_order` = 10 AND `evidence_class` = 0
                            AND `phase_mask` = 0x06 AND `address_kind` = 0
                            AND OCTET_LENGTH(`module`) = 0
                            AND `address` = 0 AND `length` = 0
                            AND OCTET_LENGTH(`request`) = 0
                            AND OCTET_LENGTH(`expected`) = 0
                            AND BINARY `comment` = BINARY
                                'Delivered-module timing health')
                        OR (`check_id` = 2003 AND `type` = 1
                            AND `sort_order` = 30 AND `evidence_class` = 3
                            AND `phase_mask` = 0x06 AND `address_kind` = 0
                            AND OCTET_LENGTH(`module`) = 0
                            AND `address` = 0 AND `length` = 0
                            AND `request` = 0x4F4B4159
                            AND `expected` = CASE `locale`
                                WHEN 0x64654445 THEN 0x4F4B
                                WHEN 0x656E434E THEN 0xE7A1AEE5AE9A
                                WHEN 0x656E4742 THEN 0x4F6B6179
                                WHEN 0x656E5457 THEN 0xE7A2BAE5AE9A
                                WHEN 0x656E5553 THEN 0x4F6B6179
                                WHEN 0x65734553 THEN 0x41636570746172
                                WHEN 0x65734D58 THEN 0x41636570746172
                                WHEN 0x66724652 THEN 0x4F4B
                                WHEN 0x6B6F4B52 THEN 0xED9995EC9DB8
                                WHEN 0x70744252 THEN 0x4F6B
                                WHEN 0x70745054 THEN 0x4F6B
                                WHEN 0x72755255 THEN 0xD09ED09A
                                WHEN 0x7A68434E THEN 0xE7A1AEE5AE9A
                                WHEN 0x7A685457 THEN 0xE7A2BAE5AE9A
                            END
                            AND BINARY `comment` = BINARY
                                'Localized OKAY callback; corroboration only')
                        OR (`check_id` = 2004 AND `type` = 3
                            AND `sort_order` = 40 AND `evidence_class` = 1
                            AND `phase_mask` = 0x0E AND `address_kind` = 1
                            AND `module` = 0x576F772D36342E657865
                            AND `address` = 0x00566C13 AND `length` = 16
                            AND OCTET_LENGTH(`request`) = 0
                            AND `expected` =
                                0x4883C9FF33C0488BFDBAF0D8FFFFF2AE
                            AND BINARY `comment` = BINARY
                                'FrameScript execution integrity invariant')))))
               )) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Exact Cata Warden predecessor validation failed';
        END IF;

        -- Preserve the shipped x86 classified profile as an explicit legacy
        -- variant before publishing the newly discriminated Grunt profile.
        UPDATE `warden_checks`
           SET `variant` = 0x6C65676163792D6772756E74
         WHERE `enabled` = 1
           AND `architecture` = 0x783836
           AND `variant` = 0x6772756E74;

        IF ROW_COUNT() <> 42 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Exact legacy x86 Grunt versioning failed';
        END IF;

        INSERT INTO `warden_checks`
        (`build`,`architecture`,`locale`,`variant`,`check_id`,`type`,
         `enabled`,`sort_order`,`evidence_class`,`phase_mask`,
         `address_kind`,`module`,`address`,`length`,`request`,
         `expected`,`comment`)
        SELECT `build`, `architecture`, `locale`, `variant`,
               1004 AS `check_id`, 3 AS `type`, 1 AS `enabled`,
               40 AS `sort_order`, 3 AS `evidence_class`,
               0x01 AS `phase_mask`, 1 AS `address_kind`,
               0x576F772E657865 AS `module`,
               0x003BFF88 AS `address`, 24 AS `length`, X'' AS `request`,
               X'' AS `expected`,
               'Exact x86 Grunt profile probe 4; non-actionable profile evidence'
                   AS `comment`
          FROM `warden_checks`
         WHERE `enabled` = 1
           AND `architecture` = 0x783836
           AND `variant` = 0x756E636C6173736966696564
           AND `check_id` = 1001;

        INSERT INTO `warden_checks`
        (`build`,`architecture`,`locale`,`variant`,`check_id`,`type`,
         `enabled`,`sort_order`,`evidence_class`,`phase_mask`,
         `address_kind`,`module`,`address`,`length`,`request`,
         `expected`,`comment`)
        SELECT `build`, `architecture`, `locale`,
               0x6772756E74 AS `variant`, `check_id`, `type`, `enabled`,
               `sort_order`, `evidence_class`, `phase_mask`,
               `address_kind`, `module`, `address`, `length`, `request`,
               `expected`, `comment`
          FROM `warden_checks`
         WHERE `enabled` = 1
           AND `architecture` = 0x783836
           AND `variant` = 0x6C65676163792D6772756E74;

        INSERT INTO `warden_checks`
        (`build`,`architecture`,`locale`,`variant`,`check_id`,`type`,
         `enabled`,`sort_order`,`evidence_class`,`phase_mask`,
         `address_kind`,`module`,`address`,`length`,`request`,
         `expected`,`comment`)
        SELECT `build`, `architecture`, `locale`, `variant`,
               2002 AS `check_id`, 2 AS `type`, 1 AS `enabled`,
               35 AS `sort_order`, 3 AS `evidence_class`,
               0x06 AS `phase_mask`, 0 AS `address_kind`,
               X'' AS `module`, 0 AS `address`, 0 AS `length`,
               0x444246696C6573436C69656E745C4974656D2E646232 AS `request`,
               0x4706FF83D9B611644A87DE79C244B414612EF4F2 AS `expected`,
               'Item.db2 archive digest; corroboration only' AS `comment`
          FROM `warden_checks`
         WHERE `enabled` = 1 AND `check_id` = 2001
           AND ((`architecture` = 0x783836
                 AND `variant` = 0x6772756E74)
             OR (`architecture` = 0x783634
                 AND `variant` IN (0x73746F636B,0x6772756E74)));

        -- Validate the complete redesign before publishing its version marker.
        IF (SELECT COUNT(*) FROM `warden_checks`) <> 350
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `enabled` = 1) <> 350
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `architecture` = 0x783836) <> 196
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `architecture` = 0x783634) <> 154
           OR (SELECT COUNT(DISTINCT `architecture`)
               FROM `warden_checks`) <> 2
           OR (SELECT COUNT(DISTINCT `locale`)
               FROM `warden_checks`) <> 14
           OR (SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`
               WHERE `architecture` = 0x783836) <> 4
           OR (SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`
               WHERE `architecture` = 0x783634) <> 3
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE (`architecture` = 0x783836
                      AND `variant` NOT IN
                         (0x756E636C6173736966696564,0x73746F636B,
                          0x6C65676163792D6772756E74,0x6772756E74))
                  OR (`architecture` = 0x783634
                      AND `variant` NOT IN
                         (0x756E636C6173736966696564,0x73746F636B,
                          0x6772756E74)))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               GROUP BY `architecture`,`locale`,`variant`
               HAVING (`architecture` = 0x783836 AND (
                           (`variant` = 0x756E636C6173736966696564
                            AND COUNT(*) <> 4)
                        OR (`variant` IN
                              (0x73746F636B,0x6C65676163792D6772756E74)
                            AND COUNT(*) <> 3)
                        OR (`variant` = 0x6772756E74
                            AND COUNT(*) <> 4)))
                   OR (`architecture` = 0x783634 AND (
                           (`variant` = 0x756E636C6173736966696564
                            AND COUNT(*) <> 3)
                        OR (`variant` IN (0x73746F636B,0x6772756E74)
                            AND COUNT(*) <> 4))))
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `check_id` = 1004) <> 14
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `check_id` = 1004 AND (
                   `architecture` <> 0x783836
                   OR `variant` <> 0x756E636C6173736966696564
                   OR `type` <> 3 OR `enabled` <> 1
                   OR `sort_order` <> 40 OR `evidence_class` <> 3
                   OR `phase_mask` <> 0x01 OR `address_kind` <> 1
                   OR `module` <> 0x576F772E657865
                   OR `address` <> 0x003BFF88 OR `length` <> 24
                   OR OCTET_LENGTH(`request`) <> 0
                   OR OCTET_LENGTH(`expected`) <> 0
                   OR BINARY `comment` <> BINARY
                      'Exact x86 Grunt profile probe 4; non-actionable profile evidence'))
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `architecture` = 0x783836
                 AND `variant` = 0x6C65676163792D6772756E74) <> 42
           OR EXISTS (SELECT 1
               FROM `warden_checks` AS `legacy`
               LEFT JOIN `warden_checks` AS `grunt`
                 ON `grunt`.`build` = `legacy`.`build`
                AND `grunt`.`architecture` = `legacy`.`architecture`
                AND `grunt`.`locale` = `legacy`.`locale`
                AND `grunt`.`variant` = 0x6772756E74
                AND `grunt`.`check_id` = `legacy`.`check_id`
                AND `grunt`.`type` = `legacy`.`type`
                AND `grunt`.`enabled` = `legacy`.`enabled`
                AND `grunt`.`sort_order` = `legacy`.`sort_order`
                AND `grunt`.`evidence_class` = `legacy`.`evidence_class`
                AND `grunt`.`phase_mask` = `legacy`.`phase_mask`
                AND `grunt`.`address_kind` = `legacy`.`address_kind`
                AND `grunt`.`module` = `legacy`.`module`
                AND `grunt`.`address` = `legacy`.`address`
                AND `grunt`.`length` = `legacy`.`length`
                AND `grunt`.`request` = `legacy`.`request`
                AND `grunt`.`expected` = `legacy`.`expected`
                AND BINARY `grunt`.`comment` = BINARY `legacy`.`comment`
               WHERE `legacy`.`architecture` = 0x783836
                 AND `legacy`.`variant` = 0x6C65676163792D6772756E74
                 AND `grunt`.`check_id` IS NULL)
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `check_id` = 2002) <> 42
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `check_id` = 2002 AND (
                   (`architecture` = 0x783836
                    AND `variant` <> 0x6772756E74)
                   OR (`architecture` = 0x783634
                       AND `variant` NOT IN (0x73746F636B,0x6772756E74))
                   OR `type` <> 2 OR `enabled` <> 1
                   OR `sort_order` <> 35 OR `evidence_class` <> 3
                   OR `phase_mask` <> 0x06 OR `address_kind` <> 0
                   OR OCTET_LENGTH(`module`) <> 0
                   OR `address` <> 0 OR `length` <> 0
                   OR `request` <>
                      0x444246696C6573436C69656E745C4974656D2E646232
                   OR `expected` <>
                      0x4706FF83D9B611644A87DE79C244B414612EF4F2
                   OR BINARY `comment` <> BINARY
                      'Item.db2 archive digest; corroboration only')) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Redesigned Cata Warden catalogue validation failed';
        END IF;

        INSERT INTO `db_version`
            (`version`,`structure`,`content`,`description`,`comment`)
        VALUES
            (@cNewVersion,@cNewStructure,@cNewContent,
             @cNewDescription,@cNewComment);
        COMMIT;

        SET @cNewResult := (SELECT `description` FROM `db_version`
            WHERE `version` = @cNewVersion
              AND `structure` = @cNewStructure
              AND `content` = @cNewContent);
        SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,
               @cNewResult AS `===== DB is now on Version =====`;
    ELSEIF (@cCurVersion = @cNewVersion
            AND @cCurStructure = @cNewStructure
            AND @cCurContent = @cNewContent
            AND @cCurResult = @cNewResult
            AND @cNewResult = @cNewDescription) THEN
        SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,
               @cCurResult AS `===== DB is already on Version =====`;
    ELSEIF (@cCurResult IS NULL) THEN
        SELECT '* UPDATE FAILED *' AS `===== Status =====`,
               'Unable to locate DB Version Information'
                   AS `============= Error Message =============`;
    ELSE
        SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_',
            @cCurContent, ' - ', @cCurResult);
        SET @cOldOutput = CONCAT('Rel', @cOldVersion, '_', @cOldStructure, '_',
            @cOldContent, ' - IS NOT CURRENT');
        SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,
               @cOldOutput AS `=== Expected ===`,
               @cCurOutput AS `===== Found Version =====`;
    END IF;
END $$

DELIMITER ;

CALL update_mangos();
DROP PROCEDURE IF EXISTS `update_mangos`;
