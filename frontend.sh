script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh

func_print_head "Install Nginx"
dnf install nginx -y &>>$log_file
func_exit_status $?

func_print_head "Copy Roboshop Conf"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_exit_status $?

func_print_head "Remove Default Content"
rm -rf /usr/share/nginx/html/* &>>$log_file
func_exit_status $?

func_print_head "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_exit_status $?

func_print_head "Unzip Frontend Content"
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_exit_status $?

func_print_head "Start Nginx Service"
systemctl enable nginx
systemctl restart nginx
func_exit_status $?