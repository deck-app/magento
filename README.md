# Magento 2.x
#Quick start

The easiest way to start Magento 2 with MySQL is using Docker Compose. Just clone this repo and run following command in the root directory. The default docker-compose.yml uses MySQL and phpMyAdmin.

$ docker-compose up -d

For admin username and password, please refer to the file env. You can also change the file env to update those configurations. Below are the default configurations.

MYSQL_HOST=db

MYSQL_ROOT_PASSWORD=myrootpassword

MYSQL_USER=magento

MYSQL_PASSWORD=magento

MYSQL_DATABASE=magento

MAGENTO_LANGUAGE=en_GB

MAGENTO_TIMEZONE=Pacific/Auckland

MAGENTO_DEFAULT_CURRENCY=NZD

MAGENTO_URL=http://local.magento

MAGENTO_BACKEND_FRONTNAME=admin

MAGENTO_USE_SECURE=0

MAGENTO_BASE_URL_SECURE=0

MAGENTO_USE_SECURE_ADMIN=0

MAGENTO_ADMIN_FIRSTNAME=Admin

MAGENTO_ADMIN_LASTNAME=MyStore

MAGENTO_ADMIN_EMAIL=amdin@example.com

MAGENTO_ADMIN_USERNAME=admin

MAGENTO_ADMIN_PASSWORD=magentorocks1
