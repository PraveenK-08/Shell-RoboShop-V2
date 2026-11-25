appname=redis
source ./common.sh

userCheck
startTime

dnf module disable redis -y &>> $logs_file
validate $? "Disable redis old version "

dnf module enable redis:7 -y &>> $logs_file
validate $? "Enable redis version 7 version "

echo "installation started ========"
dnf install redis -y &>> $logs_file
validate $? "Install redis"

sed -i -e 's/^bind 127.0.0.1/bind 0.0.0.0/' -e 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf
validate $? "Configuration file updated"

enable
start
endTime