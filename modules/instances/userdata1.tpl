#!/bin/bash
yum remove -y java
yum update -y
yum install -y java-1.8.0-openjdk-devel.x86_64
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum -y install jenkins
service jenkins start
chkconfig jenkins on
