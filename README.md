# dgiot_tdengine_mqtt
   2019年下半年在准备做3000万电表和1500万zetag压测时,开始尝试使用tdengine作为DG-IoT的主时序数据库，目前已与DG-IoT的物模型、数据管理权限、消息路由和消息缓存无缝对接，并在多个商用项目中落地.
   
  对于千万级设备时序数据无丢包实时落库难题，我们尝试了用erlang port, erlang nif, java jdbc, http resful等多种方法来解决这个技术难题，最后发现还是tdengine原生的落库方法效果是最好的，代码行数也只有100多行。
# 部署
  ``` shell script
    git clone https://hub.fastgit.org/dgiot/dgiot_tdengine_mqtt.git
    cd dgiot_tdengine_mqtt
    sh install_dgiot_tdengine_mqtt
  ```
# 功能
 - 支持开机自启动与桥接服务进程守护
 - 通过DG-IoT的设备档案管理,可以支持亿级tdengine数据节点的读写
   | 设备层 --> | DG-IoT -->  | 数据桥接 -->  |  数据存储 |
   | ------------ | ------------ | ------------ | ------------ |
   |  千万设备 | dgiot server  | dgiot_tdengine_mqtt  |tdengine server   |
   |  千万设备 | dgiot server  | dgiot_tdengine_mqtt  |tdengine server   |
   |  千万设备 | dgiot server  | dgiot_tdengine_mqtt  |tdengine server   |  
# 案例 
- [ DG-IoT百亿级物流标签轨迹时序数据压测](https://mp.weixin.qq.com/s/8cK_Mo8NayiHaZ7Bkn4HJQ)
 
