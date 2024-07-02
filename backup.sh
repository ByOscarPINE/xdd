#!/bin/bash

export RCLONE_CONFIG_PASS="$RCLONE_CONFIG_PASS"

# Configuración de rclone
RCLONE_CONFIG_PATH="/root/.config/rclone/rclone.conf"

# Directorio de copias de seguridad
BACKUP_DIR=/minecraft/backups

# Nombre del archivo de respaldo con la fecha y hora actual
BACKUP_FILE=$BACKUP_DIR/backup-$(date +%Y%m%d%H%M%S).tar.gz

# Crear el directorio de copias de seguridad si no existe
mkdir -p $BACKUP_DIR

# Crear la copia de seguridad
tar -czvf $BACKUP_FILE /minecraft

echo "Copia de seguridad realizada: $BACKUP_FILE"

# Subir la copia de seguridad a Google Drive
rclone copy $BACKUP_FILE gdrive:/12YUoe5524mFFTzi4YbGIlWtEg7zg4ZCu

# Programa el próximo respaldo en 6 horas
echo "Próxima copia de seguridad programada en 6 horas"
sleep 21600
exec $0