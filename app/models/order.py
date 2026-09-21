from pydantic import BaseModel, Field


class OrderRequest(BaseModel):
    customer_id: str = Field(min_length=1)
    product: str = Field(min_length=1)
    quantity: int = Field(gt=0)


class OrderResponse(BaseModel):
    order_id: str
    status: str
    customer_id: str
    product: str
    quantity: int
