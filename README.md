# Magento 2.x

Magento is an open-source e-commerce platform written in PHP. It uses multiple other PHP frameworks such as Laminas and Symfony. Magento source code is distributed under Open Software License v3.0.


## Quick start

The easiest way to start Magento 2 with Mariadb is using Docker Compose. Just clone this repo and run following command in the root directory. The default docker-compose.yml uses Mariadb and phpMyAdmin.

### Install

### Using DECK

Install Magento from the DECK marketplace and follow the instructions on the GUI

### From terminal with Docker

```
git clone https://github.com/deck-app/magento.git
cd magento
```
Edit .env file to change any setting before installing like magento, mariadb, php etc
```
docker-compose up -d
```

### Modifying project settings

From the DECK app, go to stack list and click on project's `More > configure > Advanced configuration` Follow the instructions below and restart your stack from the GUI

##### Edit Apache configuration
httpd.conf is located at `./magento/httpd.conf `

##### Editing php.in
PHP ini file is located at `./magento/php_ini/php.ini`


##### Rebuilding from terminal

You have to rebuild the docker image after you make any changes to the project configuration, use the snippet below to rebuild and restart the stack

```
docker-compose stop && docker-compose up --build -d
```

