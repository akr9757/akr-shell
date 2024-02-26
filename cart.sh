dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
cp /home/centos/akr-shell/cart.service /etc/systemd/system/cart.service
useradd roboshop
rm -rf /app
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install
systemctl daemon-reload
systemctl enable cart
systemctl restart cart