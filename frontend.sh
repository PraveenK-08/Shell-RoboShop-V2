appname=nginx
source ./common.sh
userCheck
startTime

dnf module disable nginx -y  &>> $logs_file
validate $? "Disable nginx default version"
dnf module enable nginx:1.26 -y &>> $logs_file
validate $? "Enable nginx 1.26 version"
dnf install nginx -y &>> $logs_file
validate $? "Install Nginx" 

enable
start

rm -rf /usr/share/nginx/html/*
validate $? "Remove Default file"

curl -L -o /tmp/frontend.zip https://raw.githubusercontent.com/daws-92s/roboshop-documentation/refs/heads/main/artifacts/frontend-v4.zip  &>> $logs_file
validate $? "downloading frontend app"

cd /usr/share/nginx/html/
unzip /tmp/frontend.zip  &>> $logs_file
validate $? "unzip the application file"

sed -i "s/domainName/$domain_name/g" "$script_path/frontend.conf" &>> $logs_file
validate $? "configuration file update "

cp "$script_path/frontend.conf" /etc/nginx/default.d/roboshop.conf &>> $logs_file
validate $? "configuration file copied"

restart
