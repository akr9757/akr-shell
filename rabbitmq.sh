echo -e "\e[32m>>>>>>>>>>> Download RabbitMQ <<<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[32m>>>>>>>>>>> Install rABBITMQ <<<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"

echo -e "\e[32m>>>>>>>>>>> Start Rabbitmq Service <<<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server