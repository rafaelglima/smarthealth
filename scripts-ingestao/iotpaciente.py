import os
import re
import subprocess
import time
import json
import random
import uuid
import threading
import pandas as pd
import pymysql
from faker import Faker
from datetime import datetime, timezone, timedelta
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configurações do MySQL
db_config = {
    'host': 'bancologs.c7kcq6eqamub.sa-east-1.rds.amazonaws.com',
    'user': 'admin',
    'password': '1fiPE9u0p2U9SSOjWZ9h',  # substitua pela sua senha
    'database': 'lambdalogs'
}

cont = 0

while (cont < 1):
    # Configurações de simulação
    fake = Faker()
    TOPICS = [
        'monitoramento/oximetria_pulso',
        'monitoramento/quedas',
        'monitoramento/pressao_arterial',
        'monitoramento/glicemia',
        'monitoramento/temperatura_ambiente',
        'monitoramento/frequencia_cardiaca',
        'monitoramento/frequencia_respiratoria',
        'monitoramento/umidade_relativa',
        'monitoramento/temperatura_corporal',
        'monitoramento/geolocalizacao'
    ]
    NUM_DEVICES_PER_TOPIC = 3200  # Número de devices por tópico
    PUBLISH_INTERVAL = 10  # Intervalo de publicação em segundos
    SIMULATION_DURATION = 1800  # Duração da simulação em segundos

    # Definição do endpoint AWS IoT
    host = 'a19ppd9pj5qumm-ats.iot.sa-east-1.amazonaws.com'

    # Certificados
    rootCAPath = 'AmazonRootCA1 (3).pem'
    privateKeyPath = '5687cd371b0c83b4b2c359c81fde56e0f967877997d2baf43235dc3d38b19b90-private.pem.key'
    certificatePath = '5687cd371b0c83b4b2c359c81fde56e0f967877997d2baf43235dc3d38b19b90-certificate.pem.crt'

    # Inicializa o cliente MQTT
    mqtt_client = AWSIoTMQTTClient(str(uuid.uuid4()))
    mqtt_client.configureEndpoint(host, 8883)
    mqtt_client.configureCredentials(rootCAPath, privateKeyPath, certificatePath)
    mqtt_client.connect()
    print("Conectado ao AWS IoT")

    def carregar_ids_pacientes(arquivo):
        try:
            with open(arquivo, 'r') as f:
                ids = [int(line.strip()) for line in f if line.strip().isdigit()]
            return ids
        except Exception as e:
            print(f'Erro ao carregar IDs de pacientes: {e}')
            return []

    # Função de publicação
    def publish_messages(device_id, topic, arquivo_pacientes='patient_ids.txt'):
        paciente_ids = carregar_ids_pacientes(arquivo_pacientes)
        paciente_id = random.choice(paciente_ids)
        message = {}
        if topic == 'monitoramento/oximetria_pulso':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=85, max=100),
            'unidade': 'SpO2',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/quedas':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=0, max=1),
            'unidade': 'int',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/pressao_arterial':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valorPAS': fake.random_int(min=108, max=132),
            'valorPAD': fake.random_int(min=72, max=88),
            'unidade': 'mmHg',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/glicemia':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=63, max=220),
            'unidade': 'mg/dL',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/temperatura_ambiente':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=-20, max=50),
            'unidade': 'ºC',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/frequencia_cardiaca':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=45, max=110),
            'unidade': 'bpm',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }                       
        elif topic == 'monitoramento/frequencia_respiratoria':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=10, max=22),
            'unidade': 'mrm',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/umidade_relativa':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=0, max=100),
            'unidade': '%',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/temperatura_corporal':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valor': fake.random_int(min=33, max=40),
            'unidade': 'ºC',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/geolocalizacao':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': paciente_id,
            'valorLATITUDE': fake.random_int(min=-90, max=90),
            'valorLONGITUDE': fake.random_int(min=-180, max=180),
            'valorPRECISAO': fake.random_int(min=0, max=5),
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }   
        try:
            mqtt_client.publish(topic, json.dumps(message), 1)
            print(f'Dispositivo {device_id} publicou no tópico {topic}:', message)
        except Exception as e:
            print(f'Erro ao publicar mensagem para dispositivo {device_id} no tópico {topic}: {e}')

    def publish_messages_alert(device_id, topic):
        message = {}
        if topic == 'monitoramento/oximetria_pulso':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1,776647,817225,817310,817314,817317,817320,817333,817334,817335]),
            'valor': fake.random_int(min=100, max=100),
            'unidade': '%',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/quedas':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024781,1024836,1024785,1024840,1024841,1024786,1024842,1024843,1024787,1024790]),
            'valor': fake.random_int(min=1, max=1),
            'unidade': 'int',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/pressao_arterial':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024846,1024791,1024847,1024848,1024792,1024796,1024797,1024852,1024798,1024799]),
            'valorPAS': fake.random_int(min=132, max=132),
            'valorPAD': fake.random_int(min=88, max=88),
            'unidade': 'mmHg',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/glicemia':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024800,1024853,1024856,1024904,1024905,1024858,1024859,1024906,1024862,1024865]),
            'valor': fake.random_int(min=220, max=220),
            'unidade': 'mg/dL',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/temperatura_ambiente':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024866,1024867,1024907,1024868,1024871,1024912,1024913,1024872,1024873,1024914]),
            'valor': fake.random_int(min=50, max=50),
            'unidade': 'ºC',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/frequencia_cardiaca':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024874,1024918,1024877,1024919,1024878,1024920,1024879,1024880,1024923,1024924]),
            'valor': fake.random_int(min=110, max=110),
            'unidade': 'bpm',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }                       
        elif topic == 'monitoramento/frequencia_respiratoria':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024884,1024885,1024886,1024887,1024891,1024927,1024892,1024893,1024928,1024929]),
            'valor': fake.random_int(min=22, max=22),
            'unidade': 'mrm',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/umidade_relativa':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024894,1024932,1024899,1024900,1024901,1024952,1024933,1024953,1024937,1024957]),
            'valor': fake.random_int(min=100, max=100),
            'unidade': '%',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/temperatura_corporal':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024958,1024938,1024959,1024960,1024965,1024940,1024966,1024941,1024942,1024943]),
            'valor': fake.random_int(min=40, max=40),
            'unidade': 'ºC',
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }
        elif topic == 'monitoramento/geolocalizacao':
            message = {
            'dispositivo_id': str(uuid.uuid4()),
            'paciente_id': random.choice([1024968,1024947,1024970,1024971,1024948,1024972,1024949,1024974,1025004,1025005]),
            'valorLATITUDE': fake.random_int(min=-90, max=90),
            'valorLONGITUDE': fake.random_int(min=-180, max=180),
            'valorPRECISAO': fake.random_int(min=0, max=5),
            'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
            '_id_': fake.random_int(min=90, max=100),
            }   
        try:
            mqtt_client.publish(topic, json.dumps(message), 1)
            print(f'ALERTA !! Dispositivo {device_id} publicou no tópico {topic}:', message)
        except Exception as e:
            print(f'Erro ao publicar mensagem para dispositivo {device_id} no tópico {topic}: {e}')

        # Função para publicar mensagens em um tópico
    def publish_for_topic(topic, use_alert=False):
        with ThreadPoolExecutor(max_workers=2) as executor:
            publish_func = publish_messages_alert if use_alert else publish_messages
            futures = [executor.submit(publish_func, device_id, topic) for device_id in range(1, NUM_DEVICES_PER_TOPIC + 1)]
            for future in as_completed(futures):
                try:
                    future.result()
                except Exception as e:
                    print(f'Erro na execução do thread: {e}')

    start_time = time.time()

    # Publica mensagens para todos os tópicos
    while time.time() - start_time < SIMULATION_DURATION:
        current_execution_time = time.time() - start_time  # Tempo decorrido desde o início
    
        # Alterna a cada 5 minutos (300 segundos) e dura 3 minutos (180 segundos)
        if (int(current_execution_time // 300) % 2 == 1) and (current_execution_time % 300 < 180):
            use_alert = True  # Estado de alerta
        else:
            use_alert = False  # Estado normal

        topic_threads = []
        for topic in TOPICS:
            thread = threading.Thread(target=publish_for_topic, args=(topic, use_alert))
            thread.start()
            topic_threads.append(thread)

        for thread in topic_threads:
            thread.join()  # Aguarda todos os tópicos

        time.sleep(PUBLISH_INTERVAL)

    mqtt_client.disconnect()
    print('Dispositivos desconectados.')

    # Lista de grupos de logs que devem ser ignorados (usando partes dos nomes)
    excluded_log_groups = ['msk', 'shdm', 'API', 'ipfs', 'users']

    # Baixar logs da última hora
    end_time = datetime.now(timezone.utc)
    start_time = end_time - timedelta(seconds=SIMULATION_DURATION)

    start_time_ms = int(start_time.timestamp() * 1000)
    end_time_ms = int(end_time.timestamp() * 1000)
    timestamp_str = end_time.strftime('%Y-%m-%d_%H-%M-%S')
    output_dir = f"logs-{timestamp_str}"

    print(f"Baixando logs de todos os grupos para o período de {start_time} até {end_time}...")

    # Criar diretório de saída
    os.makedirs(output_dir, exist_ok=True)

    # Listar todos os grupos de logs
    result = subprocess.run(["aws", "logs", "describe-log-groups", "--query", "logGroups[*].logGroupName", "--output", "text"], capture_output=True, text=True)
    log_groups = result.stdout.split()

    for log_group_name in log_groups:
        # Ignorar os grupos de logs que contém as strings na lista de exclusão
        if any(excluded in log_group_name for excluded in excluded_log_groups):
            print(f"Ignorando o grupo de logs: {log_group_name}")
            continue
        
        clean_log_group_name = "".join([c if c.isalnum() else "_" for c in log_group_name])
        output_file = os.path.join(output_dir, f"{clean_log_group_name}.json")
        
        print(f"Baixando logs do grupo {log_group_name}...")

        with open(output_file, 'w') as f:
            subprocess.run([
                "aws", "logs", "filter-log-events",
                "--log-group-name", log_group_name,
                "--start-time", str(start_time_ms),
                "--end-time", str(end_time_ms),
                "--output", "json"
            ], stdout=f)

    print(f"Todos os logs salvos no diretório {output_dir}")

    def parse_report_message(message):
        # Regex para capturar RequestId, Duration, Billed Duration e Max Memory Used
        pattern = re.compile(
            r"RequestId: (\S+)\s+Duration: (\d+\.\d+) ms\s+Billed Duration: (\d+) ms\s+Memory Size: \d+ MB\s+Max Memory Used: (\d+) MB"
        )
        match = pattern.search(message)
        if match:
            return {
                'RequestId': match.group(1),  # RequestId como o primeiro item
                'Duration': float(match.group(2)),  # Convertendo para float
                'Billed Duration': int(match.group(3)),  # Convertendo para inteiro
                'Max Memory Used': int(match.group(4))  # Convertendo para inteiro
            }
        return None
    
    def process_report_logs(directory, output_excel):
        all_data = []
        json_files = [f for f in os.listdir(directory) if f.endswith('.json')]  # Lista arquivos JSON
        
        for json_file in json_files:
            with open(os.path.join(directory, json_file), 'r') as file:
                data = json.load(file)
                events = data.get('events', [])  # Obter a lista de eventos ou uma lista vazia
                for entry in events:
                    if isinstance(entry, dict):
                        message = entry.get('message')
                        if message and 'Duration' in message:  # Verifica se a mensagem contém 'Duration'
                            parsed = parse_report_message(message)
                            if parsed:
                                all_data.append(parsed)

        if all_data:
            df = pd.DataFrame(all_data)  # Converte dados para DataFrame
            df.to_excel(output_excel, index=False)  # Salva dados em um Excel
            print(f"Relatório de métricas processado e salvo em {output_excel}")
        else:
            print("Nenhum dado correspondente encontrado.")

    # Processar os logs e gerar o arquivo Excel com métricas de execução Lambda
    output_excel = os.path.join(output_dir, f'report_logs_{timestamp_str}.xlsx')
    process_report_logs(output_dir, output_excel)

    # Conexão com o banco de dados MySQL usando pymysql
    connection = pymysql.connect(**db_config)
    cursor = connection.cursor(pymysql.cursors.DictCursor)

    # Definir o intervalo de tempo para buscar os logs
    end_time = datetime.now(timezone.utc)
    start_time = end_time - timedelta(seconds=SIMULATION_DURATION)

    query = """
        SELECT idobservation, idpaciente, nomedevice, tempo1, tempo2, tempo3, tempo4, tempo5, timestamp_column, valor1, valor2, valor3
        FROM logscompletoiot
        WHERE timestamp_column BETWEEN %s AND %s
    """
    cursor.execute(query, (start_time, end_time))
    logs = cursor.fetchall()

    # Processar os logs obtidos do banco de dados
    all_data = []
    for log in logs:
        all_data.append({
            'IDobservation': log['idobservation'],
            'IDpaciente': log['idpaciente'],
            'NomeDevice': log['nomedevice'],
            'Tempo1': log['tempo1'],
            'Tempo2': log['tempo2'],
            'Tempo3': log['tempo3'],
            'Tempo4': log['tempo4'],
            'Tempo5': log['tempo5'],
            'Timestamp': log['timestamp_column'],
            'Valor1': log['valor1'],
            'Valor2': log['valor2'],
            'Valor3': log['valor3']
        })

    # Salvar os dados em um arquivo Excel
    df = pd.DataFrame(all_data)
    df['Tempo1'] = df['Tempo1'].map(lambda x: f"{x:.6f}")
    df['Tempo2'] = df['Tempo2'].map(lambda x: f"{x:.6f}")
    df['Tempo3'] = df['Tempo3'].map(lambda x: f"{x:.6f}")
    df['Tempo4'] = df['Tempo4'].map(lambda x: f"{x:.6f}")
    df['Tempo5'] = df['Tempo5'].map(lambda x: f"{x:.6f}")

    timestamp_str = end_time.strftime('%Y-%m-%d_%H-%M-%S')
    output_excel = os.path.join(output_dir, f'dados_{timestamp_str}.xlsx')
    
    # Salvar o DataFrame como Excel
    df.to_excel(output_excel, index=False)
    print(f"Dados processados e salvos em {output_excel}")
    cont = cont + 1

    # Fechar a conexão com o banco de dados
    cursor.close()
    connection.close()

else:
    print("Processo Finalizado")
