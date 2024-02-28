script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input mysql root password is missing
  exit 1
fi

echo -e "\e[32m>>>>>>>>>>> Install Maven <<<<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[32m>>>>>>>>>>> Copy Shipping Service File <<<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

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
mysql -h mysql.akrdevopsb72.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[32m>>>>>>>>>>> Start Shipping Service <<<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping