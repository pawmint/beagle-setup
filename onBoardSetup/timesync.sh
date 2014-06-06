#!/bin/bash

ntpdate -u 0.sg.pool.ntp.org # To syncronize the clock, write: sg in Singapore, and fr in France
echo Asia/Singapore > /etc/timezone # To etablish the correct timezone, write Asia/singapore or Europe/Paris. You can find the all list with the command "ls /usr/share/zoneinfo/<continent>/<country>"

