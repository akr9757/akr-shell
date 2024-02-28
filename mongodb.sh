script=$(realpath "$0")
script_path=$(dirname "${script}")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>>>> Copy Mongo Repo <<<<<<<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[32m>>>>>>>>>>> Install MongoDB <<<<<<<<<<<<<\e[0m"
dnf install mongodb-org -y

echo -e "\e[32m>>>>>>>>>>> Modify Listen Address <<<<<<<<<<<<<\e[0m"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf

echo -e "\e[32m>>>>>>>>>>> Start Mongod <<<<<<<<<<<<<\e[0m"
systemctl enable mongod
systemctl start mongod
systemctl restart mongod