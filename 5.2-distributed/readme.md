Creates a Solr5 Cloud

Zookeeper is integrated and activated, you just need to start your instances.

Collections are not created by default. 
Exmaple: 
bin/solr create_collection -c collection1 -shards 2

  -e <example>  Name of the example to run; available examples:
      cloud:         SolrCloud example
      techproducts:  Comprehensive example illustrating many of Solr's core capabilities
      dih:           Data Import Handler
      schemaless:    Schema-less example
  -p <port>     Specify the port to start the Solr HTTP listener on; default is 8983
                  The specified port (SOLR_PORT) will also be used to determine the stop port
                  STOP_PORT=($SOLR_PORT-1000) and JMX RMI listen port RMI_PORT=(1$SOLR_PORT).
                  For instance, if you set -p 8985, then the STOP_PORT=7985 and RMI_PORT=18985


Links: 
https://cwiki.apache.org/confluence/display/solr/SolrCloud
