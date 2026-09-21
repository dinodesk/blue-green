from fastapi.testclient import TestClient
from app.main import app, orders

client = TestClient(app)

def setup_function() -> None:
    orders.clear()

def test_health() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

def test_create_and_get_order() -> None:
    payload = {"customer_id": "C-100", "product": "demo-widget", "quantity": 2}
    created = client.post("/orders", json=payload)
    assert created.status_code == 201
    order = created.json()
    assert order["status"] == "created"
    fetched = client.get(f"/orders/{order['order_id']}")
    assert fetched.status_code == 200
    assert fetched.json() == order

def test_create_order_validation() -> None:
    response = client.post("/orders", json={"customer_id": "", "product": "demo-widget", "quantity": 0})
    assert response.status_code == 422

def test_unknown_order_returns_404() -> None:
    response = client.get("/orders/does-not-exist")
    assert response.status_code == 404
    assert response.json()["detail"] == "Order not found"
