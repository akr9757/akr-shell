echo -e "\e[32m>>>>>>>>>>> Install Golang <<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Copy Service File <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/dispatch.service /etc/systemd/system/dispatch.service

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