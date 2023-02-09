
COMPONENT=rabbitmq 
LOG_FILE=/tmp/${COMPONENT}

source ./common.sh 

echo "Down the repo for Rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash
yum install erlang -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
Statuscheck $?



echo "Stop Rabbitmq service"
systemctl stop rabbitmq-server 
#&>>$LOG_FILE
#Statuscheck $?

echo "Install the Rabbitmq"
yum install rabbitmq-server -y --skip-broken &>>$LOG_FILE
Statuscheck $?

echo "Enable and start the Rabbitmq service"
systemctl enable rabbitmq-server &>>$LOG_FILE
Statuscheck $?
systemctl start rabbitmq-server &>>$LOG_FILE
Statuscheck $?

rabbitmqctl list_users | grep -i roboshop &>>$LOG_FILE
if [ $? ne 0 ]; then 
    echo "adding roboshop user to rabbitmq"
    rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
    Statuscheck $?
fi

echo " set roboshop user in rabbitmq as administrator"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
Statuscheck $?
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
Statuscheck $?