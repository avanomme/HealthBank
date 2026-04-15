# backend/app/utils/utils.py
"""
Database connection helpers and bootstrap utilities for HealthBank.

Provides get_db_connection(), the db_cursor context manager, and the
init_db_structure() / create_seed_data() helpers that run on application
startup via the FastAPI startup event in main.py.
"""

import os
import time
from urllib.parse import urlparse
import mysql.connector
from mysql.connector import Error
from mysql.connector.constants import ClientFlag

url = urlparse(os.getenv("DATABASE_URL"))

db_config = {
    "user": url.username,
    "password": url.password,
    "host": url.hostname,
    "port": url.port,
    "database": url.path[1:]
}

def get_db_connection():  # pragma: no cover — mocked in all tests
    return mysql.connector.connect(**db_config)


class db_cursor:
    """Context manager for database cursor lifecycle.

    Usage:
        with db_cursor() as cursor:
            cursor.execute("SELECT ...")
            rows = cursor.fetchall()
        # Connection and cursor are automatically closed.

        with db_cursor(commit=True) as cursor:
            cursor.execute("INSERT ...")
        # Auto-commits on clean exit, rolls back on exception.

        with db_cursor(dictionary=True) as cursor:
            cursor.execute("SELECT ...")
            row = cursor.fetchone()  # returns dict
    """

    def __init__(self, *, commit: bool = False, dictionary: bool = False):
        self._commit = commit
        self._dictionary = dictionary
        self._conn = None
        self._cursor = None

    def __enter__(self):
        self._conn = get_db_connection()
        self._cursor = self._conn.cursor(dictionary=self._dictionary)
        return self._cursor

    def __exit__(self, exc_type, exc_val, exc_tb):
        try:
            if exc_type is None and self._commit:
                self._conn.commit()
            elif exc_type is not None and self._commit:
                self._conn.rollback()
        finally:
            if self._cursor:
                self._cursor.close()
            if self._conn:
                self._conn.close()
        return False  # don't suppress exceptions


def get_db_connection_pure():
    return mysql.connector.connect(**db_config, use_pure=True, client_flags=[ClientFlag.MULTI_STATEMENTS])


def ensure_exists(cursor, table: str, id_column: str, id_value, detail: str = "Resource not found"):
    """Check that a row exists or raise 404.

    Usage:
        ensure_exists(cursor, "Survey", "SurveyID", survey_id, "Survey not found")
    """
    from fastapi import HTTPException

    # Whitelist of allowed table/column names to prevent SQL injection
    _ALLOWED = {
        "Survey": "SurveyID",
        "QuestionBank": "QuestionID",
        "SurveyTemplate": "TemplateID",
        "SurveyAssignment": "AssignmentID",
        "AccountData": "AccountID",
    }
    if table not in _ALLOWED or _ALLOWED[table] != id_column:
        raise ValueError(f"Invalid table/column: {table}.{id_column}")

    cursor.execute(
        f"SELECT {id_column} FROM {table} WHERE {id_column} = %s",
        (id_value,),
    )
    if not cursor.fetchone():
        raise HTTPException(status_code=404, detail=detail)


# Whitelist of columns allowed in dynamic UPDATE queries
_UPDATE_COLUMN_WHITELIST = {
    "Title", "Description", "QuestionContent", "ResponseType", "IsRequired",
    "Category", "ScaleMin", "ScaleMax", "Status", "PublicationStatus",
    "StartDate", "EndDate", "FirstName", "LastName", "Email", "Gender",
    "Birthdate", "IsActive", "RoleID", "IsPublic", "DueDate",
}


def build_update(table: str, id_column: str, id_value, updates: dict):
    """Build a safe parameterized UPDATE query from a dict of {column: value}.

    Returns (query_string, params_tuple) or (None, None) if no updates.

    Usage:
        query, params = build_update("Survey", "SurveyID", 1, {"Title": "New Title"})
        if query:
            cursor.execute(query, params)
    """
    if not updates:
        return None, None

    # Validate column names against whitelist
    for col in updates:
        if col not in _UPDATE_COLUMN_WHITELIST:
            raise ValueError(f"Column '{col}' not in update whitelist")

    set_clauses = [f"{col} = %s" for col in updates]
    params = list(updates.values()) + [id_value]
    query = f"UPDATE {table} SET {', '.join(set_clauses)} WHERE {id_column} = %s"
    return query, tuple(params)


def init_db_structure(retries: int = 10, delay: int = 3):
    # Was causing race condition when DB not ready yet
    # Added retry logic to prevent startup failure

    conn = None

    # Retry DB connection until MySQL ready
    for attempt in range(1, retries + 1):
        try:
            conn = get_db_connection()
            break
        except Error:
            if attempt == retries:
                raise
            time.sleep(delay)

    cursor = conn.cursor()

    with open("app/create_database.sql", "r", encoding="utf-8") as file:
        sql_queries = file.read()

    queries = [q.strip() for q in sql_queries.split(";") if q.strip()]

    for query in queries:
        try:
            cursor.execute(query)
            conn.commit()
        except Exception as e:
            print("Error executing query:", str(e))

    cursor.close()
    conn.close()


def create_seed_data():
    conn = get_db_connection_pure()
    cursor = conn.cursor()

    with open("app/survey_seed_data.sql", "r", encoding="utf-8") as f:
        sql_text = f.read()

    try:
        cursor.execute(sql_text)  # executes first statement

        # advance through remaining statements
        while cursor.nextset():
            # if a statement returned rows, consume them
            if cursor.with_rows:
                cursor.fetchall()

        conn.commit()

    except mysql.connector.Error as e:
        conn.rollback()
        print("Seed error:", e)
        # Best effort: show the statement that failed (sometimes available)
        try:
            print("Last statement (truncated):")
            print(cursor.statement[:500])
        except Exception:  # pragma: no cover
            pass
        raise

    finally:
        cursor.close()
        conn.close()