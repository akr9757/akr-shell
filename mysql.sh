script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo input mysql root password is missing
  exit 1
fi

echo -e "\e[32m>>>>>>>>>>> Copy Mysql Repo <<<<<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>> Install Mysql <<<<<<<<<<<<<\e[0m"
dnf module disable mysql -y
dnf install mysql-community-server -y

echo -e "\e[32m>>>>>>>>>>> Set Mysql Password <<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}

echo -e "\e[32m>>>>>>>>>>> Start Mysql <<<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld