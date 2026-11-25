appname=rabbitmq-server
source ./common.sh

userCheck
startTime

cp rabbitmq.repo /etc/yum.repos.d &>> $logs_file
validate $? "created rabbitmq repo "

echo "installation started ========"
dnf install erlang rabbitmq-server -y &>> $logs_file
validate $? "install rabbitmq server "

enable
start


rabbitmqctl list_users | grep -q roboshop
if [ $? -ne 0 ]; then
   rabbitmqctl add_user roboshop roboshop123 &>> $logs_file
   validate $? "Add rabbitmq user "
else
   echo "user already exist, skipping===="
fi 

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $logs_file
validate $? "set permissions to rabbitmq user "

endTime