#!/bin/bash

cd /etc/update-motd.d/; sudo rm -f 30-banner; sudo ln -s /home/ec2-user/motd.banner 30-banner
sudo /usr/sbin/update-motd

cd /etc/init.d; sudo rm -f boot.sh; sudo ln -s /home/ec2-user/boot.sh
