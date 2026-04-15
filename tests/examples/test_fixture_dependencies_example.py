# Made with assistance of generative AI
"""
Example: Fixture Dependencies
Fixtures that depend on other fixtures to build up complex test data.
"""
import pytest


# Example 1: Simple fixture dependency
@pytest.fixture
def user():
    """Create a user"""
    return {"id": 1,
            "name": "Alice",
            "email": "alice@example.com"}


@pytest.fixture
def post(user):
    """Create a post that depends on user"""
    return {"id": 1,
            "user_id": user["id"],
            "title": "Hello World"}


def test_post_belongs_to_user(post, user):
    """Test that post is created by the user"""
    assert post["user_id"] == user["id"]


# Example 2: Chain of dependencies
@pytest.fixture
def database():
    """Mock database"""
    return {"users": [],
            "posts": [],
            "comments": []}


@pytest.fixture
def user_with_db(database):
    """Create user and add to database"""
    user = {"id": 1,
            "name": "Bob"}
    database["users"].append(user)
    return user


@pytest.fixture
def post_with_db(database, user_with_db):
    """Create post and add to database"""
    post = {"id": 1,
            "user_id": user_with_db["id"],
            "title": "My Post"}
    database["posts"].append(post)
    return post


@pytest.fixture
def comment_with_db(database, post_with_db, user_with_db):
    """Create comment that depends on both post and user"""
    comment = {
        "id": 1,
        "post_id": post_with_db["id"],
        "user_id": user_with_db["id"],
        "text": "Great post!"
    }
    database["comments"].append(comment)
    return comment


def test_comment_chain_dependency(comment_with_db, post_with_db, user_with_db, database):
    """Test the full chain of dependencies"""
    assert len(database["users"]) == 1
    assert len(database["posts"]) == 1
    assert len(database["comments"]) == 1
    assert comment_with_db["post_id"] == post_with_db["id"]
    assert comment_with_db["user_id"] == user_with_db["id"]


# Example 3: Fixture dependency with setup/teardown
@pytest.fixture
def cache_data():
    """Set up a cache dictionary before test"""
    cache = {"items": []}
    yield cache  # Give cache to test
    
    # Cleanup: clear cache after test
    cache.clear()


@pytest.fixture
def cache_with_items(cache_data):
    """Add items to cache (depends on cache_data)"""
    cache_data["items"].append("item1")
    cache_data["items"].append("item2")
    yield cache_data


def test_cache_has_items(cache_with_items):
    """Test that cache has the items we added"""
    assert len(cache_with_items["items"]) == 2
    assert "item1" in cache_with_items["items"]


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
