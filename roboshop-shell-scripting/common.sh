
APP_PREREQ() {

}

SYSTEMD_SETUP() {

}

NODEJS() {
    echo " Setup NodeJS on the VM"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
    Statuscheck $?
    
    yum install nodejs -y


}

JAVA () {

}

PYTHON() {

}

GOLANG() {

}