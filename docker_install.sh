#!/bin/bash

# Allow toggling components to install and update based off flags
updateconsul=1
updatedocker=1
updatedockermachine=1
updatedockercompose=1
updatedockerswarm=1

consulversion="0.5.2"
dockerversion="1.9.0"
dockermachineversion="v0.5.0"
dockercomposeversion="1.5.1"
dockerswarmversion="1.0.0"

echo ""
echo "Updating Consul($updateconsul)"
echo "Updating Docker($updatedocker)"
echo "Updating Docker Machine($updatedockermachine)"
echo "Updating Docker Compose($updatedockercompose)"
echo "Updating Docker Swarm($updatedockerswarm)"

echo ""
echo "Starting Install"
echo ""

if [ $updateconsul -eq 1 ]; then

  echo ""
  echo "Installing Consul version: $consulversion"
  echo ""
  pushd /tmp >> /dev/null
  rm -f /tmp/consul.zip
  rm -f /tmp/consul
  wget https://releases.hashicorp.com/consul/${consulversion}/consul_${consulversion}_linux_amd64.zip -O /tmp/consul.zip
  unzip consul.zip
  cp ./consul /usr/local/bin
  cp ./consul /usr/bin
  rm -f /tmp/consul.zip
  rm -f /tmp/consul
  popd >> /dev/null
  echo ""
  echo "Done Installing Consul version: $consulversion"
  echo ""
fi

# Docker 1.9 is not shipped in an rpm yet:
if [ $updatedocker -eq 1 ]; then
  echo ""
  echo "Installing Docker version: $dockerversion"
  echo ""
  # To install, run the following command as root:
  curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-${dockerversion} && chmod +x docker-${dockerversion} && mv docker-${dockerversion} /usr/local/bin/docker
  echo ""
  echo "Done Installing Docker version: $dockerversion"
  echo ""
fi

# Now install Docker-Machine: https://github.com/docker/machine/releases/
if [ $updatedockermachine -eq 1 ]; then
  echo ""
  echo ""
  curl -L https://github.com/docker/machine/releases/download/${dockermachineversion}/docker-machine_linux-amd64.zip >machine.zip && \
  unzip machine.zip && \
  rm machine.zip && \
  mv -f docker-machine* /usr/local/bin
  echo ""
  echo "Done Installing Docker Machine version: $updatedockermachine"
  echo ""
fi

# Now install Docker-Compose: https://github.com/docker/compose/releases/
if [ $updatedockercompose -eq 1 ]; then
  echo ""
  echo "Installing Docker Compose version: $dockercomposeversion"
  echo ""
  curl -L https://github.com/docker/compose/releases/download/${dockercomposeversion}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  echo ""
  echo "Done Installing Docker Compose version: $updatedockercompose"
  echo ""
fi

# Now install Docker-Swarm: https://github.com/docker/swarm/releases
cd /opt; wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
yum install git -y
cd /usr/local 
tar xzf /opt/go1.7.3.linux-amd64.tar.gz

if [ $updatedockerswarm -eq 1 ]; then
  echo ""
  echo "Installing Docker Swarm version: $dockerswarmversion"
  echo ""
  pushd /opt >> /dev/null
  goworkspacepath="/opt/goworkspace/"
  if [ ! -e $goworkspacepath ]; then
      mkdir $goworkspacepath >> /dev/null
      chmod 777 $goworkspacepath >> /dev/null
  fi
  export GOPATH=$goworkspacepath
  echo " - Using GOPATH($GOPATH) set this in ./common.sh if you want to override"
  /usr/local/go/bin/go get github.com/docker/swarm
  chmod 777 $GOPATH/bin/swarm

  rm -f /usr/local/bin/swarm >> /dev/null
  ln -s $GOPATH/bin/swarm /usr/local/bin/swarm

  pushd >> /dev/null
  echo ""
  echo "Done Installing Docker Swarm version: $updatedockerswarm"
  echo ""
fi

mkdir -p /etc/consul.d/server /opt/consul/data
echo '{ 
"datacenter" : "VIT", 
"bootstrap" : false, 
"bootstrap_expect" : 3, 
"server" : true, 
"data_dir" : "/opt/consul/data", 
"log_level" : "INFO", 
"enable_syslog" : false, 
"start_join" : [], 
"retry_join" : [], 
"client_addr" : "0.0.0.0" 
}' >/etc/consul.d/server/config.json 

echo
echo
echo
echo "RUN THE FOLLOWING COMMANDS"
echo "nohup /usr/local/bin/consul agent -server -config-dir=/etc/consul.d/server -data-dir=/opt/consul/data -bind=`ifconfig eth0 |grep -w inet |awk '{print $2}'` &"
