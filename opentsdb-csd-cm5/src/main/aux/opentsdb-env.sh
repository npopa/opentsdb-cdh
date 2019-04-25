#!/bin/bash

export OPENTSDB_BIN=${OPENTSDB_HOME}/bin
export OPENTSDB_CFG=${OPENTSDB_HOME}/conf/gremlin-server
export OPENTSDB_LIB=${OPENTSDB_HOME}/lib
export OPENTSDB_EXT=${OPENTSDB_HOME}/ext


# Initialize classpath to $CFG
OPENTSDB_CLASSPATH="$OPENTSDB_CFG"

# Add the slf4j-log4j12 binding
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_LIB -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')

# Add the jars in $OPENTSDB_LIB that start with "opentsdb" first
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_LIB -name 'opentsdb*.jar' | sort | tr '\n' ':')

# Add the remaining jars in $OPENTSDB_LIB.
#TODO - need to check hbase-shaded-* removal and add the CDH ones
#               \! -name 'hbase-shaded-*' " \
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_LIB -name '*.jar' \
                \! -name 'opentsdb*' \
                \! -name 'slf4j-log4j12*.jar' | sort | tr '\n' ':')
# Add the jars in $OPENTSDB_EXT (at any subdirectory depth)
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_EXT -name '*.jar' | sort | tr '\n' ':')
# Add hbase configuration
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":"/etc/hbase/conf"

export OPENTSDB_CLASSPATH

# Below this line is Cloudera Manager configured content, above is parcel default
