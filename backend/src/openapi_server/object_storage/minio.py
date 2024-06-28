import os
import boto3
from typing import BinaryIO
from fastapi import HTTPException


class MinioClient:
    def __init__(self):
        self.endpoint = os.getenv('MINIO_ENDPOINT')
        self.access_key = os.getenv('MINIO_ACCESS_KEY')
        self.secret_key = os.getenv('MINIO_SECRET_KEY')
        self.bucket_name = os.getenv('BUCKET_NAME')
        if not all([self.endpoint, self.access_key, self.secret_key, self.bucket_name]):
            raise Exception('Missing environment variables')

        self.client = boto3.client(
            's3',
            endpoint_url=self.endpoint,
            aws_access_key_id=self.access_key,
            aws_secret_access_key=self.secret_key,
        )

    def create_bucket(self) -> None:
        try:
            self.client.create_bucket(Bucket=self.bucket_name)
            print(f'Bucket "{self.bucket_name}" has been created successfully.')
        except self.client.exceptions.BucketAlreadyOwnedByYou:
            print(f'{self.bucket_name} is already owned by you')
        except self.client.exceptions.BucketAlreadyExists:
            print(f'{self.bucket_name} already exists')
        except Exception as e:
            print(f'Error: {e}')

    def upload_file(self, file_bytes: BinaryIO, key: str) -> str:
        try:
            self.client.upload_fileobj(file_bytes, self.bucket_name, key)
            return key
        except Exception as e:
            raise HTTPException(status_code=500, detail=f'Error uploading file: {e}')

    def download_file(self, key: str) -> bytes:
        try:
            response = self.client.get_object(Bucket=self.bucket_name, Key=key)
            image_bytes = response['Body'].read()
            return image_bytes
        except Exception as e:
            raise HTTPException(status_code=500, detail=f'Error downloading file: {e}')

    def delete_file(self, key: str) -> None:
        try:
            self.client.delete_object(Bucket=self.bucket_name, Key=key)
        except Exception as e:
            raise HTTPException(status_code=500, detail=f'Error deleting file: {e}')

    def delete_bucket_and_contents(self) -> None:
        # バケットの存在を確認
        try:
            self.client.head_bucket(Bucket=self.bucket_name)
        except Exception as e:
            print(f'{self.bucket_name} does not exist')
            return

        try:
            # オブジェクトを取得
            objects = self.client.list_objects(Bucket=self.bucket_name)
            # オブジェクトが存在するか確認
            if 'Contents' in objects:
                for obj in objects['Contents']:
                    self.client.delete_object(Bucket=self.bucket_name, Key=obj['Key'])
            else:
                print(f'No objects found in "{self.bucket_name}".')

            # バケットを削除
            self.client.delete_bucket(Bucket=self.bucket_name)
            print(f'Bucket "{self.bucket_name}" and its contents have been deleted successfully.')
        except Exception as e:
            print(f'Error: {e}')


minio_client = MinioClient()
