#!/bin/bash

# Actualizar el sistema
yum update -y

# Instalar y configurar MySQL
yum install -y @mysql
systemctl start mysqld
systemctl enable mysqld

# Configurar la contraseña de root para MySQL
MYSQL_ROOT_PASSWORD="TuContraseñaSegura"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Instalar Zabbix
rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-release-6.0-2.el7.noarch.rpm
yum clean all
yum install -y zabbix-server-mysql zabbix-web-mysql zabbix-agent

# Crear base de datos y usuario para Zabbix
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin;"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'zabbix_password';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';"
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

# Importar el esquema inicial de la base de datos de Zabbix
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u zabbix -p'zabbix_password' zabbix

# Configurar Zabbix server
sed -i 's/# DBPassword=/DBPassword=zabbix_password/' /etc/zabbix/zabbix_server.conf

# Iniciar y habilitar Zabbix server y agent
systemctl start zabbix-server zabbix-agent
systemctl enable zabbix-server zabbix-agent

# Configurar PHP para Zabbix
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone America\/Los_Angeles/' /etc/httpd/conf.d/zabbix.conf

# Iniciar y habilitar Apache
systemctl start httpd
systemctl enable httpd

# Instalar Grafana
cat <<EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
EOF

yum install -y grafana

# Iniciar y habilitar Grafana
systemctl start grafana-server
systemctl enable grafana-server

# Fin del script
echo "Instalación completada: Zabbix, Grafana y MySQL han sido instalados y configurados."
echo "Accede a Zabbix en http://tu_servidor/zabbix"
echo "Accede a Grafana en http://tu_servidor:3000"