dnf install maven -y
cp /home/centos/akr-shell/shipping.service /etc/systemd/system/shipping.service
useradd roboshop
rm -rf /app
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
mvn clean package
mv target/shipping-1.0.jar shipping.jar
dnf install mysql -y
mysql -h mysql.akrdevopsb72.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping