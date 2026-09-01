#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
#
# MaNGOS is a full featured server for World of Warcraft, supporting
# the following clients: 1.12.x, 2.4.3, 3.3.5a, 4.3.4a and 5.4.8
#
# Copyright (C) 2005-2026 MaNGOS <https://www.getmangos.eu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# World of Warcraft, and all World of Warcraft or Warcraft art, images,
# and lore are copyrighted by Blizzard Entertainment, Inc.

"""Static and disposable-schema checks for the Cata Warden migrations."""

from __future__ import annotations

import os
import re
import shutil
import subprocess
import sys
import unittest
import uuid
from contextlib import contextmanager
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REALM_UPDATE = (
    ROOT / "Realm" / "Updates" / "Rel22"
    / "Rel22_05_001_Cata_Warden_Identity.sql"
)
WORLD_UPDATE = (
    ROOT / "World" / "Updates" / "Rel22"
    / "Rel22_10_001_Cata_Warden_Checks.sql"
)
WORLD_X64_UPDATE = (
    ROOT / "World" / "Updates" / "Rel22"
    / "Rel22_10_002_Cata_Warden_X64_Checks.sql"
)
WORLD_MPQ_UPDATE = (
    ROOT / "World" / "Updates" / "Rel22"
    / "Rel22_10_003_Cata_Warden_MPQ_Checks.sql"
)
INTEGRATION = "--integration" in sys.argv
if INTEGRATION:
    sys.argv.remove("--integration")


class MariaDbHarness:
    def __init__(self) -> None:
        self.client = shutil.which("mariadb") or shutil.which("mysql")
        if not self.client:
            raise RuntimeError("mariadb/mysql client was not found")
        required = (
            "MANGOS_TEST_DB_HOST",
            "MANGOS_TEST_DB_PORT",
            "MANGOS_TEST_DB_USER",
            "MANGOS_TEST_DB_PASSWORD",
        )
        missing = [name for name in required if name not in os.environ]
        if missing:
            raise RuntimeError(
                "missing integration environment: " + ", ".join(missing)
            )
        self.host = os.environ[required[0]]
        self.port = os.environ[required[1]]
        self.user = os.environ[required[2]]
        self.password = os.environ[required[3]]

    def execute(
        self,
        sql: str,
        database: str | None = None,
        *,
        expect_success: bool = True,
    ) -> subprocess.CompletedProcess[str]:
        command = [
            self.client,
            "--batch",
            "--skip-column-names",
            "--raw",
            "--host",
            self.host,
            "--port",
            self.port,
            "--user",
            self.user,
        ]
        if database is not None:
            self.validate_schema_name(database)
            command.extend(("--database", database))
        environment = os.environ.copy()
        environment["MYSQL_PWD"] = self.password
        result = subprocess.run(
            command,
            input=sql,
            text=True,
            capture_output=True,
            encoding="utf-8",
            errors="replace",
            env=environment,
            check=False,
        )
        if expect_success and result.returncode != 0:
            raise AssertionError(result.stdout + result.stderr)
        return result

    @staticmethod
    def validate_schema_name(name: str) -> None:
        if not re.fullmatch(r"warden_(?:realm|world)_test_[0-9a-f]{12}", name):
            raise ValueError(f"refusing unsafe schema name: {name!r}")

    @contextmanager
    def schema(self, kind: str):
        name = f"warden_{kind}_test_{uuid.uuid4().hex[:12]}"
        self.validate_schema_name(name)
        self.execute(f"CREATE DATABASE `{name}` CHARACTER SET utf8;")
        try:
            yield name
        finally:
            self.validate_schema_name(name)
            self.execute(f"DROP DATABASE IF EXISTS `{name}`;")


REALM_SCHEMA_PREFIX = """
CREATE TABLE `db_version` (
  `version` INT NOT NULL,
  `structure` INT NOT NULL,
  `content` INT NOT NULL,
  `description` VARCHAR(30) NOT NULL,
  `comment` VARCHAR(150) DEFAULT NULL,
  PRIMARY KEY (`version`,`structure`,`content`)
) ENGINE=InnoDB;
INSERT INTO `db_version` VALUES (22,4,1,'Warden audit','fixture');
CREATE TABLE `warden_audit` (
  `audit_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `occurred_at` BIGINT UNSIGNED NOT NULL,
  `realm_id` INT UNSIGNED NOT NULL,
  `client_build` SMALLINT UNSIGNED NOT NULL,
  `client_platform` VARBINARY(4) NOT NULL,
  `client_locale` BINARY(4) NOT NULL,
  `check_id` INT UNSIGNED NOT NULL,
  `check_type` TINYINT UNSIGNED NOT NULL,
  `evidence_class` TINYINT UNSIGNED NOT NULL,
  `outcome` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`audit_id`)
) ENGINE=InnoDB;
CREATE TABLE `warden_incident` (
  `incident_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `account_id` INT UNSIGNED NOT NULL,
  `occurred_at` BIGINT UNSIGNED NOT NULL,
  `realm_id` INT UNSIGNED NOT NULL,
  `client_build` SMALLINT UNSIGNED NOT NULL,
  `client_platform` VARBINARY(4) NOT NULL,
  `client_locale` BINARY(4) NOT NULL,
  `check_id` INT UNSIGNED NOT NULL,
  `check_type` TINYINT UNSIGNED NOT NULL,
  `evidence_class` TINYINT UNSIGNED NOT NULL,
  `outcome` TINYINT UNSIGNED NOT NULL,
  `ban_triggered` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`incident_id`)
) ENGINE=InnoDB;
INSERT INTO `warden_audit`
  (`account_id`,`occurred_at`,`realm_id`,`client_build`,`client_platform`,
   `client_locale`,`check_id`,`check_type`,`evidence_class`,`outcome`)
VALUES (1,2,3,15595,'Win','enUS',4,3,2,1);
INSERT INTO `warden_incident`
  (`account_id`,`occurred_at`,`realm_id`,`client_build`,`client_platform`,
   `client_locale`,`check_id`,`check_type`,`evidence_class`,`outcome`,
   `ban_triggered`)
VALUES (1,2,3,15595,'Win','enUS',4,3,2,1,0);
"""

