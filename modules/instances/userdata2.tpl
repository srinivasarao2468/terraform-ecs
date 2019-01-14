#!/bin/bash
yum remove -y java
yum update -y
yum install -y java-1.8.0-openjdk-devel.x86_64
