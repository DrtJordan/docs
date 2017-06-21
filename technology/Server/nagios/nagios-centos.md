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

### 1. 安装

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


### 2. 插件解说
