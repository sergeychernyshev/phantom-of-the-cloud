#!/bin/bash
REPO=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'git-repo:' | sed -e 's/git-repo: //'`
TARBALL=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'tarball-repo:' | sed -e 's/tarball-repo: //'`

AWS_KEY=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-key:' | sed -e 's/aws-key: //'`
AWS_SECRET=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-secret:' | sed -e 's/aws-secret: //'`
AWS_REGION=`/usr/bin/curl -s http://169.254.169.254/latest/user-data | grep 'aws-region:' | sed -e 's/aws-region: //'`

# create system.ini
echo "" >/home/ec2-user/system.ini

# populate fiels with AWS credentials if set in user data (otherwise relies on IAM roles that work on library level)
if [ ! -z "$AWS_KEY" ]; then
	echo "[aws]" >>/home/ec2-user/system.ini
	echo "aws-key = $AWS_KEY" >>/home/ec2-user/system.ini
	echo "aws-secret = $AWS_SECRET" >>/home/ec2-user/system.ini
	echo "aws-region = $AWS_REGION" >>/home/ec2-user/system.ini

	# More or less standard credentials file
	mkdir -p /home/ec2-user/.aws
	echo "[default]" >/home/ec2-user/.aws/credentials
	echo "region = $AWS_REGION" >>/home/ec2-user/.aws/credentials
	echo "aws_access_key_id = $AWS_KEY" >>/home/ec2-user/.aws/credentials
	echo "aws_secret_access_key = $AWS_SECRET" >>/home/ec2-user/.aws/credentials
	chown ec2-user.ec2-user -R /home/ec2-user/.aws
fi

echo "" >>/home/ec2-user/system.ini
echo "[repo]" >>/home/ec2-user/system.ini
echo "git-repo = $REPO" >>/home/ec2-user/system.ini
echo "tarball-repo = $TARBALL" >>/home/ec2-user/system.ini

# Getting the code from the repo provided in user data's git-repo attribute
su -l ec2-user -c /home/ec2-user/update-repo.sh

# Installing necessary yum packages
if [ -f /home/ec2-user/user-repo/yum_packages.lst ]; then
	cat /home/ec2-user/user-repo/yum_packages.lst | xargs yum install -y
fi

# Installing crontab if it's available
if [ -f /home/ec2-user/user-repo/crontab ]; then
	crontab -u ec2-user /home/ec2-user/user-repo/crontab
fi

# Let's run initialization script from repository if it's available
if [ -x /home/ec2-user/user-repo/init.sh ]; then
	su -l ec2-user -c /home/ec2-user/user-repo/init.sh
fi

if [ -d /home/ec2-user/user-repo/supervisord ]; then
	supervisord -c /home/ec2-user/supervisord/supervisord.conf
fi

if [ -f /home/ec2-user/user-repo/queue-cli.conf ]; then
	mkdir -p /etc/queue-cli
	ln -sf /home/ec2-user/user-repo/queue-cli.conf /etc/queue-cli/queue-cli.conf
fi
