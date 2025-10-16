#! /bin/bash
rpm -Uvh https://repo.zabbix.com/zabbix/7.2/release/centos/8/noarch/zabbix-release-latest-7.2.el8.noarch.rpm
dnf clean all
dnf install zabbix-agent2
dnf install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2