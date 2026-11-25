appname=mysqld
source ./common.sh

userCheck
startTime

dnf module enable mysql:8.4 -y &>> $logs_file
validate $? "Enable mysql:8.4 "

echo "installation started ========"
dnf install mysql-server -y  &>> $logs_file
validate $? "install mysql server " 

enable
start

mysql_secure_installation --set-root-pass RoboShop@1 
validate $? "mysql user creation "

endTime

