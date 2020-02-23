[TOC]

- 参考文档
  - [容器化部署方案--docker](https://zhuanlan.zhihu.com/p/26517832)
  - [Docker入门教程](http://www.ruanyifeng.com/blog/2018/02/docker-tutorial.html)
  - [Docker微服务教程](http://www.ruanyifeng.com/blog/2018/02/docker-wordpress-tutorial.html)

# Docker

## Docker是什么

- docker（现已改名为moby）是用GO语言开发的应用容器引擎，基于容器化，沙箱机制的应用部署技术。可适用于自动化测试、打包，持续集成和发布应用程序等场景。
- docker镜像是使用Dockerfile脚本，将你的应用以及应用的依赖包构建而成的一个应用包，它通常带有该应用的启动命令。而这些命令会在容器启动时被执行，也就是说你的应用在启动容器时被启动。
- docker的使用方式主要有docker命令，Dockerfile脚本，以及shell脚本三种。

## Docker基本开发流程

1. 寻找基础镜像（在构建镜像时，被依赖的底层镜像，也叫父镜像）
1. 基于基础镜像编写Dockerfile脚本
1. 根据Dockerfile脚本创建项目镜像
1. 将创建的镜像推送到docker仓库 (根据自身需要，可做可不做)
1. 基于项目镜像创建并运行docker容器 (实现最终部署)