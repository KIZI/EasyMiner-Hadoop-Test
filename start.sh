#!/bin/bash

rm -Rf /tmp/*
rm -Rf /root/hadoop-2.6.5/logs/*
rm -Rf /root/hadoop-2.6.5/metastore_db/*
hadoop namenode -format
hadoop datanode -format
#hadoop secondarynamenode -format

service ssh start
/root/hadoop-2.6.5/sbin/start-dfs.sh
/root/hadoop-2.6.5/sbin/start-yarn.sh

hadoop fs -mkdir /user
hadoop fs -mkdir /user/hive
hadoop fs -mkdir /user/hive/warehouse
hadoop fs -mkdir /tmp
hadoop fs -mkdir /user/easyminer
hadoop fs -chmod 777 /tmp
hadoop fs -chmod 777 /user/hive/warehouse
hadoop fs -chmod 777 /user/easyminer

#hadoop fs -mkdir /user/easyminer/lib
#hdfs dfs -put C:\Users\propan\Documents\NetBeansProjects\EasyMiner-Root\cesnet-conf-test\easyminer-sparkminer.jar /user/easyminer/easyminer-sparkminer.jar
#hdfs dfs -put C:\Users\propan\Documents\NetBeansProjects\EasyMiner-Root\cesnet-conf-test\lib\* /user/easyminer/lib
#hdfs dfs -chown -R easyminer /user/easyminer

service mysql start
hiveserver2 &

#/root/hadoop-2.6.5/sbin/stop-yarn.sh
#/root/hadoop-2.6.5/sbin/stop-dfs.sh
#rm -Rf /tmp/*
#hadoop namenode -format