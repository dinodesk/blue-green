from uuid import uuid4

from fastapi import FastAPI, HTTPException

from app.models.order import OrderRequest, OrderResponse
from app.version import runtime_identity, runtime_version

app = FastAPI(title="Blue-Green FastAPI Demo", version=runtime_version())
orders: dict[str, OrderResponse] = {}


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/version")
def version() -> dict[str, str]:
    return runtime_identity()


@app.post("/orders", response_model=OrderResponse, status_code=201)
def create_order(request: OrderRequest) -> OrderResponse:
    order = OrderResponse(
        order_id=str(uuid4()),
        status="created",
        customer_id=request.customer_id,
        product=request.product,
        quantity=request.quantity,
    )
    orders[order.order_id] = order
    return order


@app.get("/orders/{order_id}", response_model=OrderResponse)
def get_order(order_id: str) -> OrderResponse:
    order = orders.get(order_id)
    if order is None:
        raise HTTPException(status_code=404, detail="Order not found")
    return order
