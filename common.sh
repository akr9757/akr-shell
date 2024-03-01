app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "${script}")
log_file=/tmp/roboshop.log

func_print_head() {
  echo -e "\e[32m>>>>>>>>>>> $1 <<<<<<<<<<<<<\e[0m"
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
}

func_nodejs() {
  func_print_head "Disable Default Version"
  dnf module disable nodejs -y &>>$log_file
  func_exit_status $?

  func_print_head "Install Nodejs"
  dnf module enable nodejs:18 -y &>>$log_file
  dnf install nodejs -y &>>$log_file
  func_exit_status $?

  func_print_head "Copy ${component} Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_exit_status $?

  func_print_head "Add Application User"
  id ${app_user} &>>$log_file
  if [ $? -eq 0 ]; then
    useradd ${app_user}
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

  func_print_head "Nodejs Dependencies"
  npm install &>>$log_file
  func_exit_status $?

  func_print_head "Start ${component} Service"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_exit_status $?

  func_schema_setup
}