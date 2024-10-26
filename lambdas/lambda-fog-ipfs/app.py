import os
import boto3
import ipfscluster
import json
import pymysql
import http.client
import datetime
from datetime import datetime

from chalice import Chalice

app = Chalice(app_name='lambda-fog-ipfs')
app.debug = True

# nome do bucket s3
S3_BUCKET = "repo-fog-dicom-sa-east-1-904233115303"

@app.on_s3_event(bucket=S3_BUCKET, events=['s3:ObjectCreated:*'])
def s3_handler(event):
    app.log.debug("Received event for bucket: %s, key: %s",
                  event.bucket, event.key)
    timestamp1=datetime.now()
    try:
        ipfs_client = ipfscluster.connect('/dns4/k8s-default-ipfsclus-3f56978d74-44210d145a938626.elb.us-east-1.amazonaws.com/tcp/9094')  
        
        #S3
        s3 = boto3.client('s3')

        # banco de dados apenas para persistir os tempos para analise estatistica
        host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
        user = "admin"
        password = "1fiPE9u0p2U9SSOjWZ9h"
        database = "lambdalogs"
        
        # Download do arquivo do S3
        temp_file = "/tmp/" + event.key  # Caminho temporário para armazenar o arquivo
        s3.download_file(event.bucket, event.key, temp_file)
        timestamp2=datetime.now()
        Tempo1=(timestamp2-timestamp1).total_seconds()
        
        # Adicionar arquivo ao IPFS
        with open(temp_file, 'rb') as file:
            ipfs_data = ipfs_client.add_files(file)

        # O hash do arquivo adicionado ao IPFS
        ipfs_hash = ipfs_data['cid']
        name = ipfs_data['name']
        nome_arquivo, extensao = os.path.splitext(name)
        # Pinar o arquivo
        ipfs_pin = ipfs_client.pins.add(ipfs_hash)
        
        timestamp3=datetime.now()
        Tempo2=(timestamp3-timestamp2).total_seconds()
        datahora = datetime.now().isoformat()
        timestamp4=datetime.now()
        Media_Json={
            "resourceType": "Media",
            "status": "completed",
            "type": {
                "coding": [
                    {
                        "system": "https://terminology.hl7.org/ValueSet-v3-MediaType.html",
                        "code": "image",
                        "display": "Image"
                    }
                ]
            },
            "subject": {
                "reference": "Patient/1" # deve alterar para passar o ID do paciente
            },
            "createdDateTime": datahora,
            "content": {
                "contentType": "application/dicom",
                "url": ipfs_hash,
                "title": nome_arquivo
            },
            "note": [
                {
                    "text": ""
                }
            ]
        }
        
        id_media=None
        jsonfhir = json.dumps(Media_Json)
        headers = {
        'Content-Type': 'application/json',
        }
        timestamp5=datetime.now()
        Tempo3=(timestamp5-timestamp4).total_seconds()
        
        try:
            conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080) #endereco Cluster HAPI FHIR
            conn.request('POST', '/fhir/Media', jsonfhir, headers)
            response = conn.getresponse()
            if response.status // 100 == 2:
                response_data = response.read()
                response_json = json.loads(response_data)
                id_media = response_json.get('id')
                    
                BC_json={
                "fileid": id_media,
                "hash":ipfs_hash,
                "filename":nome_arquivo,
                "filetype":extensao,
                "timestamp":datahora
                }
                
                jsonBC = json.dumps(BC_json)
                timestamp6=datetime.now()
                Tempo4=(timestamp6-timestamp5).total_seconds()
                timestamp7=datetime.now()
                try:
                    conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws') #endereco da lambda bc
                    conn.request('POST', '/addfile', jsonBC, headers)
                    response = conn.getresponse()
                                    
                    if response.status // 100 == 2:
                        timestamp8=datetime.now()
                        Tempo5=(timestamp8-timestamp7).total_seconds()
                        labeled_Tempo1 = f"tempo1={Tempo1}"
                        labeled_Tempo2 = f"tempo2={Tempo2}"
                        labeled_Tempo3 = f"tempo3={Tempo3}"
                        labeled_Tempo4 = f"tempo4={Tempo4}"
                        labeled_Tempo5 = f"tempo5={Tempo5}"
                        labeled_ID = f"IdObservation={id_media}"
                        labeled_Nome = f"NomeDevice=Images"
                        result = ",".join([labeled_ID, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4, labeled_Tempo5])
                        print(result)
                        try:
                        
                            connection = pymysql.connect(
                                host=host,
                                user=user,
                                password=password,
                                database=database
                            )
                            cursor = connection.cursor()

                            insert_query = """
                            INSERT INTO logscompletoimages (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s);
                            """
                            cursor.execute(insert_query, (id_media, 'images', Tempo1, Tempo2, Tempo3, Tempo4, Tempo5))
                                     
                            connection.commit()
                            print("Dados inseridos no MySQL com sucesso!")

                        except pymysql.MySQLError as db_error:
                            print(f"Erro ao inserir dados no MySQL: {db_error}")

                        finally:
                            if connection:
                                cursor.close()
                                connection.close()
                    else:
                        print(response.code)
                                           
                except http.client.HTTPException as exc:
                        print(f"Erro durante a solicitação POST: {exc}")
            else:
                print(response.code)
        except http.client.HTTPException as exc:
            print(f"Erro durante a solicitação POST: {exc}")

    except Exception as e:
        print(e)
        print(f'Erro com o IPFS')

