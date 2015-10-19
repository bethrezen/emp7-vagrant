#!/usr/bin/env bash
ENV_DIR="/vagrant/vagrant-env"
PHP_RELEASE="php-7.0.0-latest"
PHP_ARCHIVE="$PHP_RELEASE.tar.gz"
MYSQL_PASSWORD="password"
MYSQL_DATABASE="php7"

echo "==== apt update ===="
apt-get update

echo "==== apt upgrade ===="
apt-get -y upgrade

echo "==== Installing dependencies ===="
apt-get install -y \
build-essential \
libcurl4-openssl-dev \
libmcrypt-dev \
libxml2-dev \
libjpeg-dev \
libfreetype6-dev \
libmysqlclient-dev \
libt1-dev \
libgmp-dev \
libpspell-dev \
libicu-dev \
librecode-dev \
curl \
libreadline-dev \
memcached \
nginx-full \
mc \
htop \
iotop \
zip \
unzip \
git \
libxpm4 \
libjpeg62 \
language-pack-ru \
npm \
libmemcached-dev \
screen \
autoconf


locale-gen
#libcurl3-devlibpng-dev \

if [ ! -d /etc/php7 ]; then
	mkdir /etc/php7
	mkdir /etc/php7/{extra,cli,conf.d,fpm}
fi;

cp $ENV_DIR/profile.d/php7.sh /etc/profile.d/

echo "==== Download & Extracting PHP7 ===="
if [ -d /usr/local/php7 ]; then
    rm -rf /usr/local/php7
fi;

mkdir /usr/local/php7

wget -qO /usr/local/php7/$PHP_ARCHIVE http://repos.zend.com/zend-server/early-access/php7/php-7.0-latest-DEB-x86_64.tar.gz
cd /usr/local/php7
tar -xzPf $PHP_ARCHIVE
mkdir /usr/local/php7/etc/conf.d

echo "==== Creating fpm init scripts ===="
wget -O /etc/init.d/php7-fpm "https://gist.github.com/bjornjohansen/bd1f0a39fd41c7dfeb3a/raw/f0312ec54d1be4a8f6f3e708e46ee34d44ef4657/etc%20inid.d%20php7-fpm"
chmod a+x /etc/init.d/php7-fpm
wget -O /etc/init/php7-fpm.conf "https://gist.github.com/bjornjohansen/9555c056a7e8d1b1947d/raw/15920fa2f447358fdd1c79eecd75a53aaaec76f9/etc%20init%20php7-fpm"
cp $ENV_DIR/php/php-fpm.conf /usr/local/php7/etc/php-fpm.conf
cp $ENV_DIR/php/php7-fpm-checkconf /usr/local/lib/php7-fpm-checkconf
chmod a+x /usr/local/lib/php7-fpm-checkconf
update-rc.d php7-fpm defaults

echo "==== Enabling opcache ===="

echo "zend_extension=opcache.so
opcache.memory_consumption=128
opcache.enable_cli=1
opcache.enable=1" > /usr/local/php7/etc/conf.d/opcache.ini

echo "==== Download & Compile php-memcached ===="
cd /root
git clone https://github.com/php-memcached-dev/php-memcached.git --branch=php7
cd php-memcached
/usr/local/php7/bin/phpize
./configure --disable-memcached-sasl --with-php-config=/usr/local/php7/bin/php-config
make
make install
echo "extension=memcached.so" > /usr/local/php7/etc/conf.d/memcached.ini

echo "==== Starting php7-fpm service ===="
service php7-fpm start

echo "==== Setting up Webserver ===="
/etc/init.d/nginx stop

cp $ENV_DIR/nginx/php7.conf /etc/nginx/sites-enabled/

/etc/init.d/nginx start


echo "==== Installing MySQL ===="
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASSWORD"
apt-get -y install mysql-server
mysqladmin -uroot -p$MYSQL_PASSWORD create $MYSQL_DATABASE

echo "==== Installing gulp ===="
npm install -g gulp

echo "==== DONE ===="

