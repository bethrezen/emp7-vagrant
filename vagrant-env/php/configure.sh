#!/usr/bin/env bash
./configure --with-config-file-path=/etc/php7 \
--with-config-file-scan-dir=/etc/php7/extra --disable-all --enable-bcmath \
--enable-ctype --enable-dom --enable-fileinfo --enable-filter --enable-hash \
--enable-json --enable-libxml --enable-phar --enable-session --enable-simplexml \
--enable-tokenizer --enable-xml --enable-xmlreader --enable-xmlwriter \
--enable-shmop --enable-sysvsem --enable-sysvshm --enable-sysvmsg \
--with-mysqli=mysqlnd --with-curl --enable-mbstring=all --with-pdo-mysql \
--enable-pdo --with-gd --enable-soap --enable-opcache --with-iconv \
--with-openssl --with-pgsql --with-mhash --with-pcre-regex \
--with-readline --with-libxml-dir --with-zlib \
--with-libdir=/lib/x86_64-linux-gnu --enable-sockets --with-pspell \
--with-pdo-sqlite --with-pdo-pgsql --enable-cgi --enable-pcntl --enable-fpm \
--enable-intl --enable-zip --enable-calendar --enable-gmp --with-xsl \
--enable-gd-native-ttf --enable-exif --with-gettext --enable-zend-signals \
--with-bz2