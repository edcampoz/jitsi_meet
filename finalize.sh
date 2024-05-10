#!/bin/bash
set -e

# Definir la ruta en S3
s3Path="s3://jitsimeetfiles/Myrecordingfolder"

# path para guardar los videos
recordings="/config/recordings"

folder=$1
videoPath=$(find "$folder" -name '*.mp4' | head -1)
videoName=$(basename "$videoPath")

# Comprobar si el archivo de video existe
if [ ! -f "$videoPath" ]; then
    echo "No se encontró ningún archivo de video en la carpeta proporcionada." >&2
    exit 1
fi

# Extraer la parte hexadecimal del nombre del video
codigoHex=$(echo "$videoName" | cut -d '_' -f 1)

# Decodificar el código hexadecimal
codigoDecodificado=$(echo "$codigoHex" | xxd -r -p)

# Comprobar si el código hexadecimal se decodificó correctamente
if [ -z "$codigoDecodificado" ]; then
    echo "No se pudo decodificar el código hexadecimal del nombre del video." >&2

    # Sincronizar la carpeta local con la carpeta en S3
    aws s3 sync "$recordings" "$s3Path"

    echo "Eliminando la carpeta original..."
    rm -rf $folder
    exit 1
fi

# Extraer cedulaMedico y cedulaPaciente
cedulaPaciente=$(echo "$codigoDecodificado" | cut -d'_' -f1)
cedulaMedico=$(echo "$codigoDecodificado" | cut -d'_' -f2)

# Obtener la fecha y hora actual en el formato deseado (YYYYMMDDHHMMSS)
fechaHora=$(date +"%Y%m%d%H%M%S")

# Concatenar la fechaHora con cedulaMedico
nameVideo="${fechaHora}_${cedulaMedico}.mp4"

# Subir el video a S3
echo "Subiendo el video a S3..."
aws s3 cp "${videoPath}" "${s3Path}/${cedulaPaciente}/${nameVideo}"

# Eliminar la carpeta original
echo "Eliminando la carpeta original..."
rm -rf "$folder"

echo "Proceso completado con éxito."
exit 0
