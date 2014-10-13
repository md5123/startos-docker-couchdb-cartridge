#!/bin/bash
LOG=/tmp/run-script.log
echo "run_script started..." >> $LOG

echo "Starting /usr/local/bin/metadata_svc_bugfix.sh" >> $LOG
/usr/local/bin/metadata_svc_bugfix.sh
echo "Ending /usr/local/bin/metadata_svc_bugfix.sh" >> $LOG

echo "Starting /etc/init.d/apache2 start" >> $LOG
/etc/init.d/apache2 start > /dev/null 2>&1 &
echo "Ending /etc/init.d/apache2 start" >> $LOG

echo "Starting /root/bin/init.sh" >> $LOG
/root/bin/init.sh > /tmp/init.log
echo "Ending /root/bin/init.sh" >> $LOG

echo "Starting /usr/local/bin/couchdb" >> $LOG
/usr/local/bin/couchdb couchdb > /dev/null 2>&1 &
echo "Ending /usr/local/bin/couchdb" >> $LOG

echo "Starting /usr/local/bin/couch_apps.sh" >> $LOG
/usr/local/bin/couch_apps.sh > /dev/null 2>&1 &
echo "Ending /usr/local/bin/couch_apps.sh" >> $LOG

echo "Ending run_script..." >> $LOG
echo " " >> $LOG