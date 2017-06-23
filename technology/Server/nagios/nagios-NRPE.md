# NRPE - Nagios Remote Plugin Executor 主动监控插件

- 版本 3.x

- 调用流程
  - nagios -> check_nrpe -> ssl -> daemon

- 组成结构
  - check_nrpe 插件, 安装在 nagios 监控服务器和被监控主机上
  - NRPE daemon , agent 守护进程, NRPE daemon 运行在被监控主机上

- 需要安装 nagios

## 一、NRPE daemon 和 check_nrpe 安装

``` sh
1. 安装依赖
  yum install -y gcc glibc glibc-common gd gd-devel xinetd openssl-devel cmake make vim c++  

2. 下载编译
  cd /usr/local/src/
  sudo wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.1.0/nrpe-3.1.0.tar.gz
  tar -zxvf nrpe-3.1.1.tar.gz

  cd nrpe-3.1.1
  ./configure --prefix=/usr/local/nagios –enable-command-args
  # 编译
  make all

3. 安装参数说明
  all                  builds nrpe and check_nrpe
  nrpe                 builds nrpe only
  check_nrpe           builds check_nrpe only
  install              install nrpe and check_nrpe
  install-plugin       install the check_nrpe plugin
  install-daemon       install the nrpe daemon
  install-config       install the nrpe configuration file
  install-inetd        install the startup files fr inetd, launchd, etc
  install-init         install the startup files or init, systemd, etc

4. 安装 NRPE daemon 守护进程
  # 安装 install-plugin, check_nrpe 插件
  make install-plugin

  # 安装 nrpe
  make nrpe
  # 安装 nrpe 守护进程
  make install-daemon
  # 安装 nrpe 配置文件
  make install-config

5. NRPE daemon 配置文件
  vim /usr/local/nagios/etc/nrpe.cfg

  # 定义 NRPE 的PID文件。
  pid_file=/usr/local/nagios/var/nrpe.pid

  # NRPE daemon 监听端口。
  server_port=5666

  # 运行用的身份和组
  nrpe_user=nagios
  nrpe_group=nagios

  # 允许连接到 NRPE daemon 的 IP 列表, 多个 ip 使用逗号隔开，网段格式 192.168.1.0/24。
  allowed_hosts=127.0.0.1,::1,host_name

6. 启动 NRPE daemon 任务
  参数解说：
    -n 表示不使用SSL方式传输数据，默认使用 SSL 方式传输数据
    -c <config_file> 配置文件路径
    -d  独立守护进程方式运行 NRPE, 本文使用此方法
    -i  以超级守护进程 inetd 或 xinetd 方式运行 NRPE

  启动服务：
    /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

    tail -f /var/log/messages

```


## 二、nagios check_nrpe 插件配置和生效


### 1. 配置 nrpe 插件

- 用作 nagios 调用 check_nrpe 执行远程命令

``` sh
1. commands.cfg 配置,
vim /usr/local/nagios/etc/objects/commands.cfg

# 定义 check_nrpe 拆件
define command{
        # 定义命令名称为 check_nrpe,在 services.cfg 中要使用这个名称.
        command_name    check_nrpe

        # 这是定义实际运行的插件程序
        # -c 后的 $ARG1$ 参数是传给 nrpe daemon 执行的检测命令
        # nrpe.cfg 配置文件: command[check_load]=/usr/local/nagios/libexec/check_load -w 15,10,5 -c 30,25,20
        # serivce.conf 配置文件:  check_command   check_nrpe!check_load
        command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}


2. 重启 nrpe
  /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

3. 重启 nagios
  service nagios restart

```


### 2. 自定义脚本

- 0(OK)表示状态正常/绿色
- 1(WARNING)表示出现警告/黄色
- 2(CRITICAL)表示出现非常严重的错误/红色
- 3(UNKNOWN)表示未知错误/深黄色。

``` sh
1. 自定义脚本
#!/bin/bash
# 打印入参
echo $1
# 打印返回值
echo "Test: OK Total: test  - concurrent_count|USED=test;200;500;;"
# 返回执行状态
$(exit 0)

2. 配置 etc/nrpe.cfg, 添加 NRPE 脚本名称和路径
command[test]=/usr/local/nagios/libexec/custom/test.sh $ARG1$

3. 定义 etc/objects/services.cfg , check_nrpe 调用 test
define service{
        # 必须在 host.cfg 先定义 hostname
        host_name                       HadoopClusterDw0
        # nagios 网页上的服务名
        service_description             HadoopClusterTest
        # 检测的间隔
        check_command                   check_nrpe!test

        # 重试次数
        max_check_attempts      3
        # 检查间隔
        check_interval          1
        # 重试间隔
        retry_interval          1
        # 主机在故障后 再次发送通知的间隔时间
        notification_interval   10
        # 监控时间范围
        check_period            24x7
        # 主机故障时发送通知的时间范围
        notification_period     24x7
        notification_options    w,u,c,r
        contact_groups          MonitorGroup
}

4. 修改了 nrpe.cfg 需要重启服务

5. 修改了 services.cfg, command.cfg 需要重启服务
```
