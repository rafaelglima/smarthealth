import os
import boto3
import pymysql
import datetime
from datetime import datetime

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

        # banco de dados apenas para persistir os tempos para analise estatistica. alterar os valores.
        host = ""
        user = ""
        password = ""
        database = ""

        timestamp1=datetime.now()
        # Download do arquivo do S3 vindo do script
        temp_file = "/tmp/" + event.key  #Caminho temporário para armazenar o arquivo
        s3_client.download_file(event.bucket, event.key, temp_file) #bucket, object_name, file_name
        
        # Upload do arquivo pro S3 da camada em nevoa
        s3_client.upload_file(temp_file, S3_BUCKET_DEST, event.key)
        timestamp2=datetime.now()
        
        Tempo1=(timestamp2-timestamp1).total_seconds()
        
        print(f'O arquivo foi enviado para o S3')

        try:
                        
            connection = pymysql.connect(
                host=host,
                user=user,
                password=password,
                database=database
            )
            cursor = connection.cursor()

                        
            insert_query = """
            INSERT INTO baseline (tempo1) 
            VALUES (%s);
            """
            cursor.execute(insert_query, (Tempo0))
                        
                        
            connection.commit()
            print("Dados inseridos no MySQL com sucesso!")

        except pymysql.MySQLError as db_error:
            print(f"Erro ao inserir dados no MySQL: {db_error}")

        finally:
            if connection:
                cursor.close()
                connection.close()

    except Exception as e:
        print(e)
        print(f'Erro com o envio do arquivo')

