#!/bin/bash

set -x

# Time marker for both stderr and stdout
date; date 1>&2

CMD=$1
shift

. opentsdb-env.sh

echo "OPENTSDB_CLASSPATH="${OPENTSDB_CLASSPATH}
cd ${CONF_DIR}
echo "Current path is $(pwd)"
echo "CONF_DIR is ${CONF_DIR}"
echo "OPENTSDB_LOGDIR is ${OPENTSDB_LOGDIR}"
echo "OPENTSDB_LOG4J is ${OPENTSDB_LOG4J}"
echo "KERBEROS_AUTH_ENABLED is ${KERBEROS_AUTH_ENABLED}"
echo "OPENTSDB_PRINCIPAL is ${OPENTSDB_PRINCIPAL}"
echo "TSD_HEAP_SIZE is ${TSD_HEAP_SIZE}"
echo "TSD_METRICS_PORT is ${TSD_METRICS_PORT}"


# Find Java
if [ "$JAVA_HOME" = "" ] ; then
    JAVA="java -server"
else
    JAVA="$JAVA_HOME/bin/java -server"
fi

if [[ ${TSD_METRICS_PORT} -gt 0 ]]; then
JAVA_OPTIONS="${JAVA_OPTIONS} -javaagent:$OPENTSDB_PARCEL/lib/jmx-json-javaagent.jar=${TSD_METRICS_PORT}"
fi
JAVA_OPTIONS="${JAVA_OPTIONS} -Xmx${TSD_HEAP_SIZE} ${TSD_JAVA_OPTS}"
JAVA_OPTIONS="${JAVA_OPTIONS} -enableassertions -enablesystemassertions"



# Execute the application and return its exit code
set -x

export CLASSPATH="${CLASSPATH}:${CONF_DIR}:${CONF_DIR}/hbase-conf"


# Generate JAAS config file
# openTSDB does not seem to know how to work with this.?
# generating one just in case it would work in the future
if [[ ${KERBEROS_AUTH_ENABLED} == "true" ]]; then
    # If user has not provided safety valve, replace JAAS_CONFIGS's placeholder
    if [ -z "$JAAS_CONFIGS" ]; then
        KEYTAB_FILE="${CONF_DIR}/opentsdb.keytab"
        JAAS_CONFIGS="
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  useTicketCache=false
  debug=true
  keyTab=\"$KEYTAB_FILE\"
  principal=\"$OPENTSDB_PRINCIPAL\";
};"
    fi
    echo "${JAAS_CONFIGS}" > $CONF_DIR/tsd-jaas.conf

    # WA till I figure how to make openTSDB work with a keytab.
    # Just doing a kinit for now. Should be good for few hours of testing
    # TODO: Need to spawn another re-newer process.
    export KRB_KINIT_ADDL_OPTS="-l 600"
    kinit -kt ${KEYTAB_FILE} $OPENTSDB_PRINCIPAL ${KERBEROS_ADDL_OPTS}
    JAVA_OPTIONS="${JAVA_OPTIONS} -Djava.security.auth.login.config=tsd-jaas.conf"
fi

JAVA_OPTIONS="${JAVA_OPTIONS} -DLOG_FILE=${OPENTSDB_LOG_DIR}/opentsdb.log"
JAVA_OPTIONS="${JAVA_OPTIONS} -DQUERY_LOG=${OPENTSDB_LOG_DIR}/queries.log"

echo $JAVA_OPTIONS
case $CMD in
    (start_tsd)
        MAINCLASS=TSDMain
        #generate/adjust opentsdb.conf
        
        #start tsd-server  
        cmd="$JAVA $JAVA_OPTIONS \
                  -classpath $OPENTSDB_CLASSPATH \
                  net.opentsdb.tools.$MAINCLASS
        exec ${cmd}
        ;;
    (start_kt_renewer)
        #start kt-renewer
        cmd="aux/kt_renewer.sh \
                ${KEYTAB_FILE} \
                ${OPENTSDB_PRINCIPAL} \
                ${KT_RENEW_INTERVAL}"
        exec ${cmd}
        ;;    
    (client_config)
        
        #generate/adjust opentsdb.conf  
        echo "Done."     
        ;;        
    (*)
        echo "Unknown command ${CMD}"
        exit 1
        ;;
esac

