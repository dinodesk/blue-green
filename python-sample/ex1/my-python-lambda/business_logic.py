def validate_input(event):
    required_keys = ['userId', 'items']
    for key in required_keys:
        if key not in event:
            raise ValueError(f"Missing required field: '{key}'")

    if not isinstance(event['items'], list):
        raise ValueError("'items' must be a list")

    if not event['items']:
        raise ValueError("'items' list cannot be empty")

    for item in event['items']:
        if 'price' not in item or 'quantity' not in item:
            raise ValueError("Each item must have 'price' and 'quantity'")


def calculate_total(items):
    return sum(item['price'] * item['quantity'] for item in items)
