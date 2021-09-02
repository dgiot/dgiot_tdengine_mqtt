#!/bin/bash
#1. 保存环境变量
export PATH=$PATH:/usr/local/bin
workdir=`pwd`
echo  $workdir

#setup mosquitto
rm mosquitto* -rf
wget http://dgiot-1253666439.cos.ap-shanghai-fsi.myqcloud.com/dgiot_release/v4.4.0/mosquitto-1.6.7.tar.gz -O /tmp/mosquitto-1.6.7.tar.gz
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
wget http://dgiot-1253666439.cos.ap-shanghai-fsi.myqcloud.com/dgiot_release/v4.4.0/TDengine-server-2.0.20.13.tar.gz -O /tmp/TDengine-server-2.0.20.13.tar.gz
cd /tmp
tar xf TDengine-server-2.0.20.13.tar.gz
cd /tmp/TDengine-server-2.0.20.13
/bin/sh install.sh.sh
ldconfig
rm /tmp/TDengine-server-2.0.20.13 -rf


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
ExecStart=/usr/sbin/dgiot_td_server 127.0.0.1
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



