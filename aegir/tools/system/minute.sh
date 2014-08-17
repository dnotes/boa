#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:/opt/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

if [ -e "/root/.high_traffic.cnf" ] ; then
  _DO_NOTHING=YES
else
  perl /var/xdrago/monitor/check/segfault_alert
fi

mysql_proc_kill()
{
  if [ "$xtime" != "Time" ] && [ "$xuser" != "root" ] && [ "$xtime" != "|" ] && [[ "$xtime" -gt "$limit" ]] ; then
    xkill=`mysqladmin kill $each`
    times=`date`
    echo $times $each $xuser $xtime $xkill
    echo "$times $each $xuser $xtime $xkill" >> /var/xdrago/log/sql_watch.log
  fi
}

mysql_proc_control()
{
limit=3600
xkill=null
for each in `mysqladmin proc | awk '{print $2, $4, $8, $12}' | awk '{print $1}'`;
do
  xtime=`mysqladmin proc | awk '{print $2, $4, $8, $12}' | grep $each | awk '{print $4}'`
  if [ "$xtime" = "|" ] ; then
    xtime=`mysqladmin proc | awk '{print $2, $4, $8, $11}' | grep $each | awk '{print $4}'`
  fi
  xuser=`mysqladmin proc | awk '{print $2, $4, $8, $12}' | grep $each | awk '{print $2}'`
  if [ "$xtime" != "Time" ] ; then
    if [ "$xuser" = "xabuse" ] ; then
      limit=60
      mysql_proc_kill
    else
      limit=3600
      mysql_proc_kill
    fi
  fi;
done
}

mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
mysql_proc_control
sleep 5
perl /var/xdrago/monitor/check/escapecheck
perl /var/xdrago/monitor/check/hackcheck
perl /var/xdrago/monitor/check/hackftp
perl /var/xdrago/monitor/check/scan_nginx
perl /var/xdrago/monitor/check/locked
perl /var/xdrago/monitor/check/sqlcheck
echo DONE!
exit 0
###EOF2014###