WORLD_DORMANT_SCHEMA = """
CREATE TABLE `db_version` (
  `version` INT NOT NULL,
  `structure` INT NOT NULL,
  `content` INT NOT NULL,
  `description` VARCHAR(30) NOT NULL,
  `comment` VARCHAR(150) DEFAULT NULL,
  PRIMARY KEY (`version`,`structure`,`content`)
) ENGINE=InnoDB;
INSERT INTO `db_version` VALUES (22,9,1,'Dormant_Warden_Checks','fixture');
CREATE TABLE `warden_checks` (
  `build` SMALLINT UNSIGNED NOT NULL,
  `platform` VARBINARY(4) NOT NULL,
  `locale` BINARY(4) NOT NULL,
  `check_id` INT UNSIGNED NOT NULL,
  `type` TINYINT UNSIGNED NOT NULL,
  `enabled` TINYINT UNSIGNED NOT NULL,
  `sort_order` SMALLINT UNSIGNED NOT NULL,
  `evidence_class` TINYINT UNSIGNED NOT NULL,
  `module` VARBINARY(255) NOT NULL DEFAULT '',
  `address` INT UNSIGNED NOT NULL DEFAULT 0,
  `length` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `request` VARBINARY(255) NOT NULL DEFAULT '',
  `expected` VARBINARY(255) NOT NULL DEFAULT '',
  `comment` VARCHAR(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`build`,`platform`,`locale`,`check_id`),
  UNIQUE KEY `uq_warden_checks_profile_order`
    (`build`,`platform`,`locale`,`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
"""


class RealmMigrationContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sql = REALM_UPDATE.read_text(encoding="utf-8")

    def test_advances_exact_realm_version_and_description(self) -> None:
        self.assertRegex(self.sql, r"SET\s+@cOldVersion\s*=\s*'22'")
        self.assertRegex(self.sql, r"SET\s+@cOldStructure\s*=\s*'04'")
        self.assertRegex(self.sql, r"SET\s+@cOldContent\s*=\s*'001'")
        self.assertRegex(self.sql, r"SET\s+@cNewVersion\s*=\s*'22'")
        self.assertRegex(self.sql, r"SET\s+@cNewStructure\s*=\s*'05'")
        self.assertRegex(self.sql, r"SET\s+@cNewContent\s*=\s*'001'")
        self.assertRegex(
            self.sql,
            r"SET\s+@cNewDescription\s*=\s*'Cata Warden identity'",
        )

    def test_uses_resignalling_exit_handler(self) -> None:
        handler = re.search(
            r"DECLARE\s+EXIT\s+HANDLER\s+FOR\s+SQLEXCEPTION(?P<body>.*?)END;",
            self.sql,
            flags=re.IGNORECASE | re.DOTALL,
        )
        self.assertIsNotNone(handler)
        assert handler is not None
        self.assertIn("ROLLBACK", handler.group("body").upper())
        self.assertIn("SHOW ERRORS", handler.group("body").upper())
        self.assertIn("RESIGNAL", handler.group("body").upper())

    def test_adds_exact_resumable_variant_columns_to_both_tables(self) -> None:
        for table in ("warden_audit", "warden_incident"):
            self.assertRegex(
                self.sql,
                rf"ALTER\s+TABLE\s+`{table}`\s+ADD\s+COLUMN\s+"
                r"`client_variant`\s+VARBINARY\(16\)\s+NOT\s+NULL\s+"
                r"DEFAULT\s+'unclassified'",
            )
            self.assertIsNotNone(re.search(
                rf"`?INFORMATION_SCHEMA`?\.`?COLUMNS`?.*?"
                rf"`?TABLE_NAME`?\s*=\s*'{table}'",
                self.sql,
                flags=re.IGNORECASE | re.DOTALL,
            ))

    def test_preserves_tables_and_verifies_backfilled_values(self) -> None:
        self.assertNotRegex(
            self.sql,
            r"(?i)\b(?:DROP|TRUNCATE)\s+(?:TABLE\s+)?"
            r"`warden_(?:audit|incident)`",
        )
        self.assertGreaterEqual(
            len(re.findall(r"client_variant.*?unclassified", self.sql,
                           flags=re.IGNORECASE | re.DOTALL)),
            4,
        )
        self.assertGreaterEqual(
            len(re.findall(r"COLUMN_TYPE.*?varbinary\(16\)", self.sql,
                           flags=re.IGNORECASE | re.DOTALL)),
            2,
        )


class WorldMigrationContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sql = WORLD_UPDATE.read_text(encoding="utf-8")

    def test_advances_exact_world_version_and_description(self) -> None:
        for name, value in (
            ("OldVersion", "22"),
            ("OldStructure", "09"),
            ("OldContent", "001"),
            ("NewVersion", "22"),
            ("NewStructure", "10"),
            ("NewContent", "001"),
        ):
            self.assertRegex(
                self.sql, rf"SET\s+@c{name}\s*=\s*'{value}'"
            )
        self.assertRegex(
            self.sql,
            r"SET\s+@cNewDescription\s*=\s*'Cata_Warden_Checks'",
        )

    def test_rebuilds_only_an_empty_dormant_catalogue(self) -> None:
        guard = self.sql.find("COUNT(*) FROM `warden_checks`")
        drop = self.sql.find("DROP TABLE IF EXISTS `warden_checks`")
        self.assertGreaterEqual(guard, 0)
        self.assertGreater(drop, guard)
        self.assertIn("RESIGNAL", self.sql)
        self.assertNotIn("DELETE FROM `warden_checks`", self.sql)

    def test_schema_carries_exact_cata_identity_and_widths(self) -> None:
        create = re.search(
            r"CREATE\s+TABLE\s+`warden_checks`\s*\((?P<body>.*?)\)\s*ENGINE",
            self.sql,
            flags=re.IGNORECASE | re.DOTALL,
        )
        self.assertIsNotNone(create)
        assert create is not None
        body = create.group("body")
        self.assertNotRegex(body, r"(?i)`platform`")
        for contract in (
            r"`architecture`\s+VARBINARY\(4\)\s+NOT\s+NULL",
            r"`variant`\s+VARBINARY\(16\)\s+NOT\s+NULL",
            r"`phase_mask`\s+TINYINT\s+UNSIGNED\s+NOT\s+NULL",
            r"`address_kind`\s+TINYINT\s+UNSIGNED\s+NOT\s+NULL",
            r"`address`\s+BIGINT\s+UNSIGNED\s+NOT\s+NULL",
        ):
            self.assertRegex(body, contract)
        self.assertRegex(
            body,
            r"PRIMARY\s+KEY\s*\(`build`,`architecture`,`locale`,"
            r"`variant`,`check_id`\)",
        )
        self.assertRegex(
            body,
            r"UNIQUE\s+KEY\s+`uq_warden_checks_profile_order`\s*\("
            r"`build`,`architecture`,`locale`,`variant`,`sort_order`\)",
        )

    def test_seed_is_x86_only_complete_and_manifest_sized(self) -> None:
        rows = re.findall(
            r"(?m)^\s*\(15595,0x783836,0x[0-9A-F]+,0x[0-9A-F]+,",
            self.sql,
        )
        self.assertEqual(len(rows), 126)
        self.assertNotRegex(
            self.sql,
            r"(?m)^\s*\(15595,0x783634,",
        )
        self.assertIn("<> 126", self.sql)
        self.assertRegex(
            self.sql,
            r"COUNT\(DISTINCT `locale`\) FROM `warden_checks`\) <> 14",
        )
        self.assertRegex(
            self.sql,
            r"COUNT\(DISTINCT `variant`\) FROM `warden_checks`\) <> 3",
        )
        self.assertNotRegex(
            self.sql,
            r"(?m)^\s*\(15595,0x783836,0x[0-9A-F]+,0x[0-9A-F]+,2002,2,",
        )

    def test_probe_and_classified_phase_contracts_are_asserted(self) -> None:
        self.assertIn("`variant` = 0x756E636C6173736966696564", self.sql)
        self.assertIn("`phase_mask` <> 0x01", self.sql)
        self.assertIn("`evidence_class` <> 3", self.sql)
        self.assertIn("`phase_mask` & ~0x0F", self.sql)
        self.assertIn("`address_kind` NOT IN (0,1,2)", self.sql)

        probe_rows = re.findall(
            r"(?m)^\s*\(15595,0x783836,0x[0-9A-F]+,"
            r"0x756E636C6173736966696564,10(?:01|02|03),3,1,"
            r"(?:10|20|30),3,0x01,1,",
            self.sql,
        )
        self.assertEqual(len(probe_rows), 42)


class WorldX64MigrationContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sql = WORLD_X64_UPDATE.read_text(encoding="utf-8")

    def test_advances_the_published_catalogue_to_the_x64_marker(self) -> None:
        for name, value in (
            ("OldVersion", "22"),
            ("OldStructure", "10"),
            ("OldContent", "001"),
            ("NewVersion", "22"),
            ("NewStructure", "10"),
            ("NewContent", "002"),
        ):
            self.assertRegex(
                self.sql, rf"SET\s+@c{name}\s*=\s*'{value}'"
            )
        self.assertRegex(
            self.sql,
            r"SET\s+@cNewDescription\s*=\s*'Cata_Warden_X64_Checks'",
        )

    def test_x64_seed_contains_only_the_complete_profile_contract(self) -> None:
        rows = re.findall(
            r"(?m)^\s*\(15595,0x783634,0x([0-9A-F]+),"
            r"0x([0-9A-F]+),(\d+),(\d+),1,(\d+),(\d+),"
            r"0x([0-9A-F]+),(\d+),(X''|0x[0-9A-F]+),"
            r"(0|0x[0-9A-F]+),(\d+),",
            self.sql,
        )
        self.assertEqual(len(rows), 126)
        self.assertNotRegex(self.sql, r"(?m)^\s*\(15595,0x783836,")

        locales = {row[0] for row in rows}
        self.assertEqual(len(locales), 14)
        by_profile = {}
        for row in rows:
            by_profile.setdefault((row[0], row[1]), []).append(row)
        self.assertEqual(len(by_profile), 42)
        self.assertTrue(all(len(profile) == 3 for profile in by_profile.values()))
        self.assertEqual(
            {variant for _, variant in by_profile},
            {
                "756E636C6173736966696564",
                "73746F636B",
                "6772756E74",
            },
        )
        for row in rows:
            address_kind = int(row[7])
            module, address, length = row[8:11]
            if address_kind == 1:
                self.assertEqual(module, "0x576F772D36342E657865")
                self.assertNotEqual(address, "0")
                self.assertGreater(int(length), 0)
            else:
                self.assertEqual(address_kind, 0)
                self.assertEqual(module, "X''")
                self.assertEqual(address, "0")
                self.assertEqual(length, "0")


