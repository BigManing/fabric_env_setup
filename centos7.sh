#!/usr/bin/env bash

echo 新建一个fabric-env目录，并在这个目录下工作
cd
mkdir fabric-env
cd fabric-env

echo -----1----pip 的安装
echo ---------
sudo yum -y install epel-release
sudo yum  -y  install python-pip
sudo pip  -y  install --upgrade pip

echo ----2-----docker的安装
echo ---------
echo 清除以前的
sudo yum  -y  remove docker  docker-common docker-selinux docker-engine
#sudo yum  -y  install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum list docker-ce --showduplicates | sort -r
sudo  yum  -y  install docker-ce
echo 修改docker镜像地址 官方的镜像库连接太慢,这里转到daocloud镜像库
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://91c0cc1e.m.daocloud.io

echo 添加用户组  重启
sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker restart
sudo systemctl restart docker

echo ----3-----docker-compose 的安装
echo ---------
sudo pip   install docker-compose
docker-compose -version

echo ----4-----node js 的安装
echo ---------
# wget https://npm.taobao.org/mirrors/node/v9.9.0/node-v9.9.0.tar.gz
echo  解压后 设置环境变量

echo ----5-----go 的安装
echo ---------

echo 下载go文件 
wget https://dl.google.com/go/go1.11.1.linux-amd64.tar.gz
tar -zxvf go1.11.1.linux-amd64.tar.gz

echo 创建gopath目录
mkdir -p  ~/gopath

echo 设置环境变量
echo "# go env" >> ~/.bashrc
echo 'export GOROOT="$HOME/rs/go"' >> ~/.bashrc
echo 'export GOPATH="$HOME/gopath"' >> ~/.bashrc
echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc