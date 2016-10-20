#!/bin/bash

## Create Log? [0=no , 1=yes]
LOG=1
LOGFILE=~/UPGRADE.log
# Maximale Logfile Grösse in Bytes? (leer lassen falls unbegrenzt) (512000 bytes = 500      kilobytes = 0.48 megabytes)
MAXLOGSIZE="256000"
# falls MAXLOGSIZE genutzt wird: Logfile rotieren(1) oder löschen(0)?
LOGROTATE=0

# -------------------------------------------------------------- #
# >>> >> >  DO NOT MESS WiTH ANYTHiNG BELOW THiS LiNE!  < << <<< #
# -------------------------------------------------------------- #

# write and check log
_LOG() {
    if [ -n "$LOGFILE" ]; then
        #check size of logfile
        if [ -n "$MAXLOGSIZE" ] && [ -f "$LOGFILE" ] && [ "$(stat --printf="%s" $LOGFILE)" -gt "$MAXLOGSIZE" ]; then
            if [ "$LOGROTATE" = 1 ]; then
                echo "rotating logfile $LOGFILE"
                mv -f $LOGFILE ${LOGFILE}.1 >/dev/null 2>&1
            else
                echo "deleting logfile $LOGFILE"
                rm -f $LOGFILE >/dev/null 2>&1
            fi
            touch $LOGFILE
        fi
        echo "[$(date +"%d.%m.%Y %H:%M:%S")]  $1" >> $LOGFILE
    fi
}

apt-get update
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG "$(apt-get upgrade -s)"
apt-get upgrade -y
apt-get clean

ap-get dist-upgrade

CurrentDate=$(date +%b" "%d" "%Y)
updateDate=$(cat /proc/version | awk {'print $15" "$16" "$19'})

#CurrentDate=$(date -d@$(date +%s) +"%H%d%m%Y")
#rpiupdateDate=$(date -d@$(stat -c %Z /root/.rpi-firmware/) +"%H%d%m%Y")

[ "$CurrentDate" == "$updateDate" ] && reboot

exit 0
