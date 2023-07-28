FROM drupal:latest

RUN apt-get update && \
    apt-get install -y git curl poppler-utils && \
    rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli

# Updating the max filesize in php.ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/g' /usr/local/etc/php/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 128M/g' /usr/local/etc/php/php.ini

# Copy Application code
COPY . /var/www/html/

# Run Composer (Install Drupal Dependencies)
RUN cd /var/www/html; composer install

# Allow Drupal to create the 'files' directory.
RUN mkdir -p /var/www/html/web/sites/default/files
RUN chown -R www-data:www-data /var/www/html/web/sites/default/files
RUN chmod 777 /var/www/html/web/sites/default/files

# Apache conf
# allow .htaccess with RewriteEngine
RUN a2enmod rewrite
# without the following line we get "AH00558: apache2: Could not reliably determine the server's fully qualified domain name"
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# autorise .htaccess files
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
# for production :
# RUN echo "ServerTokens Prod\n" >> /etc/apache2/apache2.conf
# RUN echo "ServerSignature Off\n" >> /etc/apache2/apache2.conf

WORKDIR /var/www/html/web

CMD ["/bin/sh", "-c", "/usr/sbin/apachectl -D FOREGROUND"]

ENV APACHE_DOCUMENT_ROOT=/var/www/html/web
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
EXPOSE 80 443

