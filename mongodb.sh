script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh

func_print_head "Copy Mongo Repo"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_exit_status $?

func_print_head "Install MongoDB"
dnf install mongodb-org -y &>>$log_file
func_exit_status $?

func_print_head "Modify Listen Address"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf &>>$log_file

func_print_head "Start Mongod"
systemctl enable mongod &>>$log_file
systemctl start mongod &>>$log_file
systemctl restart mongod &>>$log_file
func_exit_status $?
