# nagios 监控服务安装

## 一、nagios-core 安装

- 版本 4.x

``` sh
1. 禁止 selinux
  sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  setenforce 0

2. 安装依赖包 C 编译器, wget, httpd, php, gd
  yum install -y gcc glibc glibc-common wget unzip httpd php gd gd-devel

3. 下载编译
  1) 下载
   cd /usr/local/src
   wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.3.2.tar.gz
   tar xzf nagioscore.tar.gz

  2) 编译安装目录、命令执行用户组
   cd /usr/local/src/nagioscore-nagios-4.3.2
   ./configure --prefix=/usr/local/nagios --with-nagios-group=nagios --with-command-group=nagcmd

4. 创建用户和组
  useradd nagios

  分配 apache 到 nagios 组中
  usermod -a -G nagios apache

5. 安装二进制文件、cgi和HTML文件
  make install

6. Install Service / Daemon 添加到开机启动服务中
  1) CentOS 5.x / 6.x | RHEL 5.x / 6.x | Oracle Linux 5.x / 6.x
   make install-init
   chkconfig --add nagios
   chkconfig --level 2345 httpd on

  2) CentOS 7.x | RHEL 7.x | Oracle Linux 7.x
   make install-init
   systemctl enable nagios.service
   systemctl enable httpd.service

7. Install Command Mode 安装命令行模式
  1) 安装和配置外部命令文件
   make install-commandmode

  2) 安装配置文件示例
   make install-config

  3) 安装 Apache web 服务器的配置文件
   make install-webconf

8. 配置防火墙(可选)
  1) CentOS 5.x / 6.x | RHEL 5.x / 6.x | Oracle Linux 5.x / 6.x
   iptables -I INPUT -p tcp --destination-port 80 -j ACCEPT
   service iptables save

  2) CentOS 7.x | RHEL 7.x | Oracle Linux 7.x
   firewall-cmd --zone=public --add-port=80/tcp
   firewall-cmd --zone=public --add-port=80/tcp --permanent

9. 创建 nagios 登录账号: nagiosadmin
  htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

  输入登录密码

10. 启动服务 Httpd
  1) CentOS 5.x / 6.x | RHEL 5.x / 6.x | Oracle Linux 5.x / 6.x
    service httpd start

  2) CentOS 7.x | RHEL 7.x | Oracle Linux 7.x
    systemctl start httpd.service

11. 启动 Service
  1) CentOS 5.x / 6.x | RHEL 5.x / 6.x | Oracle Linux 5.x / 6.x
    service nagios restart

  2) CentOS 7.x | RHEL 7.x | Oracle Linux 7.x
    systemctl start nagios.service

12. 访问
  http://host-name/nagios
```


## 二、nagios-core-plugins 安装

- 版本 2.x

- 监控网络服务（SMTP，POP3，HTTP，NNTP，PING等）
- 监控主机资源（处理器负载，磁盘使用情况等）
- 简单的插件设计，允许用户轻松开发自己的服务检查
- 并行服务检查
- 能够使用“父”主机定义网络主机层次结构，允许检测和区分主机和不可达主机
- 发生服务或主机问题并联系通知（通过电子邮件，寻呼机或用户定义的方法）
- 能够定义在服务或主机事件期间运行的事件处理程序以进行主动解决问题
- 自动日志文件轮换
- 支持实现冗余监控主机
- 可选Web界面，用于查看当前网络状态，通知和问题历史记录，日志文件等。

``` sh
1. Prerequisites 安装条件
  1) CentOS 6.x / 7.x
   yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
   yum install -y perl-Net-SNMP

2. 下载安装
  1) 下载
   cd /usr/local/src
   wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
   tar -zxf nagios-plugins.tar.gz

  2) 编译
   cd /usr/local/src/
   ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
   make
   make install

3. 服务启动命令
  service nagios start
  service nagios stop
  service nagios restart
  service nagios status

4. 访问
  http://host-name/nagios
```


## 三、ndoutils 插件

- 版本 2.x

- NDOMOD
 - 接收 Program Logic、Frogram Data 数据, 或者监控信息，输出到: 标准文件、Unix 域套接字或者 TCP 套接字
- NDO2DB
  - NDO2DB 进程将创建一个 TCP 套接字 或 Unix 域套接字以监听客户端, 接收来自 NDOMOD、LOG2NDO 的数据源，并保存到数据库中
- LOG2NDO
  - 用来将 Nagios 的历史日志通过 NDO2DB 进程输出至数据库, 通讯方式是: 标准文件、Unix 域套接字或者 TCP 套接字
- FILE2SOCK
  - 标准文件或标准输入 读取数据, 并输出至 Unix 域套接字或 TCP 套接字
  - 当 NDOMOD 或 LOG2NDO 将数据输出至标准文件时， 此工具则可用来将这些标准文件中数据读出并发送给 NDO2DB 进程监听的 TCP 套接字或 Unix 域套接字


