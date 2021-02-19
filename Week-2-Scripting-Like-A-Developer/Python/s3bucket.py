import boto3
import sys

try:
    def main():
        create_s3bucket(bucket_name)

except Exception as e:
    print(e)

def create_s3bucket(bucket_name):
    s3_bucket=boto3.client(
        's3',
         region_name='eu-west-2'
    )

    # Had to add location and region because of set default region
    # https://boto3.amazonaws.com/v1/documentation/api/latest/guide/s3-example-creating-buckets.html    
    location = {'LocationConstraint':'eu-west-2'}

    bucket = s3_bucket.create_bucket(
        Bucket=bucket_name,
        ACL='private',
        CreateBucketConfiguration=location,
    )

    print(bucket)

bucket_name = sys.argv[1]

if __name__ == '__main__':
    main()