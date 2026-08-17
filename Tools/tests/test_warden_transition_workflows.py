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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

from __future__ import annotations

import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read_script(relative_path: str) -> str:
    return (ROOT / relative_path).read_text(encoding="utf-8")


def shell_function(script: str, name: str) -> str:
    match = re.search(
        rf"(?ms)^{re.escape(name)}\(\)\s*\n\{{\s*\n(?P<body>.*?)^\}}\s*$",
        script,
    )
    if not match:
        raise AssertionError(f"shell function is missing: {name}")
    return match.group("body")


class WardenTransitionWorkflowTests(unittest.TestCase):
    def test_update_only_dispatches_all_database_updates_once(self) -> None:
        script = read_script("InstallDatabases.sh")
        main_start = script.rfind('\nif [ "${createcharDB}" = "YES" ]; then')
        self.assertNotEqual(main_start, -1, "top-level database dispatch is missing")
        main = script[main_start:]

        guarded_calls = re.findall(
            r'(?ms)if \[ "\$\{(update(?:char|world|realm)DB)\}" = "YES" \]; then\s*'
            r'(update(?:Char|World|Realm)DB)\s*fi',
            main,
        )
        self.assertEqual(
            guarded_calls,
            [
                ("updatecharDB", "updateCharDB"),
                ("updateworldDB", "updateWorldDB"),
                ("updaterealmDB", "updateRealmDB"),
            ],
        )
        self.assertNotIn("updateCharDB", shell_function(script, "loadCharDB"))

    def test_windows_backup_handles_pre_and_post_migration_tables(self) -> None:
        script = read_script("Tools/backupDB.cmd")
        calls = {
            tuple(part.lower() for part in match)
            for match in re.findall(
                r'(?im)^call :DumpOptionalTable "%([wcr]db)%" '
                r'"(_full_(?:world|char|realm)db)" "%((?:load)?(?:world|char|realm)DB)%" '
                r'"(warden(?:_checks|_action|_log|_incident|_audit)?)"$',
                script,
            )
        }
        expected = {
            ("wdb", "_full_worlddb", "loadworlddb", "warden"),
            ("wdb", "_full_worlddb", "loadworlddb", "warden_checks"),
            ("cdb", "_full_chardb", "loadchardb", "warden_action"),
            ("rdb", "_full_realmdb", "loadrealmdb", "warden_log"),
            ("rdb", "_full_realmdb", "loadrealmdb", "warden_incident"),
            ("rdb", "_full_realmdb", "loadrealmdb", "warden_audit"),
        }
        self.assertEqual(calls, expected)

        helper_start = script.find("\n:DumpOptionalTable\n")
        helper_end = script.find("\n:patherror\n", helper_start)
        self.assertGreaterEqual(helper_start, 0, "optional-table helper is missing")
        self.assertGreater(helper_end, helper_start, "optional-table helper is unterminated")
        helper = script[helper_start:helper_end]
        self.assertRegex(helper, r"(?i)mysqldump .*--no-data.*%OPTIONALDB%.*%TABLENAME%")
        self.assertIn(
            'if exist "%OPTIONALDIR%\\%TABLENAME%.sql" del /q '
            '"%OPTIONALDIR%\\%TABLENAME%.sql"',
            helper,
        )

        configured = {call[3] for call in calls}
        pre_migration = {"warden", "warden_action", "warden_log"}
        post_migration = {"warden_checks", "warden_incident", "warden_audit"}
        self.assertEqual(configured & pre_migration, pre_migration)
        self.assertEqual(configured - pre_migration, post_migration)
        self.assertEqual(configured & post_migration, post_migration)
        self.assertEqual(configured - post_migration, pre_migration)

    def test_unix_dump_selects_existing_warden_tables_and_cleans_stale_files(self) -> None:
        script = read_script("Tools/dump_tables.sh")
        candidates = re.search(r"for WARDEN_TABLE in ([^;\n]+); do", script)
        self.assertIsNotNone(candidates, "Warden table probe loop is missing")
        self.assertEqual(candidates.group(1).split(), ["warden", "warden_checks"])
        self.assertRegex(
            script,
            r"(?s)for WARDEN_TABLE in warden warden_checks; do.*?"
            r"mysqldump .*--no-data.*\$\{DB\}.*\$\{WARDEN_TABLE\}",
        )
        self.assertIn(
            'rm -f "${DUMPDIR}/warden.sql" "${DUMPDIR}/warden_checks.sql"',
            script,
        )
        self.assertIn("${WARDEN_TABLES} \\", script)
        self.assertNotRegex(script, r"(?m)^`warden(?:_checks)?` \\$")


if __name__ == "__main__":
    unittest.main()
