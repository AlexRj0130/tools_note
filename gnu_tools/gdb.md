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
- `bt`: (backtrace) 显示函数调用链信息（从深到浅）
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
  - `bt`，显示调用链信息，记下目标层的层号 `NUMBER`
  - `f NUMBER`: 进入 NUMBER 所在的函数堆栈
  - `p NAME_OF_VARIABLE`: 打印 NUMBER 所在的函数内的变量值
  - 备注：对 `info local` 也有效
- 查看指针地址中保存的数值，[参考](https://blog.csdn.net/u010872203/article/details/87927654)

- x 命令查看指定内存地址的内容
  - 一般形式：x/<n/f/u> addr
  - 参数解释
    - `n`: 需要显式的==内存单元==的个数
      - 备注：内存单元的大小由 `u` 定义
    - `f`: 显式的格式（默认值根据变量的类型设定）
      - s: 需要 addr 指向字符串
      - i: addr 指向指令地址
      - x: 十六进制
      - u: 十六进制无符号整型
      - d: 十进制
      - o: 八进制
      - t: 二进制
      - a: 十六进制
      - c: 字符格式
      - f: 浮点数格式
    - `u`: 指定内存单元的大小（默认值为 w）
      - b：单字节
      - h: 双字节
      - w：四字节
      - g: 八字节
  - 备注：n\f\u均为可选参数


### 调试多线程程序

- 操作步骤
  - `ps -ef | grep NAME_OF_PROCESS`: 找到父进程 PID
  - `gdb attach PID`: gdb 附加到 PID，开始调试
  - `info threads`: 显示父进程运行的所有线程
  - `t NUMBER_OF_THREADS`: 切换到指定编号的线程（编号由 info threads 的结果给出）
  - `bt`: 显示当前线程的调用栈信息
  - `b NAME_OF_FILE:NUMBER_OF_LINE`: 在指定文件的指定行，为所有经过这里的线程设置断点
    - `b NAME_OF_FILE:NUMBER_OF_LINE thread NUMBER`: 对指定的线程生效
  - `set scheduler-locking off|on|step`: 用来解决在 step 或 continue 命令时，如何只让被调试线程执行
    - `off`: 不锁定任何线程，即所有线程都执行（默认值）
    - `on`: 只有当前被调试线程会执行
    - `step`: 在 step 时，除了 next 过一个函数的情况以外，只有当前线程会执行

- 其他操纵
  - `gcore`: 生成 CORE 文件
  - `info proc`: 显式进程信息
  - `info reg`: 显示寄存器信息

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
  
### 查看 core dump

- `gdb EXECUTABLE_BINARY_FILE CORE_FILE`: 调试 core dump 文件，以便 debug
  - EXECUTABLE_BINARY_FILE：即执行过程中发生 core 的应用程序的二进制可执行文件
  - CORE_FILE: 即执行过程中发生 core 后由操作系统生成的 core 文件

### 其他

- `set print pretty on`: 设置上之后显示结构体数据更加易读

## 配置文件

- 文件位置：HOME 目录下的 ".gdbinit"
