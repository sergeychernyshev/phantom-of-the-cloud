#!/bin/bash
#
# boot.sh	Get user's code and initialize it
#
# chkconfig: 3 30 60
# description: Gets user's code from repository provided in user-data and initializes it 
#

echo "PhantomOfTheCloud boot.sh starting" >/tmp/boot.log
>/tmp/boot.err

REPO=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'git-repo:' | sed -e 's/git-repo: //'`
AWS_KEY=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-key:' | sed -e 's/aws-key: //'`
AWS_SECRET=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-secret:' | sed -e 's/aws-secret: //'`

echo "[aws]" >/home/ec2-user/system.ini
echo "aws-key = $AWS_KEY" >>/home/ec2-user/system.ini
echo "aws-secret = $AWS_SECRET" >>/home/ec2-user/system.ini
echo "" >>/home/ec2-user/system.ini
echo "[repo]" >>/home/ec2-user/system.ini
echo "git-repo = $REPO" >>/home/ec2-user/system.ini

# Getting the code from the repo provided in user data's git-repo attribute
su -l ec2-user -c /home/ec2-user/update-repo.sh 2>>/tmp/boot.err >>/tmp/boot.log

# Installing crontab if it's available
if [ -f /home/ec2-user/user-repo/crontab ]; then
	crontab -u ec2-user /home/ec2-user/user-repo/crontab 2>>/tmp/boot.err >>/tmp/boot.log
fi

# Let's run initialization script from repository if it's available
if [ -x /home/ec2-user/user-repo/init.sh ]; then
	su -l ec2-user -c /home/ec2-user/user-repo/init.sh 2>>/tmp/boot.err >>/tmp/boot.log
fi

if [ -d /home/ec2-user/user-repo/supervisord ]; then
	supervisord -c /home/ec2-user/supervisord/supervisord.conf
fi

