#!/bin/bash

# customize these
WGET=/bin/wget
ICS2ORG=/home/josh/ical2org.awk
ICSFILE=/home/josh/Downloads/ical_export.ics
ORGFILE=/home/josh/Documents/todos/work_schedule.org
URL=https://calendar.google.com/calendar/ical/joshuabrudnak%40oakland.edu/private-cd2cbdb64cf5dfe4aa86c4b29932db16/basic.ics

# no customization needed below
$WGET -O $ICSFILE $URL
#unzip /home/josh/Downloads/ical_export.zip /home/josh/Downloads/ical_export.ics
$ICS2ORG < $ICSFILE > $ORGFILE

