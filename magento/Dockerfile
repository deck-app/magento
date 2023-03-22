FROM ghcr.io/deck-app/nginx:v8.1
LABEL maintainer Naba Das <hello@get-deck.com>

RUN mkdir -p /app
RUN mkdir -p /var/preview
COPY default.back.conf /etc/nginx/conf.d/default.conf
COPY default.conf /app/default.conf

COPY app.env /app/app.env
ARG SERVER_ROOT
ENV MAGENTO_VERSION 2.4.6

COPY auth.json /root/.composer/auth.json
# Persistent runtime dependencies
# Example RUN apk add --no-cache php81-openssl php81-sysvmsg php81-curl

WORKDIR /var/www

COPY php.ini /etc/php81/php.ini
ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; then \
sed -i "s#{DISPLAY}#On#g" /etc/php81/php.ini \
;else \
sed -i "s#{DISPLAY}#Off#g" /etc/php81/php.ini \
;fi

#Xdebug enable or disable
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; then \
apk add php81-pecl-xdebug \
&& echo "zend_extension=xdebug" >> /etc/php81/php.ini \
;fi

RUN apk add php81-zip php81-pdo_mysql php81-soap php81-xsl php81-sodium tar php81-gd
RUN apk add zip
ARG ADMIN_PASSWD
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i "s#{ADMIN_PASSWD}#${ADMIN_PASSWD}#g" /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

## Linux permission issue
ARG USER_ID
ARG GROUP_ID
RUN apk --no-cache add shadow
RUN if [[ nginx = nginx ]] ; then usermod -u ${USER_ID} nobody && groupmod -g ${GROUP_ID} nobody ; else usermod -u ${USER_ID} apache && groupmod -g ${GROUP_ID} apache ; fi
RUN cd /app && \ 
  curl https://codeload.github.com/magento/magento2/tar.gz/${MAGENTO_VERSION} -o ${MAGENTO_VERSION}.tar.gz && \
  tar xvf ${MAGENTO_VERSION}.tar.gz 
COPY index.php /app/magento2-${MAGENTO_VERSION}/index.php
COPY env.php /app/env.php
COPY install.sh /install.sh
RUN chmod +x /install.sh
# RUN composer install && composer config repositories.magento composer https://repo.magento.com/
# RUN find . -type f -exec chmod 644 {} \; && \
#         find . -type d -exec chmod 755 {} \; && \
#         chmod -Rf 777 var && \
#         chmod -Rf 777 pub/static && \
#         chmod -Rf 777 pub/media && \
#         chmod 777 ./app/etc && \
#         chmod 644 ./app/etc/*.xml && \
#         chmod -Rf 775 bin && \
#         chmod u+x bin/magento && \
#         composer selfupdate
COPY nginx.conf.sample /etc/nginx/nginx.conf.sample
## Database credentials
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD
ARG ADMIN_PASSWD
RUN sed -i "s#{DB_NAME}#${DB_NAME}#g" /docker-entrypoint.sh
RUN sed -i "s#{DB_USER}#${DB_USER}#g" /docker-entrypoint.sh
RUN sed -i "s#{DB_PASSWORD}#${DB_PASSWORD}#g" /docker-entrypoint.sh
RUN sed -i "s#{ADMIN_PASSWD}#${ADMIN_PASSWD}#g" /docker-entrypoint.sh
RUN sed -i "s#{MAGENTO_VERSION}#${MAGENTO_VERSION}#g" /docker-entrypoint.sh
RUN sed -i "s#{DB_NAME}#${DB_NAME}#g" /install.sh
RUN sed -i "s#{DB_USER}#${DB_USER}#g" /install.sh
RUN sed -i "s#{DB_PASSWORD}#${DB_PASSWORD}#g" /install.sh
RUN sed -i "s#{ADMIN_PASSWD}#${ADMIN_PASSWD}#g" /install.sh
RUN sed -i "s#{MAGENTO_VERSION}#${MAGENTO_VERSION}#g" /install.sh

RUN sed -i "s#{DB_NAME}#${DB_NAME}#g" /app/env.php
RUN sed -i "s#{DB_USER}#${DB_USER}#g" /app/env.php
RUN sed -i "s#{DB_PASSWORD}#${DB_PASSWORD}#g" /app/env.php

RUN sed -i "s#{USER_ID}#${USER_ID}#g" /docker-entrypoint.sh
RUN sed -i "s#{GROUP_ID}#${GROUP_ID}#g" /docker-entrypoint.sh

CMD /docker-entrypoint.sh & /sbin/runit-wrapper
# CMD /sbin/runit-wrapper