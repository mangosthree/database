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

-- -------------------------------------------------------------------------
-- Publish the exact Cataclysm 4.3.4.15595 x64 Warden check catalogue.
-- The x86 catalogue is an exact predecessor and remains available for rollback.
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
    SET @cOldContent = '001';
    SET @cOldDescription = 'Cata_Warden_Checks';

    SET @cNewVersion = '22';
    SET @cNewStructure = '10';
    SET @cNewContent = '002';
    SET @cNewDescription = 'Cata_Warden_X64_Checks';
    SET @cNewComment = 'Publish exact Cata 4.3.4.15595 x64 Warden profiles';

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
        IF (SELECT COUNT(*) FROM `warden_checks`) <> 126
           OR (SELECT COUNT(*) FROM `warden_checks`
               WHERE `enabled` = 1) <> 126
           OR (SELECT COUNT(DISTINCT `locale`) FROM `warden_checks`) <> 14
           OR (SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`) <> 3
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `build` <> 15595 OR `architecture` <> 0x783836)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `locale` NOT IN
                   (0x64654445,0x656E434E,0x656E4742,0x656E5457,
                    0x656E5553,0x65734553,0x65734D58,0x66724652,
                    0x6B6F4B52,0x70744252,0x70745054,0x72755255,
                    0x7A68434E,0x7A685457))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `variant` NOT IN
                   (0x756E636C6173736966696564,0x73746F636B,0x6772756E74))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               GROUP BY `locale`,`variant`
               HAVING COUNT(*) <> 3)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE NOT (
                   (`variant` = 0x756E636C6173736966696564
                    AND `type` = 3 AND `evidence_class` = 3
                    AND `phase_mask` = 0x01 AND `address_kind` = 1
                    AND `module` = 0x576F772E657865
                    AND OCTET_LENGTH(`request`) = 0
                    AND OCTET_LENGTH(`expected`) = 0
                    AND ((`check_id` = 1001 AND `sort_order` = 10
                          AND `address` = 0x00007F7A AND `length` = 5
                          AND BINARY `comment` =
                              BINARY 'Exact x86 stock/grunt profile probe 1')
                      OR (`check_id` = 1002 AND `sort_order` = 20
                          AND `address` = 0x00088FAE AND `length` = 1
                          AND BINARY `comment` =
                              BINARY 'Exact x86 stock/grunt profile probe 2')
                      OR (`check_id` = 1003 AND `sort_order` = 30
                          AND `address` = 0x000895CA AND `length` = 7
                          AND BINARY `comment` =
                              BINARY 'Exact x86 stock/grunt profile probe 3')))
                   OR
                   (`variant` IN (0x73746F636B,0x6772756E74)
                    AND (
                        (`check_id` = 2001 AND `type` = 0
                         AND `sort_order` = 10 AND `evidence_class` = 0
                         AND `phase_mask` = 0x06 AND `address_kind` = 0
                         AND OCTET_LENGTH(`module`) = 0
                         AND `address` = 0 AND `length` = 0
                         AND OCTET_LENGTH(`request`) = 0
                         AND OCTET_LENGTH(`expected`) = 0
                         AND BINARY `comment` =
                             BINARY 'Delivered-module timing health')
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
                             'FrameScript execution integrity invariant')
                    ))
               )) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Exact x86 Warden predecessor validation failed';
        END IF;

        INSERT INTO `warden_checks`
        (`build`,`architecture`,`locale`,`variant`,`check_id`,`type`,
         `enabled`,`sort_order`,`evidence_class`,`phase_mask`,
         `address_kind`,`module`,`address`,`length`,`request`,
         `expected`,`comment`)
        VALUES
(15595,0x783634,0x64654445,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x64654445,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x64654445,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x64654445,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x64654445,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x64654445,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x64654445,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x64654445,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x64654445,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E434E,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x656E434E,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x656E434E,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x656E434E,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E434E,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E434E,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E434E,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E434E,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E434E,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E4742,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x656E4742,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x656E4742,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x656E4742,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E4742,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E4742,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E4742,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E4742,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E4742,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E5457,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x656E5457,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x656E5457,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x656E5457,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E5457,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E5457,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E5457,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E5457,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E5457,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E5553,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x656E5553,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x656E5553,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x656E5553,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E5553,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E5553,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x656E5553,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x656E5553,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x656E5553,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x65734553,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x65734553,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x65734553,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x65734553,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x65734553,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x65734553,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x65734553,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x65734553,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x65734553,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x65734D58,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x65734D58,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x65734D58,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x65734D58,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x65734D58,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x65734D58,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x65734D58,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x65734D58,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x65734D58,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x66724652,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x66724652,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x66724652,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x66724652,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x66724652,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x66724652,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x66724652,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x66724652,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x66724652,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x6B6F4B52,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x6B6F4B52,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x6B6F4B52,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x6B6F4B52,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x6B6F4B52,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xED9995EC9DB8,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x6B6F4B52,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x6B6F4B52,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x6B6F4B52,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xED9995EC9DB8,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x6B6F4B52,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x70744252,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x70744252,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x70744252,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x70744252,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x70744252,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x70744252,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x70744252,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x70744252,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x70744252,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x70745054,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x70745054,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x70745054,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x70745054,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x70745054,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x70745054,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x70745054,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x70745054,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x70745054,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x72755255,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x72755255,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x72755255,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x72755255,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x72755255,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xD09ED09A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x72755255,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x72755255,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x72755255,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xD09ED09A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x72755255,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x7A68434E,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x7A68434E,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x7A68434E,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x7A68434E,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x7A68434E,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x7A68434E,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x7A68434E,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x7A68434E,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x7A68434E,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x7A685457,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772D36342E657865,0x000AB76F,5,X'',X'','Exact x64 stock/grunt profile probe 1'),
        (15595,0x783634,0x7A685457,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772D36342E657865,0x000AABAB,2,X'',X'','Exact x64 stock/grunt profile probe 2'),
        (15595,0x783634,0x7A685457,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772D36342E657865,0x000AA6D3,2,X'',X'','Exact x64 stock/grunt profile probe 3'),
        (15595,0x783634,0x7A685457,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x7A685457,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x7A685457,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant'),
        (15595,0x783634,0x7A685457,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783634,0x7A685457,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783634,0x7A685457,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772D36342E657865,0x00566C13,16,X'',0x4883C9FF33C0488BFDBAF0D8FFFFF2AE,'FrameScript execution integrity invariant');

        -- Prove that the publication is complete and no unsupported profile was
        -- introduced before advancing db_version.
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
                  OR `architecture` NOT IN (0x783836,0x783634))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               GROUP BY `architecture`,`locale`,`variant`
               HAVING COUNT(*) <> 3)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `architecture` = 0x783634
                 AND NOT (
                   (`variant` = 0x756E636C6173736966696564
                    AND `type` = 3 AND `evidence_class` = 3
                    AND `phase_mask` = 0x01 AND `address_kind` = 1
                    AND `module` = 0x576F772D36342E657865
                    AND OCTET_LENGTH(`request`) = 0
                    AND OCTET_LENGTH(`expected`) = 0
                    AND ((`check_id` = 1001 AND `sort_order` = 10
                          AND `address` = 0x000AB76F AND `length` = 5
                          AND BINARY `comment` =
                              BINARY 'Exact x64 stock/grunt profile probe 1')
                      OR (`check_id` = 1002 AND `sort_order` = 20
                          AND `address` = 0x000AABAB AND `length` = 2
                          AND BINARY `comment` =
                              BINARY 'Exact x64 stock/grunt profile probe 2')
                      OR (`check_id` = 1003 AND `sort_order` = 30
                          AND `address` = 0x000AA6D3 AND `length` = 2
                          AND BINARY `comment` =
                              BINARY 'Exact x64 stock/grunt profile probe 3')))
                   OR
                   (`variant` IN (0x73746F636B,0x6772756E74)
                    AND (
                        (`check_id` = 2001 AND `type` = 0
                         AND `sort_order` = 10 AND `evidence_class` = 0
                         AND `phase_mask` = 0x06 AND `address_kind` = 0
                         AND OCTET_LENGTH(`module`) = 0
                         AND `address` = 0 AND `length` = 0
                         AND OCTET_LENGTH(`request`) = 0
                         AND OCTET_LENGTH(`expected`) = 0
                         AND BINARY `comment` =
                             BINARY 'Delivered-module timing health')
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
                             'FrameScript execution integrity invariant')
                    ))
                 ))
           OR EXISTS (
               SELECT 1
                 FROM `warden_checks` AS `x64`
                 LEFT JOIN `warden_checks` AS `x86`
                   ON `x86`.`build` = `x64`.`build`
                  AND `x86`.`architecture` = 0x783836
                  AND `x86`.`locale` = `x64`.`locale`
                  AND `x86`.`variant` = `x64`.`variant`
                  AND `x86`.`check_id` = `x64`.`check_id`
                WHERE `x64`.`architecture` = 0x783634
                  AND `x64`.`check_id` = 2003
                  AND (`x86`.`check_id` IS NULL
                       OR `x86`.`expected` <> `x64`.`expected`)
           ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Expanded x64 Warden catalogue validation failed';
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
