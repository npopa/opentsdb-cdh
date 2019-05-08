#!/bin/bash

export OPENTSDB_BIN=${OPENTSDB_HOME}/usr/share/opentsdb/bin
export OPENTSDB_CFG=${OPENTSDB_HOME}/usr/share/opentsdb/etc
export OPENTSDB_LIB=${OPENTSDB_HOME}/usr/share/opentsdb/lib
export OPENTSDB_PLUGINS=${OPENTSDB_HOME}/usr/share/opentsdb/plugins
export OPENTSDB_STATIC=${OPENTSDB_HOME}/usr/share/opentsdb/static
export OPENTSDB_TOOLS=${OPENTSDB_HOME}/usr/share/opentsdb/tools
export OPENTSDB_LOG_DIR=/var/log/opentsdb
export OPENTSDB_CACHE=/tmp/tsd

# Initialize classpath to $CFG
OPENTSDB_CLASSPATH="$OPENTSDB_CFG/opentsdb"

# Add the jars in $OPENTSDB_LIB that start with "tsdb" first
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_LIB -name 'tsdb*.jar' | sort | tr '\n' ':')
# Add the rest of the jars in $OPENTSDB_LIB
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_LIB -name '*.jar' \
                \! -name 'tsdb*' | sort | tr '\n' ':')
                
# Add the jars in $OPENTSDB_PLUGINS (at any subdirectory depth). Maybe?
#OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":$(find -L $OPENTSDB_PLUGINS -name '*.jar' | sort | tr '\n' ':')

# Add hbase configuration
OPENTSDB_CLASSPATH="$OPENTSDB_CLASSPATH":"/etc/hbase/conf"

export OPENTSDB_CLASSPATH

env

# Below this line is Cloudera Manager configured content, above is parcel default
