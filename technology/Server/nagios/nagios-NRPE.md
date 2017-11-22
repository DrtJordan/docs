# NRPE - Nagios Remote Plugin Executor 主动监控插件

- 版本 3.x

- 调用流程
  - nagios -> check_nrpe -> ssl -> NRPE daemon

- 组成结构
  - check_nrpe : 插件, 安装在 nagios 监控服务器和被监控主机上
  - NRPE daemon : agent 守护进程, NRPE daemon 运行在被监控主机上

- 需要安装 nagios

- 用来执行远程命令


## 一、 Nagios 主机安装 check_nrpe 插件,  远程主机安装 NRPE daemon 服务

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

4.1 安装 install-plugin, check_nrpe 插件(Nagios 主机操作)
  make install-plugin

4.2 安装 NRPE daemon 守护进程(远程主机上操作)
  # 安装 nrpe
  make nrpe
  # 安装 nrpe 守护进程
  make install-daemon
  # 安装 nrpe 配置文件
  make install-config

5. NRPE daemon 配置文件(远程主机上操作)
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

6. 启动 NRPE daemon 任务(远程主机上操作)
  参数解说：
    -n 表示不使用SSL方式传输数据，默认使用 SSL 方式传输数据
    -c <config_file> 配置文件路径
    -d  独立守护进程方式运行 NRPE, 本文使用此方法
    -i  以超级守护进程 inetd 或 xinetd 方式运行 NRPE

  启动服务：
    /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

    tail -f /var/log/messages

```


## 二、Nagios 远程操作 NRPE 案例

### 1. nagios 主机配置 check_nrpe 插件

``` sh
1. commands.cfg 配置 check_nrpe 插件
vim etc/objects/commands.cfg

# 定义 check_nrpe 拆件
define command{
        # 定义命令名称为 check_nrpe,在 services.cfg 中要使用这个名称.
        command_name    check_nrpe

        # 这是定义实际运行的插件程序
        # -H : 表示远程主机 NRPE daemon IP 地址
        # -p : 表示远程主机 NRPE daemon 端口, 默认 5666
        # -c $ARG1$ : check_nrpe 插件传给 NRPE daemon 上执行的 <脚本名称>, 例如: serivce.cfg 配置文件中的 check_command  check_nrpe!test, test 就是 <脚本名称>
          # <脚本名称> 是在 NRPE daemon 远程主机中的 nrpe.cfg 配置文件中定义的, 例如: command[test]=/usr/local/nagios/libexec/custom/test.sh $ARG1$
        command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -p 5666 -c $ARG1$
}


2. services.cfg  配置一个 test 服务(案例)
vim etc/objects/services.cfg

# 定义一个服务, 使用 check_nrpe 插件执行 NRPE daemon 远程的<脚本名称>, 这里是 test
define service{
        # 执行命令的主机
        host_name                       serverTest
        # nagios 网页上的服务名
        service_description             serverTest

        # 通过 check_nrpe 插件远程执行 <host_name> 主机上的 <test> 脚本
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


3. 重启 nagios
  service nagios restart
```


### 2. 在 NRPE daemon 远程主机上配置 <脚本名称>

``` sh
1. 配置 etc/nrpe.cfg, 添加 NRPE 脚本名称和路径
  command[test]=/usr/local/nagios/libexec/custom/test.sh $ARG1$


2. 重启 nrpe
  /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

```


### 3. 自定义 <脚本名称> 脚本的书写格式

- 0(OK)表示状态正常/绿色
- 1(WARNING)表示出现警告/黄色
- 2(CRITICAL)表示出现非常严重的错误/红色
- 3(UNKNOWN)表示未知错误/深黄色。

``` sh
#!/bin/bash
# 打印入参
echo $1
# 打印返回值
echo "Test: OK Total: test  - concurrent_count|USED=test;200;500;;"
# 返回执行状态
$(exit 0)
```
