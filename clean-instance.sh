#!/bin/bash
#
# This script cleans the instance so it can be re-AMI-ized
# 

# History and dev cleanup
rm -f ~/.bash_history
rm -f ~/.viminfo
rm -f ~/.lesshst
rm -f ~/.gitconfig

# User-data cleanup
rm -rf ~/user-repo
rm -rf ~/user-logs/*

# Removing supervisord logs
sudo killall supervisord
rm -rf ~/supervisord/logs/*

# PhantomJS cleanup
rm -rf ~/.fontconfig
rm -rf ~/.qws

# Removing crontabs
crontab -r

# System info cleanup
rm -f system.ini
rm -f ~/.aws

sudo rm -f /tmp/boot.err /tmp/boot.log
