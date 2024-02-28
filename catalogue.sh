echo -e "\e[32m>>>>>>>>>>> Disable Default Version <<<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y

echo -e "\e[32m>>>>>>>>>>> Install Nodejs <<<<<<<<<<<<<\e[0m"
dnf module enable nodejs:18 -y
dnf install nodejs -y

echo -e "\e[32m>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>> Copy Catalogue Service <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<\e[0m"
rm -rf app
mkdir /app

echo -e "\e[32m>>>>>>>>>>> Download Catalogue Content <<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo -e "\e[32m>>>>>>>>>>> Unzip App Content <<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip

echo -e "\e[32m>>>>>>>>>>> Nodejs Dependencies <<<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[32m>>>>>>>>>>> Install Mongodb Client <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[32m>>>>>>>>>>> Load Schema <<<<<<<<<<<<<\e[0m"
mongo --host mongodb.akrdevopsb72.online </app/schema/catalogue.js

echo -e "\e[32m>>>>>>>>>>> Start Catalogue Service  <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue