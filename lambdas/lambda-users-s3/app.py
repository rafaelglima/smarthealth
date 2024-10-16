import os
import boto3
#from confluent_kafka import Producer
#import base64
#from kafka import KafkaProducer
#from kafka.errors import KafkaError
#import socket
#import time
#from aws_msk_iam_sasl_signer import MSKAuthTokenProvider
#import logging
#from botocore.exceptions import ClientError
#import botocore.credentials

from chalice import Chalice

app = Chalice(app_name='lambda-users-s3')
app.debug = True

#Bucket Origem
S3_BUCKET_ORIG = "repo-users-dicom-sa-east-1-904233115303"
#Bucket Destino
S3_BUCKET_DEST = "repo-fog-dicom-sa-east-1-904233115303" #os.environ.get('APP_BUCKET_NAME', '')

@app.on_s3_event(bucket=S3_BUCKET_ORIG, events=['s3:ObjectCreated:*'])
def s3_handler(event):
    app.log.debug("Received event for bucket: %s, key: %s",
                  event.bucket, event.key)
    try:
        #S3
        s3_client = boto3.client('s3')
    
        # Download do arquivo do S3
        temp_file = "/tmp/" + event.key  #Caminho temporário para armazenar o arquivo
        s3_client.download_file(event.bucket, event.key, temp_file) #bucket, object_name, file_name
        
        # Upload do arquivo pro S3 da camada em nevoa
        s3_client.upload_file(temp_file, S3_BUCKET_DEST, event.key)
        
        print(f'O arquivo foi enviado para o S3')

        #obtendo a sessao
#        sts_client = boto3.client('sts', region_name='sa-east-1')
#        response = sts_client.get_session_token()
#        session = response['Credentials']['SessionToken']
        
        #obtendo credenciais
#        provider = botocore.credentials.create_credential_resolver(session)
#        credenciais = provider.load_credentials()
        

#        class MSKTokenProvider():
#            def token(self):
#                oauth2_token, _ = MSKAuthTokenProvider.generate_auth_token_from_credentials_provider('sa-east-1', credenciais)
#                return oauth2_token

#        tp = MSKTokenProvider()

#        producer = KafkaProducer(
#            bootstrap_servers='b-2.shdmmsk.7cknv6.c4.kafka.sa-east-1.amazonaws.com:9098,b-3.shdmmsk.7cknv6.c4.kafka.sa-east-1.amazonaws.com:9098,b-1.shdmmsk.7cknv6.c4.kafka.sa-east-1.amazonaws.com:9098',
#            security_protocol='SASL_SSL',
#            sasl_mechanism='OAUTHBEARER',
#            sasl_oauth_token_provider=tp,
#            client_id=socket.gethostname(),
#        )
        

        
#        topic = "topic-shdm"
#        while True:
#            try:
#                inp=input(">")
#                producer.send(topic, event.key) #inp.encode()
#                producer.flush()
#                print("Produced!")
#            except Exception as e:
#                print("Failed to send message:", e)

#        producer.close()

    except Exception as e:
        print(e)
        print(f'Erro com o envio do arquivo')

