script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<\e[0m"
dnf install nginx -y

echo -e "\e[32m>>>>>>>>>>> Copy Roboshop Conf <<<<<<<<<<<<<\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32m>>>>>>>>>>> Remove Default Content <<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[32m>>>>>>>>>>> Download Frontend Content <<<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[32m>>>>>>>>>>> Unzip Frontend Content <<<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[32m>>>>>>>>>>> Start Nginx Service <<<<<<<<<<<<<\e[0m"
systemctl enable nginx
systemctl start nginx
systemctl restart nginx