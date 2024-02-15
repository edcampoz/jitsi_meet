# jitsi_meet

1. Ingresa como usuario root utilizando el siguiente comando:

```sh
sudo su
```

2. Actualiza la lista de paquetes disponibles del sistema con el siguiente comando:

```sh
apt update && apt upgrade -y
```

3. Para dar permisos de ejecución a los scripts de instalación y desinstalación de Jitsi Meet,       utiliza los siguientes comandos:

```sh
chmod +x install_jitsi_meet_.sh
chmod +x uninstall_jitsi_meet_.sh
```

4. Luego, puedes ejecutar cada script de la siguiente forma:

```sh
./install_jitsi_meet_.sh nombre_de_tu_dominio
```


