#!/bin/bash
# GLPI scheduled backup script
# by draft04
#

# Verify that script run as root

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#
(
start_time=`date +%s`

glpi_dir=/var/www/soporte/
backup_date=$(date +%d-%m-%y)
backup_dir=/mnt/fenvg06/backups/glpi
backups_dir=/mnt/fenvg06/backups/glpi/glpi-$backup_date/

mkdir -p $backups_dir

chown $SUDO_USER:$SUDO_USER $backup_dir -R

# Export database
echo "Exporting database, please wait... "
mysqldump -h 172.14.244.5 -u fenvg_soporte --password=f12111977 -C fenvg_glpi > "$backups_dir"glpi-database-$backup_date.sql

if [ $? -eq 0 ]
then
  echo " DONE"
else
  echo dumb database error, aborting ...
  exit 1
fi

cd $glpi_dir
echo "Compress glpi binary data, please wait... "
tar -czf "$backups_dir"glpi-$backup_date.tar.gz .

if [ $? -eq 0 ]
then
  echo " DONE"
else
  echo glpi binary data compress error, aborting ...
  exit 1
fi

cp /etc/apache2/sites-enabled/soporte.escuelanueva.co.conf $backups_dir

chown $SUDO_USER:$SUDO_USER $backup_dir -R

# Magic
#eval $(ssh-agent)
#/home/$SUDO_USER/scripts/server/addkey
#echo "sending backup, please wait... "

#RC=1
#while [[ $RC -ne 0 ]]
#do
#   rsync -arzP --size-only /home/$SUDO_USER/backups/glpi/ sysadmin@181.48.117.122:/home/sysadmin/backups/glpi/
#   RC=$?
#done


#sendStatus=$?

#if [ $sendStatus -eq 0 ]
#then
#  echo " DONE"
#else
#  echo send data error, aborting ...
#  exit 1
#fi


fecha=$(date +%d-%m-%y-%R)
fileInfo1=$(du -sh "$backups_dir"glpi-$backup_date.tar.gz)
fileInfo2=$(du -sh "$backups_dir"glpi-database-$backup_date.sql)

echo "Enviando correo al administrador ..."
/usr/sbin/sendmail soporte@escuelanueva.org <<EOF
Subject: Backup glpi $backup_date - FENVG06
La copia de respaldo del Software de Inventarios de FEN ha sido realizada.
Datos del backup:
Servidor: $HOSTNAME
Fecha del backup: $fecha
Tamaño del archivo (data): $fileInfo1
Tamaño del archivo (database): $fileInfo2
URL del servicio Web: soporte.escuelanueva.co
Programa realizado por Sysadmin FEN
EOF

if [ $? -eq 0 ]
then
  echo " DONE"
else
  echo send mail error aborting ...
  exit 1
fi

#pkill -9 ssh-agent

chown $SUDO_USER:$SUDO_USER $backup_dir -R

echo glpi backup of the $backup_date was completed!!!
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
) 2>&1 | tee /home/$SUDO_USER/history/`basename "$0" | cut -f1 -d"."`-`date +%d-%m-%y`.log