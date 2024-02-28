script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input rabbitmq appuser password is missing
  exit 1
fi

echo -e "\e[32m>>>>>>>>>>> Install Golang <<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Copy Service File <<<<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/dispatch.service
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[32m>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>>>> Download App Content <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[32m>>>>>>>>>>> Download Dependencies <<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip
go mod init dispatch
go get
go build

echo -e "\e[32m>>>>>>>>>>> Start Dispatch Service <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch