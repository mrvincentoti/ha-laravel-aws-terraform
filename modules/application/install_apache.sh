#!/bin/bash -xe

DB_NAME="${DB_NAME}"
DB_HOSTNAME="${DB_HOSTNAME}"
DB_USERNAME="${DB_USERNAME}"
DB_PASSWORD="${DB_PASSWORD}"

WP_ADMIN="wordpressadmin"
WP_PASSWORD="wordpressadminn"

LB_HOSTNAME="${LB_HOSTNAME}"


sudo yum update -y
sudo yum install -y httpd
sudo service httpd start

# Install git
# sudo yum install -y git

# Install php and composer
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo curl -sS https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
sudo ln -s /usr/local/bin/composer /usr/bin/composer

# Create a static html file
sudo touch /var/www/html/index.php
echo "<html><head><title>Test</title></head><body><?php $ip_server = $_SERVER['SERVER_ADDR']; echo 'Server IP Address is: $ip_server';?></body></html>" > /var/www/html/index.php
# Install laravel
#sudo composer create-project laravel/laravel poll-analysis
# Clone project from git
# git clone https://github.com/mrvincentoti/poll-analysis.git

# Deploy poll application
#sudo cp -r poll-analysis/* /var/www/html/

# Create .env file
# sudo touch /var/www/html/.env
# echo "APP_NAME=Laravel" >> /var/www/html/.env
# echo "APP_ENV=local" >> /var/www/html/.env
# echo "APP_KEY=shdkldjsdkdnaadknnkaddjdjkd" >> /var/www/html/.env
# echo "APP_DEBUG=true" >> /var/www/html/.env
# echo "APP_URL=${LB_HOSTNAME}" >> /var/www/html/.env

# echo "LOG_CHANNEL=stack" >> /var/www/html/.env
# echo "LOG_DEPRECATIONS_CHANNEL=null" >> /var/www/html/.env
# echo "LOG_LEVEL=debug" >> /var/www/html/.env

# echo "DB_CONNECTION=mysql" >> /var/www/html/.env
# echo "DB_HOST=${DB_HOSTNAME}" >> /var/www/html/.env
# echo "DB_PORT=3306" >> /var/www/html/.env
# echo "DB_DATABASE=${DB_NAME}" >> /var/www/html/.env
# echo "DB_USERNAME=${DB_USERNAME}" >> /var/www/html/.env
# echo "DB_PASSWORD=${DB_PASSWORD}" >> /var/www/html/.env

# Install project dependencies
# cd /var/www/html && composer install

# Restart httpd
sudo chkconfig httpd on
sudo service httpd start
sudo service httpd restart
#Restart httpd after a while
setsid nohup "sleep 480; sudo service httpd restart" &