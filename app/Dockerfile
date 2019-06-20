FROM centos:7

ENV PATH=$PATH:/opt/rh/php71u/root/usr/bin

RUN yum install -y epel-release && yum install -y https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm && \
    INSTALL_PKGS="php71u php71u-cli php71u-mysqlnd php71u-pgsql php71u-bcmath \
                  php71u-gd php71u-intl php71u-ldap php71u-mbstring php71u-pdo \
                  php71u-process php71u-soap php71u-opcache php71u-xml \
                  php71u-gmp php71u-pecl-apcu php71u-pecl-memcached \
                  php71u-xml php71u-mbstring \
                  php71u-gd php71u-zip php71u-mcrypt \
                  wget curl git unzip" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS --nogpgcheck && \
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

# Installing dokuwiki
#
# The version of Dokuwiki to install: (see https://github.com/splitbrain/dokuwiki/releases )
ENV DOKUWIKI_INSTALL="release_stable_2018-04-22b.tar.gz"
RUN wget --continue https://github.com/splitbrain/dokuwiki/archive/${DOKUWIKI_INSTALL} && \
  tar xzf ${DOKUWIKI_INSTALL} --directory /var/www/html --strip 1 && \
  rm ${DOKUWIKI_INSTALL} && \
  chown -R apache:apache /var/www/html/data && \
  chown -R apache:apache /var/www/html/conf

RUN ln -sfT /dev/stdout /var/log/httpd/access_log
COPY start.sh /tmp/start.sh

EXPOSE 80

ENTRYPOINT [ "/tmp/start.sh" ]
