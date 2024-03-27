import boto3
from botocore.exceptions import ClientError
from retrying import retry

client = boto3.client('ssm', "us-east-1")

class Config:
    SECRET_KEY = None

class DevelopmentConfig(Config):
    DEBUG = False
    MYSQL_HOST = client.get_parameter(Name='MYSQL_HOST', WithDecryption=True)['Parameter']['Value']
    MYSQL_USER = client.get_parameter(Name='MYSQL_USER', WithDecryption=True)['Parameter']['Value']
    MYSQL_PASSWORD = client.get_parameter(Name='MYSQL_PASSWORD', WithDecryption=True)['Parameter']['Value']
    MYSQL_DB = client.get_parameter(Name='MYSQL_DB', WithDecryption=True)['Parameter']['Value']

    @retry(stop_max_attempt_number=3, wait_fixed=2000)
    def get_secret_key(self):
        try:
            response = client.get_parameter(Name='SECRET_KEY', WithDecryption=True)
            return response['Parameter']['Value']
        except ClientError as e:
            if e.response['Error']['Code'] == 'ParameterNotFound':
                print("SECRET_KEY parameter not found.")
            else:
                print(f"Error retrieving SECRET_KEY parameter: {e}")
            raise  # Reraise the exception to trigger retry

    try:
        SECRET_KEY = get_secret_key(None)
    except Exception as e:
        print("Failed to retrieve SSM parameters:", e)

config = {
    'development': DevelopmentConfig
}