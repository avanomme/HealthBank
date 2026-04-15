"""
Unit Tests for Terms of Service API

Tests for the /api/v1/tos/accept endpoint.
"""

import pytest
import ipaddress
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


class TestAcceptTOS:
    """Tests for POST /api/v1/tos/accept"""

    def test_accept_tos_success_authenticated_user(self, client):
        """Should accept TOS for authenticated user"""
        from app.api.deps import get_current_user

        # Mock authentication
        mock_user = {
            "account_id": 123,
            "email": "testuser@example.com",
            "role": "participant"
        }

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.tos.CURRENT_TOS_VERSION", "1.0"):
            # Override the dependency
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            # Mock database
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post(
                    "/api/v1/tos/accept",
                    headers={"x-forwarded-for": "192.168.1.1"}
                )

                assert response.status_code == 200
                data = response.json()
                assert data["accepted"] is True
                assert "version" in data
                assert isinstance(data["version"], str)
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_unauthenticated(self, client):
        """Should reject unauthenticated user
        
        Simulates authentication failure by replacing get_current_user
        with a function that raises HTTPException(401). This tests that
        the endpoint properly enforces authentication requirements and
        returns 401 when auth fails.
        """
        from fastapi import HTTPException
        from app.api.deps import get_current_user

        def raise_401():
            raise HTTPException(status_code=401, detail="Not authenticated")

        # Override the auth dependency to always fail
        client.app.dependency_overrides[get_current_user] = raise_401
        try:
            response = client.post("/api/v1/tos/accept")
            assert response.status_code == 401
        finally:
            client.app.dependency_overrides.clear()

    def test_accept_tos_extracts_ip_from_x_forwarded_for(self, client):
        """Should extract IP from x-forwarded-for header"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post(
                    "/api/v1/tos/accept",
                    headers={"x-forwarded-for": "10.0.0.5, 192.168.1.1"}
                )

                assert response.status_code == 200
                
                # Verify the execute was called with IP
                mock_cursor.execute.assert_called_once()
                call_args = mock_cursor.execute.call_args[0]
                sql, params = call_args
                
                # Check that IP was converted to binary
                tos_version, ip_binary, account_id = params
                assert ip_binary is not None
                # Should extract first IP from comma-separated list
                assert ip_binary == ipaddress.ip_address("10.0.0.5").packed
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_uses_client_host_fallback(self, client):
        """Should handle missing x-forwarded-for gracefully
        
        When no x-forwarded-for header is present, the endpoint should fall back
        to capturing the client's connection IP. This test verifies that the endpoint
        still successfully accepts TOS even when this fallback is used.
        (The actual IP capture is environment-dependent and better tested in integration tests)
        """
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post("/api/v1/tos/accept")
                # Should still succeed even without explicit x-forwarded-for header
                assert response.status_code == 200
                data = response.json()
                assert data["accepted"] is True
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_handles_invalid_ip(self, client):
        """Should handle invalid IP address gracefully"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post(
                    "/api/v1/tos/accept",
                    headers={"x-forwarded-for": "not-an-ip"}
                )

                assert response.status_code == 200
                # Should store None for IP if invalid
                call_args = mock_cursor.execute.call_args[0]
                sql, params = call_args
                tos_version, ip_binary, account_id = params
                assert ip_binary is None
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_updates_correct_fields(self, client):
        """Should update TosAcceptedAt, TosVersion, and TosAcceptedIp"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 456, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.tos.CURRENT_TOS_VERSION", "1.0"):
            client.app.dependency_overrides[get_current_user] = lambda: mock_user

            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post(
                    "/api/v1/tos/accept",
                    headers={"x-forwarded-for": "203.0.113.42"}
                )

                assert response.status_code == 200

                # Verify SQL and parameters
                mock_cursor.execute.assert_called_once()
                call_args = mock_cursor.execute.call_args[0]
                sql, params = call_args

                assert "UPDATE AccountData" in sql
                assert "TosAcceptedAt" in sql
                assert "TosVersion" in sql
                assert "TosAcceptedIp" in sql
                assert "WHERE AccountID = %s" in sql

                # Verify parameters
                tos_version, ip_binary, account_id = params
                assert account_id == 456
                assert tos_version is not None
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_commits_transaction(self, client):
        """Should commit the database transaction"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post("/api/v1/tos/accept")

                assert response.status_code == 200
                mock_conn.commit.assert_called_once()
                mock_cursor.close.assert_called_once()
                mock_conn.close.assert_called_once()
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_multiple_times(self, client):
        """Should allow user to accept TOS multiple times (updates existing)"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                # First acceptance
                response1 = client.post("/api/v1/tos/accept")
                assert response1.status_code == 200

                # Second acceptance (should update, not fail)
                response2 = client.post("/api/v1/tos/accept")
                assert response2.status_code == 200
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_returns_current_version(self, client):
        """Should return the current TOS version"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn, \
             patch("app.api.v1.tos.CURRENT_TOS_VERSION", "2026-02-01"):
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post("/api/v1/tos/accept")

                assert response.status_code == 200
                data = response.json()
                assert data["version"] == "2026-02-01"
            finally:
                client.app.dependency_overrides.clear()

    def test_accept_tos_handles_ipv6(self, client):
        """Should handle IPv6 addresses"""
        from app.api.deps import get_current_user
        
        mock_user = {"account_id": 123, "email": "test@example.com", "role": "participant"}

        with patch("app.api.v1.tos.get_db_connection") as mock_db_conn:
            client.app.dependency_overrides[get_current_user] = lambda: mock_user
            
            mock_cursor = MagicMock()
            mock_conn = MagicMock()
            mock_conn.cursor.return_value = mock_cursor
            mock_db_conn.return_value = mock_conn

            try:
                response = client.post(
                    "/api/v1/tos/accept",
                    headers={"x-forwarded-for": "2001:0db8:85a3::8a2e:0370:7334"}
                )

                assert response.status_code == 200
                
                # Verify IPv6 was converted to binary
                call_args = mock_cursor.execute.call_args[0]
                sql, params = call_args
                tos_version, ip_binary, account_id = params
                assert ip_binary is not None
                assert len(ip_binary) == 16  # IPv6 is 16 bytes
            finally:
                client.app.dependency_overrides.clear()


class TestIpToVarbinary:
    """Cover line 14: ip_to_varbinary with None/empty returns None."""

    def test_ip_to_varbinary_none(self):
        from app.api.v1.tos import ip_to_varbinary
        assert ip_to_varbinary(None) is None

    def test_ip_to_varbinary_empty_string(self):
        from app.api.v1.tos import ip_to_varbinary
        assert ip_to_varbinary("") is None

    def test_ip_to_varbinary_valid_ipv4(self):
        from app.api.v1.tos import ip_to_varbinary
        result = ip_to_varbinary("192.168.1.1")
        assert result is not None
        assert len(result) == 4

    def test_ip_to_varbinary_invalid(self):
        from app.api.v1.tos import ip_to_varbinary
        assert ip_to_varbinary("not-an-ip") is None
