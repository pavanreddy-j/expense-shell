#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/expense-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP= $(date +%Y-%m-%d-%H_%M_%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$1  ... $R FAILURE $N"
        exit 1
    else
        echo -e " $2... $G SUCCESS $N"
    fi
}

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "ERROR:: You must have sudo access to execute the scripts"
        exit 1 # other than o
    fi
}

echo "Scripts started executing at : $TIMSTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y
VALIDATE $? "Installing mysql server"

systemctl enable mysqld 
VALIDATE $? "Enable mysqld server"

systemctl start mysqld 
VALIDATE $? "Starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting root password"
