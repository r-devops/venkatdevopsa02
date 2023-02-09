COMPONENT=mysql 
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh 

# echo $1
# sleep 15 
# echo $#
# sleep 15 

if [ $# -eq 0 ]
then 
    echo " you need to pass the password of mysql to the script"
    echo " exiting the script"
    exit 1
fi 



source ./common.sh 

echo "setup the repo for mysql"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo  &>>$LOG_FILE
Statuscheck $?
dnf module disable mysql

echo "Install MySQL "
yum install mysql-community-server -y  &>>$LOG_FILE
Statuscheck $?


echo " Enable & Start MySQL"
systemctl enable mysqld   &>>$LOG_FILE
Statuscheck $?
systemctl start mysqld  &>>$LOG_FILE
Statuscheck $?


DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | cut -d " " -f 11)


 echo " ALTER USER 'root'@'localhost' IDENTIFIED BY '$1';
FLUSH PRIVILEGES; " > /tmp/set-root-passwd.sql


echo "show databases;" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD}
if [ $? -ne 0 ]; then 
echo " change the default password"
mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD} < /tmp/set-root-passwd.sql 
#&>>$LOG_FILE
#Statuscheck $?
echo " uninstall plugin validate_password; " | mysql -uroot -p$1 &>>$LOG_FILE
Statuscheck $?
fi 

echo " cleanup before installation"
rm -rf /tmp/mysql.zip &>>$LOG_FILE
Statuscheck $?
rm -rf /tmp/mysql-main &>>$LOG_FILE
Statuscheck $?

echo "download the database"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
Statuscheck $?

echo "Load the schema for Services"
cd /tmp
unzip mysql.zip
cd mysql-main
mysql -uroot -p$1 <shipping.sql  &>>$LOG_FILE
Statuscheck $?