``` sh
1. 安装依赖
   yum install -y mysql-devel perl-DBD-MySQL

2. 下载安装
  1) 下载
    cd /usr/local/src
    wget https://downloads.sourceforge.net/project/nagios/ndoutils-2.x/ndoutils-2.1.3/ndoutils-2.1.3.tar.gz?r=&ts=1497433073&use_mirror=jaist
    tar -zxvf ndoutils-2.1.3.tar.gz

  2) 安装
    cd /usr/local/src
    ./configure --prefix=/usr/local/nagios --enable-mysql --disable-pgsql --with-ndo2db-user=nagios --with-ndo2db-group=nagios LDFLAGS=-L/usr/lib64/mysql
    make
    make all

3. 配置模块 ndomod 代理模块(转发数据)
  1) 复制 ndomod 模块, 4x.0 表示 nagios-core 是 4.x 版本, 具体根据 core 定义
    cp -v src/ndomod-4x.o  /usr/local/nagios/bin/
    chown nagios:nagios /usr/local/nagios/bin/ndomod-4x.o

  2) 复制 ndomod 配置文件
    mkdir -p /usr/local/nagios/etc/ndoutils
    cp -v config/ndomod.cfg-sample /usr/local/nagios/etc/ndoutils/ndomod.cfg
    chown nagios:nagios /usr/local/nagios/etc/ndoutils/ndomod.cfg

4. 配置 ndo2db 模块(接收数据保存到 MySQL)
  1) 复制 ndo2db 模块, 4x 表示 nagios-core 是 4.x 版本
    cp -v src/ndo2db-4x /usr/local/nagios/bin/
    chown nagios:nagios /usr/local/nagios/bin/ndo2db-4x

  2) 复制 ndo2db 配置文件
    mkdir -p /usr/local/nagios/etc/ndoutils
    cp -v config/ndo2db.cfg-sample /usr/local/nagios/etc/ndoutils/ndo2db.cfg
    chown nagios:nagios /usr/local/nagios/etc/ndoutils/ndo2db.cfg

  3) 配置 ndo2db.cfg 数据库
    vim /usr/local/nagios/etc/ndoutils/ndo2db.cfg

    # db 配置
    socket_type=tcp
    db_servertype=mysql
    db_host=dw0
    db_port=3306
    db_name=nagios
    db_prefix=nagios_
    db_user=nagios
    db_pass=nagios

5. 安装数据库
  1) 登录 Mysql 创建数据库
    CREATE DATABASE nagios /*!40100 DEFAULT CHARACTER SET utf8 */;
    GRANT ALL PRIVILEGES ON nagios.* TO 'nagios'@'%' IDENTIFIED BY 'nagios' WITH GRANT OPTION;

  2) 安装数据库
    cd src/db
    ./installdb -h dw0 -u nagios -p nagios -d nagios

6. 配置 nagios.cfg 加载 ndomod 模块
  vim /usr/local/nagios/etc/nagios.cfg

  # ndoutils ndomod 模块, 设置同一行
  broker_module=/usr/local/nagios/bin/ndomod-4x.o config_file=/usr/local/nagios/etc/ndoutils/ndomod.cfg
  # 开启代理
  event_broker_options=-1

7. 复制 file2sock,log2ndo 依赖
  cp -v src/{file2sock,log2ndo} /usr/local/nagios/bin
  chown nagios:nagios /usr/local/nagios/bin/{file2sock,log2ndo}

8. 配置 ndomod -> ndo2db, ndomod 发送数据到的地址和端口 ndo2db
  1) ndomod 发送数据地址
    vim /usr/local/nagios/etc/ndoutils/ndomod.cfg

    # 发送到 ndo2db 的地址
    output_type=tcpsocket
    output=127.0.0.1
    tcp_port=5668

  2）ndo2db 监听接收数据地址
    vim /usr/local/nagios/etc/ndoutils/ndo2db.cfg

    # 监听设置
    socket_type=tcp
    tcp_port=5668

7. 启动 ndo2db, 监听在端口 5668, 接收 ndomod 发来的数据
  # 启动 ndo2db-4x 服务
  /usr/local/nagios/bin/ndo2db-4x -c /usr/local/nagios/etc/ndoutils/ndo2db.cfg
  tail -f /var/log/messages
  netstat -tnulp | grep 5668

  # 重启 nagios 服务
  service nagios restart
  tail -f /usr/local/nagios/var/nagios.log

8. 实例 ndomod 实例默认和更改
  vim /usr/local/nagios/etc/ndoutils/ndomod.cfg

  # 默认组是 default, 大型应用中可能存在多个独立的或分布式布置的 Nagios 服务器.
  # 这种环境中的每个 Nagios 服务器通常被称为一个 Nagios 实例。
  # 在多 Nagios 实例的环境中，既可以把所有实例的数据存入到一个数据库，也可以将各实例的数据分别存储。
  instance_name=dw_groups

```
