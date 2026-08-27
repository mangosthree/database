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
        self.assertEqual(len(rows), 154)
        self.assertNotRegex(
            self.sql,
            r"(?m)^\s*\(15595,0x783634,",
        )
        self.assertIn("<> 154", self.sql)
        self.assertRegex(
            self.sql,
            r"COUNT\(DISTINCT `locale`\) FROM `warden_checks`\) <> 14",
        )
        self.assertRegex(
            self.sql,
            r"COUNT\(DISTINCT `variant`\) FROM `warden_checks`\) <> 3",
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
                          AND `rows_in_profile`<>4)
                ) AS `bad_profiles`;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(counts, ["1", "154", "14", "3", "1", "0", "0"])

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
                SELECT HEX(`expected`) FROM `warden_checks`
                  WHERE `locale`=0x7A685457 AND `variant`=0x73746F636B
                    AND `check_id`=2002;
                """,
                schema,
            ).stdout.splitlines()
            self.assertEqual(samples, [
                "ED9995EC9DB8",
                "43C24E|576F772E657865|8B4D10890D9480D300538B5D",
                "4706FF83D9B611644A87DE79C244B414612EF4F2",
            ])

            self.db.execute(self.update, schema)
            self.assertEqual(
                self.db.execute(
                    "SELECT COUNT(*) FROM `warden_checks`;", schema
                ).stdout.strip(),
                "154",
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
                "COUNT(*) FROM `warden_checks`) <> 154",
                "COUNT(*) FROM `warden_checks`) <> 155",
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
            self.assertEqual(values, ["154", "1"])

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
