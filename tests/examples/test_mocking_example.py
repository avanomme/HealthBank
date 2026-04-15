# Made with assistance of generative AI
"""
Simple example of using monkeypatch to mock a class for testing.
"""
import pytest


class Database:
    """Real database class (external dependency)"""
    def connect(self):
        # In real life, this would connect to an actual database
        raise RuntimeError("Real database connection")


class UserService:
    """Service that depends on Database"""
    def __init__(self, db: Database):
        self.db = db
    
    def get_user(self, user_id: int):
        self.db.connect()
        return {"id": user_id, "name": "John Doe"}


# Tests using monkeypatch

def test_user_service_with_mocked_database(monkeypatch):
    """Example: Use monkeypatch to mock the Database.connect method"""
    
    # Create a mock function to replace Database.connect
    def mock_connect(self):
        return "mocked connection"
    
    # Monkeypatch the Database.connect method
    monkeypatch.setattr(Database, "connect", mock_connect)
    
    # Now we can test UserService without hitting a real database
    db = Database()
    service = UserService(db)
    result = service.get_user(1)
    
    assert result["id"] == 1
    assert result["name"] == "John Doe"


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
