[TOC]

# 远程开发：[SSH到远程linux服务器](https://code.visualstudio.com/docs/remote/ssh)

- 准备工作
  - 确保本机可以通过命令行**ssh到远程linux服务器**
  - 在本机的ssh的配置文件下添加如下内容
    ```bash
    Host LinuxServer  # alias of linux server
    HostName 192.168.1.1  # IP address of linux server
    User ExampleName  # username of linux server
    Port 22222  # SSH connection port number of linux_server, default is 22 which can be omitted
    ```
- 使用方法
  - 安装**Insider版的VS Code**
  - 点击位于**Side Bar**的**Remote Explorer**图标，根据**Alias**选择目标linux服务器并通过鼠标右键打开
  - 连接成功后，通过VS Code 的**菜单栏**打开linux服务器上的**文件**或**文件夹**即可