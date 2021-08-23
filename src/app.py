import json
import boto3

# Create boto3 session
session = boto3.Session()

def lambda_handler(event, context):

    # Connect to STS service.
    client = session.client("sts")

    # Make STS api call.
    sts_response = client.get_caller_identity()

    # Remove metadata from response.
    sts_response.pop("ResponseMetadata", None)

    # Return formatted response object.
    return {
        "statusCode": 200,
        "body": json.dumps(sts_response),
        "isBase64Encoded": False
    }
