#!/bin/bash
export PATH=$PATH:/usr/local/bin
sudo apt-get -y update
sudo apt-get -y install apache2
sudo rm /var/www/html/index.html
sudo echo "<H1>This is from WEB 2</H1>" >> index.html
sudo cp index.html /var/www/html/index.html