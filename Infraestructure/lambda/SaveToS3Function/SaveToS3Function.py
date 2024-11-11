import boto3

s3_client = boto3.client('s3')

def copy_file_between_buckets(event, context):
    source_bucket = "input-bucket"
    source_key = "processed_test_input.csv"
    destination_bucket = "output-bucket"
    destination_key = "processed_test_input.csv"

    try:
        # Copiar el archivo de un bucket a otro
        copy_source = {
            'Bucket': source_bucket,
            'Key': source_key
        }
        s3_client.copy_object(CopySource=copy_source, Bucket=destination_bucket, Key=destination_key)
        
        return {
            'statusCode': 200,
            'body': f"Archivo copiado de {source_bucket}/{source_key} a {destination_bucket}/{destination_key}"
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f"Error al copiar el archivo: {e}"
        }