
FROM    java:8
MAINTAINER  benjamin Wenderoth "b.wenderoth@gmail.com"

ENV SOLR_VERSION 5.2.1
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr
ENV SOLR_MEM_SIZE 512m

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install \
    curl \
    lsof \
    procps && \
  groupadd -r $SOLR_USER && \
  useradd -r -g $SOLR_USER $SOLR_USER && \
  mkdir -p /opt && \
  wget -nv --output-document=/opt/$SOLR.tgz http://www.us.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR

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

# Add Drupal schema files.
RUN git clone --branch 7.x-1.x http://git.drupal.org/project/search_api_solr.git && \
  mkdir -p /opt/solr/server/solr/drupal/conf && \   
  cp search_api_solr/solr-conf/5.x/* /opt/solr/server/solr/drupal/conf && \
  rm -rf ./search_api_solr*
RUN /opt/solr/bin/solr start && \
  sleep 10 && \
  /opt/solr/bin/solr create -c drupal -d /opt/solr/server/solr/drupal

VOLUME ["/opt/solr/server/solr/drupal/data", "/opt/solr/server/solr/drupal/conf"]

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr start -f -m $SOLR_MEM_SIZE -z 8983]

