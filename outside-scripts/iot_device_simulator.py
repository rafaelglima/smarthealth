import time
import json
import uuid
import threading
from faker import Faker
from datetime import datetime, timezone
from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
from concurrent.futures import ThreadPoolExecutor, as_completed

# Configurações
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
NUM_DEVICES_PER_TOPIC = 1600  # Número de devices por topico
PUBLISH_INTERVAL = 25  # Intervalo de publicação em segundos
SIMULATION_DURATION = 3600  # Duração da simulação em segundos

# Definição do endpoint
host = 'a2sryy6dg4nuu6-ats.iot.us-east-1.amazonaws.com' 

# Certificados
rootCAPath = 'AmazonRootCA1.pem'
privateKeyPath = '1dea09b759d5f171118d55135572278ba07ff68c237584505dc46b12f911f89f-private.pem.key'
certificatePath = '1dea09b759d5f171118d55135572278ba07ff68c237584505dc46b12f911f89f-certificate.pem.crt'

# Inicializa o cliente MQTT
mqtt_client = AWSIoTMQTTClient(str(uuid.uuid4()))
mqtt_client.configureEndpoint(host, 8883)
mqtt_client.configureCredentials(rootCAPath, privateKeyPath, certificatePath)

# Configurações do MQTT
mqtt_client.configureAutoReconnectBackoffTime(1, 32, 20)
mqtt_client.configureOfflinePublishQueueing(-1)  
mqtt_client.configureDrainingFrequency(2)  
mqtt_client.configureConnectDisconnectTimeout(10)  
mqtt_client.configureMQTTOperationTimeout(10)  

# Conecta ao AWS IoT Core
mqtt_client.connect()
print("Conectado ao AWS IoT")

# Publica uma mensagem JSON simulada para um dispositivo específico em um determinado tópico MQT
def publish_messages(device_id, topic):
    message = {
        'dispositivo_id': str(uuid.uuid4()),
        'paciente_id': fake.random_int(min=1, max=1000),
        'valor': fake.random_int(min=90, max=100),
        'unidade': '%',
        'datahora': datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%S'),
        '_id_': fake.random_int(min=90, max=100),
        'valorPAD': fake.random_int(min=90, max=100),
        'valorPAS': fake.random_int(min=90, max=100),
        'valorLATITUDE': fake.random_int(min=0, max=90),
        'valorLONGITUDE': fake.random_int(min=0, max=180),
        'valorPRECISAO': fake.random_int(min=0, max=5),
    }

    try:
        mqtt_client.publish(topic, json.dumps(message), 1) # Publica a mensagem no tópico MQTT
        print(f'Dispositivo {device_id} publicou no tópico {topic}:', message)
    except Exception as e:
        print(f'Erro ao publicar mensagem para dispositivo {device_id} no tópico {topic}: {e}')

# Publica mensagens para todos os dispositivos simulados em um tópico específico usando threads.
def publish_for_topic(topic):
    with ThreadPoolExecutor(max_workers=2) as executor:  # Limita o número de threads simultâneas
        futures = [executor.submit(publish_messages, device_id, topic) for device_id in range(1, NUM_DEVICES_PER_TOPIC + 1)]
        for future in as_completed(futures):
            try:
                future.result()  # Captura exceções se ocorrerem durante a execução
            except Exception as e:
                print(f'Erro na execução do thread: {e}')

start_time = time.time()

# Publica mensagens para todos os dispositivos em todos os tópicos
while time.time() - start_time < SIMULATION_DURATION:
    topic_threads = []
    for topic in TOPICS:
        thread = threading.Thread(target=publish_for_topic, args=(topic,))
        thread.start()
        topic_threads.append(thread)
    
    for thread in topic_threads:
        thread.join()  # Aguarda todos os threads de tópicos terminarem
    
    time.sleep(PUBLISH_INTERVAL)

# Desconecta após a simulação
mqtt_client.disconnect()
print('Dispositivos desconectados.')
