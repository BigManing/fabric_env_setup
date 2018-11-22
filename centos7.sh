#!/usr/bin/env bash

echo "creat fabric-env dir ,we will work in this floder"
cd
mkdir fabric-env
cd fabric-env  
# 打印操作说明
printOperation(){
    echo 
    echo 
    echo "-----------------------------$1----------------------------------"
    echo 
    echo 
}

installGit(){
    printOperation "installGit"
    sudo yum -y install git
}

installPip(){
    printOperation "install pip"
    sudo yum -y install epel-release
    sudo yum  -y  install python-pip
    sudo pip  -y  install --upgrade pip
}
installDocker(){
    printOperation "installDocker"
    sudo yum  -y  remove docker  docker-common docker-selinux docker-engine
    #sudo yum  -y  install -y yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum list docker-ce --showduplicates | sort -r
    sudo  yum  -y  install docker-ce
    echo  "change download source url ,you can skip this if you can touch offical address"
    curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://91c0cc1e.m.daocloud.io

    echo "add user group  and restart server . so you can use 'docker xx' instead of 'sudo docker xx'"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo service docker restart
}
installDockerCompose(){
    printOperation "installDockerCompose"

    sudo pip   install docker-compose
    docker-compose -version
}
installNodejs(){
    printOperation "installNodejs"
    # 国内地址
    wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.9.1.tar.gz
    # 官方地址
    # wget  https://nodejs.org/download/release/v8.9.1/node-v8.9.1-linux-x64.tar.gz
    tar -zxvf node-v8.9.1.tar.gz

    echo "# node env" >> ~/.bashrc
    echo "export PATH=$HOME/node-v8.9.1/bin:$PATH" >> ~/.bashrc
    source ~/.bashrc

}
installGo(){
    printOperation "installGo"
        
    # 国内地址
    wget https://studygolang.com/dl/golang/go1.9.7.linux-amd64.tar.gz
    # 官方地址 
    # wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
    tar -zxvf go1.9.7.linux-amd64.tar.gz
    echo "创建gopath目录"
    mkdir -p  ~/gopath

    echo "# go env" >> ~/.bashrc
    echo "export GOROOT=$HOME/fabric-env/go" >> ~/.bashrc
    echo "export GOPATH=$HOME/gopath" >> ~/.bashrc
    echo "export PATH=$GOROOT/bin:$GOPATH/bin:$PATH" >> ~/.bashrc
    source ~/.bashrc
}
 
echo "---------------------开始安装基础环境----------------------------"

installPip
installDocker
installDockerCompose
installGo
installNodejs


echo "---------------------下载fabric源码 并切换到1.1版本----------------------------"

mkdir -p $GOPATH/src/hyperleder
cd  $GOPATH/src/hyperleder
git clone https://github.com/hyperledger/fabric.git
git checkout release-1.1

echo "---------------------all  done ----------------------------"
