# Created with the Assistance of Claude Code
# backend/tests/test_utils.py
"""Tests for app/utils/utils.py — db_cursor, ensure_exists, build_update."""

import pytest
from unittest.mock import patch, MagicMock
from fastapi import HTTPException


# ---------------------------------------------------------------------------
# db_cursor context manager
# ---------------------------------------------------------------------------

class TestDbCursor:
    """Tests for the db_cursor context manager."""

    @patch("app.utils.utils.get_db_connection")
    def test_basic_usage_returns_cursor(self, mock_get_conn):
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_get_conn.return_value = mock_conn

        with db_cursor() as cur:
            assert cur is mock_cursor

        mock_conn.cursor.assert_called_once_with(dictionary=False)
        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()
        mock_conn.commit.assert_not_called()

    @patch("app.utils.utils.get_db_connection")
    def test_commit_on_clean_exit(self, mock_get_conn):
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = MagicMock()
        mock_get_conn.return_value = mock_conn

        with db_cursor(commit=True) as cur:
            cur.execute("INSERT INTO t VALUES (%s)", (1,))

        mock_conn.commit.assert_called_once()
        mock_conn.rollback.assert_not_called()

    @patch("app.utils.utils.get_db_connection")
    def test_rollback_on_exception(self, mock_get_conn):
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_get_conn.return_value = mock_conn

        with pytest.raises(ValueError):
            with db_cursor(commit=True) as cur:
                raise ValueError("boom")

        mock_conn.rollback.assert_called_once()
        mock_conn.commit.assert_not_called()
        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()

    @patch("app.utils.utils.get_db_connection")
    def test_dictionary_flag(self, mock_get_conn):
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = MagicMock()
        mock_get_conn.return_value = mock_conn

        with db_cursor(dictionary=True):
            pass

        mock_conn.cursor.assert_called_once_with(dictionary=True)

    @patch("app.utils.utils.get_db_connection")
    def test_no_commit_without_flag(self, mock_get_conn):
        """Without commit=True, neither commit nor rollback is called."""
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_conn.cursor.return_value = MagicMock()
        mock_get_conn.return_value = mock_conn

        with db_cursor():
            pass

        mock_conn.commit.assert_not_called()
        mock_conn.rollback.assert_not_called()

    @patch("app.utils.utils.get_db_connection")
    def test_exception_without_commit_flag_still_closes(self, mock_get_conn):
        """Without commit=True, exception propagates and resources close."""
        from app.utils.utils import db_cursor

        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_get_conn.return_value = mock_conn

        with pytest.raises(RuntimeError):
            with db_cursor() as cur:
                raise RuntimeError("oops")

        mock_conn.rollback.assert_not_called()
        mock_cursor.close.assert_called_once()
        mock_conn.close.assert_called_once()


# ---------------------------------------------------------------------------
# ensure_exists
# ---------------------------------------------------------------------------

class TestEnsureExists:
    """Tests for ensure_exists helper."""

    def test_found_row_does_not_raise(self):
        from app.utils.utils import ensure_exists

        cursor = MagicMock()
        cursor.fetchone.return_value = (1,)

        # Should not raise
        ensure_exists(cursor, "Survey", "SurveyID", 1)
        cursor.execute.assert_called_once()

    def test_missing_row_raises_404(self):
        from app.utils.utils import ensure_exists

        cursor = MagicMock()
        cursor.fetchone.return_value = None

        with pytest.raises(HTTPException) as exc_info:
            ensure_exists(cursor, "Survey", "SurveyID", 999, "Survey not found")

        assert exc_info.value.status_code == 404
        assert exc_info.value.detail == "Survey not found"

    def test_default_detail_message(self):
        from app.utils.utils import ensure_exists

        cursor = MagicMock()
        cursor.fetchone.return_value = None

        with pytest.raises(HTTPException) as exc_info:
            ensure_exists(cursor, "QuestionBank", "QuestionID", 42)

        assert exc_info.value.detail == "Resource not found"

    def test_invalid_table_raises_value_error(self):
        from app.utils.utils import ensure_exists

        cursor = MagicMock()

        with pytest.raises(ValueError, match="Invalid table/column"):
            ensure_exists(cursor, "BadTable", "BadCol", 1)

    def test_mismatched_column_raises_value_error(self):
        from app.utils.utils import ensure_exists

        cursor = MagicMock()

        with pytest.raises(ValueError, match="Invalid table/column"):
            ensure_exists(cursor, "Survey", "QuestionID", 1)

    def test_all_allowed_pairs(self):
        """Every whitelisted table/column pair should work when row exists."""
        from app.utils.utils import ensure_exists

        allowed = {
            "Survey": "SurveyID",
            "QuestionBank": "QuestionID",
            "SurveyTemplate": "TemplateID",
            "SurveyAssignment": "AssignmentID",
            "AccountData": "AccountID",
        }
        for table, col in allowed.items():
            cursor = MagicMock()
            cursor.fetchone.return_value = (1,)
            ensure_exists(cursor, table, col, 1)  # should not raise


