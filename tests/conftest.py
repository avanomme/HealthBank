# Made with assistance of GH Co-Pilot
import pytest
from fastapi import FastAPI, APIRouter
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base


ProjectBase = declarative_base()

# In-memory SQLite DB
TEST_DATABASE_URL = "sqlite:///:memory:"
engine = create_engine(TEST_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(bind=engine)


app = FastAPI()  # Local app for testing
router = APIRouter(prefix="/api/v1")

@router.get("/users")
def list_users():  # Handler for when the API's users are requested
    return [{"id": 1, "name": "Alice"}, {"id": 2, "name": "Bob"}]

app.include_router(router)

@pytest.fixture(scope="module")
def test_client():
    """
    Gives a local API to the test.
    """
    with TestClient(app) as client:
        yield client


@pytest.fixture()
def db_session():
    """
    Provide a SQLAlchemy session connected to an isolated in-memory database.

    - Creates all tables from `ProjectBase` if they exist.
    - Starts a transaction and yields a session bound to that transaction.
    - Rolls back and closes everything on teardown to leave a clean state.
    """
    ProjectBase.metadata.create_all(bind=engine)

    connection = engine.connect()
    transaction = connection.begin()
    session = TestingSessionLocal(bind=connection)

    try:
        yield session
    finally:
        # Revert DB to original state
        session.close()
        transaction.rollback()
        connection.close()
        ProjectBase.metadata.drop_all(bind=engine)


@pytest.fixture
def auth_app():
    """Create a test app with auth router for testing authentication endpoints"""
    auth_app = FastAPI()
    auth_router = APIRouter(prefix="/api/v1/auth", tags=["auth"])
    
    # NOTE: Authentication endpoints need to be implemented in the actual auth.py file
    # This fixture is prepared for when they exist
    
    auth_app.include_router(auth_router)
    return auth_app


@pytest.fixture
def auth_client(auth_app):
    """Provide a test client for the auth app"""
    return TestClient(auth_app)