# Imports das bibliotecas
import pandas as pd
import plotly.express as px
import numpy as np

# Escolha e leitura do arquivo .xlsx
file_path = 'output.xlsx'
df = pd.read_excel(file_path)

# Transformação do formato timedelta da planilha para segundos
def timedelta_to_seconds(td_str):
    td_str = td_str.strip()
    return pd.to_timedelta(td_str).total_seconds()

# Converte os valores das colunas Tempo para segundos e armazena em uma nova coluna.
df['Tempo1_seconds'] = df['Tempo1'].apply(timedelta_to_seconds)
df['Tempo2_seconds'] = df['Tempo2'].apply(timedelta_to_seconds)
df['Tempo3_seconds'] = df['Tempo3'].apply(timedelta_to_seconds)

# Normalizar os valores do eixo x para o intervalo [0, 1]
x_normalized = np.linspace(0, 1, len(df))
df['x_normalized'] = x_normalized

# Gráfico para Tempo1
fig1 = px.line(df, x='x_normalized', y='Tempo1_seconds', title='Gráfico de Linha para Tempo1', labels={'x_normalized': 'Hora', 'Tempo1_seconds': 'Tempo (segundos)'})
fig1.update_layout(legend_title_text='Tempo1')
fig1.show()

# Gráfico para Tempo2
fig2 = px.line(df, x='x_normalized', y='Tempo2_seconds', title='Gráfico de Linha para Tempo2', labels={'x_normalized': 'Hora', 'Tempo2_seconds': 'Tempo (segundos)'})
fig2.update_layout(legend_title_text='Tempo2')
fig2.show()

# Gráfico para Tempo3
fig3 = px.line(df, x='x_normalized', y='Tempo3_seconds', title='Gráfico de Linha para Tempo3', labels={'x_normalized': 'Hora', 'Tempo3_seconds': 'Tempo (segundos)'})
fig3.update_layout(legend_title_text='Tempo3')
fig3.show()
