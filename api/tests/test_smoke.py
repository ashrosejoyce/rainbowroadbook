import pytest
from django.contrib.auth import get_user_model


def test_admin_login_page_loads(client):
    response = client.get("/admin/login/")
    assert response.status_code == 200


@pytest.mark.django_db
def test_database_is_reachable():
    User = get_user_model()
    User.objects.create_user(username="smoke", password="not-a-real-password")
    assert User.objects.count() == 1
