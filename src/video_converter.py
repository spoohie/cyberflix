import boto3
import logging
from io import BytesIO
from math import floor
from os import path, environ
from dataclasses import dataclass


logger = logging.getLogger(__name__)

# get video from event
# run mediaconvert
# put converted video to output
# SNS notify user
# post metadata to DynamoDB


@dataclass
class SourceVideo:
    bucket_arn: str
    bucket_name: str
    file_key: str


def lambda_handler(event, context):
    output_bucket = environ.get("destination_bucket")

    mediaconvert_client=boto3.client("mediaconvert")
    mediaconvert_endpoint = get_mediaconvert_endpoint(mediaconvert_client)

    record = event["Records"][0]
    source_video = SourceVideo(
        bucket_arn=record["s3"]["bucket"]["arn"],
        bucket_name=record["s3"]["bucket"]["name"],
        file_key=record["s3"]["object"]["key"],
    )

    job = generate_mediaconvert_job()
    convert_video(job)

    _copy_file(source_video.bucket_name, source_video.file_key, output_bucket)
    return {"statusCode": 201, "body": "Video conversion initiated"}

def get_mediaconvert_endpoint(client):
    if endpoint := not environ.get("mediaconvert_endpoint"):
        response = client.describe_endpoints()
        endpoint = response.get('Endpoints', {})[0].get('Url')
        logger.info(f"Mediaconvert endpoint downloaded: {endpoint}")
    return endpoint

def generate_mediaconvert_job():
    pass

def convert_video(job):
    pass

def _copy_file(input_bucket, file_key, output_bucket):
    s3 = boto3.resource('s3')
    source= { 'Bucket' : input_bucket,'Key':file_key}
    dest = output_bucket
    s3.meta.client.copy(source,dest, file_key)
