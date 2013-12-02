#!/bin/bash

REPO=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'git-repo:' | sed -e 's/git-repo: //'`
AWS_KEY=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-key:' | sed -e 's/aws-key: //'`
AWS_SECRET=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-secret:' | sed -e 's/aws-secret: //'`

echo "[aws]" >/home/ec2-user/system.ini
echo "aws-key = $AWS_KEY" >>/home/ec2-user/system.ini
echo "aws-secret = $AWS_SECRET" >>/home/ec2-user/system.ini

echo "[repo]" >>/home/ec2-user/system.ini
echo "git-repo = $REPO" >>/home/ec2-user/system.ini

if [ -d /home/ec2-user/user-repo ]; then
	cd /home/ec2-user/user-repo
	/usr/bin/git pull 
else
	/usr/bin/git clone $REPO /home/ec2-user/user-repo
fi