class WorldMpqMigrationContract(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sql = WORLD_MPQ_UPDATE.read_text(encoding="utf-8")

    def test_advances_the_exact_x64_predecessor_to_the_mpq_marker(self) -> None:
        for name, value in (
            ("OldVersion", "22"),
            ("OldStructure", "10"),
            ("OldContent", "002"),
            ("NewVersion", "22"),
            ("NewStructure", "10"),
            ("NewContent", "003"),
        ):
            self.assertRegex(
                self.sql, rf"SET\s+@c{name}\s*=\s*'{value}'"
            )
        self.assertRegex(
            self.sql,
            r"SET\s+@cNewDescription\s*=\s*'Cata_Warden_MPQ_Checks'",
        )

    def test_is_an_atomic_redesign_with_exact_cardinality_guards(self) -> None:
        self.assertIn("START TRANSACTION", self.sql.upper())
        self.assertNotRegex(
            self.sql,
            r"(?i)\b(?:DROP|TRUNCATE)\s+(?:TABLE\s+)?`?warden_checks`?",
        )
        self.assertNotRegex(self.sql, r"(?i)DELETE\s+FROM\s+`?warden_checks`?")
        for fragment in (
            "COUNT(*) FROM `warden_checks`) <> 252",
            "COUNT(*) FROM `warden_checks`) <> 350",
            "WHERE `architecture` = 0x783836) <> 196",
            "WHERE `architecture` = 0x783634) <> 154",
        ):
            self.assertIn(fragment, self.sql)
        self.assertRegex(
            self.sql,
            r"COUNT\(DISTINCT `locale`\)\s+FROM `warden_checks`\)\s*<> 14",
        )

    def test_versions_legacy_grunt_and_publishes_current_x86_contract(self) -> None:
        for fragment in (
            "0x6C65676163792D6772756E74",
            "1004 AS `check_id`",
            "40 AS `sort_order`",
            "0x01 AS `phase_mask`",
            "1 AS `address_kind`",
            "0x576F772E657865 AS `module`",
            "0x003BFF88 AS `address`",
            "24 AS `length`",
            "X'' AS `expected`",
            "OCTET_LENGTH(`expected`) <> 0",
            "2002 AS `check_id`",
            "2 AS `type`",
            "35 AS `sort_order`",
            "3 AS `evidence_class`",
            "0x06 AS `phase_mask`",
            "0x444246696C6573436C69656E745C4974656D2E646232 AS `request`",
            "0x4706FF83D9B611644A87DE79C244B414612EF4F2 AS `expected`",
        ):
            self.assertIn(fragment, self.sql)
        self.assertIn("`architecture` = 0x783836", self.sql)
        self.assertIn("`architecture` = 0x783634", self.sql)


@unittest.skipUnless(INTEGRATION, "pass --integration for disposable schemas")
class WorldX64MigrationIntegration(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.db = MariaDbHarness()
        cls.x86_update = WORLD_UPDATE.read_text(encoding="utf-8")
        cls.x64_update = WORLD_X64_UPDATE.read_text(encoding="utf-8")

    def apply_x86_catalogue(self, schema: str) -> None:
        self.db.execute(WORLD_DORMANT_SCHEMA, schema)
        self.db.execute(self.x86_update, schema)

    def test_forward_and_replay_publish_the_exact_x64_catalogue(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            self.db.execute(self.x64_update, schema)

            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2
                    AND `description`='Cata_Warden_X64_Checks';
                SELECT COUNT(*) FROM `warden_checks` WHERE `enabled`=1;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836 AND `enabled`=1;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634 AND `enabled`=1;
                SELECT COUNT(DISTINCT `locale`) FROM `warden_checks`;
                SELECT COUNT(*) FROM (
                  SELECT `architecture`,`locale`,`variant`,COUNT(*) AS `rows`
                    FROM `warden_checks`
                   GROUP BY `architecture`,`locale`,`variant`
                  HAVING `rows`<>3
                ) AS `bad_profiles`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `variant`=0x6C65676163792D6772756E74;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "1", "252", "126", "126", "14", "0", "0"])

            x64_contract = self.db.execute(
                """
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634
                    AND (`type` NOT IN (0,1,3)
                         OR `phase_mask`=0 OR (`phase_mask` & ~0x0F)<>0
                         OR `address_kind` NOT IN (0,1,2));
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634
                    AND ((`variant`=0x756E636C6173736966696564
                          AND (`type`<>3 OR `evidence_class`<>3
                               OR `phase_mask`<>0x01 OR `address_kind`<>1
                               OR OCTET_LENGTH(`expected`)<>0))
                         OR (`variant` IN (0x73746F636B,0x6772756E74)
                             AND (`check_id` NOT IN (2001,2003,2004)
                                  OR (`check_id`=2001
                                      AND (`type`<>0 OR `evidence_class`<>0
                                           OR `phase_mask`<>0x06
                                           OR `address_kind`<>0))
                                  OR (`check_id`=2003
                                      AND (`type`<>1 OR `evidence_class`<>3
                                           OR `phase_mask`<>0x06
                                           OR `address_kind`<>0))
                                  OR (`check_id`=2004
                                      AND (`type`<>3 OR `evidence_class`<>1
                                           OR `phase_mask`<>0x0E
                                           OR `address_kind`<>1)))));
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634 AND `address_kind`=1
                    AND (`module`<>0x576F772D36342E657865 OR `address`=0
                         OR `length`=0 OR `length`>255);
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634 AND `address_kind`=0
                    AND (OCTET_LENGTH(`module`)<>0 OR `address`<>0
                         OR `length`<>0);
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634
                    AND `variant`=0x756E636C6173736966696564
                    AND NOT ((`check_id`=1001
                              AND `module`=0x576F772D36342E657865
                              AND `address`=0x000AB76F AND `length`=5)
                         OR (`check_id`=1002
                             AND `module`=0x576F772D36342E657865
                             AND `address`=0x000AABAB AND `length`=2)
                         OR (`check_id`=1003
                             AND `module`=0x576F772D36342E657865
                             AND `address`=0x000AA6D3 AND `length`=2));
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634 AND `check_id`=2004
                    AND (`module`<>0x576F772D36342E657865
                         OR `address`<>0x00566C13 OR `length`<>16
                         OR `expected`<>0x4883C9FF33C0488BFDBAF0D8FFFFF2AE);
                SELECT COUNT(*) FROM `warden_checks` AS `x64`
                  JOIN `warden_checks` AS `x86`
                    ON `x86`.`architecture`=0x783836
                   AND `x86`.`locale`=`x64`.`locale`
                   AND `x86`.`variant`=`x64`.`variant`
                   AND `x86`.`check_id`=2003
                 WHERE `x64`.`architecture`=0x783634
                   AND `x64`.`check_id`=2003
                   AND `x64`.`expected`<>`x86`.`expected`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(x64_contract, [
                "0",
                "0",
                "0",
                "0",
                "0",
                "0",
                "0",
            ])

            self.db.execute(self.x64_update, schema)
            self.assertEqual(
                self.db.execute(
                    "SELECT COUNT(*) FROM `warden_checks`;", schema
                ).stdout.strip(),
                "252",
            )

    def test_modified_catalogue_is_rejected_atomically(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            self.db.execute(
                """
                UPDATE `warden_checks` SET `length`=0
                 WHERE `architecture`=0x783836
                   AND `locale`=0x656E5553
                   AND `variant`=0x73746F636B AND `check_id`=2004;
                """,
                schema,
            )
            failed = self.db.execute(
                self.x64_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                SELECT `length` FROM `warden_checks`
                  WHERE `architecture`=0x783836
                    AND `locale`=0x656E5553
                    AND `variant`=0x73746F636B AND `check_id`=2004;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "0", "0"])

    def test_modified_predecessor_comment_is_rejected_atomically(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            self.db.execute(
                """
                UPDATE `warden_checks` SET `comment`='operator changed'
                 WHERE `architecture`=0x783836
                   AND `locale`=0x656E5553
                   AND `variant`=0x756E636C6173736966696564
                   AND `check_id`=1001;
                """,
                schema,
            )
            failed = self.db.execute(
                self.x64_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                SELECT `comment` FROM `warden_checks`
                  WHERE `architecture`=0x783836
                    AND `locale`=0x656E5553
                    AND `variant`=0x756E636C6173736966696564
                    AND `check_id`=1001;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "0", "operator changed"])

    def test_modified_x64_comment_rolls_back_publication(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            modified_update = self.x64_update.replace(
                "'Exact x64 stock/grunt profile probe 1'",
                "'operator changed'",
                1,
            )
            self.assertNotEqual(modified_update, self.x64_update)
            failed = self.db.execute(
                modified_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "126", "0"])

    def test_post_insert_validation_failure_rolls_back_and_retries(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            forced_failure = self.x64_update.replace(
                "COUNT(*) FROM `warden_checks`) <> 252",
                "COUNT(*) FROM `warden_checks`) <> 253",
                1,
            )
            self.assertNotEqual(forced_failure, self.x64_update)
            failed = self.db.execute(
                forced_failure, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            rolled_back = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(rolled_back, ["1", "0", "126", "0"])

            self.db.execute(self.x64_update, schema)
            retried = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(retried, ["1", "252", "126"])

    def test_committed_partial_x64_residue_is_rejected_without_x86_mutation(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            self.db.execute(
                """
                INSERT INTO `warden_checks` VALUES
                  (15595,0x783634,0x656E5553,
                   0x756E636C6173736966696564,1001,3,1,10,3,0x01,1,
                   0x576F772D36342E657865,0x000AB76F,5,X'',X'',
                   'committed partial x64 residue');
                """,
                schema,
            )
            failed = self.db.execute(
                self.x64_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836;
                SELECT HEX(`expected`) FROM `warden_checks`
                  WHERE `architecture`=0x783836 AND `locale`=0x656E5553
                    AND `variant`=0x73746F636B AND `check_id`=2003;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "126", "4F6B6179", "1"])

    def test_rollback_removes_only_the_x64_publication(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_x86_catalogue(schema)
            self.db.execute(self.x64_update, schema)
            self.db.execute(
                """
                START TRANSACTION;
                DELETE FROM `warden_checks` WHERE `architecture` = 0x783634;
                DELETE FROM `db_version`
                 WHERE `version` = '22' AND `structure` = '10'
                   AND `content` = '002'
                   AND `description` = 'Cata_Warden_X64_Checks';
                COMMIT;
                """,
                schema,
            )
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `warden_checks` WHERE `architecture`=0x783836;
                SELECT COUNT(*) FROM `warden_checks` WHERE `architecture`=0x783634;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "126", "0"])


@unittest.skipUnless(INTEGRATION, "pass --integration for disposable schemas")
class WorldMpqMigrationIntegration(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.db = MariaDbHarness()
        cls.x86_update = WORLD_UPDATE.read_text(encoding="utf-8")
        cls.x64_update = WORLD_X64_UPDATE.read_text(encoding="utf-8")
        cls.mpq_update = WORLD_MPQ_UPDATE.read_text(encoding="utf-8")

    def apply_predecessor(self, schema: str) -> None:
        self.db.execute(WORLD_DORMANT_SCHEMA, schema)
        self.db.execute(self.x86_update, schema)
        self.db.execute(self.x64_update, schema)

    def test_forward_and_replay_publish_the_exact_redesigned_catalogue(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_predecessor(schema)
            self.db.execute(self.mpq_update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3
                    AND `description`='Cata_Warden_MPQ_Checks';
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                SELECT COUNT(DISTINCT `locale`) FROM `warden_checks`;
                SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`
                  WHERE `architecture`=0x783836;
                SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783836
                    AND `variant`=0x6C65676163792D6772756E74;
                SELECT COUNT(*) FROM `warden_checks` WHERE `check_id`=1004;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `check_id`=1004 AND (
                    `architecture`<>0x783836
                    OR `variant`<>0x756E636C6173736966696564
                    OR `type`<>3 OR `enabled`<>1 OR `sort_order`<>40
                    OR `evidence_class`<>3 OR `phase_mask`<>0x01
                    OR `address_kind`<>1 OR `module`<>0x576F772E657865
                    OR `address`<>0x003BFF88 OR `length`<>24
                    OR OCTET_LENGTH(`request`)<>0
                    OR OCTET_LENGTH(`expected`)<>0);
                SELECT COUNT(*)
                  FROM `warden_checks` AS `legacy`
                  LEFT JOIN `warden_checks` AS `grunt`
                    ON `grunt`.`build`=`legacy`.`build`
                   AND `grunt`.`architecture`=`legacy`.`architecture`
                   AND `grunt`.`locale`=`legacy`.`locale`
                   AND `grunt`.`variant`=0x6772756E74
                   AND `grunt`.`check_id`=`legacy`.`check_id`
                   AND `grunt`.`type`=`legacy`.`type`
                   AND `grunt`.`enabled`=`legacy`.`enabled`
                   AND `grunt`.`sort_order`=`legacy`.`sort_order`
                   AND `grunt`.`evidence_class`=`legacy`.`evidence_class`
                   AND `grunt`.`phase_mask`=`legacy`.`phase_mask`
                   AND `grunt`.`address_kind`=`legacy`.`address_kind`
                   AND `grunt`.`module`=`legacy`.`module`
                   AND `grunt`.`address`=`legacy`.`address`
                   AND `grunt`.`length`=`legacy`.`length`
                   AND `grunt`.`request`=`legacy`.`request`
                   AND `grunt`.`expected`=`legacy`.`expected`
                   AND BINARY `grunt`.`comment`=BINARY `legacy`.`comment`
                 WHERE `legacy`.`architecture`=0x783836
                   AND `legacy`.`variant`=0x6C65676163792D6772756E74
                   AND `grunt`.`check_id` IS NULL;
                SELECT COUNT(*) FROM `warden_checks` WHERE `check_id`=2002;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `check_id`=2002 AND (`type`<>2 OR `enabled`<>1
                    OR `sort_order`<>35 OR `evidence_class`<>3
                    OR `phase_mask`<>0x06 OR `address_kind`<>0
                    OR OCTET_LENGTH(`module`)<>0 OR `address`<>0 OR `length`<>0
                    OR `request`<>0x444246696C6573436C69656E745C4974656D2E646232
                    OR `expected`<>0x4706FF83D9B611644A87DE79C244B414612EF4F2
                    OR BINARY `comment`<>BINARY
                       'Item.db2 archive digest; corroboration only'
                    OR (`architecture`=0x783836
                        AND `variant`<>0x6772756E74)
                    OR (`architecture`=0x783634
                        AND `variant` NOT IN (0x73746F636B,0x6772756E74)));
                SELECT COUNT(*) FROM (
                  SELECT `architecture`,`locale`,`variant`,COUNT(*) AS `rows`
                    FROM `warden_checks`
                   GROUP BY `architecture`,`locale`,`variant`
                  HAVING (`architecture`=0x783836 AND (
                            (`variant`=0x756E636C6173736966696564
                             AND `rows`<>4)
                         OR (`variant` IN
                               (0x73746F636B,0x6C65676163792D6772756E74)
                             AND `rows`<>3)
                         OR (`variant`=0x6772756E74 AND `rows`<>4)))
                      OR (`architecture`=0x783634 AND (
                            (`variant`=0x756E636C6173736966696564
                             AND `rows`<>3)
                         OR (`variant` IN (0x73746F636B,0x6772756E74)
                             AND `rows`<>4)))
                ) AS `bad_profiles`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `check_id`=2002 AND (
                    (`architecture`=0x783836
                     AND `variant` IN
                         (0x73746F636B,0x6C65676163792D6772756E74))
                    OR (`architecture`=0x783634
                        AND `variant`=0x6C65676163792D6772756E74));
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(
                values,
                [
                    "1", "350", "196", "154", "14", "4", "3", "42",
                    "14", "0", "0", "42", "0", "0", "0",
                ],
            )

            self.db.execute(self.mpq_update, schema)
            self.assertEqual(
                self.db.execute(
                    "SELECT COUNT(*) FROM `warden_checks`;", schema
                ).stdout.strip(),
                "350",
            )

    def test_wrong_predecessor_is_refused_without_mutation(self) -> None:
        with self.db.schema("world") as schema:
            self.db.execute(WORLD_DORMANT_SCHEMA, schema)
            self.db.execute(self.x86_update, schema)
            self.db.execute(self.mpq_update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3;
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `variant`=0x6C65676163792D6772756E74;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "126", "0"])

    def test_operator_modified_predecessor_is_rejected_atomically(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_predecessor(schema)
            self.db.execute(
                """
                UPDATE `warden_checks` SET `comment`='operator changed'
                 WHERE `architecture`=0x783634 AND `locale`=0x656E5553
                   AND `variant`=0x73746F636B AND `check_id`=2004;
                """,
                schema,
            )
            failed = self.db.execute(
                self.mpq_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3;
                SELECT COUNT(*) FROM `warden_checks` WHERE `check_id`=2002;
                SELECT `comment` FROM `warden_checks`
                 WHERE `architecture`=0x783634 AND `locale`=0x656E5553
                   AND `variant`=0x73746F636B AND `check_id`=2004;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "0", "operator changed"])

    def test_post_insert_failure_rolls_back_and_clean_retry_succeeds(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_predecessor(schema)
            forced_failure = self.mpq_update.replace(
                "COUNT(*) FROM `warden_checks`) <> 350",
                "COUNT(*) FROM `warden_checks`) <> 351",
                1,
            )
            self.assertNotEqual(forced_failure, self.mpq_update)
            failed = self.db.execute(
                forced_failure, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            rolled_back = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3;
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `warden_checks` WHERE `check_id`=1004;
                SELECT COUNT(*) FROM `warden_checks` WHERE `check_id`=2002;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `variant`=0x6C65676163792D6772756E74;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(
                rolled_back, ["1", "0", "252", "0", "0", "0"]
            )

            self.db.execute(self.mpq_update, schema)
            retried = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3;
                SELECT COUNT(*) FROM `warden_checks`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(retried, ["1", "350"])

    def test_committed_partial_mpq_residue_is_rejected(self) -> None:
        with self.db.schema("world") as schema:
            self.apply_predecessor(schema)
            self.db.execute(
                """
                INSERT INTO `warden_checks` VALUES
                  (15595,0x783836,0x656E5553,0x73746F636B,
                   2002,2,1,35,3,0x06,0,X'',0,0,
                   0x444246696C6573436C69656E745C4974656D2E646232,
                   0x4706FF83D9B611644A87DE79C244B414612EF4F2,
                   'committed partial MPQ residue');
                """,
                schema,
            )
            failed = self.db.execute(
                self.mpq_update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=2;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=3;
                SELECT COUNT(*) FROM `warden_checks`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0", "253"])


@unittest.skipUnless(INTEGRATION, "pass --integration for disposable schemas")
class RealmMigrationIntegration(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.db = MariaDbHarness()
        cls.update = REALM_UPDATE.read_text(encoding="utf-8")

    def test_forward_and_already_applied_paths_preserve_rows(self) -> None:
        with self.db.schema("realm") as schema:
            self.db.execute(REALM_SCHEMA_PREFIX, schema)
            self.db.execute(self.update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=5 AND `content`=1;
                SELECT CONCAT(LOWER(`COLUMN_TYPE`),'|',`IS_NULLABLE`,'|',
                              `COLUMN_DEFAULT`)
                  FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME` IN ('warden_audit','warden_incident')
                    AND `COLUMN_NAME`='client_variant'
                  ORDER BY `TABLE_NAME`;
                SELECT HEX(`client_variant`) FROM `warden_audit`;
                SELECT HEX(`client_variant`) FROM `warden_incident`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values[0], "1")
            self.assertEqual(
                values[1:3],
                ["varbinary(16)|NO|'unclassified'"] * 2,
            )
            self.assertEqual(
                values[3:5],
                ["756E636C6173736966696564"] * 2,
            )

            self.db.execute(self.update, schema)
            counts = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=5 AND `content`=1;
                SELECT COUNT(*) FROM `warden_audit`;
                SELECT COUNT(*) FROM `warden_incident`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(counts, ["1", "1", "1"])

    def test_wrong_predecessor_does_not_mutate(self) -> None:
        with self.db.schema("realm") as schema:
            self.db.execute(
                REALM_SCHEMA_PREFIX.replace(
                    "(22,4,1,'Warden audit','fixture')",
                    "(99,1,1,'Unrelated','fixture')",
                ),
                schema,
            )
            self.db.execute(self.update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=5 AND `content`=1;
                SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `COLUMN_NAME`='client_variant';
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["0", "0"])

    def test_interrupted_ddl_does_not_claim_version_and_resumes(self) -> None:
        with self.db.schema("realm") as schema:
            prefix_without_incident = REALM_SCHEMA_PREFIX.split(
                "CREATE TABLE `warden_incident`", maxsplit=1
            )[0]
            self.db.execute(prefix_without_incident, schema)
            self.db.execute(
                "CREATE VIEW `warden_incident` AS SELECT 1 AS `placeholder`;",
                schema,
            )
            failed = self.db.execute(
                self.update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=5 AND `content`=1;
                SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_audit'
                    AND `COLUMN_NAME`='client_variant';
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["0", "1"])

            self.db.execute("DROP VIEW `warden_incident`;", schema)
            incident_ddl = "CREATE TABLE `warden_incident`" + \
                REALM_SCHEMA_PREFIX.split(
                    "CREATE TABLE `warden_incident`", maxsplit=1
                )[1].split("INSERT INTO `warden_audit`", maxsplit=1)[0]
            self.db.execute(incident_ddl, schema)
            self.db.execute(self.update, schema)
            marker = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=5 AND `content`=1;
                """,
                schema,
            ).stdout.strip()
            self.assertEqual(marker, "1")


@unittest.skipUnless(INTEGRATION, "pass --integration for disposable schemas")
class WorldMigrationIntegration(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.db = MariaDbHarness()
        cls.update = WORLD_UPDATE.read_text(encoding="utf-8")

    def test_forward_and_already_applied_catalogue(self) -> None:
        with self.db.schema("world") as schema:
            self.db.execute(WORLD_DORMANT_SCHEMA, schema)
            self.db.execute(self.update, schema)

            counts = self.db.execute(
                """
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(DISTINCT `locale`) FROM `warden_checks`;
                SELECT COUNT(DISTINCT `variant`) FROM `warden_checks`;
                SELECT COUNT(DISTINCT `architecture`) FROM `warden_checks`;
                SELECT COUNT(*) FROM `warden_checks`
                  WHERE `architecture`=0x783634;
                SELECT COUNT(*) FROM (
                  SELECT `locale`,`variant`,COUNT(*) AS `rows_in_profile`
                    FROM `warden_checks` GROUP BY `locale`,`variant`
                  HAVING (`variant`=0x756E636C6173736966696564
                          AND `rows_in_profile`<>3)
                      OR (`variant` IN (0x73746F636B,0x6772756E74)
                          AND `rows_in_profile`<>3)
                ) AS `bad_profiles`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(counts, ["1", "126", "14", "3", "1", "0", "0"])

            columns = self.db.execute(
                """
                SELECT CONCAT(`COLUMN_NAME`,'|',LOWER(`COLUMN_TYPE`),'|',
                              `IS_NULLABLE`)
                  FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_checks'
                    AND `COLUMN_NAME` IN
                      ('architecture','variant','phase_mask','address_kind','address')
                  ORDER BY `ORDINAL_POSITION`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(columns, [
                "architecture|varbinary(4)|NO",
                "variant|varbinary(16)|NO",
                "phase_mask|tinyint(3) unsigned|NO",
                "address_kind|tinyint(3) unsigned|NO",
                "address|bigint(20) unsigned|NO",
            ])

            indexes = self.db.execute(
                """
                SELECT CONCAT(`INDEX_NAME`,'|',
                    GROUP_CONCAT(`COLUMN_NAME` ORDER BY `SEQ_IN_INDEX`
                                 SEPARATOR ','))
                  FROM `INFORMATION_SCHEMA`.`STATISTICS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_checks'
                  GROUP BY `INDEX_NAME` ORDER BY `INDEX_NAME`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(indexes, [
                "PRIMARY|build,architecture,locale,variant,check_id",
                "uq_warden_checks_profile_order|build,architecture,locale,variant,sort_order",
            ])

            samples = self.db.execute(
                """
                SELECT HEX(`expected`) FROM `warden_checks`
                  WHERE `locale`=0x6B6F4B52 AND `variant`=0x73746F636B
                    AND `check_id`=2003;
                SELECT CONCAT(HEX(`address`),'|',HEX(`module`),'|',HEX(`expected`))
                  FROM `warden_checks`
                  WHERE `locale`=0x656E5553 AND `variant`=0x6772756E74
                    AND `check_id`=2004;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(samples, [
                "ED9995EC9DB8",
                "43C257|576F772E657865|538B5D08568BC3578D50018A",
            ])

            self.db.execute(self.update, schema)
            self.assertEqual(
                self.db.execute(
                    "SELECT COUNT(*) FROM `warden_checks`;", schema
                ).stdout.strip(),
                "126",
            )

    def test_nonempty_dormant_catalogue_is_never_discarded(self) -> None:
        with self.db.schema("world") as schema:
            self.db.execute(WORLD_DORMANT_SCHEMA, schema)
            self.db.execute(
                """
                INSERT INTO `warden_checks` VALUES
                  (15595,'Win','enUS',1,0,1,1,0,'',0,0,'','','operator');
                """,
                schema,
            )
            failed = self.db.execute(
                self.update, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_checks'
                    AND `COLUMN_NAME`='platform';
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "1", "0"])

    def test_partial_new_schema_is_rebuilt_on_retry(self) -> None:
        with self.db.schema("world") as schema:
            self.db.execute(WORLD_DORMANT_SCHEMA, schema)
            forced_failure = self.update.replace(
                "COUNT(*) FROM `warden_checks`) <> 126",
                "COUNT(*) FROM `warden_checks`) <> 127",
                1,
            )
            failed = self.db.execute(
                forced_failure, schema, expect_success=False
            )
            self.assertNotEqual(failed.returncode, 0)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_checks'
                    AND `COLUMN_NAME`='architecture';
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["0", "1", "0"])

            self.db.execute(self.update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `warden_checks`;
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["126", "1"])

    def test_wrong_predecessor_does_not_mutate(self) -> None:
        with self.db.schema("world") as schema:
            self.db.execute(
                WORLD_DORMANT_SCHEMA.replace(
                    "(22,9,1,'Dormant_Warden_Checks','fixture')",
                    "(99,1,1,'Unrelated','fixture')",
                ),
                schema,
            )
            self.db.execute(self.update, schema)
            values = self.db.execute(
                """
                SELECT COUNT(*) FROM `INFORMATION_SCHEMA`.`COLUMNS`
                  WHERE `TABLE_SCHEMA`=DATABASE()
                    AND `TABLE_NAME`='warden_checks'
                    AND `COLUMN_NAME`='platform';
                SELECT COUNT(*) FROM `db_version`
                  WHERE `version`=22 AND `structure`=10 AND `content`=1;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(values, ["1", "0"])


if __name__ == "__main__":
    unittest.main()
