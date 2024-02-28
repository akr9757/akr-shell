echo -e "\e[32m>>>>>>>>>>> Copy Mysql Repo <<<<<<<<<<<<<\e[0m"
cp /home/centos/akr-shell/mysql.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>> Install Mysql <<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y
dnf install mysql-community-server -y

echo -e "\e[32m>>>>>>>>>>> Set Mysql Password <<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1

echo -e "\e[32m>>>>>>>>>>> Start Mysql <<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld