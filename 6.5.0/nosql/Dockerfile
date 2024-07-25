# DO NOT EDIT: created by update_maintainer_version from Dockerfile-debian-nosql.template 
FROM debian:bookworm as basesystem
LABEL maintainer="lachlan-00"

ENV DEBIAN_FRONTEND=noninteractive
ENV DISABLE_INOTIFYWAIT_CLEAN 0
ARG VERSION=

# Add Debian package sources for main and security repositories
RUN   sh -c 'echo "Types: deb\n# http://snapshot.debian.org/archive/debian/20230612T000000Z\nURIs: http://deb.debian.org/debian\nSuites: stable stable-updates\nComponents: main contrib non-free\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg\n\nTypes: deb\n# http://snapshot.debian.org/archive/debian-security/20230612T000000Z\nURIs: http://deb.debian.org/debian-security\nSuites: stable-security\nComponents: main\nSigned-By: /usr/share/keyrings/debian-archive-keyring.gpg\n" > /etc/apt/sources.list.d/debian.sources' &&\
      apt-get -q -q update &&\
      apt-get -q -q -y install --no-install-recommends \
            wget \
            lsb-release \
            ca-certificates \
            curl \
            software-properties-common \ 
            libdvd-pkg &&\
      curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg &&\
      sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php2.list' &&\
      apt-get update &&\
      apt-get -q -q -y install --no-install-recommends \
              apache2 \
              beets \
              cron \
              ffmpeg \
              flac \
              gosu \
              inotify-tools \
              lame \
              libavcodec-extra \
              libev-libevent-dev \
              libfaac-dev \
              libmp3lame-dev \
              libtheora-dev \
              libvorbis-dev \
              libvpx-dev \
              locales \
              logrotate \
              php8.3 \
              php8.3-curl \
              php8.3-gd \
              php8.3-intl \
              php8.3-ldap \
              php8.3-mysql \
              php8.3-xml \
              php8.3-zip \
              pwgen \
              supervisor \
              vorbis-tools \
              zip \
              unzip &&\
            rm -rf /var/lib/apt/lists/*

# Configure locale and clean up
RUN   sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen &&\
      locale-gen &&\
      apt-get -q -q purge \
            libdvd-pkg \
            lsb-release \
            software-properties-common \
            wget &&\
      apt-get -q -q autoremove &&\
      rm -rf /var/lib/apt/lists/*

## Base system ready

FROM basesystem

#Configure Cron
RUN   echo '30 * * * *   /usr/local/bin/ampache_cron.sh' | crontab -u www-data - 

#Configure Apache
COPY data/sites-enabled/001-ampache.conf /etc/apache2/sites-available/
RUN   a2enmod rewrite &&\
      a2dissite  000-default &&\
      a2ensite  001-ampache

# Prepare Ampache Context
RUN   mkdir -p /var/log/ampache &&\
      chown -R www-data:www-data /var/log/ampache 
      

# Download and extract Ampache source code
RUN   rm -rf /var/www/* &&\
      curl -sSLo /tmp/master.zip https://github.com/ampache/ampache/releases/download/6.5.0/ampache-6.5.0_all_php8.3.zip &&\
      unzip /tmp/master.zip -d /var/www/ &&\
      cp -f /var/www/public/rest/.htaccess.dist /var/www/public/rest/.htaccess &&\
      cp -f /var/www/public/play/.htaccess.dist /var/www/public/play/.htaccess &&\
      cp -f /var/www/config/ampache.cfg.php.dist /var/tmp/ &&\
      find /var/www -type d -name ".git*" -print0 | xargs -0 rm -rf {} &&\
      rm -rf /var/www/.php*cs* \
            /var/www/.sc \
            /var/www/.scrutinizer.yml \
            /var/www/.tgitconfig \
            /var/www/.travis.yml \
            /var/www/*.md \
            /var/cache/* \
            /tmp/* \
            /var/tmp/master.zip \
            /root/.cache \
            /var/www/docs \
            /var/www/.tx &&\
      chown -R www-data:www-data /var/www &&\
      chmod -R 775 /var/www 

# Configure Ampache Context
COPY data/bin/run.sh data/bin/inotifywait.sh data/bin/cron.sh data/bin/apache2.sh data/bin/ampache_cron.sh data/bin/docker-entrypoint.sh /usr/local/bin/
COPY data/apache2/php.ini /etc/php/8.3/apache2/
COPY data/logrotate.d/* /etc/logrotate.d/
COPY data/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chown -R www-data:www-data /var/tmp/ampache.cfg.php.dist /var/www/config &&\
    chmod +x /usr/local/bin/*.sh

VOLUME ["/var/www/config"]

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["run.sh"]
