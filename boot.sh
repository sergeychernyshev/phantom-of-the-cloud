#!/bin/bash
#
# boot.sh	Get user's code and initialize it
#
# chkconfig: 3 30 60
# description: Gets user's code from repository provided in user-data and initializes it 
#

echo "PhantomOfTheCloud boot.sh starting" >/tmp/boot.log 2>/tmp/boot.err

# Get latest code
cd /home/ec2-user/
git pull

/home/ec2-user/init.sh >>/tmp/boot.log 2>>/tmp/boot.err
