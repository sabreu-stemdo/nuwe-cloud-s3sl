import boto3
import pandas as pd
from io import StringIO

s3_client = boto3.client('s3')

def add_age_group_column(event, context):
    
    bucket_name = "input-bucket"
    file_key = "test_input.csv"
    
    try:
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        csv_content = response['Body'].read().decode('utf-8')
        
        df = pd.read_csv(StringIO(csv_content))
        
        df['Age'] = pd.to_numeric(df['Age'], errors='coerce')

        df['Age'].fillna(0, inplace=True)

        df['AgeGroup'] = df['Age'].apply(lambda x: 0 if x < 5 else 1)

        
        csv_buffer = StringIO()
        df.to_csv(csv_buffer, index=False)
        
        processed_key = 'processed_'+file_key
        s3_client.put_object(Bucket=bucket_name, Key=processed_key, Body=csv_buffer.getvalue())
        
        return {
            'statusCode': 200,
            'body': f"Archivo procesado y guardado como {processed_key}",
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error: {e}"
        }

