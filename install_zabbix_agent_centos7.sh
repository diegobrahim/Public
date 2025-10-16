#! /bin/bash

rpm -Uvh https://repo.zabbix.com/zabbix/7.2/release/rhel/7/noarch/zabbix-release-latest-7.2.el7.noarch.rpm
yum clean all
yum install zabbix-agent2 -y
yum install zabbix-agent2-plugin-mongodb zabbix-agent2-plugin-mssql zabbix-agent2-plugin-postgresql -y
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2