FROM ubuntu:18.04

MAINTAINER "AzagraMac"

RUN apt-get update && apt-get -y upgrade && apt-get install -y apt-transport-https apt-utils openjdk-8-jdk unzip wget curl vim && apt-get clean all

RUN cd /tmp && wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.zip && unzip apache-tomcat-*.zip
RUN mkdir -p /usr/local/tomcat
RUN mv /tmp/apache-tomcat-8.5.40/* /usr/local/tomcat

WORKDIR /usr/local/tomcat

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN useradd -m -U -d /usr/local/tomcat -s /bin/false tomcat
RUN chown -R tomcat:tomcat /usr/local/tomcat
RUN sh -c 'chmod a+x /usr/local/tomcat/bin/*.sh'

COPY tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY manager/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
COPY host-manager/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml

EXPOSE 8080
CMD ["catalina.sh", "jpda", "run"]
