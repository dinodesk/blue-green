import pytest
from business_logic import validate_input, calculate_total

# ✅ Valid input example
valid_event = {
    "userId": "u123",
    "items": [
        {"price": 10.0, "quantity": 2},
        {"price": 5.0, "quantity": 1}
    ]
}

def test_validate_input_success():
    # Should not raise any exception
    validate_input(valid_event)

def test_validate_input_missing_userid():
    event = { "items": valid_event["items"] }
    with pytest.raises(ValueError, match="Missing required field: 'userId'"):
        validate_input(event)

def test_validate_input_items_not_list():
    event = { "userId": "u123", "items": "not a list" }
    with pytest.raises(ValueError, match="'items' must be a list"):
        validate_input(event)

def test_validate_input_empty_items():
    event = { "userId": "u123", "items": [] }
    with pytest.raises(ValueError, match="'items' list cannot be empty"):
        validate_input(event)

def test_validate_input_item_missing_fields():
    event = { "userId": "u123", "items": [{}] }
    with pytest.raises(ValueError, match="Each item must have 'price' and 'quantity'"):
        validate_input(event)

def test_calculate_total():
    total = calculate_total(valid_event["items"])
    assert total == 25.0
