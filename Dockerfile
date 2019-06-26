FROM centos:7

RUN yum install -y epel-release && yum install -y https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm && \
    INSTALL_PKGS="php72u php72u-cli php72u-mysqlnd php72u-pgsql php72u-bcmath \
                  php72u-gd php72u-intl php72u-ldap php72u-mbstring php72u-pdo \
                  php72u-process php72u-soap php72u-opcache php72u-xml \
                  php72u-gmp php72u-pecl-apcu php72u-pecl-memcached \
                  php72u-xml php72u-mbstring \
                  php72u-gd php72u-zip php72u-mcrypt \
                  wget curl git unzip" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
    yum update -y --nogpgcheck && \
    yum clean all -y

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /etc/php.d/opcache-recommended.ini

RUN { \
		echo 'expose_php=Off'; \
		echo 'memory_limit=250M'; \
	} > /etc/php.d/php_defaults.ini


COPY apache.conf /etc/httpd/conf.d/default_vhost.conf

WORKDIR /var/www/html

# Put something in the /var/www/html docroot so the container won't go into a restart loop on provision 
COPY index.php /var/www/html/index.php

# Installing dokuwiki
#
# The version of Dokuwiki to install: (see https://github.com/splitbrain/dokuwiki/releases )
ENV DOKUWIKI_INSTALL="release_stable_2018-04-22b.tar.gz"
RUN wget -q --continue https://github.com/splitbrain/dokuwiki/archive/${DOKUWIKI_INSTALL} && \
  mkdir /var/www/dokuwiki && \
  tar xzf ${DOKUWIKI_INSTALL} --directory /var/www/dokuwiki --strip 1 && \
  rm ${DOKUWIKI_INSTALL} && \
  chown -R apache:apache /var/www/dokuwiki/data && \
  chown -R apache:apache /var/www/dokuwiki/conf

RUN ln -sfT /dev/stdout /var/log/httpd/access_log
COPY start.sh /tmp/start.sh

EXPOSE 80

ENTRYPOINT [ "/tmp/start.sh" ]
