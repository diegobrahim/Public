#!/bin/bash

# ---- Instalación de MySQL Server -----
echo "Instalando MySQL Server..."
dnf install -y mysql-server
dnf install -y mysql

# ---- Habilitación de servicios -----
echo "Habilitando y arrancando el servicio MySQL..."
systemctl enable mysqld
systemctl start mysqld

# ---- Reglas de firewall -----
echo "Configurando las reglas del firewall..."
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

# ---- Configuración de bind access -----
echo "Permitiendo acceso desde cualquier IP en MySQL..."
sed -i '/bind-address/s/^#//g' /etc/my.cnf
sed -i 's/^bind-address\s*=.*$/bind-address = 0.0.0.0/' /etc/my.cnf
systemctl restart mysqld

# ---- Creación de usuario y habilitación de acceso -----
echo "Creando usuario 'dbadmin' y configurando permisos..."
mysql -e "CREATE USER 'dbadmin'@'%' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'dbadmin'@'%' WITH GRANT OPTION;"
mysql -e "ALTER USER 'dbadmin'@'%' IDENTIFIED BY 'password';"
mysql -e "FLUSH PRIVILEGES;"

echo "Instalación y configuración de MySQL Server completada."