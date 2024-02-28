echo -e "\e[32m>>>>>>>>>>> Install Maven <<<<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[32m>>>>>>>>>>> Copy Shipping Service File <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[32m>>>>>>>>>>> Add Application User <<<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[32m>>>>>>>>>>> Add Application Directory <<<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m>>>>>>>>>>> Download App Content <<<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[32m>>>>>>>>>>> Download Dependencies <<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[32m>>>>>>>>>>> Install Mysql Client <<<<<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[32m>>>>>>>>>>> Load Schema <<<<<<<<<<<<<\e[0m"
mysql -h mysql.akrdevopsb72.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[32m>>>>>>>>>>> Start Shipping Service <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping