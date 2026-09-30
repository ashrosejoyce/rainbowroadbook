import pytest
from django.db import DatabaseError


@pytest.mark.django_db
def test_healthz_returns_ok_when_database_is_reachable(client):
    response = client.get("/health/")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_healthz_returns_503_when_database_is_unreachable(client, monkeypatch):
    def broken_connection():
        raise DatabaseError("database is down")

    monkeypatch.setattr("config.views.connection.ensure_connection", broken_connection)

    response = client.get("/health/")

    assert response.status_code == 503
    assert response.json() == {"status": "unavailable"}
