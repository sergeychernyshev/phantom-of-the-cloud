Phantom Of The Cloud
====================

To use this Amazon AMI, just launch an instance and send following values within user data:

    git-repo: <url-to-git-repo>
    aws-key: <amazon-aws-security-key>
    aws-secret: <amazon-aws-secret>

During boot process, this image will clone the repo you specified and will create `/home/ec2-user/system.ini` file with specified parameters so your app can read them later.

You should also include at least one of these files as part of your repo:
* `/crontab` - crontab that will be installed for `ec2-user` user
* `/init.sh` - shell script that will be executed after repo is cloned
* `/supervisord/supervisord.conf` - supervisord config that will be installed in the system

This is how this image will know to start your apps.

Usually, your apps will be some kind of independent crawler or worker that will read data from Amazon SQS queue or SNS topic, do work and output results back into SQS/SNS or save to S3 or ping an external web service.

This allows you to spin up a bunch of instances to scale to high amount of work, you can utilize autoscaling groups based on group CPU usage or SQS queue lengh to scale your farm up and down.
