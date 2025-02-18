import json
import os
import boto3
import requests

# Initialize clients
sqs = boto3.client('sqs')
sns = boto3.client('sns')

# Environment variables
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def query_external_api(data):
    """
    Query an external web API with data from the SQS message.
    Replace this with your actual API endpoint and logic.
    """
    api_url = "https://api.example.com/query"
    response = requests.post(api_url, json=data)
    return response.json()

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")
    for record in event['Records']:
        # Parse SQS message
        message_body = json.loads(record['body'])
        
        # Query external API
        # api_response = query_external_api(message_body)
        api_response = {"message": "Test from Mirchi Lambda!"}
        
        # Publish API response to SNS
        sns.publish(
            TopicArn=SNS_TOPIC_ARN,
            Message=json.dumps(api_response),
            Subject="API Response"
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Message processed and published to SNS')
    }