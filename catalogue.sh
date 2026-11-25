appname=catalogue
source ./common.sh

userCheck
startTime
appSetup
nodejs
reload
enable
start


cp "$script_path/mongo.repo" /etc/yum.repos.d/mongo.repo  &>> $logs_file
validate $? "creating repo file for mongodb"

dnf install mongodb-mongosh -y  &>> $logs_file
validate $? "mongodb client application is installed"
echo "checking whether the data is already present or not"


dataCount=$(mongosh --host mongodb.$domain_name --quiet --eval 'db.getSiblingDB("catalogue").products.countDocuments()') &>> $logs_file
if [ $dataCount -eq 0 ]; then
    mongosh --host mongodb.$domain_name </app/db/master-data.js &>> $logs_file
    validate $? "data load"
    
else
    echo   "[info] Data already loaded .skipping============"
fi

endTime




