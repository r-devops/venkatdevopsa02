COMPONENT=mongodb 
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh 



echo "Download MongoDB repo "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
Statuscheck $?


echo " Install Mongo & Start Service"
yum install -y mongodb-org &>>${LOG_FILE}
Statuscheck $?

systemctl enable mongod &>>${LOG_FILE}
Statuscheck $?

systemctl start mongod &>>${LOG_FILE}
Statuscheck $?


echo "Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file"
sed -i -e 's/127.0.0.1/0.0.0.0/'  /etc/mongod.conf &>>${LOG_FILE}
Statuscheck $?
systemctl restart mongod &>>${LOG_FILE}
Statuscheck $?

echo "Download the schema and load it."
rm -rf /tmp/mongodb.zip
rm -rf /tmp/mongodb-main
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
Statuscheck $?

echo "load the data into mongodb"
cd /tmp
unzip mongodb.zip &>>${LOG_FILE}
Statuscheck $?
cd mongodb-main
mongo < catalogue.js &>>${LOG_FILE}
Statuscheck $?
mongo < users.js &>>${LOG_FILE}
Statuscheck $?
