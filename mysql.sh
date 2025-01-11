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

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enable mysqld server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting mysql server"

mysql -h mysql.pavanreddy.store -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME

if [ $? -ne 0 ]
then
    echo "mysql Root password is not set" &>>$LOG_FILE_NAME
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting the root password"
else
    echo -e "mysql Root password is Already setup... -Y SKIPPING $N"
fi    


