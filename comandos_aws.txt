# ======
# EC2
# ======

# Detener todas las instancias activas
aws ec2 stop-instances --instance-ids $(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].InstanceId" --output text)

# Obtener IPs públicas de todas las instancias
aws ec2 describe-instances --query "Reservations[*].Instances[*].PublicIpAddress" --output text

# Listar todas las instancias con el tag "Proyecto"
aws ec2 describe-instances --filters "Name=tag:Proyecto,Values=MyProjectName" --query "Reservations[*].Instances[*].InstanceId"

# Verificar el estado de salud de todas las instancias
aws ec2 describe-instance-status --query "InstanceStatuses[*].[InstanceId,InstanceState.Name,InstanceStatus.Status]" --output table

# ======
# S3
# ======

# Calcular el tamaño total de un bucket S3 (en bytes)
aws s3 ls s3://tu-nombre-de-bucket --recursive --human-readable --summarize | grep "Total Size"

# Sincronizar una carpeta local con S3
aws s3 sync ./carpeta-local s3://tu-bucket/destino

# ======
# IAM
# ======

# Listar todos los usuarios y la última vez que se loguearon
aws iam list-users --query "Users[*].[UserName,PasswordLastUsed]" --output table

# Ver el rol que estoy usando actualmente para interactuar con la plataforma AWS
aws sts get-caller-identity


# ======
# Lambda
# ======

# Listar todas mis funciones Lambda y su uso de memoria
aws lambda list-functions --query "Functions[*].[FunctionName,MemorySize,Runtime]" --output table



# ======
# Limpieza
# ======

# Encontrar volúmenes de disco (EBS) que no están en uso (y así poder borrarlos)
aws ec2 describe-volumes --filters Name=status,Values=available --query "Volumes[*].VolumeId" --output text

# Listar snapshots antiguos
aws ec2 describe-snapshots --owner-ids self --query "Snapshots[?StartTime<='2023-01-01'].SnapshotId"
