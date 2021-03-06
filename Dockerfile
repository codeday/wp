FROM wordpress:5.4

RUN apt-get update && apt-get install -y unzip cron

ENV WP_PLUGIN_GRAPHQL_VERSION v0.8.4
ENV WP_PLUGIN_GRAPHQL_ACF_VERSION v0.3.3
ENV WP_PLUGIN_ACF_VERSION 5.8.9
ENV WP_PLUGIN_SMTP_VERSION 2.0.0
ENV WP_PLUGIN_AUTH0_VERSION 4.0.0
ENV WP_PLUGIN_OFFLOAD_VERSION 2.3.2

ADD https://github.com/AdvancedCustomFields/acf/archive/${WP_PLUGIN_ACF_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://github.com/wp-graphql/wp-graphql/archive/${WP_PLUGIN_GRAPHQL_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://github.com/wp-graphql/wp-graphql-acf/archive/${WP_PLUGIN_GRAPHQL_ACF_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://github.com/awesomemotive/WP-Mail-SMTP/archive/${WP_PLUGIN_SMTP_VERSION}.tar.gz /usr/src/wordpress/wp-content/plugins/
ADD https://downloads.wordpress.org/plugin/auth0.${WP_PLUGIN_AUTH0_VERSION}.zip /usr/src/wordpress/wp-content/plugins/
ADD https://downloads.wordpress.org/plugin/amazon-s3-and-cloudfront.${WP_PLUGIN_OFFLOAD_VERSION}.zip /usr/src/wordpress/wp-content/plugins/

RUN cd /usr/src/wordpress/wp-content/plugins \
  && for a in `ls -1 *.tar.gz`; do tar xzf $a; done \
  && cd /usr/src/wordpress/wp-content/plugins \
  && for a in `ls -1 *.zip`; do unzip $a; done

COPY themes/noop /usr/src/wordpress/wp-content/themes/noop

COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini
