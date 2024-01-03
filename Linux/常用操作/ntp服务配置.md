# 1. CentOS 7 及以下

# 2. Centos 8 / almalinux 8

请注意自己的业务是否会因为时间更新有所影响，方法仅供参考。

一、错误再现
centos 8 执行 ntpdate 会出现以下错误

```
No match for argument: ntpdate Error: Unable to find a match: ntpdate
```

原因：在CentOS8.0中默认不再支持ntp软件包，时间同步将由chrony来实现

二、解决方法

## 通过 wlnmp 方式

1. 添加wlnmp的yum源

   ```
   rpm -ivh http://mirrors.wlnmp.com/centos/wlnmp-release-centos.noarch.rpm
   ```
2. 安装ntp服务

   ```
   yum -y install wntp
   ```
3. 时间同步

   ```
   ntpdate ntp1.aliyun.com
   ```

## 通过同步目标服务器方式

1. centos8 里是预安装的，没有安装的话执行以下命令：

   ```
   yum -y install chrony
   ```
2. 修改配置文件

   ```
   vi /etc/chrony.conf
   ```
3. 修改配置文件

   ```
   Please consider joining the pool (http://www.pool.ntp.org/join.html).
   pool 2.centos.pool.ntp.org iburst

   修改

   Please consider joining the pool (http://www.pool.ntp.org/join.html).
   pool 2.centos.pool.ntp.org iburst
   server 目标服务器IP iburst
   ```
4. 保存退出，重启 chronyd 服务
