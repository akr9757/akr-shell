app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "${script}")

func_print_head() {
  echo -e "\e[32m>>>>>>>>>>> $1 <<<<<<<<<<<<<\e[0m"
}

func_exit_status() {
  if [ $1 != 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[34mFAILURE\e[0m"
    exit 1
  fi
}

func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copy Mongo Repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    func_exit_status $?

    func_print_head "Install Mongodb Client"
    dnf install mongodb-org-shell -y
    func_exit_status $?

    func_print_head "Load Schema"
    mongo --host mongodb.akrdevopsb72.online </app/schema/${component}.js
    func_exit_status $?
  fi
}

func_nodejs() {
  func_print_head "Disable Default Version"
  dnf module disable nodejs -y
  func_exit_status $?

  func_print_head "Install Nodejs"
  dnf module enable nodejs:18 -y
  dnf install nodejs -y
  func_exit_status $?

  func_print_head "Copy ${component} Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  func_exit_status $?

  func_print_head "Add Application User"
  useradd ${app_user}
  func_exit_status $?

  func_print_head "Add Application Directory"
  rm -rf app
  mkdir /app
  func_exit_status $?

  func_print_head "Download ${component} Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  func_exit_status $?

  func_print_head "Unzip App Content"
  cd /app
  unzip /tmp/${component}.zip
  func_exit_status $?

  func_print_head "Nodejs Dependencies"
  npm install
  func_exit_status $?

  func_print_head "Start ${component} Service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_exit_status $?

  func_schema_setup
}