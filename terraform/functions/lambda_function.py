import json
import boto3
import piexif
import io

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event.
    record = event['Records'][0]

    s3bucket = record['s3']['bucket']['name']
    s3object = record['s3']['object']['key']

    try:
        response = s3.get_object(Bucket=s3bucket, Key=s3object)
        print("CONTENT TYPE: " + response['ContentType'])

        # Setting object content to var, ready for input to piexif.
        content = response['Body'].read()

        print('DOING THE EXIF REMOVAL')
        # Writing to memory, due to no writable storage in lambda.
        output = io.BytesIO()

        # Running piexif to remove exif data.
        newImage = piexif.remove(content, output)

        # Upload Object to bucket
        objectupload = s3.put_object(
            Body=output,
            Bucket='bucket-images-noexif',
            Key=s3object)


    except Exception as e:
        print(e)
        print(
            'Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(
                s3object, s3bucket))
        raise e

