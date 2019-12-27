FROM debian:jessie

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install apache2 php5 libapache2-mod-php5 php5-cli php5-ldap php5-dev php-pear php5-curl curl libaio1 php5-mssql

# Instalar as dependencias do OCI8
ADD conf/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp
ADD conf/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp
ADD conf/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb /tmp
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
RUN rm -rf /tmp/oracle-instantclient12.1-*.deb

# Alterar o Freetds.conf para versao 8
ADD conf/freetds.conf /etc/freetds

ENV LD_LIBRARY_PATH /usr/lib/conf/12.1/client64/lib/
ENV ORACLE_HOME /usr/lib/conf/12.1/client64/lib/

RUN echo 'instantclient,/usr/lib/conf/12.1/client64/lib' | pecl install -f oci8-2.0.8
RUN echo "extension=oci8.so" > /etc/php5/apache2/conf.d/30-oci8.ini

# Habilitar rewrite
RUN a2enmod rewrite

# VAriaveis de ambiente do apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN apt-get -y install php5-pgsql

EXPOSE 80

# Run Apache2 in Foreground
CMD /usr/sbin/apache2 -D FOREGROUND
