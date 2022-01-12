FROM wordpress:5.8

RUN apt-get update && apt-get install -y unzip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

ENV WP_PLUGIN_GRAPHQL_VERSION 1.6.11
ENV WP_PLUGIN_GRAPHQL_ACF_VERSION v0.5.3
ENV WP_PLUGIN_ACF_VERSION 5.11.4
ENV WP_PLUGIN_SMTP_VERSION 3.2.1
ENV WP_PLUGIN_AUTH0_VERSION 4.3.1
ENV WP_PLUGIN_OFFLOAD_VERSION 2.5.5

ADD https://github.com/AdvancedCustomFields/acf/archive/${WP_PLUGIN_ACF_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://github.com/wp-graphql/wp-graphql/archive/v${WP_PLUGIN_GRAPHQL_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://github.com/wp-graphql/wp-graphql-acf/archive/${WP_PLUGIN_GRAPHQL_ACF_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://downloads.wordpress.org/plugin/auth0.${WP_PLUGIN_AUTH0_VERSION}.zip /usr/src/wordpress/wp-content/plugins/
ADD https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.${WP_PLUGIN_OFFLOAD_VERSION}.zip /usr/src/wordpress/wp-content/plugins/
ADD https://downloads.wordpress.org/plugin/wp-mail-smtp.${WP_PLUGIN_SMTP_VERSION}.zip /usr/src/wordpress/wp-content/plugins/

RUN cd /usr/src/wordpress/wp-content/plugins \
  && for a in `ls -1 *.tar.gz`; do tar xzf $a; done \
  && cd /usr/src/wordpress/wp-content/plugins \
  && for a in `ls -1 *.zip`; do unzip $a; done

RUN cd /usr/src/wordpress/wp-content/plugins/wp-graphql-${WP_PLUGIN_GRAPHQL_VERSION} \
  && composer install --no-dev

FROM wordpress:5.8
RUN apt-get update && apt-get install -y cron
COPY --from=0 /usr/src/wordpress /usr/src/wordpress
COPY themes/noop /usr/src/wordpress/wp-content/themes/noop
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini
