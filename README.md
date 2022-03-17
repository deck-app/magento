# Magento
## Introduction
Magento is an open-source e-commerce platform written in PHP. It uses multiple other PHP frameworks such as Laminas and Symfony. Magento source code is distributed under Open Software License v3.0. Magento was acquired by Adobe Inc in May 2018 for $1.68 billion

## Install

### Using DECK

Install Magento from the DECK marketplace and follow the instructions on the GUI

### From terminal with Docker

```
git clone https://github.com/deck-app/magento/
cd magento
```

Edit `.env` file to change any settings before installing like backend etc

```
docker-compose up -d
```
### Modifying project settings
From the DECK app, go to stack list and click on project's `More > configure > Advanced configuration`
Follow the instructions below and restart your stack from the GUI

#### Edit Apache configuration

httpd.conf is located at `./httpd.conf`
#### Edit Nginx configuration

default.conf is located at `./default.conf`

#### Editing php.in

PHP ini file is located at `./php.ini`

#### Installing / removing PHP extensions

Add / remove PHP extensions from `./Dockerfile`

```
RUN apk add --update --no-cache bash \
				curl \
				curl-dev \
				php7-intl \
				php7-openssl \
				php7-dba \
				php7-sqlite3 \
```

#### Rebuilding from terminal

You have to rebuild the docker image after you make any changes to the project configuration, use the snippet below to rebuild and restart the stack

```
docker-compose stop && docker-compose up --build -d
```