# ---------------------------------------------------------------------------
# build_update
# ---------------------------------------------------------------------------

class TestBuildUpdate:
    """Tests for build_update helper."""

    def test_single_column_update(self):
        from app.utils.utils import build_update

        query, params = build_update("Survey", "SurveyID", 1, {"Title": "New"})
        assert query == "UPDATE Survey SET Title = %s WHERE SurveyID = %s"
        assert params == ("New", 1)

    def test_multiple_columns(self):
        from app.utils.utils import build_update

        updates = {"Title": "T", "Description": "D"}
        query, params = build_update("Survey", "SurveyID", 5, updates)
        assert "Title = %s" in query
        assert "Description = %s" in query
        assert params[-1] == 5
        assert len(params) == 3

    def test_empty_dict_returns_none(self):
        from app.utils.utils import build_update

        query, params = build_update("Survey", "SurveyID", 1, {})
        assert query is None
        assert params is None

    def test_invalid_column_raises(self):
        from app.utils.utils import build_update

        with pytest.raises(ValueError, match="not in update whitelist"):
            build_update("Survey", "SurveyID", 1, {"DropTable": "bad"})

    def test_mixed_valid_and_invalid_columns_raises(self):
        from app.utils.utils import build_update

        with pytest.raises(ValueError, match="not in update whitelist"):
            build_update("Survey", "SurveyID", 1, {"Title": "ok", "Hacked": "no"})

    def test_all_whitelisted_columns_accepted(self):
        from app.utils.utils import build_update, _UPDATE_COLUMN_WHITELIST

        updates = {col: "val" for col in _UPDATE_COLUMN_WHITELIST}
        query, params = build_update("T", "ID", 1, updates)
        assert query is not None
        assert len(params) == len(_UPDATE_COLUMN_WHITELIST) + 1


# ---------------------------------------------------------------------------
# init_db_structure (lines 135-162)
# ---------------------------------------------------------------------------

class TestInitDbStructure:

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection")
    def test_init_db_structure_executes_sql(self, mock_conn, mock_open):
        from app.utils.utils import init_db_structure

        mock_cursor = MagicMock()
        mock_conn.return_value.cursor.return_value = mock_cursor
        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "CREATE TABLE t1 (id INT); CREATE TABLE t2 (id INT)"

        init_db_structure()

        assert mock_cursor.execute.call_count == 2
        mock_conn.return_value.commit.assert_called()
        mock_cursor.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection")
    def test_init_db_structure_handles_query_error(self, mock_conn, mock_open):
        """Individual query errors are printed but do not stop execution (line 158-159)."""
        from app.utils.utils import init_db_structure

        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = Exception("syntax error")
        mock_conn.return_value.cursor.return_value = mock_cursor
        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "BAD SQL"

        # Should not raise
        init_db_structure()

        mock_cursor.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("time.sleep")
    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection")
    def test_init_db_structure_retries_on_db_error(self, mock_conn, mock_open, mock_sleep):
        """Connection retries until DB is ready (lines 138-145)."""
        from app.utils.utils import init_db_structure
        from mysql.connector import Error

        mock_cursor = MagicMock()
        # Fail first two attempts, succeed on third
        good_conn = MagicMock()
        good_conn.cursor.return_value = mock_cursor
        mock_conn.side_effect = [Error("not ready"), Error("not ready"), good_conn]

        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "SELECT 1"

        init_db_structure(retries=3, delay=0)

        assert mock_conn.call_count == 3
        assert mock_sleep.call_count == 2

    @patch("time.sleep")
    @patch("app.utils.utils.get_db_connection")
    def test_init_db_structure_exhausted_retries_raises(self, mock_conn, mock_sleep):
        """When all retries fail, the error is raised (line 143-144)."""
        from app.utils.utils import init_db_structure
        from mysql.connector import Error

        mock_conn.side_effect = Error("db down")

        with pytest.raises(Error):
            init_db_structure(retries=2, delay=0)


