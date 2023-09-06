#!/bin/bash

###Обновляем и устанавливаем необходимые пакеты
apt update
apt install audispd-plugins -y
###Добавляем запись DNS
echo "192.168.50.11 nginx" >> /etc/hosts
###Настраиваем порт auditd
sed -i 's/##tcp_listen_port = 60/tcp_listen_port = 60/' /etc/audit/auditd.conf
###Перезагружаем службу
systemctl restart auditd.service
###Настраеваем порт rsys
sed -i 's/#module(load="imudp")/module(load="imudp")/' /etc/rsyslog.conf
sed -i 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/' /etc/rsyslog.conf
sed -i 's/#module(load="imtcp")/module(load="imtcp")/' /etc/rsyslog.conf
sed -i 's/#input(type="imtcp" port="514")/input(type="imtcp" port="514")/' /etc/rsyslog.conf
###Добавляем список разрешенных IP
$AllowedSender UDP, 192.168.50.11/24, [::1]/128
$AllowedSender TCP, 192.168.50.11/24, [::1]/128
###Настраиваем шаблон
$template RemInputLogs, "/var/spool/rsyslog/%FROMHOST-IP%/%PROGRAMNAME%.log"
*.* ?RemInputLogs' >> /etc/rsyslog.conf
###Перезагружаем службу
systemctl restart rsyslog
