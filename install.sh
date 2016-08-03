#!/bin/bash
    read -p "Quieres Instalar Docker? >> (Y/N) " yn
    case $yn in
        [Yy]* ) 
		    #Información obtenida del sitio oficial https://www.docker.com/
			sudo apt-get update
			sudo apt-get install apt-transport-https ca-certificates
			sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
			sudo echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
			sudo apt-get update
			sudo apt-get purge lxc-docker
			sudo apt-cache policy docker-engine
			sudo apt-get update
			sudo apt-get install linux-image-extra-$(uname -r)
			sudo apt-get install docker-engine
			sudo service docker start
			sudo groupadd docker
			read -p "Nombre del usuario que ejecutara Docker " nombre
			sudo usermod -aG docker $nombre
		break;; 
    esac
    read -p "Quieres Instalar LAMP (PHP-ZTS? >> (Y/N) " yn
    case $yn in
        [Yy]* )
			sudo apt-get -qq update && apt-get -qqy install vim wget curl
			sudo apt-get update && apt-get install build-essential libpcre3-dev  libghc-zlib-dev  libssl-dev cmake  libncurses5-dev bison libxml2 libxml2-dev  libjpeg-dev libpng12-dev libfreetype6-dev  libssl-dev libcurl4-openssl-dev libmhash-dev libmcrypt-dev  libtool patch bzip2 gzip libbz2-dev libxslt1-dev autoconf libevent-dev -y
			sudo mkdir -p /opt/src
			cd /opt/src
			wget http://ftp.cixug.es/apache//httpd/httpd-2.4.20.tar.gz
			wget http://ftp.cixug.es/apache//apr/apr-1.5.2.tar.gz
			wget http://ftp.cixug.es/apache//apr/apr-util-1.5.4.tar.gz
			wget http://ftp.cixug.es/apache//apr/apr-iconv-1.2.1.tar.gz
			wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.28.tar.gz
			wget http://cn2.php.net/distributions/php-5.6.18.tar.gz
			wget http://downloads.sourceforge.net/mcrypt/libmcrypt-2.5.8.tar.gz
			wget http://downloads.sourceforge.net/mcrypt/mcrypt-2.6.8.tar.gz
			wget http://downloads.sourceforge.net/mhash/mhash-0.9.9.9.tar.gz
			wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
			tar zxvf apr-1.5.2.tar.gz
			tar zxvf apr-util-1.5.4.tar.gz
			tar zxvf apr-iconv-1.2.1.tar.gz
			tar zxvf httpd-2.4.20.tar.gz
			mv apr-1.5.2 httpd-2.4.20/srclib/apr
			mv apr-util-1.5.4 httpd-2.4.20/srclib/apr-util
			mv apr-iconv-1.2.1 httpd-2.4.20/srclib/apr-iconv
			cd ./httpd-2.4.20
			sudo ./configure --prefix=/usr/local/apache --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-ssl=shared --enable-headers=shared --enable-rewrite=shared --enable-static-support --with-mpm=prefork
			make
			make install
			ln -s /usr/local/apache/bin/apachectl /etc/init.d/httpd
			chmod 755 /etc/init.d/httpd
			update-rc.d httpd defaults
			ln -s /usr/local/apache/conf  /etc/httpd
			ln -sf /usr/local/apache/bin/httpd  /usr/sbin/httpd
			ln -sf /usr/local/apache/bin/apachectl  /usr/sbin/apachectl
			ln -s /usr/local/apache/logs  /var/log/httpd
			groupadd apache
			useradd -g apache -s /usr/sbin/nologin apache
			chown -R apache:apache /usr/local/apache
			cp /etc/httpd/httpd.conf /etc/httpd/httpd.conf.back-ayen
			sed -i 's/#ServerName www.localhost.com:80/ServerName 0.0.0.0:80/g' /etc/httpd/httpd.conf
			sed -i 's/ServerAdmin tfg@localhost.com/ServerAdmin info@uc3m.local/g' /etc/httpd/httpd.conf
			sed -i 's/User daemon/User apache/' /etc/httpd/httpd.conf
			sed -i 's/Group daemon/Group apache/' /etc/httpd/httpd.conf
			mkdir -p /data/www/apache/default
			mv /usr/local/apache/htdocs/index.html /data/www/apache/default
			mv /usr/local/apache/cgi-bin /data/www/apache/cgi-bin
			chown -R apache:apache /data/www/apache
			sed -i 's;/usr/local/apache/htdocs;/data/www/apache/default;g' /etc/httpd/httpd.conf
			sed -i 's;/usr/local/apache/cgi-bin;/data/www/apache/cgi-bin;g' /etc/httpd/httpd.conf
			#PHP
			cd /opt/src
			tar zxvf libmcrypt-2.5.8.tar.gz
			cd ./libmcrypt-2.5.8
			./configure --prefix=/usr
			make && make install
			cd /opt/src
			tar zxvf mhash-0.9.9.9.tar.gz
			cd ./mhash-0.9.9.9
			./configure --prefix=/usr
			make && make install
			cd /opt/src
			/sbin/ldconfig
			tar zxvf mcrypt-2.6.8.tar.gz
			cd ./mcrypt-2.6.8
			./configure
			make && make install
			cd /opt/src
			tar zxvf libiconv-1.14.tar.gz
			cd ./libiconv-1.14
			./configure --prefix=/usr/local/libiconv
			sed -i '698d' /opt/src/libiconv-1.14/srclib/stdio.in.h
			make && make install
			cd /opt/src
			tar zxvf php-5.6.18.tar.gz
			cd ./php-5.6.18
			./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache/bin/apxs --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-bz2 --with-gettext --with-mhash --with-mcrypt --with-iconv=/usr/local/libiconv --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-freetype-dir --with-jpeg-dir=/usr --with-freetype-dir=/usr --with-kerberos --with-openssl --with-mcrypt=/usr/local/lib --with-mhash --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pcre-regex --with-pear --with-png-dir=/usr --with-xsl --with-zlib --with-zlib-dir=/usr --with-iconv --enable-bcmath --enable-calendar --enable-exif --enable-ftp --enable-gd-native-ttf --enable-soap --enable-sockets --enable-mbstring --enable-zip --enable-wddx --enable-posix --enable-pcntl --enable-maintainer-zts
			make && make install
			libtool --finish /opt/src/php-5.6.18/libs
			cp php.ini-development /etc/php.ini
			sed -i 's/;date.timezone =/date.timezone = PRC/' /etc/php.ini
			echo 'AddType application/x-httpd-php .php' >> /etc/httpd/httpd.conf
			echo 'PhpIniDir /etc' >> /etc/httpd/httpd.conf
			sed -i 's/index.html/index.html index.php/' /etc/httpd/httpd.conf
			cp ./files/info.php /data/www/apache/default/info.php
			echo 'export PATH=$PATH:/usr/local/php/bin' >> ~/.bashrc
			echo 'source ~/.bashrc'
			#MYSQL
			cd /opt/src
			mkdir -pv /data/mysql
			groupadd mysql
			useradd -g mysql -s /usr/sbin/nologin mysql
			tar zxvf mysql-5.6.28.tar.gz
			cd mysql-5.6.28
			cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql  -DMYSQL_DATADIR=/data/mysql  -DDEFAULT_CHARSET=utf8  -DWITH_READLINE=1  -DWITH_SSL=system  -DWITH_EMBEDDED_SERVER=1  -DENABLED_LOCAL_INFILE=1  -DDEFAULT_COLLATION=utf8_general_ci  -DWITH_MYISAM_STORAGE_ENGINE=1  -DWITH_INNOBASE_STORAGE_ENGINE=1  -DWITH_DEBUG=0 -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock
			make && make install
			chmod +x /usr/local/mysql
			chown -R mysql:mysql /usr/local/mysql
			chown -R mysql:mysql /data/mysql
			cp ./support-files/mysql.server /etc/init.d/mysqld
			chmod +x /etc/init.d/mysqld
			update-rc.d mysqld defaults
			ln -sv /usr/local/mysql/bin/mysql  /usr/sbin/mysql
			ln -sv /usr/local/mysql/bin/mysqladmin  /usr/sbin/mysqladmin
			ln -sv /usr/local/mysql/bin/mysqldump  /usr/sbin/mysqldump
			cp ./files/my.cnf /etc/my.cnf
			/usr/local/mysql/scripts/mysql_install_db  --user=mysql  --basedir=/usr/local/mysql  --datadir=/data/mysql
			/usr/local/php/bin/pecl update-channels
			/usr/local/php/bin/pecl install pthreads-2.0.10
			sed -i '/extension=modulename.extension/a extension=pthreads.so' /etc/php.ini
		break;;
    esac
    read -p "Quieres Instalar PHPMYADMIN? >> (Y/N) " yn
    case $yn in
        [Yy]* ) 
			cd /data/www/apache/default/
			wget https://files.phpmyadmin.net/phpMyAdmin/4.6.3/phpMyAdmin-4.6.3-all-languages.tar.gz
			tar xvf phpMyAdmin-4.6.3-all-languages.tar.gz
			mv phpMyAdmin-4.6.3-all-languages phpMyAdmin
		break;;
    esac   
    read -p "Quieres Instalar Symfony? >> (Y/N) " yn
    case $yn in
        [Yy]* ) 
			sudo apt-get update
			sudo apt-get install curl
			sudo curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
			sudo chmod a+x /usr/local/bin/symfony
			cd /data/www/apache/default/
			read -p "Nombre del proyecto Symfony " nombreSymfony
			symfony new $nombreSymfony
			cd "./$nombreSymfony"
			php bin/console generate:bundle --bundle-name=BenchmarkBundle --format=yml
		break;;
    esac
    read -p "Quieres Importar la BBDD? >> (Y/N) " yn
    case $yn in
        [Yy]* ) 
			read -p "Nombre del usuario " MYSQL_user
			read -p "Contrasena de $MYSQL_user " MYSQL_pass
			mysql --user="$MYSQL_user" --password="$MYSQL_pass" < tfg.sql
		break;;
    esac
    read -p "Quieres Descargar las imagenes Docker? >> (Y/N) " yn
    case $yn in
        [Yy]* ) 
			docker pull marioskill/apache-flink
			docker pull marioskill/apache-storm
			docker pull marioskill/apache-spark
    esac


