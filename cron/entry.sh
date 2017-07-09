#!/bin/ash

# list used crontab
echo "Used crontable:"
/usr/bin/crontab -l

# start cron in foreground
/usr/sbin/crond -f
