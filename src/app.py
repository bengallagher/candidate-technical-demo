import json
import boto3

# Create boto3 session
session = boto3.Session()

def lambda_handler(event, context):

    client = session.client("sts")

    sts_response = client.get_caller_identity()

    return {
        "statusCode": 200,
        "body": json.dumps(sts_response),
        "isBase64Encoded": False
    }
