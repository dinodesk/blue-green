import subprocess
import sys
import time
import httpx

def test_health_against_running_server() -> None:
    process = subprocess.Popen(
        [sys.executable, "-m", "uvicorn", "app.main:app", "--host", "127.0.0.1", "--port", "18000"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
    )
    try:
        deadline = time.time() + 10
        while time.time() < deadline:
            try:
                response = httpx.get("http://127.0.0.1:18000/health", timeout=1)
                if response.status_code == 200:
                    assert response.json() == {"status": "ok"}
                    return
            except httpx.HTTPError:
                time.sleep(0.2)
        raise AssertionError("FastAPI server did not become healthy")
    finally:
        process.terminate()
        process.wait(timeout=5)
