cd /etc/yum.repos.d/
sudo yum install -y wget
sudo wget https://storage.googleapis.com/arenadata-repo/ambari/2.6.3/repos/ambari.repo

sudo yum install -y ambari-server
(echo n; echo 1; echo y; echo y; echo n) | sudo ambari-server setup
sudo ambari-server start
