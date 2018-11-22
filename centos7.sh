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
    # Set up repository
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    # Use Aliyun Docker
    sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    # show version list
    # yum list docker-ce --showduplicates | sort -r
    sudo  yum  -y  install docker-ce
    echo  "change download source url ,you can skip this if you can touch offical address"
    curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://91c0cc1e.m.daocloud.io

    echo "add user group  and restart server . so you can use 'docker xx' instead of 'sudo docker xx'"
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo service docker restart
}

installDockerComposeUesPip(){
    printOperation "installDockerCompose"

    sudo pip   install docker-compose
    docker-compose -version
}

installDockerComposeUseOffical(){
    printOperation "installDockerCompose"

    sudo curl -L "https://github.com/docker/compose/releases/download/1.13.0/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
}

installNodejs(){
    printOperation "installNodejs"
    # 国内地址
    wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.9.1-linux-x64.tar.gz
    # 官方地址
    # wget  https://nodejs.org/download/release/v8.9.1/node-v8.9.1-linux-x64.tar.gz
    tar -zxf node-v8.9.1-linux-x64.tar.gz 

    echo "# node env" >> ~/.bash_profile
    echo "export PATH=$HOME/fabric-env/node-v8.9.1-linux-x64/bin:$PATH" >> ~/.bash_profile
    source ~/.bash_profile
}
installGo(){
    printOperation "installGo"
        
    # 国内地址
    wget https://studygolang.com/dl/golang/go1.9.7.linux-amd64.tar.gz
    # 官方地址 
    # wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
    tar -zxvf go1.9.7.linux-amd64.tar.gz
    echo "创建gopath目录"
    mkdir -p  $HOME/gopath

    echo "# go env" >> ~/.bash_profile
    echo "export GOROOT=$HOME/fabric-env/go" >> ~/.bash_profile
    echo "export GOPATH=$HOME/gopath" >> ~/.bash_profile
    echo "export PATH=$GOROOT/bin:$GOPATH/bin:$PATH" >> ~/.bash_profile
    source ~/.bash_profle
}

downloadFaricSource(){
    mkdir -p $GOPATH/src/github.com/hyperleder
    cd  $GOPATH/src/github.com/hyperleder
    git clone https://github.com/hyperledger/fabric.git
    git checkout release-1.1
} 

#-------------------------执行操作---------------------------------------

printOperation "1 开始安装基础环境"

installGit
installPip
installDocker
# installDockerComposeUesPip
installDockerComposeUseOffical
installGo
installNodejs


printOperation "2 下载fabric源码 并切换到1.1版本"

downloadFaricSource

printOperation "3 all  done   验证版本"

git --version
python -V
docker --version
docker-compose --version
node --version
npm --version      
go version