NAME_NODE=89.208.228.72


ssh -o StrictHostKeyChecking=accept-new -i ../ssh/id_rsa centos@$NAME_NODE /bin/bash <<EOF
  sudo su - hdfs -c 'hdfs dfs -chmod -R 777 /user'
  sudo su - hdfs -c 'hdfs dfs -chmod -R 777 /var/log/spark/apps'
EOF