import os

DEFAULT_VERSION = "0.0.0.0"


def runtime_version() -> str:
    """Return the release version supplied by deployment automation."""
    return os.getenv("APP_VERSION", DEFAULT_VERSION)


def runtime_identity() -> dict[str, str]:
    return {
        "version": runtime_version(),
        "environment": os.getenv("ENVIRONMENT", "local"),
        "source_commit": os.getenv("SOURCE_COMMIT", "unknown"),
        "image_tag": os.getenv("IMAGE_TAG", runtime_version()),
        "image_digest": os.getenv("IMAGE_DIGEST", "unknown"),
    }
