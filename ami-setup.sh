#!/bin/bash

# This is an attempt to automate setting up AMI from files in ec2-user's home folder.
# It probably requires much more work, especially with all the packages installed and all.
# This should be moved over to an ansible/puppet/chef configuration so it can leave outside AMI itself

cd /etc/update-motd.d/; sudo rm -f 30-banner; sudo ln -s /home/ec2-user/motd.banner 30-banner
sudo /usr/sbin/update-motd

cd /etc/init.d; sudo rm -f boot.sh; sudo ln -s /home/ec2-user/boot.sh
