# DISCLAIMER: Ensure the docker container is running as this test is for the actual API.
# $ docker compose up -d

import requests
import pytest


def test_health_endpoint_returns_ok():
    """
    Tests that fastAPI endpoint returns 202 and status "ok".
    """
    url = "http://127.0.0.1:8000/health"
    resp = requests.get(url)
    assert resp.status_code == 200
    try:
        body = resp.json()
    except ValueError:
        body = {}
    assert body.get("status") == "ok"


def test_invalid_endpoint_returns_404():
    """
    Tests that accessing an invalid endpoint returns 404.
    """
    url = "http://127.0.0.1:8000/nonexistent"
    resp = requests.get(url)
    assert resp.status_code == 404


def test_health_endpoint_content_type_is_json():
    """
    Tests that the /health endpoint returns application/json content type.
    """
    url = "http://127.0.0.1:8000/health"
    resp = requests.get(url)
    assert resp.headers["Content-Type"] == "application/json"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])