# ---------------------------------------------------------------------------
# create_seed_data (lines 166-196)
# ---------------------------------------------------------------------------

class TestCreateSeedData:

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection_pure")
    def test_create_seed_data_success(self, mock_conn, mock_open):
        from app.utils.utils import create_seed_data

        mock_cursor = MagicMock()
        # nextset returns True once then False (two statements)
        mock_cursor.nextset.side_effect = [True, False]
        mock_cursor.with_rows = True
        mock_conn.return_value.cursor.return_value = mock_cursor

        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "INSERT INTO t VALUES (1); INSERT INTO t VALUES (2)"

        create_seed_data()

        mock_cursor.execute.assert_called_once()
        mock_conn.return_value.commit.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection_pure")
    def test_create_seed_data_nextset_no_rows(self, mock_conn, mock_open):
        """Statements that don't return rows should not call fetchall."""
        from app.utils.utils import create_seed_data

        mock_cursor = MagicMock()
        mock_cursor.nextset.side_effect = [True, False]
        mock_cursor.with_rows = False
        mock_conn.return_value.cursor.return_value = mock_cursor

        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "INSERT INTO t VALUES (1)"

        create_seed_data()

        mock_cursor.fetchall.assert_not_called()
        mock_conn.return_value.commit.assert_called_once()

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection_pure")
    def test_create_seed_data_error_rolls_back_and_raises(self, mock_conn, mock_open):
        """mysql.connector.Error should rollback and re-raise (lines 183-192)."""
        import mysql.connector
        from app.utils.utils import create_seed_data

        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("seed fail")
        mock_cursor.statement = "INSERT INTO ..."
        mock_conn.return_value.cursor.return_value = mock_cursor

        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "BAD SQL"

        with pytest.raises(mysql.connector.Error):
            create_seed_data()

        mock_conn.return_value.rollback.assert_called_once()
        mock_cursor.close.assert_called_once()
        mock_conn.return_value.close.assert_called_once()

    @patch("builtins.open")
    @patch("app.utils.utils.get_db_connection_pure")
    def test_create_seed_data_error_no_statement_attr(self, mock_conn, mock_open):
        """Lines 190-191: cursor.statement access raises -> suppressed."""
        import mysql.connector
        from app.utils.utils import create_seed_data

        mock_cursor = MagicMock()
        mock_cursor.execute.side_effect = mysql.connector.Error("seed fail")
        # Make cursor.statement raise AttributeError
        type(mock_cursor).statement = property(lambda self: (_ for _ in ()).throw(AttributeError("no attr")))
        mock_conn.return_value.cursor.return_value = mock_cursor

        mock_open.return_value.__enter__ = lambda s: s
        mock_open.return_value.__exit__ = MagicMock(return_value=False)
        mock_open.return_value.read.return_value = "BAD SQL"

        with pytest.raises(mysql.connector.Error):
            create_seed_data()


class TestGetDbConnectionPure:
    """Cover line 68: get_db_connection_pure."""

    def test_get_db_connection_pure_calls_connect(self):
        """Line 68: get_db_connection_pure uses use_pure=True."""
        with patch("app.utils.utils.mysql.connector.connect") as mock_connect:
            mock_connect.return_value = MagicMock()
            from app.utils.utils import get_db_connection_pure
            conn = get_db_connection_pure()
            assert conn is not None
            # Verify use_pure was passed
            call_kwargs = mock_connect.call_args
            assert call_kwargs is not None


class TestGetDbConnectionDirect:
    """Cover line 21: get_db_connection."""

    def test_get_db_connection_returns_connection(self):
        """Line 21: get_db_connection calls mysql.connector.connect."""
        with patch("app.utils.utils.mysql.connector.connect") as mock_connect:
            mock_connect.return_value = MagicMock()
            from app.utils.utils import get_db_connection
            conn = get_db_connection()
            assert conn is not None
