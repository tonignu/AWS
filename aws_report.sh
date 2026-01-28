#!/bin/bash

# =================================================================
# Script: AWS Inventory & Status Report
# Descripción: Genera un reporte rápido de EC2, S3 e IAM.
# Uso: chmod +x aws_report.sh && ./aws_report.sh
# =================================================================

REPORT_FILE="aws_report_$(date +%Y%m%d_%H%M%S).txt"

echo "-------------------------------------------------------" | tee -a $REPORT_FILE
echo "REPORTANDO INFRAESTRUCTURA AWS - $(date)" | tee -a $REPORT_FILE
echo "-------------------------------------------------------" | tee -a $REPORT_FILE

# 1. Identidad: ¿Con qué cuenta estamos trabajando?
echo -e "\n[1] IDENTIDAD" | tee -a $REPORT_FILE
aws sts get-caller-identity --query "[Account, Arn]" --output table | tee -a $REPORT_FILE

# 2. EC2: Resumen de instancias
echo -e "\n[2] RESUMEN DE INSTANCIAS EC2" | tee -a $REPORT_FILE
aws ec2 describe-instances \
    --query "Reservations[*].Instances[*].{ID:InstanceId, Type:InstanceType, State:State.Name, PublicIP:PublicIpAddress}" \
    --output table | tee -a $REPORT_FILE

# 3. S3: Buckets y sus tamaños (aproximados)
echo -e "\n[3] BUCKETS S3 Y TAMAÑO" | tee -a $REPORT_FILE
for bucket in $(aws s3 ls | awk '{print $3}'); do
    echo -n "Bucket: $bucket -> " | tee -a $REPORT_FILE
    aws s3 ls s3://$bucket --recursive --human-readable --summarize | grep "Total Size" | tee -a $REPORT_FILE
done

# 4. EBS: Discos huérfanos (Available = Gasto innecesario)
echo -e "\n[4] VOLÚMENES EBS SIN USO (ESTADO: AVAILABLE)" | tee -a $REPORT_FILE
aws ec2 describe-volumes --filters Name=status,Values=available \
    --query "Volumes[*].{ID:VolumeId, Size:Size, Zone:AvailabilityZone}" \
    --output table | tee -a $REPORT_FILE

# 5. IAM: Seguridad - Usuarios y llaves de acceso
echo -e "\n[5] SEGURIDAD: USUARIOS IAM" | tee -a $REPORT_FILE
aws iam list-users --query "Users[*].{User:UserName, Created:CreateDate, LastLogin:PasswordLastUsed}" \
    --output table | tee -a $REPORT_FILE

echo -e "\n-------------------------------------------------------"
echo "Reporte guardado en: $REPORT_FILE"
echo "-------------------------------------------------------"
