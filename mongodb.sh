appname=mongod
source ./common.sh

userCheck
startTime 
cp mongo.repo /etc/yum.repos.d &>> $logs_file
validate $? "creating repo file" 

echo "installation started ========"
dnf install mongodb-org -y  &>> $logs_file
validate $? "Installing mongodb"

enable
start 

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> $logs_file
validate $? "Configuration update "

restart

endTime