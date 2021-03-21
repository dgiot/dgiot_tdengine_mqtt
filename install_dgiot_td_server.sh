#!/bin/bash
#1. 保存环境变量
export PATH=$PATH:/usr/local/bin
workdir=`pwd`
echo  $workdir

#setup mosquitto
rm mosquitto* -rf
wget http://ci.iotn2n.com/shuwa/oem/mosquitto-1.6.7.tar.gz -O /tmp/mosquitto-1.6.7.tar.gz
cd /tmp
tar xvf mosquitto-1.6.7.tar.gz
cd  mosquitto-1.6.7
make uninstall
make clean
make install
sudo ln -s /usr/local/lib/libmosquitto.so.1 /usr/lib/libmosquitto.so.1
ldconfig
cd ..
rm mosquitto*  -rf

#setup tdengine server
wget http://ci.iotn2n.com/shuwa/oem/TDengine-server-2.0.16.0-Linux-x64.tar.gz -O /tmp/TDengine-server-2.0.16.0-Linux-x64.tar.gz
cd /tmp
tar xf TDengine-server-2.0.16.0-Linux-x64.tar.gz
cd /tmp/TDengine-server-2.0.16.0-Linux-x64.tar.gz
/bin/sh install.sh.sh
ldconfig
rm /tmp/TDengine-server-2.0.16.0-Linux-x64 -rf

#setup tdengine client
wget http://ci.iotn2n.com/shuwa/oem/TDengine-client-2.0.16.0-Linux-x64.tar.gz -O /tmp/TDengine-client-2.0.16.0-Linux-x64.tar.gz
cd /tmp
tar xf TDengine-client-2.0.16.0-Linux-x64.tar.gz
cd /tmp/TDengine-client-2.0.16.0-Linux-x64
/bin/sh install_client.sh
ldconfig
rm /tmp/TDengine-client-2.0.16.0-Linux-x64 -rf

#编译dgiot_td_server桥接服务
cd $workdir/c
make
cp ./dgiot_td_server /usr/sbin/dgiot_td_server

systemctl stop dgiot_td_server
rm /usr/lib/systemd/system/dgiot_td_server.service  -rf
cat > /lib/systemd/system/dgiot_td_server.service << "EOF"
[Unit]
Description=dgiot_td_server

[Service]
Type=simple
ExecStart=/usr/sbin/dgiot_td_server 127.0.0.1 taosd root
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=300
OOMScoreAdjust=-1000
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable dgiot_td_server
systemctl start dgiot_td_server



