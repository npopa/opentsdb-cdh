# The Parcel

This parcel should be compatible with both CDH5 and CDH6 Cloudera distros. \
The parcel gets installed on `/opt/cloudera/parcels` and the internal layout looks like below:

* **opentsdb-0.3.1-hadoop2** - the ***unmodified*** distro downloaded from [github](https://github.com/openTSDB/opentsdb/releases).\
Currently builds a parcel around openTSDB-0.3.1-hadoop2.
* **lib** - helper lib files. 
  * opentsdb-compat-cdh5-1.0.0-SNAPSHOT.jar - work in progress. **Not used**.
  * jmx-json-javaagent.jar - intended for monitoring
* **meta** - parcel definition files. More information on this [here](https://github.com/cloudera/cm_ext/wiki/Building-a-parcel).  

``` shell 

OPENTSDB
├── opentsdb-0.3.1-hadoop2
│   ├── bin
│   ├── changelog.adoc
│   ├── conf
│   ├── data
│   ├── elasticsearch
│   ├── examples
│   ├── ext
│   ├── javadocs
│   ├── lib
│   ├── LICENSE.txt
│   ├── log
│   ├── NOTICE.txt
│   ├── scripts
│   └── upgrade.adoc
├── lib
│   ├── opentsdb-compat-cdh5-1.0.0-SNAPSHOT.jar
│   └── jmx-json-javaagent.jar
└── meta
    ├── alternatives.json
    ├── opentsdb_env.sh
    ├── parcel.json
    └── release-notes.txt

```
### TODO
 * Need to have a consistent version for the parcel that is incremental on build. \
 Maybe OPENTSDB-<project.version>.p<project.patch>-<opentsdb.version>-<os>.parcel \
 Currently it is OPENTSDB-<opentsdb.version>-<build.date>-<os>.parcel \
 (eg. OPENTSDB-0.3.1-20190412144507-el7.parcel)

  




