script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo input rabbitmq appuser password is missing
  exit 1
fi

echo -e "\e[32m>>>>>>>>>>> Download RabbitMQ <<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[32m>>>>>>>>>>> Install rABBITMQ <<<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo -e "\e[32m>>>>>>>>>>> Start Rabbitmq Service <<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server