FROM anapsix/alpine-java
MAINTAINER Benjamin Wenderoth "b.wenderoth@gmail.com"

#
## install required utils
RUN [ -e /sbin/apk ] && apk add bash; [ -e /bin/bash ]
RUN [ -e /usr/bin/apt-get ] && apt-get update && apt-get install -y patch unzip wget curl && apt-get clean all; which unzip && which patch
##
#

#
## SOLR INSTALLATION
ENV SOLR_VERSION 5.2.1
ENV SOLR_MEM_SIZE 512m
ENV SOLR solr-$SOLR_VERSION
ADD http://mirrors.gigenet.com/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz /tmp/$SOLR.tgz
RUN mkdir -p /opt \
 && gzip -dc /tmp/$SOLR.tgz | tar -C /opt -x \
 && ln -sf /opt/$SOLR /opt/solr \
 && rm /tmp/$SOLR.tgz
##
#

#
## JDBC
ENV JDBC_MYSQL_VERSION 5.1.35
ENV JDBC_PSQL_VERSION 9.3-1103.jdbc41
# PostgreSQL
ADD http://jdbc.postgresql.org/download/postgresql-$JDBC_PSQL_VERSION.jar /opt/solr/dist/postgresql-$JDBC_PSQL_VERSION.jar
# MySQL
ADD http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz
RUN echo mysql-connector-java-$JDBC_MYSQL_VERSION/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar > /tmp/include \
 && gzip -dc /tmp/mysql-connector-java-$JDBC_MYSQL_VERSION.tar.gz | tar -x -T /tmp/include > /opt/solr/dist/mysql-connector-java-$JDBC_MYSQL_VERSION-bin.jar \
 && rm -rf /tmp/*
##
#

## getting drupal files and creating core. 
# Add Drupal schema files.
# Getting the stable release with solr5 support 
RUN wget http://ftp.drupal.org/files/projects/search_api_solr-7.x-1.8.zip && \
  unzip search_api_solr-7.x-1.8.zip && \
  mkdir -p /opt/solr/server/solr/drupal/conf && \   
  cp search_api_solr/solr-conf/5.x/* /opt/solr/server/solr/drupal/conf && \
  rm -rf ./search_api_solr*

# Create a Drupal Solr core.
RUN /opt/solr/bin/solr start && \
  sleep 10 && \
  /opt/solr/bin/solr create -c core1 -d /opt/solr/server/solr/core1

VOLUME ["/opt/solr/server/solr/drupal/core1", "/opt/solr/server/solr/drupal/core1"]

EXPOSE 8983
ADD ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /opt/solr
ENTRYPOINT ["/entrypoint.sh"]
#CMD ["/entrypoint.sh"] # if needed we can overwrite the default command. 
#CMD ["/bin/bash", "-c", "/opt/solr/bin/solr create_core -c core1"]
