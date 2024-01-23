#!/bin/bash

# Detener los servicios de Jitsi Meet
sudo service jitsi-videobridge2 stop
sudo service jicofo stop
sudo service prosody stop
sudo service nginx stop

# Desinstalar los paquetes de Jitsi Meet
# sudo apt-get remove --purge jitsi-meet jitsi-meet-web jitsi-meet-prosody jitsi-meet-web-config jitsi-meet-turnserver jitsi-meet-nginx
sudo apt-get remove --purge jitsi-meet jitsi-meet-prosody jitsi-meet-web jitsi-meet-web-config jicofo jitsi-videobridge2
sudo apt-get autoclean
sudo apt-get --force-yes remove
sudo apt-get install --reinstall dpkg
sudo cd /var/lib/dpkg/info
sudo rm jitsi-meet-web-config.postinst
cd /
sudo dpkg -l | grep jitsi

# Eliminar configuraciones y datos
#sudo rm -rf /etc/jitsi
#sudo rm -rf /usr/share/jitsi-meet
#sudo rm -rf /var/lib/prosody
#sudo rm -rf /var/lib/jitsi
#sudo rm -rf /var/log/jitsi

# Recargar la configuración de systemd
sudo systemctl daemon-reload

# Eliminar todos los enlaces simbólicos de Jitsi Meet en el directorio de sitios de Nginx
sudo rm /etc/nginx/sites-enabled/*

# Reiniciar Nginx para aplicar los cambios
sudo service nginx restart

echo "Jitsi Meet ha sido desinstalado exitosamente."
