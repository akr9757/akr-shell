echo -e "\e[32m>>>>>>>>>>> Disable Default Version <<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[32m>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[32m>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>> Copy user Service <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/user.service /etc/systemd/system/user.service

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<\e[0m"
rm -rf app
mkdir /app

echo -e "\e[32m>>>>>>>>>>> Download user Content <<<<<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip

echo -e "\e[32m>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip

echo -e "\e[32m>>>>>>>>>>> Nodejs Dependencies <<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[32m>>>>>>>>>>> Start user Service  <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user
