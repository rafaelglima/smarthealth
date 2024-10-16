from chalice import Chalice
import json
import pymysql
import os
import sys
import base64
import httpx
import http.client
import boto3
from botocore.exceptions import BotoCoreError, ClientError
import datetime
from datetime import datetime

app = Chalice(app_name='lambda-fog-iot')


@app.lambda_function(name='frequencia_cardiaca')
def frequencia_cardiaca(event, context):
    timestamp1=datetime.now() # Exemplo dos TimeStamps coletados durante a execução
    #date_format = "%Y-%m-%dT%H:%M:%S"
    #valor = json.loads(event['body']) # Converte a requisição para uma variavel
    #valordata = datetime.strptime(valor['datahora'], date_format)
    #valor = json.loads(json.dumps(event))
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"

    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-frequencia-cardiaca']
    print(value)
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    print(valor)
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()  

    observation_json = {
    'resourceType': 'Observation',
    'status': 'final',
    'meta': {
        'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
    },
    'code': {
        'coding': [{
            'system': 'http://loinc.org/',
            'code': '1111-2',
            'display': valor['_id_'],
        }]
    },
    'subject': {
        'reference': f'Patient/{valor["paciente_id"]}'
    },
    'valueQuantity': {
        'value': valor['valor'],
        'unit': valor['unidade']
    },
    'device': {
        'id': valor['dispositivo_id'],
    },
    'effectiveDateTime': valor['datahora']
    }
    
    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()
    
    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080) #('10.20.12.58', 31621) 
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
        
        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valor'],
            "value2": 0,
            "value3": 0,
            "timestamp": valor['datahora']
            }
            
                        
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=frequencia_cardiaca"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'frequencia_cardiaca', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print(f"response.status != 2: {response.code}")
                
    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")
        
        
    return True
    
@app.lambda_function(name='temperatura_corporal')
def temperatura_corporal(event,context):
    
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"

    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-temperatura-corporal']
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
        
    observation_json = {
    'resourceType': 'Observation',
    'status': 'final',
    'meta': {
        'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
    },
    'code': {
        'coding': [{
            'system': 'http://loinc.org/',
            'code': '2222-2',
            'display': valor['_id_'],
        }]
    },
    'subject': {
        'reference': f'Patient/{valor["paciente_id"]}'
    },
    'valueQuantity': {
        'value': valor['valor'],
        'unit': valor['unidade']
    },
    'device': {
        'id': valor['dispositivo_id'],
    },
    'effectiveDateTime': valor['datahora']
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()

    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
    
        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valor'],
            "value2": 0,
            "value3": 0,
            "timestamp": valor['datahora']
            }
                        
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=temperatura_corporal"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'temperatura_corporal', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print(response.code)
            
    except httpx.HTTPError as exc:
            print(f"Erro durante a solicitação POST: {exc}")
        
    return True
    
@app.lambda_function(name='oximetria_pulso')
def oximetria_pulso(event,context):
    
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"

    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-oximetria-pulso']
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
          
    observation_json = {
    'resourceType': 'Observation',
    'status': 'final',
    'meta': {
        'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
    },
    'code': {
        'coding': [{
            'system': 'http://loinc.org/',
            'code': '3333-3',
            'display': valor['_id_'],
        }]
    },
    'subject': {
        'reference': f'Patient/{valor["paciente_id"]}'
    },
    'valueQuantity': {
        'value': valor['valor'],
        'unit': valor['unidade']
    },
    'device': {
        'id': valor['dispositivo_id'],
    },
    'effectiveDateTime': valor['datahora']
    }
    
    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()
    
    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
    
        if response.status // 100 == 2:
            
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valor'],
            "value2": 0,
            "value3": 0,
            "timestamp": valor['datahora']
            }
            
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=oximetria_pulso"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'oximetria_pulso', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print(response.code)
            
    except httpx.HTTPError as exc:
            print(f"Erro durante a solicitação POST: {exc}")
                
    
    return True
    
    
