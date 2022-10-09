#!/bin/bash
# WP scheduled backup script
# by draft04
#

# Verify that script run as root

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

(
start_time=`date +%s`

wp_dir=/var/www/html/escuelanueva/
backup_date=$(date +%d-%m-%y)
backups_dir=/mnt/backups/fenvg07/wp/escuelanueva-$backup_date/

mkdir -p $backups_dir

# Export database
echo "Exporting database, please wait... "

mysqldump -h 172.14.244.5 -u wpadmin --password=Jz.Ue2K3Rw -C fenwpdb > "$backups_dir"escuelanueva-database-$backup_date.sql

if [ $? -eq 0 ]
then
  echo " DONE"
else
  echo dum database, error aborting ...
  exit 1
fi

#echo Compress wp binary data
echo "Compress wp binary data, please wait... "
cd $wp_dir

set +e
tar --warning=no-file-changed -czf "$backups_dir"escuelanueva-$backup_date.tar.gz .
exitcode=$?
if [ $exitcode -eq 0 ] || [ $exitcode -eq 1 ]
then
  echo " DONE"
else
  echo compress wp binary data, error $exitcode aborting ...
  exit 1
fi

#backup apache configs
cp /etc/apache2/sites-enabled/escuelanueva.org.conf $backups_dir

chown $SUDO_USER:$SUDO_USER $backups_dir -R

#sync data with FEN local server
#eval $(ssh-agent)
#/home/$SUDO_USER/scripts/server/addkey
#echo "sending backup, please wait... "

#RC=1
#while [[ $RC -ne 0 ]]
#do
#   rsync -arzP --size-only /home/$SUDO_USER/backups/wp/ sysadmin@181.48.117.122:/home/sysadmin/backups/wp/
#   RC=$?
#done


#sendStatus=$?

#if [ $sendStatus -eq 0 ]
#then
#  echo " DONE"
#else
#  echo "send data error, aborting ..."
#  exit 1
#fi

fecha=$(date +%d-%m-%y-%R)
fileInfo1=$(du -sh "$backups_dir"escuelanueva-$backup_date.tar.gz)
fileInfo2=$(du -sh "$backups_dir"escuelanueva-database-$backup_date.sql)


#pkill -9 ssh-agent

echo "Enviando correo al administrador ..."
/usr/sbin/sendmail soporte@escuelanueva.org <<EOF
Subject: Backup WordPress $backup_date - FENVG07
La copia de respaldo del CMS de FEN ha sido realizada.
Servidor: $HOSTNAME
Fecha del backup: $fecha
Info de archivo (data): $fileInfo1
Info de archivo (database): $fileInfo2
URL del servicio Web: www.escuelanueva.org
Programa realizado por webmaster FEN
EOF

if [ $? -eq 0 ]
then
  echo " DONE"
else
  echo send mail error, aborting ...
  exit 1
fi

echo wp backup of the $backup_date was completed!!!
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
) 2>&1 | tee /home/$SUDO_USER/history/`basename "$0" | cut -f1 -d"."`-`date +%d-%m-%y`.log