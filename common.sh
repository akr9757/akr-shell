app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "${script}")
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[32m>>>>>>>>>>> $1 <<<<<<<<<<<<<\e[0m"
  echo -e "\e[32m>>>>>>>>>>> $1 <<<<<<<<<<<<<\e[0m" &>>$log_file
}

func_exit_status() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[34mFAILURE\e[0m"
    echo refer the log file /tmp/roboshop.log for more information
    exit 1
  fi
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongo Repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    func_exit_status $?

    func_print_head "Install Mongodb Client"
    dnf install mongodb-org-shell -y &>>$log_file
    func_exit_status $?

    func_print_head "Load Schema"
    mongo --host mongodb.akrdevopsb72.online </app/schema/${component}.js &>>$log_file
    func_exit_status $?
  fi
  if [ "${schema_setup}" == "mysql" ]; then
    func_print_head "Install Mysql Client"
    dnf install mysql -y

    func_print_head "Load Schema"
    mysql -h mysql.akrdevopsb72.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  fi
}

func_systemd_setup() {
    func_print_head "Copy ${component} Service"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
    func_exit_status $?

    func_print_head "Start ${component} Service"
    systemctl daemon-reload &>>$log_file
    systemctl enable ${component} &>>$log_file
    systemctl restart ${component} &>>$log_file
    func_exit_status $?
}

func_app_prereq() {
  func_print_head "Add Application User"
  id ${app_user} &>>$log_file
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>$log_file
  fi
  func_exit_status $?

  func_print_head "Add Application Directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_exit_status $?

  func_print_head "Download ${component} Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_exit_status $?

  func_print_head "Unzip App Content"
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_exit_status $?
}

func_nodejs() {
  func_print_head "Disable Default Version"
  dnf module disable nodejs -y &>>$log_file
  func_exit_status $?

  func_print_head "Install Nodejs"
  dnf module enable nodejs:18 -y &>>$log_file
  dnf install nodejs -y &>>$log_file
  func_exit_status $?

  func_app_prereq

  func_print_head "Nodejs Dependencies"
  npm install &>>$log_file
  func_exit_status $?

  func_schema_setup

  func_systemd_setup
}

func_java() {
  func_print_head "Install Maven"
  dnf install maven -y &>>$log_file
  func_exit_status $?

  func_app_prereq

  func_print_head "Download Dependencies"
  mvn clean package &>>$log_file
  func_exit_status $?
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_exit_status $?

  func_schema_setup

  func_systemd_setup
}

func_python() {
  func_print_head "Install Python"
  dnf install python36 gcc python3-devel -y &>>$log_file
  func_exit_status $?

  func_app_prereq

  func_print_head "Download Dependencies"
  pip3.6 install -r requirements.txt &>>$log_file
  func_exit_status $?

  func_print_head "Copy ${component} Service"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file

  func_systemd_setup
}

func_golang() {
  func_print_head "Install Golang"
  dnf install golang -y
  func_exit_status $?

  func_app_prereq

  func_print_head "Download Dependencies"
  go mod init dispatch &>>$log_file
  go get &>>$log_file
  go build &>>$log_file
  func_exit_status $?

  func_print_head "Copy Service File"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>>$log_file

  func_systemd_setup
}