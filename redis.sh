script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh

func_print_head "Download Redis Repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
func_exit_status $?

func_print_head "Enable Redis"
dnf module enable redis:remi-6.2 -y&>>$log_file
func_exit_status $?

func_print_head "Install Redis"
dnf install redis -y &>>$log_file
func_exit_status $?

func_print_head "Modify Listen Address"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf &>>$log_file
func_exit_status $?

func_print_head "Start Redis"
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
func_exit_status $?