# 实验三 Systemd基础

## 实验环境
- Ubuntu 18.04.4 Server 64bit
- PuTTy 64bit

## 实验流程

注：命令篇3.1 代码部分无法进行录制，操作如下
```bash
# 重启系统
$ sudo systemctl reboot

# 关闭系统，切断电源
$ sudo systemctl poweroff

# CPU停止工作
$ sudo systemctl halt

# 暂停系统，按任意键可继续
$ sudo systemctl suspend

# 让系统进入冬眠状态，休眠到硬盘，重新打开无需登录
$ sudo systemctl hibernate

# 让系统进入交互式休眠状态，同时休眠到内存和硬盘，重新打开无需登录
$ sudo systemctl hybrid-sleep

# 启动进入救援状态（单用户状态）
$ sudo systemctl rescue
```

**录像1 Systemd命令篇 1-5**

[![asciicast](https://asciinema.org/a/xot44qxTbt70Uv3vS123gnEFf.svg)](https://asciinema.org/a/xot44qxTbt70Uv3vS123gnEFf)

**录像2 Systemd命令篇 6-7**

[![asciicast](https://asciinema.org/a/vhDbiSsyaJs5jI85qwAgU8p7G.svg)](https://asciinema.org/a/vhDbiSsyaJs5jI85qwAgU8p7G)

**录像3 Systemd实战篇 **

[![asciicast](https://asciinema.org/a/N51Mk442KFTk5yoXzaxdvdV6n.svg)](https://asciinema.org/a/N51Mk442KFTk5yoXzaxdvdV6n)

## 自查清单

**如何添加一个用户并使其具备sudo执行程序的权限？**
- ```usermod -a -G sudo username```
- 修改 /etc/sudoers配置文件
    ```bash
    # 原文
    root ALL=(ALL) ALL
    # 加入
    username ALL=(ALL) ALL
    ```
**如何将一个用户添加到一个用户组？**

- ```usermod -a -G groupname username```


**如何查看当前系统的分区表和文件系统详细信息？**
- `sudo fdisk -l` / `sudo sfdisk -l` / `cfdisk` 分区表信息
- `df -h`  以更易读的方式显示目前磁盘空间和使用情况
- `lsblk` 分区表和文件系统信息

**如何实现开机自动挂载Virtualbox的共享目录分区？**

在root用户文件 `/etc/rc.local` 中追加如下命令
```
mount -t vboxsf sharing /mnt/share
```
**基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？**

```bash
# 扩容
lvextend -L size dir
# 缩减
lvreduce -L size dir
```
**如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？**

修改 `systemd-networkd.service`配置文件
```
ExecStartPost=一个指定脚本
ExecStopPost=另一个脚本 
```
之后重新加载并重启`systemd-networkd.service`。

**如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现杀不死？**

修改对应的配置文件
```
[Service]
Restart=always
```
之后重新加载并重启

## 遇到的问题

- 修改时区时报错 `automatic time synchronization is enabled`

    `timedatectl set-ntp no` 解决

- 个人认为这部分代码作者应该是手误了。
    ```bash
    # 命令篇第7部分 倒数第四条命令，应删掉qq
    # 以 JSON 格式（多行）输出，可读性更好
    $ sudo journalctl -b -u nginx.serviceqq
    -o json-pretty
    ```

## 参考资料
- [Systemd 入门教程：命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
- [Systemd 入门教程：实战篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)