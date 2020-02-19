[TOC]

# SSH

## ssh到远程linux服务器

- 准备工作
  - 本地机[安装OpenSSH](https://docs.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_install_firstuse)
  - 生成密钥（在本地机运行以下命令）
    ```shell
    ssh-keygen -t rsa -b 4096 -C "your_email_address@example.com"
    ```
  - 将公钥拷贝到linux服务器的“~/.ssh/authorized_keys”文件中
    - 公钥的默认名为“id_rsa.pub”
    - 对于Win10，公钥所在的默认目录为“C:\Users\username\\.ssh”
    - 对于Ubuntu，公钥所在的默认目录为“~/.ssh”
    - 可以在authorized_keys文件中使用“#”为不同的公钥添加行注释
  - 在linux服务器中安装openssh-server
    ```shell
    sudo apt-get install openssh-server
    ```
  - 修改linux服务器ssh连接的默认端口（可选）
    - 配置文件位于“/etc/ssh/sshd_config”
    - 修改文件中的“Port”参数的值（默认为22）
  - 重启linux服务器的ssh-server服务
    ```shell
    service sshd restart
    ```

- 使用方法
  - 未修改linux服务器的ssh连接端口
    ```shell
    ssh username@ip_address
    ```
  - 已修改linux服务器的ssh连接端口
    ```shell
    ssh username@IP_ADDRESS -p PORT
    ```
  - > 注：username为登陆linux服务器时的用户名。
