# Welcome to LCSEE myLOUD on rails
=================================

*Please see repo [mycloud](https://webgit.lcseecloud.net/lcseesystems/mycloud) for old commits*

### Dev Environment

You will need an AWS account and AWS access keys. Get your keys and
create this config file (This will not be stored in version control):

_{RAILS_ROOT}/config/aws.yml_
```
development:
  access_key_id: 'PUT_KEY_HERE'
  secret_access_key: 'PUT_KEY_HERE'
```

You will also need to create a VPC in AWS. Once you do you will need
to put the VPC ID and subnet ID in {RAILS_ROOT}/config/aws_configs.yml
in the development section. As for AMIs I've just been using the stock
Ubuntu AMI provided by Amazon to use for testing.  You can find the ID
by launching an EC2 instance and looking through the quick start AMI
page.

### Setting up cron to shut off idle instances

This app is designed to shut off instances after a certain amount of
time using a cronjob that runs every 15 minutes. After you install
your gems you will need to update your crontabs for this feature to be
fully functional.

_from {RAILS_ROOT}_
```
$ whenever --update-crontab myloud --set environment=[RAILS_ENV]
```  
