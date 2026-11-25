appname=shipping
source ./common.sh

userCheck
startTime

dnf module enable maven:3.9 -y &>> $logs_file
validate $? "Enable maven3.9 "

echo "[INFO] installing maven and java packages"
dnf install maven java-25-openjdk-devel -y &>> $logs_file
validate $? " Maven and Java Installation"

alternatives --set java "/usr/lib/jvm/java-25-openjdk/bin/java"
validate $? "Setting Java 25 as default Java version"

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f /usr/bin/java)))" > /etc/profile.d/java.sh
source /etc/profile.d/java.sh
echo $JAVA_HOME
validate $? "Setting JAVA_HOME for maven"

appSetup

mvn clean package  &>> $logs_file
validate $? "Installing Dependencies"

mv target/shipping.jar shipping.jar  &>> $logs_file
validate $? "Moving Shipping Jar file"

dnf install mysql -y  &>> $logs_file
validate $? "Installing mysql client"

count=$(mysql -h mysql.$domain_name -uroot  -pRoboShop@1 -D cities -N -s -e "SELECT COUNT(*) FROM cities"; 2>> $logs_file) 

if [ $count -eq 0 ] || [ -z $count ]; then
    mysql -h mysql.$domain_name -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $logs_file
    validate $? "Loading cities data"
else
    echo "Data already loaded , so Skipping==========="
fi

mysql -h mysql.$domain_name -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $logs_file
validate $? "Creating app user"


reload
enable
start
endTime

