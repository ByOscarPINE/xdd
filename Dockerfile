# Usa Ubuntu 20.04 como imagen base
FROM ubuntu:20.04

# Instala OpenJDK 8 y wget
RUN apt-get update \
    && apt-get install -y openjdk-8-jre wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configura la variable de entorno JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# Instalar Rclone
RUN apt-get update \
    && apt-get install -y rclone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configura rclone para Google Drive
RUN mkdir -p /root/.config/rclone \
    && echo "[gdrive]" > /root/.config/rclone/rclone.conf \
    && echo "type = drive" >> /root/.config/rclone/rclone.conf \
    && echo "scope = drive" >> /root/.config/rclone/rclone.conf \
    && echo "token = ${RCLONE_TOKEN}" >> /root/.config/rclone/rclone.conf \
    && echo "team_drive = ${RCLONE_TEAM_DRIVE}" >> /root/.config/rclone/rclone.conf

# Directorio de trabajo para la aplicación
WORKDIR /minecraft

# Copia los archivos necesarios
COPY server/ .

# Copia el script de respaldo
COPY backup.sh /minecraft/backup.sh

# Otorga permisos de ejecución al script de respaldo
RUN chmod +x /minecraft/backup.sh

# Aceptar automáticamente el EULA de Minecraft
RUN echo "eula=true" > eula.txt

# Exponer el puerto del servidor Minecraft
EXPOSE 25565

# Comando de inicio del servidor Minecraft con respaldo cada 6 horas
CMD ["sh", "-c", "while true; do /minecraft/backup.sh; sleep 21600; done & java -Xmx1024M -Xms1024M -jar forge-1.16.5-36.2.34.jar nogui"]
