[TOC]

# Docker

## Dockerfile脚本的编写方法

- 创建脚本文件：touch Dockerfile
- 存放脚本的目录
  - Dockerfile脚本文件通常放在项目的根目录下（用点“.”表示）；
  - 也可以放在其他文件夹或网络上，但执行docker build时需要指定该文件路径。
- 脚本的组成
  - 基础（父、底层）镜像信息
    ```bash
    # 7.5为底层镜像的标签
    From registry.cn-hangzhou.aliyuncs.com/sessionboy/node:7.5
    ```
  - 维护者信息（用来描述镜像维护者的信息）
    ```bash
    MAINTAINER sessionboy <postmaster@boyagirl.com>
    ```
  - 镜像操作指令
    ```bash
    # 将 “./”(当前目录) 下的文件拷贝到容器内的 “/sinn-server” 目录
    COPY ./ /sinn-server

    # 将当前/server目录拷贝到容器内的/projects目录
    # 如果拷贝了压缩文件，那么拷贝到容器之后自动解压
    ADD /server  /project

    # 指定 RUN、CMD、ENTRYPOINT 指令的工作目录为 /sinn-server
    WORKDIR /sinn-server
    # 接受命令作为参数，并用于创建镜像，命令较长时可使用\换行
    RUN ["/bin/bash", "-c", "echo hello"]
    RUN rm ./tmp \
    npm install

    # 指定容器的UID为23541
    USER  23541

    # 指定容器可访问宿主机(服务器)的“/data”目录和“/home”目录
    VOLUME ["/data","/home"]

    # ONBUILD：配置当所创建的镜像作为其它新创建镜像的基础镜像时，所执行的操作指令。

    # 设置环境变量 NODE_ENV 为 production，可以被容器内的程序或脚本调用
    ENV NODE_ENV  production

    # 对外暴露8080端口
    EXPOSE 8080
    ```

  - 启动容器
    - 方式一：CMD 指令
      - 指定启动容器时执行的命令
      - 每个 Dockerfile 只能有一条 CMD 命令
      - 可被 docker run 提供的参数覆盖
      ```bash
      # 方式1：使用 exec 执行，推荐方式
      CMD ["executable","param1","param2"] 
      # 示例：
      CMD ["sh", "-c", "/etc/init.d/nginx start && uwsgi config.ini"]

      # 方式2：在 /bin/sh 中执行，提供给需要交互的应用
      CMD command param1 param2

      # 方式3：提供给 ENTRYPOINT 的默认参数
      CMD ["param1","param2"]
      ```
    - 方式二：ENTRYPOINT 指令
      - 容器启动后执行的命令
      - 不会被 docker run 提供的参数覆盖
      ```bash
      # 方式1：
      ENTRYPOINT ["executable", "param1", "param2"]

      # 方式2：在 shell 中执行
      ENTRYPOINT command param1 param2
      ```