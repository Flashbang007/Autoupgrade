#!/bin/bash

PATH=$PATH:/opt/OpenPrinting-Gutenprint/sbin:/opt/OpenPrinting-Gutenprint/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/snap/bin:~/bin

## Create Log? [0=no , 1=yes]
LOG=1
LOGFILE=/home/flashbang/Data/UPGRADE.log
# Maximale Logfile Grösse in Bytes? (leer lassen falls unbegrenzt) (512000 bytes = 500      kilobytes = 0.48 megabytes)
MAXLOGSIZE="25600"
# falls MAXLOGSIZE genutzt wird: Logfile rotieren(1) oder löschen(0)?
LOGROTATE=1

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
        echo -e "[$(date +"%d.%m.%Y %H:%M:%S")] \n$1" | tee -a $LOGFILE
    fi
}

apt-get update
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " upgrade \n$(apt-get upgrade -y)"
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " autoclean \n$(apt-get autoclean)"
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " clean $(apt-get clean)"
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " autoremove \n$(apt-get autoremove -y)"
#apt upgrade -y
#apt autoclean
#apt clean
#apt autoremove -y

if [ -f /var/run/reboot-required ]; then
        reboot & exit 0
fi

exit 0
