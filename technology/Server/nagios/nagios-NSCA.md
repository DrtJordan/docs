# NSCA 被动模式插件


useradd nagios

分配 apache 到 nagios 组中
usermod -a -G nagios apache



cd /usr/local/src
sudo wget https://nchc.dl.sourceforge.net/project/nagios/nsca-2.x/nsca-2.9.2/nsca-2.9.2.tar.gz
sudo tar -zxvf nsca-2.9.2.tar.gz

./configure
make  all

cd src
以上步骤检查正确执行以后：
       1、会在src目录下生成两个程序 nsca  send_nsca（主程序）
       2、sample-config中会有nsca.cfg与send_nsca.cfg（配置文件）
       3、当前目录下会有一个init-script（启动脚本）


NSCA port:  5667
NSCA user:  nagios
NSCA group: nagios


commen.sh中注意一点是输出的格式：
       HOSTNAME [TAB]SERVICE_DESCRIBE[TAB]STATUS[TAB]OUTPUT
       主机名        服务描述            状态码       附加输出

主机名必须与nagios端定义的hostname相同
服务描述必须与nagios端定义的service配置文件内容的相同
状态码（0 1 2 3 4）主要是用来给check_dummy翻译使用
附加输出 可以理解为对监控结果的一个简单描述
这个格式是由 nsca插件决定的


Usage: /usr/local/nagios/bin/nsca -c <config_file> [mode

Options:
 <config_file> = Name of config file to use
 [mode]        = Determines how NSCA should run. Valid modes:
   --inetd     = Run as a service under inetd or xinetd
   --daemon    = Run as a standalone multi-process daemon
   --single    = Run as a standalone single-process daemon (default)

/usr/local/nagios/bin/nsca -c /usr/local/nagios/etc/nsca/nsca.cfg