@app.lambda_function(name='frequencia_respiratoria')
def frequencia_respiratoria(event,context):
         
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-frequencia-respiratoria']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
    
    observation_json = {
    'resourceType': 'Observation',
    'status': 'final',
    'meta': {
        'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
    },
    'code': {
        'coding': [{
            'system': 'http://loinc.org/',
            'code': '4444-2',
            'display': valor['_id_'],
        }]
    },
    'subject': {
        'reference': f'Patient/{valor["paciente_id"]}'
    },
    'valueQuantity': {
        'value': valor['valor'],
        'unit': valor['unidade']
    },
    'device': {
        'id': valor['dispositivo_id'],
    },
    'effectiveDateTime': valor['datahora']
    }
    
    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()

    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
    
        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valor'],
            "value2": 0,
            "value3": 0,
            "timestamp": valor['datahora']
            }
            
                        
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=frequencia_respiratoria"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'frequencia_respiratoria', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")
            
    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")
           
        
    return True
    
@app.lambda_function(name='glicemia')
def glicemia(event,context):
         
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-glicemia']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
    
    observation_json = {
    'resourceType': 'Observation',
    'status': 'final',
    'meta': {
        'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
    },
    'code': {
        'coding': [{
            'system': 'http://loinc.org/',
            'code': '5555-2',
            'display': valor['_id_'],
        }]
    },
    'subject': {
        'reference': f'Patient/{valor["paciente_id"]}'
    },
    'valueQuantity': {
        'value': valor['valor'],
        'unit': valor['unidade']
    },
    'device': {
        'id': valor['dispositivo_id'],
    },
    'effectiveDateTime': valor['datahora']
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()
    
    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
    
        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valor'],
            "value2": 0,
            "value3": 0,
            "timestamp": valor['datahora']
            }
            
                        
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=glicemia"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'glicemia', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")
            
    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")
           
    
    return True
    
    
