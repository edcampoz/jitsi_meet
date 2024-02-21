# jitsi_meet

1. Ingresa como usuario root utilizando el siguiente comando:

```sh
sudo su
```

2. Para dar permisos de ejecución a los scripts de instalación y desinstalación de Jitsi Meet,       utiliza los siguientes comandos:

```sh
chmod +x install_jitsi_meet_.sh
chmod +x uninstall_jitsi_meet_.sh
```

3. Luego, puedes ejecutar cada script de la siguiente forma:

```sh
./install_jitsi_meet_.sh nombre_de_tu_dominio
```

4. Si pasadas unas horas no se ve refleajado el certificado SSL, 
    puedes intentar con el siguiente comando.

```sh
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d nombre_de_tu_dominio -d www.nombre_de_tu_dominio
```    

