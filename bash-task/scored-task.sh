#!/bin/bash

#BACKUP LOGIC

DEFAULT_SRC=/etc
EMAIL="yoossef11gaber10@gmail.com"


#1- if the backup dirctory not exist make it and also if the logs dirctory not exist make it
if [ ! -d ~/backups ]; then
    mkdir ~/backups
fi
if [ ! -d ~/backups-logs ]; then
    mkdir ~/backups-logs
fi

# 1- take argument  with path of file to backup (optional)if exist check if its valid directory
# if not exist or invalid backup /etc

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

#2-add logging redirectional to log files
touch ~/backups-logs/success-$timestamp
touch ~/backups-logs/error-$timestamp



PATHFILE="$1"
if [ -n "$PATHFILE" ] && [ -d "$PATHFILE" ]; then

sudo tar -czf ~/backups/$timestamp-yourfile.tar.gz $PATHFILE  >  ~/backups-logs/success-$timestamp 2>  ~/backups-logs/error-$timestamp
    if ! [ $? -eq 0 ]; then
        mail -s "backup faild for $PATHFILE"  $EMAIL < ~/backups-logs/error-$timestamp
        rm -r ~/backups-logs/success-$timestamp
    else
       echo "Backup completed successfully at $timestamp-yourfile.tar.gz for $PATHFILE" > ~/backups-logs/success-$timestamp
       rm -r ~/backups-logs/error-$timestamp
    fi
else
sudo  tar -czf ~/backups/$timestamp-etc.tar.gz -C / etc >  ~/backups-logs/success-$timestamp 2>  ~/backups-logs/error-$timestamp
 if ! [ $? -eq 0 ]; then
        mail -s "backup faild for $DEFAULT_SRC"  $EMAIL < ~/backups-logs/error-$timestamp
         rm -r ~/backups-logs/success-$timestamp
 else
        echo "Backup completed successfully at $timestamp-etc.tar.gz  for $DEFAULT_SRC" > ~/backups-logs/success-$timestamp 
         rm -r ~/backups-logs/error-$timestamp
fi

fi

#check after each daily backup if days number exist and its integre backups older than that number of days
# if not exist or invalid integer delete older than 7 days
DAYS_NUMBER=$2
if [[ "$DAYS_NUMBER" =~ ^[1-9]+$ ]]; then
    files=$(find ~/backups -type f -name  "*.tar.gz" -mtime +$DAYS_NUMBER ) 
    if [ -n "$files" ]; then
        #sudo rm -r $files
        echo "$files" | xargs -d '\n' sudo rm -f
    fi

else
    files=$(find ~/backups -type f -name  "*.tar.gz" -mtime +7 )
    if [ -n "$files" ]; then
    #udo rm -r $files  
    echo "$files" | xargs -d '\n' sudo rm -f
    fi
fi


#LOGGING LOGIC
#1- we added the files of logs and when success of backup redirect to success.logs
# and when backups fail added to error.logs

#2- must keep last 5 logs in each file (you can do it with find also)

# sudo rm -r $(ls -tp ~/backups-logs/success | grep -v / | head -n -5) &>> /dev/null
# sudo rm -r $(ls -tp ~/backups-logs/error | grep -v / | head -n -5) &>> /dev/null


logs_to_delete=$(ls -tp ~/backups-logs/ | grep -v '/$' | tail -n +6)
if [ -n "$logs_to_delete" ]; then
    echo "$logs_to_delete" | xargs -I{} rm -f ~/backups-logs/{}
fi

#ALERT ON FAILING LOGIC
# send email in else condition in fail of backups


