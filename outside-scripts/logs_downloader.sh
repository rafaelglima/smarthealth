#!/bin/bash

DATE="2024-08-23"
START_TIME=$(date -d "$DATE 00:00:00" +%s000)
END_TIME=$(date -d "$DATE 23:59:59" +%s000)
OUTPUT_DIR="logs-$DATE"

echo "Baixando logs de todos os grupos para o dia $DATE..."

# Criar diretório de saída
mkdir -p "$OUTPUT_DIR"

# Listar todos os grupos de logs
LOG_GROUPS=$(aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text)

for LOG_GROUP_NAME in $LOG_GROUPS; do
  # Remove possíveis espaços extras e caracteres especiais dos nomes dos grupos
  CLEAN_LOG_GROUP_NAME=$(echo "$LOG_GROUP_NAME" | sed 's/[^a-zA-Z0-9]/_/g')
  OUTPUT_FILE="$OUTPUT_DIR/${CLEAN_LOG_GROUP_NAME}.json"
  
  echo "Baixando logs do grupo $LOG_GROUP_NAME..."

  # Baixar logs e salvar em formato JSON
  MSYS_NO_PATHCONV=1 aws logs filter-log-events \
    --log-group-name "$LOG_GROUP_NAME" \
    --start-time $START_TIME \
    --end-time $END_TIME \
    --output json > "$OUTPUT_FILE"

done

echo "Todos os logs salvos no diretório $OUTPUT_DIR"
