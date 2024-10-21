import os
import boto3
import time
import json
import re
import subprocess
import pandas as pd
import pymysql
from datetime import datetime, timezone, timedelta
from botocore.exceptions import NoCredentialsError

# Configurações do MySQL
db_config = {
    'host': 'bancologs-base.ch8o80maetn5.us-east-1.rds.amazonaws.com',
    'user': 'admin',
    'password': 'OWOvwXT4n4pP1Q5j4C4D',  # substitua pela sua senha
    'database': 'lambdalogs'
}

cont = 0

while cont < 1:
    # Configurações do S3
    bucket_name = 'repo-users-dicom-sa-east-1-905418066307'  # Substitua pelo nome do seu bucket S3
    folder_path = 'basecompleta'  # Substitua pelo caminho da pasta local com as imagens
    target_lambda = 'lambda-cloud-images-dev-s3_handler'

    # Inicializa o cliente S3
    s3 = boto3.client('s3')
    logs_client = boto3.client('logs')

    def upload_file_to_s3(file_path, bucket_name, s3_file_name):
        try:
            s3.upload_file(file_path, bucket_name, s3_file_name)
            time.sleep(1)
            print(f'Sucesso: {file_path} foi enviado para {bucket_name}/{s3_file_name}')
        except FileNotFoundError:
            print(f'Erro: O arquivo {file_path} não foi encontrado.')
        except NoCredentialsError:
            print('Erro: Credenciais não encontradas.')

    def upload_images_from_folder(folder_path, bucket_name):
        start_time = datetime.now(timezone.utc)  # Marca o início do upload
        for root, dirs, files in os.walk(folder_path):
            for file in files:
                if file.lower().endswith('.dcm'):  # Filtro para imagens
                    file_path = os.path.join(root, file)
                    s3_file_name = os.path.relpath(file_path, folder_path)
                    upload_file_to_s3(file_path, bucket_name, s3_file_name)
        end_time = datetime.now(timezone.utc)  # Marca o fim do upload
        return start_time, end_time
    
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
    
    def download_lambda_logs(lambda_name, start_time, end_time):
        start_time_ms = int(start_time.timestamp() * 1000)
        end_time_ms = int(end_time.timestamp() * 1000)
        timestamp_str = end_time.strftime('%Y-%m-%d_%H-%M-%S')
        output_dir = f"logs-{timestamp_str}"
        
        # Criar diretório de saída
        os.makedirs(output_dir, exist_ok=True)
        
        # Buscar os grupos de logs
        result = subprocess.run(["aws", "logs", "describe-log-groups", "--query", "logGroups[*].logGroupName", "--output", "text"], capture_output=True, text=True)
        log_groups = result.stdout.split()

        # Filtrar o grupo de logs da Lambda específica
        for log_group_name in log_groups:
            if lambda_name in log_group_name:
                clean_log_group_name = "".join([c if c.isalnum() else "_" for c in log_group_name])
                output_file = os.path.join(output_dir, f"{clean_log_group_name}.json")
                
                print(f"Baixando logs do grupo {log_group_name}...")

                with open(output_file, 'w') as f:
                    subprocess.run([
                        "aws", "logs", "filter-log-events",
                        "--log-group-name", log_group_name,
                        "--start-time", str(start_time_ms),
                        "--end-time", str(end_time_ms),
                        "--output", "json",
                        "--filter-pattern", ""
                    ], stdout=f)

        print(f"Logs da Lambda {lambda_name} salvos no diretório {output_dir}")
        return output_dir, timestamp_str

    def empty_s3_bucket(bucket_name):
        try:
            # Listar todos os objetos no bucket
            response = s3.list_objects_v2(Bucket=bucket_name)
            if 'Contents' in response:
                objects = [{'Key': obj['Key']} for obj in response['Contents']]
                # Excluir todos os objetos
                s3.delete_objects(Bucket=bucket_name, Delete={'Objects': objects})
                print(f"Bucket {bucket_name} esvaziado com sucesso.")
            else:
                print(f"O bucket {bucket_name} já está vazio.")
        except Exception as e:
            print(f'Erro ao esvaziar o bucket: {e}')

    # Função fetch_logs_from_database ajustada para aceitar output_dir
    def fetch_logs_from_database(start_time, end_time, output_dir):
        # Adiciona 3 minutos ao tempo final
        end_time += timedelta(minutes=3)
        start_time -= timedelta(minutes=2)

        connection = pymysql.connect(**db_config)
        cursor = connection.cursor(pymysql.cursors.DictCursor)

        query = """
            SELECT idobservation, nomedevice, tempo1, tempo2, tempo3
            FROM logsbaselineimages
            WHERE timestamp_column BETWEEN %s AND %s
        """
        cursor.execute(query, (start_time, end_time))
        logs = cursor.fetchall()

        # Processar os logs obtidos do banco de dados
        all_data = []
        for log in logs:
            all_data.append({
                'IDobservation': log['idobservation'],
                'NomeDevice': log['nomedevice'],
                'Tempo1': log['tempo1'],
                'Tempo2': log['tempo2'],
                'Tempo3': log['tempo3']
            })

        # Salvar os dados em um arquivo Excel
        df = pd.DataFrame(all_data)

        # Formatar os valores para 6 casas decimais
        df['Tempo1'] = df['Tempo1'].map(lambda x: f"{x:.6f}")
        df['Tempo2'] = df['Tempo2'].map(lambda x: f"{x:.6f}")
        df['Tempo3'] = df['Tempo3'].map(lambda x: f"{x:.6f}")

        # Criar o caminho do arquivo de saída com base no diretório e timestamp
        timestamp_str = end_time.strftime('%Y-%m-%d_%H-%M-%S')
        output_excel = os.path.join(output_dir, f'dados_{timestamp_str}.xlsx')
        
        # Salvar o DataFrame como Excel
        df.to_excel(output_excel, index=False)
        print(f"Dados processados e salvos em {output_excel}")

        cursor.close()
        connection.close()


    # Inicia o processo de upload e obtém o tempo de início e fim
    print("Iniciando upload das imagens...")
    start_time, end_time = upload_images_from_folder(folder_path, bucket_name)

    # Esvaziar o bucket após o upload
    print("Esvaziando o bucket S3...")
    empty_s3_bucket(bucket_name)

    print("Esperando os logs")
    time.sleep(5400)  # Aguarda um tempo para garantir que os logs estejam disponíveis

    # Criar o timestamp para nomear o diretório de saída
    timestamp_str = end_time.strftime('%Y-%m-%d_%H-%M-%S')
    output_dir = f"logs-{timestamp_str}"

    # Criar o diretório de saída para armazenar logs e relatórios
    os.makedirs(output_dir, exist_ok=True)

    # Baixar os logs da Lambda com base no tempo de execução do upload
    print("Upload concluído. Baixando logs da Lambda...")
    output_dir, timestamp_str = download_lambda_logs(target_lambda, start_time, end_time)

    # Processar os logs da Lambda e salvar o relatório no mesmo diretório
    output_excel_report = os.path.join(output_dir, f'report_logs_{timestamp_str}.xlsx')
    process_report_logs(output_dir, output_excel_report)

    # Buscar e processar logs do banco de dados e salvar no mesmo diretório
    print("Buscando logs do banco de dados...")
    fetch_logs_from_database(start_time, end_time, output_dir)


    print("Processo concluído.")
    cont += 1

else:
    print("Processo Finalizado")
