import boto3

# Initialize SQS client
sqs = boto3.client('sqs', region_name='us-east-1')

# Queue URL
queue_url = 'https://sqs.us-east-1.amazonaws.com/118964108661/tomato-sqs-queue'

# Send message
response = sqs.send_message(
    QueueUrl=queue_url,
    MessageBody='{"airTime": "Hello8 tracker"}'
)

print("Message sent. MessageId:", response['MessageId'])