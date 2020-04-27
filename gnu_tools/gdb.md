[TOC]

# gdb

## 简介


## 基本使用

### 编译可以被调试的程序

- 使用 g++ 编译
  - 开启 -g 选项：确保编译结果中保留了符号信息
  - 开启 -Wall 选项：输出所有的错误提示信息，便于提早发现错误

### 常用命令

- `gdb a.out`: 使用 gdb 调试程序 a.out
  - 注：不会自动运行程序 a.out，需要在 gdb 中执行 `run` 才行
- `b NUMBER_OF_LINE/NAME_OF_FUNC`: (break) 在指定位置添加一个断点
  - `b`: 显示当前所有的断点
  - `delete NUMBER_OF_BREAKPOINT`: 根据断点编号删除断点
  - 注2：run 之前如果不加断点，就会一直运行
- `run`：运行
- `n`: (next) 单步执行一次
- `s`: (step) 进入当前函数
- `c`: (continue) 继续执行，直到遇到断点
- `p NAME_OF_VARIABLE`: (print) 打印指定变量的值
- `info local`: 查看当前函数栈内所有局部变量的值
- `backtrace`: 显示函数调用链信息（从深到浅）
- `ENTER`: 直接回车，重复上一个命令

### 进阶操作

- 自定义命令
  - 示例：单步执行后刷新 layout 窗口
    ```shell
    (gdb) def nref
    > n
    > ref
    > end
    ```
    - 备注：可以追加到 `$HOME/.gdbinit` 目录下，每次启动 gdb 后会自动加载
- 显示调用链上层中变量的值，操作顺序
  - `backtrace`，显示调用链信息，记下目标层的层号 `NUMBER`
  - `f NUMBER`: 进入 NUMBER 所在的函数堆栈
  - `p NAME_OF_VARIABLE`: 打印 NUMBER 所在的函数内的变量值
  - 备注：对 `info local` 也有效
- 查看指针地址中保存的数值，[参考](https://blog.csdn.net/u010872203/article/details/87927654)

### 调试窗口

- `layout`: 开启一个窗格，同步显示正在运行的代码
  - `layout src`: 显示源代码
  - `layout asm`: 显示汇编代码
  - `layout split`: 同时显示源代码和汇编代码
  - `layout regs`: 显示寄存器中的值
    - `tui reg next`: 显示下一组寄存器
    - `tui reg system`: 显示系统寄存器
  - `layout next`: 切换到下一个布局模式
  - `layout prev`: 切换到上一个布局模式
  - 注：如果程序没有运行的话，窗格中显示的内容将为空
- `update`: 更新源代码窗口和当前执行点
- `refresh`: 刷新所有窗口

- 调试命令
  
