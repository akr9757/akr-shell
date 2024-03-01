script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input mysql root password is missing
  exit 1
fi

func_print_head "Copy Mysql Repo"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mongo.repo &>>$log_file
func_exit_status $?

func_print_head "Install Mysql"
dnf module disable mysql -y &>>$log_file
dnf install mysql-community-server -y &>>$log_file
func_exit_status $?

func_print_head "Set Mysql Password"
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
mysql -uroot -pRoboShop@1
func_exit_status $?

func_print_head "Start Mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_exit_status $?