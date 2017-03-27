#nohup /usr/local/bin/consul agent -server -config-dir=/etc/consul.d/server -data-dir=/opt/consul/data -bind=`ifconfig eth0 |grep -w inet |awk '{print $2}'` &

#### /usr/local/bin/consul join node1 node2 node3 

nohup /usr/local/bin/docker daemon -H `ifconfig eth0 |grep -w inet |awk '{print $2}'`:2375 --cluster-advertise `ifconfig eth0 |grep -w inet |awk '{print $2}'`:2375 --cluster-store consul://`ifconfig eth0 |grep -w inet |awk '{print $2}'`:8500/VIT --label=com.docker.network.driver.overlay.bind_interface=eth0 &

nohup /usr/local/bin/swarm join --addr=`ifconfig eth0 |grep -w inet |awk '{print $2}'`:2375 consul://`ifconfig eth0 |grep -w inet |awk '{print $2}'`:8500/VIT &

nohup /usr/local/bin/swarm manage -H tcp://`ifconfig eth0 |grep -w inet |awk '{print $2}'`:4000 --replication --advertise `ifconfig eth0 |grep -w inet |awk '{print $2}'`:4000 consul://`ifconfig eth0 |grep -w inet |awk '{print $2}'`:8500/VIT &
