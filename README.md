# 🚀 AWS Infrastructure Reporter & Automation

Este repositorio contiene un conjunto de utilidades y scripts en **Bash** diseñados para interactuar con la [AWS CLI](https://aws.amazon.com). El objetivo principal es facilitar la auditoría rápida, el control de costos y la gestión de recursos en entornos de Amazon Web Services.

## 📋 Características

El script principal (`aws_report.sh`) automatiza la recolección de datos críticos:
- **Identidad:** Verifica la cuenta y el ARN del usuario actual.
- **EC2:** Tabla resumen con IDs, tipos de instancia, estados y IPs públicas.
- **S3:** Listado de buckets con cálculo de tamaño total por bucket.
- **Cost Optimization:** Identificación de volúmenes **EBS** en estado `available` (sin usar) que generan cargos innecesarios.
- **Seguridad:** Reporte de usuarios **IAM** con fechas de creación y último inicio de sesión.

## 🛠️ Requisitos Previos

1. **AWS CLI Instalado:** Sigue la [guía oficial de instalación](https://docs.aws.amazon.com).
2. **Credenciales Configuradas:** El script utiliza tu perfil por defecto. Configúralo con:
   ```bash
   aws configure
   
3. **Permisos IAM:** El usuario debe tener permisos de lectura (ReadOnlyAccess) o específicos para EC2, S3 e IAM.
