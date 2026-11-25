appname=payment
source ./common.sh

userCheck
startTime

appSetup

dnf install python3.14 python3.14-pip -y &>> $logs_file
validate $? "Install python "


python3.14 -m venv /app/.venv &>> $logs_file
/app/.venv/bin/pip install -r requirements.txt &>> $logs_file
validate $? "creating and installing virtual Environment and Dependencies"


reload
enable
start
endTime


