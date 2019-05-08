# openTSDB - Cloudera Parcel/CSD
## - this is a work in progress and not yet functional 

### Building the project

* Install maven

``` shell
#Install maven (if you don't already have)
export MAVEN_VERSION=3.6.0
mkdir -p /usr/local/maven
wget "http://mirrors.ocf.berkeley.edu/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz" -O - | tar -xz -C /usr/local/maven
ln -sf /usr/local/maven/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn

#Install git (if you don't already have)
yum install -y git

```

* Clone repo 
``` shell
#clone repository
cd ~ && git clone https://github.com/npopa/opentsdb-cdh
```

* Build
```
#build repository
export JAVA_HOME=/usr/java/default
cd ~/opentsdb-cdh && git pull && mvn clean package

```

* Install CSD. More info [here](https://github.com/cloudera/cm_ext/wiki/Administration-of-CSDs).
``` shell
#copy the CSD to CM folder
#If it was built on the same host where CM resides then it can be copied directly.
#Else it needs to be scp-ed to CM host.
\cp ~/opentsdb-cdh/opentsdb-csd-cm6/target/OPENTSDB-2.4.0-CM6.jar /opt/cloudera/csd/

#restart CM & CM Service after that
#service cloudera-scm-server restart
#or http://localhost:7180/cmf/csd/reinstall?csdName=OPENTSDB-2.4.0-CM6

```
* Install parcel

``` shell
cd ~/opentsdb-cdh/opentsdb-parcel/target && python -m SimpleHTTPServer 8001
```


* Create a dedicated `opentsdb` hbase namespace that will contain all the hbase tables for openTSDB. \
This is not required but it will keep things tidy in a crowded environment.

``` shell
# kinit hbase
# Create a namespace for the JanusGraph tables.
# Grant opentsdb group admin priviledges on it 
echo "create_namespace 'opentsdb'"|hbase shell
echo "grant '@opentsdb','RWXCA', '@opentsdb'"|hbase shell

```


