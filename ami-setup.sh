#!/bin/bash

cd /etc; sudo rm -f motd.head; sudo ln -s /home/ec2-user/motd.head
sudo /usr/sbin/update-motd

cd /etc/init.d; sudo rm -f boot.sh; sudo ln -s /home/ec2-user/boot.sh
