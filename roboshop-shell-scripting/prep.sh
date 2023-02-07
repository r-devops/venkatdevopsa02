COMPONENT=prep 
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh 
echo "disable selinux"
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config &>>${LOG_FILE}
Statuscheck $?

echo "install git on it"
yum install -y git  &>>${LOG_FILE}
Statuscheck $?
