
#!/bin/bash
# Moodle installation script
#by draft04

(


#Verify that arguments is provided
if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "ex. ./moodle_upgrade.sh -v moodle_version"
    exit 1
fi

#Save username arguments
while getopts v: option
do
case "${option}"
in
v) moodle_version=${OPTARG};;
esac
done

moodledata_dir=/var/www/moodledata
moodle_dir=/var/www/html/campus
backup_date=$(date +%d-%m-%y)
backups_dir=/home/$SUDO_USER/backups/moodle/campus-$backup_date/
#short="${moodle_version:0:4}"
#release=$(echo $short | tr -d \.)

echo "versión de moodle a actualizar" $moodle_version
#echo  "release" $release

while true; do
      read -p "Deseas continuar (s/n): " sn
    case $sn in
          [Ss]* ) break;;
          [Nn]* ) exit 1;;
          * ) echo "Please answer yes or no.";;
    esac
done



while true; do
      read -p "Do you make moodle backup (y/n): " yn
    case $yn in
          [Yy]* )
          bash moodle_backup.sh
          break;;
          [Nn]* ) break;;
          * ) echo "Please answer yes or no.";;
    esac
done

apt-get -y -qq update
apt-get -y -qq upgrade

apt-get -y -qq install php php-mysql libapache2-mod-php \
php-gd php-mbstring php-xml php-zip php-intl \
php-xmlrpc php-soap php-curl php-fileinfo php-json \
php-mysqli php-simplexml php-xml php-cli php-common \
php-imap php-ldap php-cas php-dev php-pear php-imagick \
php-bcmath php-opcache php-apcu php-apcu-bc

systemctl restart apache2
pecl channel-update pecl.php.net
pecl install apcu
#echo "extension=apcu.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
phpenmod pdo_mysql


service apache2 restart
upgrade_date=$(date +%d-%m-%y)
old_moodle_dir=/var/www/html/campus-$upgrade_date

backups_dir=/home/$SUDO_USER/backups/moodle
moodle_dir=/var/www/html/campus
moodledata_dir=/var/www/moodledata
#moodle_version=moodle-3.9.1

mv $moodle_dir $old_moodle_dir

cd /tmp
curl -O https://download.moodle.org/download.php/direct/stable$moodle_version/moodle-latest-$moodle_version.tgz
tar -xzf moodle-latest-$moodle_version.tgz

mkdir $moodle_dir

cp -a moodle/. $moodle_dir
cp $old_moodle_dir/config.php $moodle_dir

diff -q $moodle_dir $old_moodle_dir/

while true; do
      read -p "Deseas continuar (s/n): " sn
    case $sn in
          [Ss]* ) break;;
          [Nn]* ) exit 1;;
          * ) echo "Please answer yes or no.";;
    esac
done

cp -pr $old_moodle_dir/theme/bootstrapbase/. $moodle_dir/theme/bootstrapbase
cp -pr $old_moodle_dir/theme/clean/. $moodle_dir/theme/clean
cp -pr $old_moodle_dir/theme/klassroom/. $moodle_dir/theme/klassroom
cp -pr $old_moodle_dir/mod/certificate/. $moodle_dir/mod/certificate
cp -pr $old_moodle_dir/mod/openmeetings/. $moodle_dir/mod/openmeetings
cp -pr $old_moodle_dir/mod/simplecertificate/. $moodle_dir/mod/simplecertificate
cp -pr $old_moodle_dir/mod/questionnaire/. $moodle_dir/mod/questionnaire
cp -pr $old_moodle_dir/mod/game/. $moodle_dir/mod/game
cp -pr $old_moodle_dir/mod/customcert/. $moodle_dir/mod/customcert
cp -pr $old_moodle_dir/mod/certificate/. $moodle_dir/mod/certificate
cp -pr $old_moodle_dir/mod/hvp/. $moodle_dir/mod/hvp
cp -pr $old_moodle_dir/local/bulkenrol/. $moodle_dir/local/bulkenrol
cp -pr $old_moodle_dir/local/fullscreen/. $moodle_dir/local/fullscreen
cp -pr $old_moodle_dir/local/ganalytics/. $moodle_dir/local/ganalytics
cp -pr $old_moodle_dir/local/mailtest/. $moodle_dir/local/mailtest
cp -pr $old_moodle_dir/availability/condition/badge/. $moodle_dir/availability/condition/badge
cp -pr $old_moodle_dir/availability/condition/coursecompleted/. $moodle_dir/availability/condition/coursecompleted
cp -pr $old_moodle_dir/report/completionoverview/. $moodle_dir/report/completionoverview
cp -pr $old_moodle_dir/report/benchmark/. $moodle_dir/report/benchmark
cp -pr $old_moodle_dir/blocks/configurable_reports/. $moodle_dir/blocks/configurable_reports
cp -pr $old_moodle_dir/blocks/course_contents/. $moodle_dir/blocks/course_contents
cp -pr $old_moodle_dir/admin/tool/downloaddata/. $moodle_dir/admin/tool/downloaddata
cp -pr $old_moodle_dir/course/format/flexsections/. $moodle_dir/course/format/flexsections
cp -pr $old_moodle_dir/course/format/grid/. $moodle_dir/course/format/grid
cp -pr $old_moodle_dir/course/format/onetopic/. $moodle_dir/course/format/onetopic
cp -pr $old_moodle_dir/course/format/tiles/. $moodle_dir/course/format/tiles
cp -pr $old_moodle_dir/course/format/topcoll/. $moodle_dir/course/format/topcoll
cp -pr $old_moodle_dir/theme/klassroom/pix/welcomebg.png $moodle_dir/theme/klassroom/pix/
cp -pr $old_moodle_dir/theme/klassroom/pix/campus_arrow_down.png $moodle_dir/theme/klassroom/pix/
cp -pr $old_moodle_dir/theme/klassroom/pix/footer-bg.jpg $moodle_dir/theme/klassroom/pix/
cp -pr $old_moodle_dir/theme/klassroom/pix/Renueva_BID.png $moodle_dir/theme/klassroom/pix/
cp -pr $old_moodle_dir/theme/klassroom/pix/Renueva_Bmanga.png $moodle_dir/theme/klassroom/pix/
cp -pr $old_moodle_dir/theme/klassroom/pix/Renueva_Ecopetrol.png $moodle_dir/theme/klassroom/pix/


chmod 777 $moodledata_dir -R
chown -R root $moodle_dir
chmod -R 0755 $moodle_dir
find $moodle_dir -type f -exec chmod 0644 {} \;

sudo -u www-data /usr/bin/php $moodle_dir/admin/cli/upgrade.php
#1. sudo -u www-data /usr/bin/php $moodle_dir/campus/admin/cli/mysql_engine.php --engine=InnoDB

service mysql restart
) 2>&1 | tee /home/$SUDO_USER/history/`basename "$0" | cut -f1 -d"."`-`date +%d-%m-%y`.log
# Some commands to changes DB
#php $moodle_dir/campus/admin/cli/mysql_compressed_rows.php --list
#php $moodle_dir/campus/admin/cli/mysql_compressed_rows.php --showsql
#sudo php $moodle_dir/campus/admin/cli/mysql_compressed_rows.php --fix
#php $moodle_dir/campus/admin/cli/mysql_collation.php --collation=utf8mb4_unicode_ci
# sudo chmod -R 0777 $moodle_dir/campus/mod
# sudo chmod -R 0777 $moodle_dir/campus/course/format
# sudo chmod -R 0777 $moodle_dir/campus/theme
# to restore access
#sudo chmod -R 0755 $moodle_dir