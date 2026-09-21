import os

import httpx


BASE_URL = os.getenv("BASE_URL", "http://127.0.0.1:8000")


def test_health_against_docker() -> None:
    response = httpx.get(f"{BASE_URL}/health", timeout=5)
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_order_flow_against_docker() -> None:
    create = httpx.post(
        f"{BASE_URL}/orders",
        json={"customer_id": "docker-test", "product": "test-product", "quantity": 2},
        timeout=5,
    )
    assert create.status_code == 201

    order = create.json()
    assert order["customer_id"] == "docker-test"
    assert order["product"] == "test-product"
    assert order["quantity"] == 2
    assert order["status"] == "created"

    get = httpx.get(f"{BASE_URL}/orders/{order['order_id']}", timeout=5)
    assert get.status_code == 200
    assert get.json() == order
