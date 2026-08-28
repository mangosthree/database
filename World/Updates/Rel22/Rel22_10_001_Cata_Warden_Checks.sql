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
-- Publish the exact Cataclysm 4.3.4.15595 x86 Warden check catalogue.
-- The x64 module remains compatibility-probe-only and owns no database rows.
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

    SET @cCurVersion := (SELECT `version` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cCurStructure := (SELECT `structure` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cCurContent := (SELECT `content` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);

    SET @cOldVersion = '22';
    SET @cOldStructure = '09';
    SET @cOldContent = '001';

    SET @cNewVersion = '22';
    SET @cNewStructure = '10';
    SET @cNewContent = '001';
    SET @cNewDescription = 'Cata_Warden_Checks';
    SET @cNewComment = 'Publish exact Cata 4.3.4.15595 x86 Warden profiles';

    SET @cCurResult := (SELECT `description` FROM `db_version` ORDER BY `version` DESC, `structure` DESC, `content` DESC LIMIT 0,1);
    SET @cOldResult := (SELECT `description` FROM `db_version` WHERE `version` = @cOldVersion AND `structure` = @cOldStructure AND `content` = @cOldContent);
    SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version` = @cNewVersion AND `structure` = @cNewStructure AND `content` = @cNewContent);

    IF (@cCurResult = @cOldResult) THEN
        IF (SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`TABLES`
            WHERE `TABLE_SCHEMA` = DATABASE()
              AND `TABLE_NAME` = 'warden_checks'
              AND `TABLE_TYPE` = 'BASE TABLE') <> 1 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Required dormant warden_checks table is missing';
        END IF;

        SET @cHasPlatform := (SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
            WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'warden_checks'
              AND `COLUMN_NAME` = 'platform');
        SET @cHasArchitecture := (SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
            WHERE `TABLE_SCHEMA` = DATABASE() AND `TABLE_NAME` = 'warden_checks'
              AND `COLUMN_NAME` = 'architecture');

        IF @cHasPlatform = 1 AND @cHasArchitecture = 0 THEN
            IF (SELECT COUNT(*) FROM `warden_checks`) <> 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Dormant warden_checks contains operator rows';
            END IF;
        ELSEIF NOT (@cHasPlatform = 0 AND @cHasArchitecture = 1) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'warden_checks is neither dormant nor resumable';
        END IF;

        -- At the old marker an architecture-form table can only be residue from
        -- this update. Rebuild it deterministically; never discard old-schema rows.
        DROP TABLE IF EXISTS `warden_checks`;
        CREATE TABLE `warden_checks` (
          `build` SMALLINT UNSIGNED NOT NULL,
          `architecture` VARBINARY(4) NOT NULL,
          `locale` BINARY(4) NOT NULL,
          `variant` VARBINARY(16) NOT NULL,
          `check_id` INT UNSIGNED NOT NULL,
          `type` TINYINT UNSIGNED NOT NULL,
          `enabled` TINYINT UNSIGNED NOT NULL,
          `sort_order` SMALLINT UNSIGNED NOT NULL,
          `evidence_class` TINYINT UNSIGNED NOT NULL,
          `phase_mask` TINYINT UNSIGNED NOT NULL,
          `address_kind` TINYINT UNSIGNED NOT NULL,
          `module` VARBINARY(255) NOT NULL DEFAULT '',
          `address` BIGINT UNSIGNED NOT NULL DEFAULT 0,
          `length` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
          `request` VARBINARY(255) NOT NULL DEFAULT '',
          `expected` VARBINARY(255) NOT NULL DEFAULT '',
          `comment` VARCHAR(255) NOT NULL DEFAULT '',
          PRIMARY KEY (`build`,`architecture`,`locale`,`variant`,`check_id`),
          UNIQUE KEY `uq_warden_checks_profile_order`
            (`build`,`architecture`,`locale`,`variant`,`sort_order`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC
          COMMENT='Exact Cata Warden check catalogue';

        START TRANSACTION;
        INSERT INTO `warden_checks`
        (`build`,`architecture`,`locale`,`variant`,`check_id`,`type`,`enabled`,
         `sort_order`,`evidence_class`,`phase_mask`,`address_kind`,`module`,
         `address`,`length`,`request`,`expected`,`comment`)
        VALUES
        (15595,0x783836,0x64654445,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x64654445,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x64654445,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x64654445,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x64654445,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x64654445,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x64654445,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x64654445,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x64654445,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E434E,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x656E434E,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x656E434E,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x656E434E,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E434E,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E434E,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E434E,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E434E,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E434E,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E4742,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x656E4742,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x656E4742,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x656E4742,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E4742,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E4742,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E4742,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E4742,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E4742,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E5457,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x656E5457,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x656E5457,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x656E5457,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E5457,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E5457,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E5457,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E5457,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E5457,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E5553,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x656E5553,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x656E5553,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x656E5553,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E5553,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E5553,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x656E5553,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x656E5553,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B6179,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x656E5553,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x65734553,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x65734553,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x65734553,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x65734553,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x65734553,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x65734553,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x65734553,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x65734553,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x65734553,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x65734D58,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x65734D58,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x65734D58,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x65734D58,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x65734D58,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x65734D58,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x65734D58,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x65734D58,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x41636570746172,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x65734D58,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x66724652,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x66724652,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x66724652,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x66724652,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x66724652,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x66724652,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x66724652,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x66724652,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F4B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x66724652,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x6B6F4B52,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x6B6F4B52,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x6B6F4B52,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x6B6F4B52,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x6B6F4B52,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xED9995EC9DB8,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x6B6F4B52,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x6B6F4B52,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x6B6F4B52,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xED9995EC9DB8,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x6B6F4B52,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x70744252,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x70744252,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x70744252,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x70744252,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x70744252,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x70744252,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x70744252,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x70744252,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x70744252,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x70745054,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x70745054,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x70745054,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x70745054,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x70745054,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x70745054,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x70745054,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x70745054,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0x4F6B,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x70745054,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x72755255,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x72755255,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x72755255,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x72755255,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x72755255,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xD09ED09A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x72755255,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x72755255,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x72755255,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xD09ED09A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x72755255,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x7A68434E,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x7A68434E,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x7A68434E,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x7A68434E,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x7A68434E,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x7A68434E,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x7A68434E,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x7A68434E,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A1AEE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x7A68434E,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x7A685457,0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,0x576F772E657865,0x00007F7A,5,X'',X'','Exact x86 stock/grunt profile probe 1'),
        (15595,0x783836,0x7A685457,0x756E636C6173736966696564,1002,3,1,20,3,0x01,1,0x576F772E657865,0x00088FAE,1,X'',X'','Exact x86 stock/grunt profile probe 2'),
        (15595,0x783836,0x7A685457,0x756E636C6173736966696564,1003,3,1,30,3,0x01,1,0x576F772E657865,0x000895CA,7,X'',X'','Exact x86 stock/grunt profile probe 3'),
        (15595,0x783836,0x7A685457,0x73746F636B,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x7A685457,0x73746F636B,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x7A685457,0x73746F636B,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant'),
        (15595,0x783836,0x7A685457,0x6772756E74,2001,0,1,10,0,0x06,0,X'',0,0,X'',X'','Delivered-module timing health'),
        (15595,0x783836,0x7A685457,0x6772756E74,2003,1,1,30,3,0x06,0,X'',0,0,0x4F4B4159,0xE7A2BAE5AE9A,'Localized OKAY callback; corroboration only'),
        (15595,0x783836,0x7A685457,0x6772756E74,2004,3,1,40,1,0x0E,1,0x576F772E657865,0x0043C257,12,X'',0x538B5D08568BC3578D50018A,'FrameScript execution integrity invariant');

        IF (SELECT COUNT(*) FROM `warden_checks`) <> 126
           OR (SELECT COUNT(*) FROM `warden_checks` WHERE `enabled` = 1) <> 126
           OR (SELECT COUNT(DISTINCT `locale`) FROM `warden_checks`) <> 14
           OR (SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`) <> 3
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `build` <> 15595 OR `architecture` <> 0x783836)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `variant` NOT IN
                   (0x756E636C6173736966696564,0x73746F636B,0x6772756E74))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               GROUP BY `locale`,`variant`
               HAVING (`variant` = 0x756E636C6173736966696564 AND COUNT(*) <> 3)
                   OR (`variant` IN (0x73746F636B,0x6772756E74) AND COUNT(*) <> 3))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE (`variant` = 0x756E636C6173736966696564
                       AND (`phase_mask` <> 0x01 OR `type` <> 3
                            OR `evidence_class` <> 3 OR `address_kind` <> 1
                            OR OCTET_LENGTH(`expected`) <> 0))
                  OR (`variant` <> 0x756E636C6173736966696564
                      AND (`phase_mask` & 0x01) <> 0))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `phase_mask` = 0 OR (`phase_mask` & ~0x0F) <> 0
                  OR `address_kind` NOT IN (0,1,2))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE (`address_kind` = 1
                       AND (`module` <> 0x576F772E657865 OR `address` = 0
                            OR `length` = 0 OR `length` > 255))
                  OR (`address_kind` = 0
                      AND (OCTET_LENGTH(`module`) <> 0 OR `address` <> 0
                           OR `length` <> 0)))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE (`type` = 0 AND (OCTET_LENGTH(`request`) <> 0
                                      OR OCTET_LENGTH(`expected`) <> 0))
                  OR (`type` = 1 AND (OCTET_LENGTH(`request`) = 0
                                      OR OCTET_LENGTH(`expected`) = 0))
                  OR (`type` = 3 AND `variant` <> 0x756E636C6173736966696564
                      AND OCTET_LENGTH(`expected`) <> `length`)
                  OR `type` NOT IN (0,1,3))
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `type` = 3
               GROUP BY `variant`,`check_id`
               HAVING COUNT(DISTINCT `module`,`address`,`length`,`expected`) <> 1)
           OR EXISTS (SELECT 1 FROM `warden_checks`
               WHERE `architecture` = 0x783634) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Cata Warden catalogue validation failed';
        END IF;

        INSERT INTO `db_version`
            (`version`,`structure`,`content`,`description`,`comment`)
        VALUES
            (@cNewVersion,@cNewStructure,@cNewContent,
             @cNewDescription,@cNewComment);
        COMMIT;

        SET @cNewResult := (SELECT `description` FROM `db_version` WHERE `version` = @cNewVersion AND `structure` = @cNewStructure AND `content` = @cNewContent);
        SELECT '* UPDATE COMPLETE *' AS `===== Status =====`,
               @cNewResult AS `===== DB is now on Version =====`;
    ELSEIF (@cCurResult = @cNewResult) THEN
        SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,
               @cCurResult AS `===== DB is already on Version =====`;
    ELSEIF (@cCurResult IS NULL) THEN
        SELECT '* UPDATE FAILED *' AS `===== Status =====`,
               'Unable to locate DB Version Information' AS `============= Error Message =============`;
    ELSE
        SET @cCurOutput = CONCAT(@cCurVersion, '_', @cCurStructure, '_', @cCurContent, ' - ', @cCurResult);
        SET @cOldOutput = CONCAT('Rel', @cOldVersion, '_', @cOldStructure, '_', @cOldContent, ' - IS NOT CURRENT');
        SELECT '* UPDATE SKIPPED *' AS `===== Status =====`,
               @cOldOutput AS `=== Expected ===`,
               @cCurOutput AS `===== Found Version =====`;
    END IF;
END $$

DELIMITER ;

CALL update_mangos();
DROP PROCEDURE IF EXISTS `update_mangos`;
