# Comments made with help of Generative A.I.
import pytest
def test_get_users(test_client):
    """
    Test that the users listing endpoint returns a successful response with a JSON list.

    Uses the test_client fixture to send a GET request to "/api/v1/users" and asserts:
    - response status code is 200 (OK)
    - response body parses as JSON and is a list

    This verifies the endpoint is reachable and returns a list-formatted payload.
    """
    r = test_client.get("/api/v1/users")
    assert r.status_code == 200
    assert isinstance(r.json(), list)


if __name__ == "__main__":
    pytest.main([__file__, "-v"])