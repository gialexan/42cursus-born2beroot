#!/bin/bash

ARCH=$(uname -a)
CPU=$(lscpu | grep 'CPU(s)' -m1 | awk '{print $2}')
CPU_CORE=$(lscpu | grep Core -m1| awk '{print $NF}')
CPU_THREAD=$(lscpu | grep Thread -m1| awk '{print $NF}')
vCPU=$((CPU_THREAD * CPU_CORE * CPU))
MEM_USE=$(free -m | grep Mem | awk '{printf("%s/%s MB (%.1f%%)", $3, $2, ($3/($2 - 1)) * 100)'})
DISK_USE=$(df -BG --total | grep total | awk '{printf ("%sGB/%sGB (%s)", $3-G, $2-G, $5)}')
CPU_LOAD=$(top -bn 1 | grep '%Cpu(s)' | awk '{printf("%s%%"), $2}')
LAST_BOOT=$(who -b | awk '{printf("%s %s"), $3, $4}')
LVM_USE=$(lsblk | grep lvm)
TCP_CONN=$(ss -t | grep -c ESTAB)
USER_LOG=$(who | wc -l)
NET_WORK_IP=$(ip a | grep enp0s3 | awk '/inet/{print $2}' | cut -d '/' -f1)
NET_WORK_MAC=$(ip a | grep 'ether/ether' | awk '{print $2}')
SUDO=$(grep -c sudo /var/log/auth.log)

echo "# Architecture: $ARCH"
echo "# CPU physical: $CPU"
echo "# vCPU: $vCPU"
echo "# Memory usage: $MEM_USE"
echo "# Disk usage: $DISK_USE"
echo "# CPU load: $CPU_LOAD"
echo "# Last boot: $LAST_BOOT"
if [ ! -z "$LVM_USE" ]
then
	echo "# LVM use: yes"
else
	echo "# LVM use: no"
fi
echo "# Connections TCP: $TCP_CONN ESTABLISHED"
echo "# User log: $USER_LOG"
echo "# Network: $NET_WORK_IP ($NET_WORK_MAC)"
echo "# Sudo: $SUDO"