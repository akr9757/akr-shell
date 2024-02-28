script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input rabbitmq appuser password is missing
  exit 1
fi

echo -e "\e[32m>>>>>>>>>>> Install Python <<<<<<<<<<<<<\e[0m"
dnf install python36 gcc python3-devel -y

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Copy Payment Service <<<<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/dispatch.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

echo -e "\e[32m>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>>>> Download Payment Content <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip

echo -e "\e[32m>>>>>>>>>>> Download App Dependencies <<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip
pip3.6 install -r requirements.txt

echo -e "\e[32m>>>>>>>>>>> Start Payment Service <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment