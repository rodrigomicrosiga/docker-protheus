#!/bin/bash

export LC_ALL=C
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

# Descompacta a SystemLoad em background.
if [[ -f "/protheus/protheus_data/systemload.tar.xz" ]]; then
	cd /protheus/protheus_data/
	(tar -xvf systemload.tar.xz && rm systemload.tar.xz) &
fi

# Configura e inicia serviço do Protheus.
cd /protheus/bin/appserver/
sed 's/{{APPSERVER_DATABASE}}/'"${APPSERVER_DATABASE}"'/' -i ./appserver.ini
echo "Inicializando AppServer $(./appsrvlinux --version) ${APPSERVER_DATABASE}"
./appsrvlinux

# Verifica limites de /proc/sys/fs/file-max.
FILE_MAX=$( cat /proc/sys/fs/file-max )
printf -- '-%.0s' {1..69}; printf '\n'
echo "Valor atual de /proc/sys/fs/file-max: $FILE_MAX"
if [[ $FILE_MAX -gt 2147483647 ]]; then
	echo "Tente o comando abaixo, no host, como root, antes de inicializar o container:"
	echo "# echo 2147483647 > /proc/sys/fs/file-max"
else
	echo "Tente o comando abaixo, no host, como root, antes de inicializar o container:"
	echo "# echo 65536 > /proc/sys/fs/file-max"
fi
printf -- '-%.0s' {1..69}; printf '\n'