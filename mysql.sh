cp /home/centos/akr-shell/mysql.repo /etc/yum.repos.d/mongo.repo
dnf module disable mysql -y
dnf install mysql-community-server -y
mysql_secure_installation --set-root-pass RoboShop@1
mysql -uroot -pRoboShop@1
systemctl enable mysqld
systemctl start mysqld