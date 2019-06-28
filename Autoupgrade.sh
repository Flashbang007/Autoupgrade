#!/bin/bash

source /usr/local/lib/flashbang_lib.sh
# Colors $COL[R,G,B,Y,LR..] for Color. $COLD for Reset
# $SCRIPTNAME and $SCRIPTPATH for Name and Path
# $PIPEFILE for Pushbulletervice dir is "/home/flashbang/Data/pushbullet.pipe"
# lc_error() exits with exit information of last command of script
# check_file() [FILE] Check if File exists and create
# check_dir() [DIR]  Check if Directory exists and create
# check_root() Checks if user is root and exits if not
# check_var_empty() check if given var is empty and !exit!

check_root

## Create Log? [0=no , 1=yes]
LOG=1
LOGFILE=/home/flashbang/Data/UPGRADE.log
# Maximale Logfile Grösse in Bytes? (leer lassen falls unbegrenzt) (512000 bytes = 500      kilobytes = 0.48 megabytes)
MAXLOGSIZE="25600"
# falls MAXLOGSIZE genutzt wird: Logfile rotieren(1) oder löschen(0)?
LOGROTATE=1


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
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " upgrade \n$(apt-get upgrade -y)" || apt-get upgrade -y
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " autoclean \n$(apt-get autoclean)" || apt-get autoclean
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " clean \n$(apt-get clean)" || apt-get clean
[ ! -z "$LOG" -a "$LOG" == 1 ] && _LOG " autoremove \n$(apt-get autoremove -y)" || apt-get autoremove -y

exit 0
