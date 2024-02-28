echo -e "\e[32m>>>>>>>>>>> Download Redis Repo <<<<<<<<<<<<<\e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[32m>>>>>>>>>>> Enable Redis <<<<<<<<<<<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[32m>>>>>>>>>>> Install Redis <<<<<<<<<<<<<\e[0m"
dnf install redis -y

echo -e "\e[32m>>>>>>>>>>> Modify Listen Address <<<<<<<<<<<<<\e[0m"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[32m>>>>>>>>>>> Start Redis <<<<<<<<<<<<<\e[0m"
systemctl enable redis
systemctl restart redis