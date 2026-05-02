from __future__ import annotations

import argparse
from pathlib import Path
import sqlite3
import sys


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create the database from schema.sql."
    )
    parser.add_argument(
        "--schema",
        type=Path,
        default=Path(__file__).with_name("schema.sql"),
        help="Path to the SQL schema file.",
    )
    parser.add_argument(
        "--db",
        type=Path,
        default=Path(__file__).with_name("futuristic_scoring.db"),
        help="Path to the SQLite database file to create.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Remove any existing database file before creating a new one.",
    )
    return parser.parse_args()


def create_database(schema_path: Path, db_path: Path, force: bool = False) -> None:
    if not schema_path.exists():
        raise FileNotFoundError(f"Schema file not found: {schema_path}")

    if db_path.exists() and not force:
        raise FileExistsError(
            f"Database already exists: {db_path}. Use --force to replace it."
        )

    if db_path.exists() and force:
        db_path.unlink()

    sql = schema_path.read_text(encoding="utf-8")

    db_path.parent.mkdir(parents=True, exist_ok=True)
    with sqlite3.connect(db_path) as conn:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.executescript(sql)

    print(f"Database created successfully at: {db_path}")


def main() -> int:
    args = parse_args()

    try:
        create_database(args.schema, args.db, args.force)
    except (FileNotFoundError, FileExistsError, sqlite3.Error) as exc:
        print(f"Error: {exc}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
