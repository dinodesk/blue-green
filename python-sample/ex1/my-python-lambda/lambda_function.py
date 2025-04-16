import json
from business_logic import validate_input, calculate_total

def lambda_handler(event, context):
    # name = event.get("name", "world")
    # return {
    #     "statusCode": 200,
    #     "body": json.dumps({"message": f"Hello, {name}!"})
    # }
    try:
        # Log the incoming event
        print("Received event:", json.dumps(event, indent=2))

        # ✅ Input Validation
        validate_input(event)

        # 📦 Business Logic: Calculate total cost of items
        total = calculate_total(event['items'])

        response = {
            "statusCode": 200,
            "body": {
                "message": f"Order for user {event['userId']} processed successfully.",
                "totalAmount": total
            }
        }

    except ValueError as ve:
        response = {
            "statusCode": 400,
            "body": {
                "error": str(ve)
            }
        }

    except Exception as e:
        response = {
            "statusCode": 500,
            "body": {
                "error": f"Internal error: {str(e)}"
            }
        }

    # Optional: Format body as JSON
    response['body'] = json.dumps(response['body'])
    return response