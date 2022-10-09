#!/bin/bash
# Let´s encrypt backup script
#by draft04
#

# bash ssl_backup.sh -d campus.escuelanueva.co

# Verify that script run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ $# -le 1 ]; then
    echo "No arguments provided"
    echo "Ex. -d DOMAIN"
    echo "List available domains"
    ls /etc/letsencrypt/archive/
    echo "List available renewal domains"
    ls /etc/letsencrypt/renewal/
    exit 1
fi

#Save username arguments
while getopts d: option
do
case "${option}"
in
d) domain=${OPTARG};;
esac
done


ssl_backups_dir=/home/$SUDO_USER/backups/ssl/$domain
mkdir -p $ssl_backups_dir

cd $ssl_backups_dir
rm certs.tar.gz
tar -chvzf certs.tar.gz /etc/letsencrypt/archive/$domain /etc/letsencrypt/renewal/$domain.conf
cp /etc/apache2/sites-available/$domain.conf $ssl_backups_dir
cp /etc/apache2/sites-available/$domain-le-ssl.conf $ssl_backups_dir
chown -R $SUDO_USER:$SUDO_USER $ssl_backups_dir
ls $ssl_backups_dir


