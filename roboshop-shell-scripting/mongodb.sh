COMPONENT=mysql 
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

# ```

# 1. Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file

# Config file: `/etc/mongod.conf`

# then restart the service

# ```bash
# # systemctl restart mongod

# ```

# ## Every Database needs the schema to be loaded for the application to work.

# Download the schema and load it.

# ```
# # curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

# # cd /tmp
# # unzip mongodb.zip
# # cd mongodb-main
# # mongo < catalogue.js
# # mongo < users.js

# ```

# Symbol `<` will take the input from a file and give that input to the command.