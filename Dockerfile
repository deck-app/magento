ARG BACK_END
FROM deckapp/${BACK_END}:v7.3
LABEL maintainer Naba Das <hello@get-deck.com>

ARG LARAVEL_VERSION
RUN mkdir -p /app
RUN mkdir -p /var/preview
RUN mkdir -p /app/magento
COPY default.conf /app/default.conf
COPY httpd.conf /app/httpd.conf
RUN sed -i "s#{SERVER_ROOT}#/var/preview#g" /app/default.conf;
RUN sed -i "s#{SERVER_ROOT}#/var/preview#g" /app/httpd.conf;
RUN if [ "$BACK_END" = "nginx" ]; then cp /app/default.conf /etc/nginx/conf.d/default.conf; else cp /app/httpd.conf /etc/apache2/httpd.conf; fi
COPY default.conf /app/default.conf
COPY httpd.conf /app/httpd.conf
RUN sed -i "s#{SERVER_ROOT}#/var/www#g" /app/default.conf;
RUN sed -i "s#{SERVER_ROOT}#/var/www#g" /app/httpd.conf;
RUN wget -O /var/preview/index.html https://raw.githubusercontent.com/deck-app/stack-preview-screen/main/install/index.html
WORKDIR /var/www
RUN apk add --no-cache php7-soap php7-xsl php7-sodium
COPY php.ini /etc/php7/php.ini
ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; then \
sed -i "s#{DISPLAY}#On#g" /etc/php7/php.ini \
;else \
sed -i "s#{DISPLAY}#Off#g" /etc/php7/php.ini \
;fi

#Xdebug enable or disable
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; then \
apk add php7-pecl-xdebug \
&& echo "zend_extension=xdebug" >> /etc/php7/php.ini \
;fi

ARG INSTALL_ADDITIONAL_EXTENSIONS
RUN if [ -z "$INSTALL_ADDITIONAL_EXTENSIONS" ] ; then \
echo "No additional PHP extensions added" \
;else \
apk add --no-cache ${INSTALL_ADDITIONAL_EXTENSIONS} \
;fi

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# User ID defined
# ARG USER_ID
# ARG GROUP_ID
# RUN if [ ${USER_ID} -gt 0 ]; then \
# 	apk --no-cache add shadow && \
#     	usermod -u ${USER_ID} -g ${GROUP_ID} nobody \
# ;fi
# RUN sed -i "s#{USER_ID}#${USER_ID}#g" /docker-entrypoint.sh
# RUN sed -i "s#{GROUP_ID}#${GROUP_ID}#g" /docker-entrypoint.sh

RUN mkdir -p /root/.composer
ARG MAGENTO_VERSION=2.3.6
RUN cd /app/magento && \ 
  curl https://codeload.github.com/magento/magento2/tar.gz/$MAGENTO_VERSION -o $MAGENTO_VERSION.tar.gz && \
  tar xvf $MAGENTO_VERSION.tar.gz && \
  mv /app/magento/magento2-$MAGENTO_VERSION /app/magento/magento 
RUN apk add php7-zip zip tar php7-gd php7-intl php7-pdo_mysql
RUN composer self-update 1.10.12
RUN sed -i "s#{BACK_END}#${BACK_END}#g" /docker-entrypoint.sh

CMD /docker-entrypoint.sh & /sbin/runit-wrapper