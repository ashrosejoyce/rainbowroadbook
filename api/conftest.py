import pytest


@pytest.fixture(autouse=True)
def plain_static_storage(settings):
    """Tests don't run collectstatic, so skip WhiteNoise's manifest lookup."""
    settings.STORAGES = {
        **settings.STORAGES,
        "staticfiles": {
            "BACKEND": "django.contrib.staticfiles.storage.StaticFilesStorage"
        },
    }
