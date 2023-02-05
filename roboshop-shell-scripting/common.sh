
ID=$(id -u)

if [ $ID -ne 0 ]; then 
    echo "you are not running as root and this will fail"
    exit 1
fi     


Statuscheck() {
    if [ $1 -eq 0 ]; then 
    echo -e status ="\e[32Sucess\e[0m"
    else
    echo -e status ="\e[31Failed\e[0m"
    exit 1
    fi 

}


APP_PREREQ() {

    echo " validate whether roboshop user is alreday exists or not"
    id roboshop &>>${LOG_FILE}

    if [ $? -ne 0 ]; then 
    echo " adding user robohop to the VM "
    useradd roboshop &>>${LOG_FILE}
    Statuscheck $?
    fi 

    echo "Download ${COMPONENT} Application code"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
    Statuscheck $?

    echo "stoping the service before cleanup"
    systemctl stop ${COMPONENT}.service

    echo " remove old content if exists - make the script compatable to re-run"
    cd /home/roboshop && rm -rf ${COMPONENT}  &>>${LOG_FILE}
    Statuscheck $?

    echo "extract the application "
    unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
    Statuscheck $?


    mv ${COMPONENT}-main ${COMPONENT}

}

SYSTEMD_SETUP() {

    echo " Updating the systemD service file with DNS name"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e  's/AMQPHOST/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
    Statuscheck $?

    echo "Setting the service tr=o run "
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    Statuscheck $?

    echo "reloading the config from disk "
    systemctl daemon-reload

    echo "reloadstarting the service "
    systemctl start ${COMPONENT} &>>${LOG_FILE}
    Statuscheck $?
    
    echo "enable the service "
    systemctl enable ${COMPONENT} &>>${LOG_FILE}     
    Statuscheck $?

}

NODEJS() {
    echo " Setup NodeJS on the VM"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
    Statuscheck $?
    
    echo "Install Nodejs "
    yum install nodejs -y &>>${LOG_FILE}
    Statuscheck $?

    APP_PREREQ
    
    echo "Install NodeJs dependencies"
    cd /home/roboshop
    cd  ${COMPONENT}
    npm install &>>${LOG_FILE}
    Statuscheck $?

    SYSTEMD_SETUP


}

MAVEN() {

    echo "Install maven"
    yum install maven -y &>>${LOG_FILE}
    Statuscheck $?

    APP_PREREQ

    echo " Installing the dependencies "
    cd /home/roboshop
    cd ${COMPONENT}
    mvn clean package  &>>${LOG_FILE}
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar  &>>${LOG_FILE}
    Statuscheck $?

    SYSTEMD_SETUP

}

PYTHON() {

    echo " Installing Python on the VM "
    yum install python36 gcc python3-devel -y  &>>${LOG_FILE}
    Statuscheck $?

    APP_PREREQ

    echo " Installing the dependencies "
    cd /home/roboshop
    cd ${COMPONENT}
    #cd /home/${COMPONENT}/ 
    pip3 install -r requirements.txt &>>${LOG_FILE}
    Statuscheck $?

    SYSTEMD_SETUP


}

GOLANG() {

    echo " Installing golang "
    yum install golang -y &>>${LOG_FILE}
    Statuscheck $?

    APP_PREREQ

    echo " Installing the dependencies "
    cd /home/roboshop
    cd ${COMPONENT}
    #cd /home/${COMPONENT}/
    go mod init dispatch &>>${LOG_FILE}
    Statuscheck $?

    echo "Doing the golang build"
    go get 
    go build &>>${LOG_FILE}
    Statuscheck $?

    SYSTEMD_SETUP

}