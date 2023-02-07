COMPONENT=frontend 
LOG_FILE=/tmp/${COMPONENT}
source ./common.sh 

echo "Clean up"
yum remove nginx &>>${LOG_FILE}
Statuscheck $?
rm -rf /etc/nginx &>>${LOG_FILE}
Statuscheck $?

echo "Install Nginx & starting the service"
yum install nginx -y &>>${LOG_FILE}
Statuscheck $?
systemctl enable nginx &>>${LOG_FILE}
Statuscheck $?
systemctl start nginx &>>${LOG_FILE}
Statuscheck $?



echo "Let's download the HTDOCS content and deploy under the Nginx path."
rm -rf /tmp/frontend.zip
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
Statuscheck $?

echo "Deploy the downloaded content in Nginx Default Location."
cd /usr/share/nginx/html
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf  &>>${LOG_FILE}
Statuscheck $?


/etc/nginx/default.d/roboshop.conf

# ```

# Finally restart the service once to effect the changes.

systemctl restart nginx &>>${LOG_FILE}
Statuscheck $?
