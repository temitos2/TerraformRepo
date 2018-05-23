#!/bin/bash
yum install -y mysql-server
service mysqld start
chkconfig --levels 235 mysqld on