@app.lambda_function(name='pressao_arterial')
def pressao_arterial(event,context):
    
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-pressao-arterial']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
    
    observation_json = {
    "resourceType": "Observation",
    "status": "final",
    "code": {
    "coding": [
        {
        "system": "http://loinc.org/",
        "code": '6666-2',
        "display": valor['_id_']
        }
    ]
    },
    "subject": {
    'reference': f'Patient/{valor["paciente_id"]}'
    },
    "component": [
    {
        "code": {
        "coding": [
            {
            "system": "http://loinc.org/",
            "code": "55284-4",
            "display": "Pressão Arterial Diastólica"
            }
        ]
        },
        "valueQuantity": {
        "value": valor['valorPAD'],
        "unit": valor['unidade'],
        "code": '6666-2'
        }
    },
    {
        "code": {
        "coding": [
            {
            "system": "http://loinc.org/",
            "code": "8480-6",
            "display": "Pressão Arterial Sistólica"
            }
        ]
        },
        "valueQuantity": {
        "value": valor['valorPAS'],
        "unit": valor['unidade'],
        "code": '6666-2'
        }
    }
    ],
    "effectiveDateTime": valor['datahora'],
    "device": {
    "id": valor['dispositivo_id']
    }
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None
    
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()

    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()
    
        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')
                
                
            BC_json={
            "id": id_observation,
            "deviceId": valor['dispositivo_id'],
            "patientId": valor['paciente_id'],
            "unit": valor['unidade'],
            "value1": valor['valorPAD'],
            "value2": valor['valorPAS'],
            "value3": 0,
            "timestamp": valor['datahora']
            }
            
                        
            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()
            

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()
                                
                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=pressao_arterial"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1, valor2) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'pressao_arterial', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valorPAD'], valor['valorPAS']))
                        
                        
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
                                        
            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")
            
    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")
           
        
    return True

@app.lambda_function(name='umidade_relativa')
def umidade_relativa(event, context):

    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-umidade-relativa']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()

    # Cria o Json no formato FHIR
    observation_json = {
        'resourceType': 'Observation',
        'status': 'final',
        'meta': {
            'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
        },
        'code': {
            'coding': [{
                'system': 'http://loinc.org/',
                'code': '5555-2',
                'display': valor['_id_'],
            }]
        },
        'subject': {
            'reference': f'Patient/{valor["paciente_id"]}'
        },
        'valueQuantity': {
            'value': valor['valor'],
            'unit': valor['unidade']
        },
        'device': {
            'id': valor['dispositivo_id'],
        },
        'effectiveDateTime': valor['datahora']
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None

    headers = {
        'Content-Type': 'application/json',
    }

    timestamp3 = datetime.now()

    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()

        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')

            BC_json = {
                "id": id_observation,
                "deviceId": valor['dispositivo_id'],
                "patientId": valor['paciente_id'],
                "unit": valor['unidade'],
                "value1": valor['valor'],
                "value2": 0,
                "value3": 0,
                "timestamp": valor['datahora']
            }

            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()

                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=umidade_relativa"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'umidade_relativa', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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

            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")

    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")

    return True
       

@app.lambda_function(name='temperatura_ambiente')
def temperatura_ambiente(event, context):

    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-temperatura-ambiente']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()

    # Cria o Json no formato FHIR
    observation_json = {
        'resourceType': 'Observation',
        'status': 'final',
        'meta': {
            'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
        },
        'code': {
            'coding': [{
                'system': 'http://loinc.org/',
                'code': '5555-2',
                'display': valor['_id_'],
            }]
        },
        'subject': {
            'reference': f'Patient/{valor["paciente_id"]}'
        },
        'valueQuantity': {
            'value': valor['valor'],
            'unit': valor['unidade']
        },
        'device': {
            'id': valor['dispositivo_id'],
        },
        'effectiveDateTime': valor['datahora']
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()
    jsonfhir = json.dumps(observation_json)
    id_observation = None

    headers = {
        'Content-Type': 'application/json',
    }

    timestamp3 = datetime.now()

    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()

        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get('id')

            BC_json = {
                "id": id_observation,
                "deviceId": valor['dispositivo_id'],
                "patientId": valor['paciente_id'],
                "unit": valor['unidade'],
                "value1": valor['valor'],
                "value2": 0,
                "value3": 0,
                "timestamp": valor['datahora']
            }

            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()

                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=temperatura_ambiente"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'temperatura_ambiente', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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

            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")

    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")

    return True

    
@app.lambda_function(name='quedas')
def quedas(event, context):
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-quedas']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds() 

    # Cria o JSON no formato FHIR
    observation_json = {
        'resourceType': 'Observation',
        'status': 'final',
        'meta': {
            'source': 'e2GnP9EXQJ#QJVvZPm1IHZlXkQq'
        },
        'code': {
            'coding': [{
                'system': 'http://loinc.org/',
                'code': '5555-2',
                'display': valor['_id_'],
            }]
        },
        'subject': {
            'reference': f'Patient/{valor["paciente_id"]}'
        },
        'valueQuantity': {
            'value': valor['valor']
        },
        'device': {
            'id': valor['dispositivo_id'],
        },
        'effectiveDateTime': valor['datahora']
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds()  # Cria o segundo tempo
    jsonfhir = json.dumps(observation_json)  # Converte o JSON FHIR em uma string para envio
    id_observation = None

    headers = {
        'Content-Type': 'application/json',
    }

    timestamp3 = datetime.now()

    # Conexão POST com o banco FHIR
    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()

        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()  # Cria o terceiro tempo
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get("id")

            BC_json = {
                "id": id_observation,
                "deviceId": valor['dispositivo_id'],
                "patientId": valor['paciente_id'],
                "unit": valor['unidade'],
                "value1": valor['valor'],
                "value2": 0,
                "value3": 0,
                "timestamp": valor['datahora']
            }

            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()

                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=quedas"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'quedas', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valor']))
                        
                        
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

            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")

    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")

    return True

    
@app.lambda_function(name='geolocalizacao')
def geolocalizacao(event,context):
    
    timestamp1=datetime.now()
    json_string = json.dumps(event)

    host = "bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com"
    user = "admin"
    password = "1fiPE9u0p2U9SSOjWZ9h"
    database = "lambdalogs"
    
    # Analisando a string JSON
    data = json.loads(json_string)
    value = [record['value'] for record in data if record['topic'] == 'topic-geolocalizacao']
    
    
    #convertendo string decodificada para json
    valor = json.loads(base64.b64decode(value[0]).decode("utf-8"))
    valordata = datetime.strptime(valor['datahora'], '%Y-%m-%dT%H:%M:%S')
    Tempo1 = (timestamp1 - valordata).total_seconds()
    
    # Cria o Json no formato FHIR
    observation_json = {
    "resourceType": "Observation",
    "status": "final",
    "code": {
    "coding": [
      {
        "system": "http://loinc.org/",
        "code": '6666-2',
        "display": valor['_id_']
      }
    ]
    },
    "subject": {
    'reference': f'Patient/{valor["paciente_id"]}'
    },
    "component": [
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org/",
            "code": "55284-4",
            "display": "Latitude"
          }
        ]
      },
      "valueQuantity": {
        "value": valor['valorLATITUDE'],
        "unit": "Graus",
        "code": '6666-2'
      }
    },
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org/",
            "code": "8480-6",
            "display": "Longitude"
          }
        ]
      },
      "valueQuantity": {
        "value": valor['valorLONGITUDE'],
        "unit": "Graus",
        "code": '6666-2'
      }
    },
    {
      "code": {
        "coding": [
          {
            "system": "http://loinc.org/",
            "code": "8480-6",
            "display": "Precisão"
          }
        ]
      },
      "valueQuantity": {
        "value": valor['valorPRECISAO'],
        "unit": "Graus",
        "code": '6666-2'
      }
    }
    ],
    "effectiveDateTime": valor['datahora'],
    "device": {
    "id": valor['dispositivo_id']
    }
    }

    timestamp2 = datetime.now()
    Tempo2 = (timestamp2 - timestamp1).total_seconds() # Cria o segundo tempo
    jsonfhir = json.dumps(observation_json) # Converte o JSON FHIR em uma string para envio
    
    #print(jsonfhir)
    
    headers = {
    'Content-Type': 'application/json',
    }
    
    timestamp3 = datetime.now()
    
    # Conexão POST com o banco FHIR
    try:
        conn = http.client.HTTPConnection('acdba15b2a6dd4ffc810773b2c1ee2e1-818048396.us-east-1.elb.amazonaws.com',8080)
        conn.request('POST', '/fhir/Observation', jsonfhir, headers)
        response = conn.getresponse()

        if response.status // 100 == 2:
            timestamp4 = datetime.now()
            Tempo3 = (timestamp4 - timestamp3).total_seconds()  # Cria o terceiro tempo
            response_data = response.read()
            response_json = json.loads(response_data)
            id_observation = response_json.get("id")

            BC_json = {
                "id": id_observation,
                "deviceId": valor['dispositivo_id'],
                "patientId": valor['paciente_id'],
                "unit": 'Graus',
                "value1": valor['valorLATITUDE'],
                "value2": valor['valorLONGITUDE'],
                "value3": valor['valorPRECISAO'],
                "timestamp": valor['datahora']
            }

            jsonBC = json.dumps(BC_json)
            timestamp5 = datetime.now()

            try:
                conn = http.client.HTTPSConnection('khnqmo67dzocjdbgjmdkimvdya0vvdth.lambda-url.us-east-1.on.aws')
                conn.request('POST', '/addmeasurement', jsonBC, headers)
                response = conn.getresponse()

                if response.status // 100 == 2:
                    timestamp6 = datetime.now()
                    Tempo4 = (timestamp6 - timestamp5).total_seconds()
                    labeled_Tempo1 = f"tempo1={Tempo1}"
                    labeled_Tempo2 = f"tempo2={Tempo2}"
                    labeled_Tempo3 = f"tempo3={Tempo3}"
                    labeled_Tempo4 = f"tempo4={Tempo4}"
                    labeled_ID = f"IdObservation={id_observation}"
                    labeled_Nome = f"NomeDevice=geolocalizacao"
                    labeled_pacient = f"PacientId={valor["paciente_id"]}"
                    result = ",".join([labeled_ID, labeled_pacient, labeled_Nome, labeled_Tempo1, labeled_Tempo2, labeled_Tempo3,labeled_Tempo4])
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
                        INSERT INTO logscompletoiot (idobservation, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, idpaciente, valor1, valor2, valor3) 
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
                        """
                        cursor.execute(insert_query, (id_observation, 'geolocalizacao', Tempo1, Tempo2, Tempo3, Tempo4, 0, valor['paciente_id'], valor['valorLATITUDE'], valor['valorLONGITUDE'], valor['valorPRECISAO']))
                        
                        
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

            except httpx.HTTPError as exc:
                print(f"Erro durante a solicitação POST: {exc}")
        else:
            print("ERRO no Post FHIR")

    except httpx.HTTPError as exc:
        print(f"Erro durante a solicitação POST: {exc}")

    return True

