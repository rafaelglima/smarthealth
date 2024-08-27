import boto3
from datetime import datetime
import pandas as pd
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# Cria uma sessão com a AWS
session = boto3.Session(
    aws_access_key_id='AKIA5FTY7JGB4G7FH77T',
    aws_secret_access_key='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',
    region_name='us-east-1'
)

# Cria clientes Lambda, CloudWatch, EC2 e RDS
lambda_client = session.client('lambda')
cloudwatch = session.client('cloudwatch')
ec2_client = session.client('ec2')
rds_client = session.client('rds')

# Função para obter as métricas do CloudWatch para Lambda
def get_lambda_metrics(function_name, metric_name, start_time, end_time):
    try:
        response = cloudwatch.get_metric_statistics(
            Namespace='AWS/Lambda',
            MetricName=metric_name,
            Dimensions=[
                {
                    'Name': 'FunctionName',
                    'Value': function_name
                },
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=300,  # Período de 5 minutos (300 segundos)
            Statistics=['Average']
        )
        return response['Datapoints']
    except Exception as e:
        print(f"Erro ao obter métricas para {function_name} na métrica {metric_name}: {e}")
        return []

# Função para obter as métricas do CloudWatch para EC2
def get_ec2_metrics(instance_id, metric_name, start_time, end_time):
    try:
        response = cloudwatch.get_metric_statistics(
            Namespace='AWS/EC2',
            MetricName=metric_name,
            Dimensions=[
                {
                    'Name': 'InstanceId',
                    'Value': instance_id
                },
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=300,  # Período de 5 minutos (300 segundos)
            Statistics=['Average']
        )
        return response['Datapoints']
    except Exception as e:
        print(f"Erro ao obter métricas para {instance_id} na métrica {metric_name}: {e}")
        return []

# Função para obter as métricas do CloudWatch para RDS
def get_rds_metrics(db_instance_id, metric_name, start_time, end_time):
    try:
        response = cloudwatch.get_metric_statistics(
            Namespace='AWS/RDS',
            MetricName=metric_name,
            Dimensions=[
                {
                    'Name': 'DBInstanceIdentifier',
                    'Value': db_instance_id
                },
            ],
            StartTime=start_time,
            EndTime=end_time,
            Period=300,  # Período de 5 minutos (300 segundos)
            Statistics=['Average']
        )
        return response['Datapoints']
    except Exception as e:
        print(f"Erro ao obter métricas para {db_instance_id} na métrica {metric_name}: {e}")
        return []

# Define o período de tempo específico
start_time = datetime(2024, 8, 23, 0, 0, 0)
end_time = datetime(2024, 8, 23, 23, 59, 59)

print(f"Coletando métricas para o período de {start_time} a {end_time}")

# Lista todas as funções Lambda
functions = lambda_client.list_functions()

# Lista todas as instâncias EC2
instances = ec2_client.describe_instances()
instance_ids = [instance['InstanceId'] for reservation in instances['Reservations'] for instance in reservation['Instances']]

# Lista todas as instâncias RDS
rds_instances = rds_client.describe_db_instances()
rds_instance_ids = [db_instance['DBInstanceIdentifier'] for db_instance in rds_instances['DBInstances']]

# Métricas que queremos obter para Lambda, EC2 e RDS
lambda_metrics = [
    'ConcurrentExecutions',
    'Invocations',
    'PostRuntimeExtensionsDuration',
    'Duration',
    'Throttles',
    'Errors'
]

ec2_metrics = [
    'DiskReadBytes',
    'NetworkPacketsIn',
    'NetworkPacketsOut',
    'CPUUtilization',
    'NetworkIn',
    'NetworkOut'
]

rds_metrics = [
    'CPUUtilization',
    'ReadLatency',
    'ReadThroughput',
    'WriteLatency',
    'WriteThroughput'
]

# Dicionário para armazenar os dados
data = {
    'ResourceType': [],
    'ResourceId': [],
    'MetricName': [],
    'Timestamp': [],
    'Average': []
}

# Coleta métricas para funções Lambda
for function in functions['Functions']:
    function_name = function['FunctionName']
    print(f"Função Lambda: {function_name}")
    for metric in lambda_metrics:
        print(f"Coletando dados para {metric}")
        data_points = get_lambda_metrics(function_name, metric, start_time, end_time)
        if not data_points:
            print(f"Nenhum dado encontrado para {function_name} na métrica {metric}")
        for data_point in data_points:
            data['ResourceType'].append('Lambda')
            data['ResourceId'].append(function_name)
            data['MetricName'].append(metric)
            data['Timestamp'].append(data_point['Timestamp'].replace(tzinfo=None))  # Remove o fuso horário
            data['Average'].append(data_point.get('Average', 'N/A'))

# Coleta métricas para instâncias EC2
for instance_id in instance_ids:
    print(f"Instância EC2: {instance_id}")
    for metric in ec2_metrics:
        print(f"Coletando dados para {metric}")
        data_points = get_ec2_metrics(instance_id, metric, start_time, end_time)
        if not data_points:
            print(f"Nenhum dado encontrado para {instance_id} na métrica {metric}")
        for data_point in data_points:
            data['ResourceType'].append('EC2')
            data['ResourceId'].append(instance_id)
            data['MetricName'].append(metric)
            data['Timestamp'].append(data_point['Timestamp'].replace(tzinfo=None))  # Remove o fuso horário
            data['Average'].append(data_point.get('Average', 'N/A'))

# Coleta métricas para instâncias RDS
for db_instance_id in rds_instance_ids:
    print(f"Instância RDS: {db_instance_id}")
    for metric in rds_metrics:
        print(f"Coletando dados para {metric}")
        data_points = get_rds_metrics(db_instance_id, metric, start_time, end_time)
        if not data_points:
            print(f"Nenhum dado encontrado para {db_instance_id} na métrica {metric}")
        for data_point in data_points:
            data['ResourceType'].append('RDS')
            data['ResourceId'].append(db_instance_id)
            data['MetricName'].append(metric)
            data['Timestamp'].append(data_point['Timestamp'].replace(tzinfo=None))  # Remove o fuso horário
            data['Average'].append(data_point.get('Average', 'N/A'))

# Cria um DataFrame a partir dos dados
df = pd.DataFrame(data)

# Ordena o DataFrame por Timestamp
df = df.sort_values(by='Timestamp')

# Verifica se o DataFrame está vazio
if not df.empty:
    try:
        # Salva o DataFrame em uma planilha Excel
        df.to_excel('cloudwatch_metrics.xlsx', index=False)
        print("Métricas salvas na planilha 'cloudwatch_metrics.xlsx'")
        
        # Cria um gráfico interativo com Plotly para funções Lambda
        fig_lambda = make_subplots(specs=[[{"secondary_y": True}]])

        # Adiciona as linhas ao gráfico com eixos y secundários quando necessário
        for function_name in df[df['ResourceType'] == 'Lambda']['ResourceId'].unique():
            function_df = df[(df['ResourceType'] == 'Lambda') & (df['ResourceId'] == function_name)]
            for metric in function_df['MetricName'].unique():
                metric_data = function_df[function_df['MetricName'] == metric]
                fig_lambda.add_trace(
                    go.Scatter(
                        x=metric_data['Timestamp'],
                        y=metric_data['Average'],
                        name=f"{function_name} - {metric}"
                    ),
                    secondary_y=metric_data['Average'].max() > 1000  # Define como eixo y secundário se o valor máximo for maior que 1000
                )

        fig_lambda.update_layout(
            title_text="Métricas do CloudWatch para Funções Lambda",
            xaxis_title="Timestamp",
            yaxis_title="Media",
            legend_title_text="Métricas",
            legend=dict(orientation='h', yanchor='bottom', y=1.02, xanchor='right', x=1)
        )

        fig_lambda.update_yaxes(title_text="Media", secondary_y=False)
        fig_lambda.update_yaxes(title_text="Valores Grandes", secondary_y=True)

        # Salva o gráfico interativo como um arquivo HTML
        fig_lambda.write_html('lambda_metrics_graph.html')
        fig_lambda.show()

        # Cria um gráfico interativo com Plotly para instâncias EC2 e RDS
        fig_ec2_rds = make_subplots(specs=[[{"secondary_y": True}]])

        # Adiciona as linhas ao gráfico com eixos y secundários quando necessário
        for resource_id in df[(df['ResourceType'] == 'EC2') | (df['ResourceType'] == 'RDS')]['ResourceId'].unique():
            resource_df = df[(df['ResourceId'] == resource_id)]
            for metric in resource_df['MetricName'].unique():
                metric_data = resource_df[resource_df['MetricName'] == metric]
                fig_ec2_rds.add_trace(
                    go.Scatter(
                        x=metric_data['Timestamp'],
                        y=metric_data['Average'],
                        name=f"{resource_id} - {metric}"
                    ),
                    secondary_y=metric_data['Average'].max() > 1000  # Define como eixo y secundário se o valor máximo for maior que 1000
                )

        fig_ec2_rds.update_layout(
            title_text="",
            xaxis_title="Timestamp",
            yaxis_title="Media",
            legend_title_text="Métricas",
            legend=dict(orientation='h', yanchor='bottom', y=1.02, xanchor='right', x=1)
        )

        fig_ec2_rds.update_yaxes(title_text="Average", secondary_y=False)
        fig_ec2_rds.update_yaxes(title_text="Valores Grandes", secondary_y=True)

        # Salva o gráfico interativo como um arquivo HTML
        fig_ec2_rds.write_html('ec2_rds_metrics_graph.html')
        fig_ec2_rds.show()
                
    except Exception as e:
        print(f"Erro ao salvar o DataFrame em Excel ou criar gráficos: {e}")
else:
    print("O DataFrame está vazio. Nenhum dado para salvar ou plotar.")
