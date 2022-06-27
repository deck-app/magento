#!/bin/bash
set +x

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
        # git clone https://github.com/octobercms/install.git .
        echo >&2 "Magento not found in $(pwd) - Create apps please patience..."
        tar cf - --one-file-system -C /app/magento2-2.4.3/ . | tar xf -
        tar cf - --one-file-system -C /app/magento2-2.4.3/.htaccess . | tar xf -
        composer install && composer config repositories.magento composer https://repo.magento.com/
        # composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition:2.4.4 .
        find . -type d -exec chmod 770 {} \;
        find . -type f -exec chmod 660 {} \;
        chmod -Rf 777 var
        chmod -Rf 777 pub/static
        chmod -Rf 777 pub/media
        chmod 777 ./app/etc
        chmod 644 ./app/etc/*.xml
        chmod -Rf 775 bin
        chmod u+x bin/magento
        composer selfupdate
        # bin/magento module:disable {Magento_Elasticsearch,Magento_Elasticsearch6,Magento_Elasticsearch7}
        # bin/magento setup:install --base-url=http://localhost:53487 --backend-frontname=admin --language=en_US --timezone=America/Chicago --currency=USD --db-host=mariadb --db-name=test --db-user=root --db-password=password --use-secure=0 --base-url-secure=0 --use-secure-admin=0 --admin-firstname=Admin --admin-lastname=MyStore --admin-email=admin@admin.com --admin-user=admin --admin-password=P@ssw0rd@1992
        HOST=`hostname`
        NAME=`echo $HOST | sed 's:.*-::'`
        sed -i "s/{DB_HOSTNAME}/$NAME/g" /install.sh
        # HOST_NAME = echo "`hostname`" | sed 's:.*-::'
        # bin/magento setup:install \
        # --base-url=https://{DB_HOSTNAME}.stacks.run \
        # --backend-frontname=admin \
        # --db-host=mariadb-{DB_HOSTNAME} \
        # --db-name={DB_NAME} \
        # --db-user={DB_USER} \
        # --db-password={DB_PASSWORD} \
        # --admin-firstname=admin \
        # --admin-lastname=admin \
        # --admin-email=admin@admin.com \
        # --admin-user=admin \
        # --admin-password={ADMIN_PASSWD} \
        # --language=en_US \
        # --currency=USD \
        # --timezone=America/Chicago \
        # --use-rewrites=1 \
        # --elasticsearch-host=elasticsearch-{DB_HOSTNAME}
        # bin/magento cron:install --force
        # bin/magento indexer:reindex
         sh /install.sh
        cp /root/.composer/auth.json /var/www/var/composer_home/auth.json
        # bin/magento sampledata:deploy
        # bin/magento setup:upgrade
        # php artisan winter:env
        # cp -a /app/app.env /var/www/.env
        # HOST=`hostname`
        # NAME=`echo $HOST | sed 's:.*-::'`
        #HOST_NAME = echo "`hostname`" | sed 's:.*-::'
        # sed -i "s/{DB_HOSTNAME}/$NAME/g" /var/www/.env
        # php artisan winter:up
fi

if [[ {BACK_END} = nginx ]] ;
then
    cp /app/default.conf /etc/nginx/conf.d/default.conf
    nginx -s reload
    chown -R nobody:nobody /var/www 2> /dev/null
else
    cp /app/httpd.conf /etc/apache2/httpd.conf
    httpd -k graceful
    chown -R apache:apache /var/www 2> /dev/null
fi

rm -rf /var/preview

exec "$@"