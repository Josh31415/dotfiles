#!/bin/bash

portlet=$1

echo "Building project..."
cd ~/uportal/$portlet
find src/main/react/src -name "*.js" -exec prettier --write --no-semi {} \;
mvn clean package

echo "Deploying generated war file to $CATALINA_HOME/webapps."

~/uportal/uportal/bin/webapp_cntl.sh stop $portlet 

cd $HOME/uportal/uportal
ant clean deployPortletApp -DportletApp=/home/joshb/uportal/$portlet/target/$portlet.war

~/uportal/uportal/bin/webapp_cntl.sh start $portlet 
~/uportal/uportal/bin/webapp_cntl.sh -s 
