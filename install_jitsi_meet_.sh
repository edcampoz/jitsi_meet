#!/bin/bash

# Verificar que se proporcione un argumento
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <nombre_de_dominio>"
    exit 1
fi

# Verificar si Nginx está instalado
if ! command -v nginx &> /dev/null; then
    echo "Nginx no está instalado. Instalándolo..."
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "Nginx instalado y configurado."
fi

# Verificar y configurar puertos en UFW
ufw_status=$(sudo ufw status | grep "Status: active")
if [ -z "$ufw_status" ]; then
    echo "Firewall no está activado. Activando..."
    sudo ufw allow 22/tcp
    sudo ufw enable
    echo "Firewall activado."
fi

# Verificar y permitir acceso a puertos
for port in 80 443 10000/udp 22 3478/udp 5349/tcp; do
    if sudo ufw status | grep -q "$port"; then
        echo "Puerto $port ya está permitido."
    else
        echo "Permitiendo acceso al puerto $port..."
        sudo ufw allow $port
        echo "Acceso permitido al puerto $port."
    fi
done

# Establecer el nombre de dominio con hostnamectl
sudo hostnamectl set-hostname "$1"

# Actualizar el sistema y requisitos previos
sudo apt update && apt upgrade -y
sudo apt-get install wget curl gnupg2 apt-transport-https -y
sudo echo 'deb https://download.jitsi.org stable/' >> /etc/apt/sources.list.d/jitsi-stable.list
sudo wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add - 
sudo apt-get update -y

# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar Jitsi Meet
sudo apt install -y jitsi-meet

# Configurar Jitsi Meet
sudo /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh

# Reiniciar los servicios de Jitsi Meet
sudo service jitsi-videobridge2 restart
sudo service jicofo restart
sudo service prosody restart

echo "Instalación y configuración de Jitsi Meet completadas."

# Mostrar la URL de Jitsi Meet
echo "Accede a tu servidor Jitsi Meet en tu navegador: https://$1"

exit 0
