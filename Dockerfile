FROM debian:jessie

LABEL maintainer="prozeman@gmail.com"

WORKDIR /root

RUN echo 'deb http://http.debian.net/debian jessie-backports main' >> /etc/apt/sources.list && \
    echo 'deb http://dl.bintray.com/sbt/debian /' >> /etc/apt/sources.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
    apt-get update && \
    apt-get install -t jessie-backports -y --no-install-recommends openjdk-8-jdk && \
    debconf-set-selections <<< 'mysql-server mysql-server/root_password password test' && \
    debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password test' && \
    apt-get install -y mysql-server
    
RUN apt-get install -y ssh curl wget rsync && \
    wget http://mirror.dkm.cz/apache/hadoop/common/hadoop-2.6.5/hadoop-2.6.5.tar.gz && \
    wget http://mirror.dkm.cz/apache/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz && \
    tar -zxvf hadoop-2.6.5.tar.gz && \
    tar -zxvf apache-hive-1.2.2-bin.tar.gz && \
    rm hadoop-2.6.5.tar.gz && \
    rm apache-hive-1.2.2-bin.tar.gz && \
    apt-get upgrade -y  && \
    ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa && \
    cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

WORKDIR hadoop-2.6.5

ADD core-site.xml /root/hadoop-2.6.5/etc/hadoop
ADD hdfs-site.xml /root/hadoop-2.6.5/etc/hadoop
ADD mapred-site.xml /root/hadoop-2.6.5/etc/hadoop
ADD yarn-site.xml /root/hadoop-2.6.5/etc/hadoop
ADD hadoop-env.sh /root/hadoop-2.6.5/etc/hadoop
ADD hive-site.xml /root/apache-hive-1.2.2-bin/conf
ADD mysql-connector-java-5.1.38-bin.jar /root/apache-hive-1.2.2-bin/lib
ADD start.sh /root

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_PREFIX=/root/hadoop-2.6.5
ENV HADOOP_HOME=/root/hadoop-2.6.5
ENV HIVE_HOME=/root/apache-hive-1.2.2-bin
ENV PATH="/root/hadoop-2.6.5/bin:/root/apache-hive-1.2.2-bin/bin:${PATH}"

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 54310
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122  
#Hive ports
EXPOSE 10000 9999 9083

#docker build -t hadoop .
#docker run -it --hostname=xtest.lmcloud.vse.cz --name=hadoop -p 54310:54310 -p 50010:50010 -p 50020:50020 -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 19888:19888 -p 8030:8030 -p 8031:8031 -p 8032:8032 -p 8033:8033 -p 8040:8040 -p 8042:8042 -p 8088:8088 -p 49707:49707 -p 2122:2122 -p 10000:10000 -p 9999:9999 -p 9083:9083 hadoop bash