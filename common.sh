#!/bin/bash
RED='\e[31m'
GREEN='\e[1;32m'
Normal="\e[0m"
user_id=$(id -u)
logs_folder="/var/log/Shell-RoboShop-V1"
logs_file="$logs_folder/$0"

userCheck() {
if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access.."
    exit 1
fi
}

mkdir -p $logs_folder

startTime() {
echo " $appname server configuration is started========="
echo "started time = $(date +"%Y%m%d_%H%M%S")"
}

validate() {
    if [ $1 -eq 0 ]; then 
        echo -e " ${2} is ${GREEN}success$Normal" | tee -a  $logs_file
    
    else
        echo -e " ${2} is ${RED}Failed$Normal"  | tee -a  $logs_file
        exit 1
    
    fi 
}

endTime() {
    echo "configuration endtime = $(date +"%Y%m%d_%H%M%S")"
    echo "time taken : $SECONDS"
}

enable() {
    systemctl enable $appname &>> $logs_file
    validate $? "package enabled  "
}

start(){
systemctl start $appname &>> $logs_file
validate $? "package started "
}

restart(){
systemctl restart $appname &>> $logs_file
validate $? "package restarted "

}