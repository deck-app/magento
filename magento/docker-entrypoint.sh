#!/bin/bash
set +x
rm -rf /var/www/*
if [[ -f "/var/www/composer.json" ]] ;
then
    cd /var/www/
    if [[ -d "/var/www/vendor" ]] ;
    then
        echo "Steps to use Composer optimise autoloader"
        composer update
    else
        echo "If composer vendor folder is not installed follow the below steps"
        composer install
    fi

fi
if [[ "$(ls -A "/var/www/")" ]] ;
    then
        echo "If the Directory is not empty, please delete the hidden files and directory"
    else
         echo >&2 "Magento not found in $(pwd) - Create apps please patience..."
        tar cf - --one-file-system -C /app/magento2-{MAGENTO_VERSION}/ . | tar xf -
        tar cf - --one-file-system -C /app/magento2-{MAGENTO_VERSION}/.htaccess . | tar xf -
        composer install && composer config repositories.magento composer https://repo.magento.com/
        find . -type f -exec chmod 644 {} \;
        find . -type d -exec chmod 755 {} \;
        chmod -Rf 777 var
        chmod -Rf 777 pub/static
        chmod -Rf 777 pub/media
        chmod 777 ./app/etc
        chmod 644 ./app/etc/*.xml
        chmod -Rf 775 bin
        chmod u+x bin/magento
        composer selfupdate
        HOST=`hostname`
        NAME=`echo $HOST | cut -c9-`
        sed -i "s/{DB_HOSTNAME}/$NAME/g" /install.sh
        sed -i "s/{DB_HOSTNAME}/$NAME/g" /app/env.php
        sh /install.sh
        cp /root/.composer/auth.json /var/www/var/composer_home/auth.json
fi
composer update
cp /app/default.conf /etc/nginx/conf.d/default.conf
nginx -s reload
chown -R nobody:nobody /var/www 2> /dev/null


rm -rf /var/preview
cp /app/env.php /var/www/app/etc/env.php
echo "Application installed successfully"
exec "$@"