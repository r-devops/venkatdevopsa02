
COMPONENT=rabbitmq 
LOG_FILE=/tmp/${COMPONENT}

source ./common.sh 

echo "Down the repo for Rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
Statuscheck $?


echo "Install the Rabbitmq"
yum install rabbitmq-server -y &>>$LOG_FILE
Statuscheck $?

echo "Enable and start the Rabbitmq service"
systemctl enable rabbitmq-server &>>$LOG_FILE
Statuscheck $?
systemctl start rabbitmq-server &>>$LOG_FILE
Statuscheck $?


# RabbitMQ comes with a default username / password as `guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.

# 1. Create application user
# # rabbitmqctl add_user roboshop roboshop123
# # rabbitmqctl set_user_tags roboshop administrator
# # rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"