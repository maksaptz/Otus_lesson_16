#!/bin/bash

###Обновляем и устанавливаем необходимые пакеты
apt update
apt install nginx audispd-plugins -y
###Добавляем запись в DNS
echo "192.168.50.10 auditd" >> /etc/hosts
###Добавляем запись auditd которая отслеживает изменения в конфигах nginx 
echo "-w /etc/nginx/nginx.conf -p wa -k nginx_conf
-w /etc/nginx/conf.d/ -p wa -k nginx_conf" >> /etc/audit/rules.d/audit.rules
###Включаем удаленное отслеживание
sed -i 's/active = no/active = yes/' /etc/audisp/plugins.d/au-remote.conf
###Добавляем адрес сервера
sed -i 's/remote_server = /remote_server = 192.168.50.10/' /etc/audisp/audisp-remote.conf
###Перезагружаем службу
systemctl restart auditd.service
###Добавляем сервер syslog
echo "*.* @@192.168.50.10:514" > /etc/rsyslog.d/all.conf
###Перезагружаем службу
systemctl restart rsyslog
###Изменяем конфиг nginx чтобы он отправлял логи на rsys сервер все логи
sed -i -e '/access.log/aaccess_log syslog:server=192.168.50.10:514,tag=nginx,severity=info;' /etc/nginx/nginx.conf
sed -i -e '/error.log/aerror_log syslog:server=192.168.50.10:514,tag=nginx_err info;' /etc/nginx/nginx.conf
sed -i 's|access_log /var/log/nginx/access.log|access_log /var/log/nginx/access.log,severity=critical|' /etc/nginx/nginx.conf
sed -i 's|error_log /var/log/nginx/error.log|error_log /var/log/nginx/error.log crit|' /etc/nginx/nginx.conf
###Перезагружаем nginx
systemctl restart nginx.service
###Выведем страницу чтобы лог стартанул
curl 127.0.0.1
