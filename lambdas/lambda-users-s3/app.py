import os
import boto3
from chalice import Chalice

app = Chalice(app_name='lambda-users-s3')
app.debug = True

#Bucket Origem
S3_BUCKET_ORIG = "repo-users-dicom-sa-east-1-904233115303"
#Bucket Destino
S3_BUCKET_DEST = "repo-fog-dicom-sa-east-1-904233115303"

@app.on_s3_event(bucket=S3_BUCKET_ORIG, events=['s3:ObjectCreated:*'])
def s3_handler(event):
    app.log.debug("Received event for bucket: %s, key: %s",
                  event.bucket, event.key)
    try:
        #S3
        s3_client = boto3.client('s3')
    
        # Download do arquivo do S3 vindo do script
        temp_file = "/tmp/" + event.key  #Caminho temporário para armazenar o arquivo
        s3_client.download_file(event.bucket, event.key, temp_file) #bucket, object_name, file_name
        
        # Upload do arquivo pro S3 da camada em nevoa
        s3_client.upload_file(temp_file, S3_BUCKET_DEST, event.key)
        
        print(f'O arquivo foi enviado para o S3')

    except Exception as e:
        print(e)
        print(f'Erro com o envio do arquivo')

