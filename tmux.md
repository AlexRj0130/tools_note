[TOC]

# TMUX

> 用来将 linux 终端窗口切分成多个屏幕。
> 并且，一旦在 linux 主机上安装好该软件，即使使用本地的终端软件通过 ssh 连接 linux 后，仍然可以通过该软件对远程 linux 主机的终端窗口进行切分。

## 安装方法

- 运行以下命令（以 Ubuntu 系统为例）
  ```bash
    sudo apt update && sudo apt install tmux
  ```

## [使用方法](https://tmuxcheatsheet.com/)

### 会话管理

- 创建命名会话：
  - 创建并连接：tmux new -s dev
  - 创建但不连接：tmux new -s dev -d
- 离开会话：ctrl+b d
- 重连会话：tmux attach -t dev
- 打开会话列表：ctrl+b s
  - 打开列表后，可以通过输入编号的方式切换会话
- 上一个会话：ctrl+b (
- 下一个会话：ctrl+b )
- 重命名会话：ctrl+b $
- 删除会话
  - 删除当前会话：ctrl+b: kill-session
  - 删除所有会话：ctrl+b: kill-server

### 窗口管理

- 创建窗口
  - ctrl+b c
- 切换窗口
  - ctrl+b number
- 重命名窗口
  - ctrl+b ,

### 面板管理

- 分割面板
  - 水平分割：ctrl+b  "
  - 垂直分割：ctrl+b  %
- 切换面板
  - 显式面板序号并切换：ctrl+b q number
  - 上：ctrl+b  up
  - 下：ctrl+b  down
  - 左：ctrl+b  left
  - 右：ctrl+b  right
- 关闭面板
  - 关闭当前面板：ctrl+b x
- 调整面板尺寸
  - 全屏显式当前面板：ctrl+b z（再次操作，则恢复原状）
  - 上：ctrl+b ctrl+up
  - 下：ctrl+b ctrl+down
  - 左：ctrl+b ctrl+left
  - 右：ctrl+b ctrl+right
  - 备注：mac 上为 ctrl+b option+up/down/left/right
- 调整面板顺序
  - 左移：ctrl+b {
  - 右移：ctrl+b }
  - 上移：ctrl+b ctrl+o
  - 下移：ctrl+b alt+o
- 其他
  - 将面板拆分为单独的窗口：ctrl+b !
  - 在当前面板显式时间：ctrl+b t
