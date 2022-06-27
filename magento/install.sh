#!/bin/sh
cd /var/www
bin/magento setup:install \
        --base-url=https://{DB_HOSTNAME}.stacks.run \
        --backend-frontname=admin \
        --db-host=mariadb-{DB_HOSTNAME} \
        --db-name={DB_NAME} \
        --db-user={DB_USER} \
        --db-password={DB_PASSWORD} \
        --admin-firstname=admin \
        --admin-lastname=admin \
        --admin-email=admin@admin.com \
        --admin-user=admin \
        --admin-password={ADMIN_PASSWD} \
        --language=en_US \
        --currency=USD \
        --timezone=America/Chicago \
        --use-rewrites=1 \
        --elasticsearch-host=elasticsearch-{DB_HOSTNAME}
        bin/magento cron:install --force
        bin/magento indexer:reindex
bin/magento deploy:mode:set developer
exec "$@"