#!/bin/bash
set +x
if [ ! -e index.php ] && [ ! -e composer.json ]; then
                echo >&2 "Magento2 not found in $PWD - copying now..."
                tar cf - --one-file-system -C /app/magento/magento . | tar xf - 
                composer install
                echo >&2 "Complete! Magento2 has been successfully copied to $PWD"
fi
if [[ ${BACK_END} = nginx ]] ;
then
    cp /app/default.conf /etc/nginx/conf.d/default.conf
else
    cp /app/httpd.conf /etc/apache2/httpd.conf
fi

rm -rf /var/preview
# if [[ {USER_ID} -gt 0 ]] ;
# then
#     chown -R {USER_ID}:{GROUP_ID} /var/www
# else
#     chown -R nobody:nobody /var/www
# fi
if [[ ${BACK_END} = nginx ]]  ; 
then
    nginx -s reload
else
    httpd -k graceful
fi

exec "$@"