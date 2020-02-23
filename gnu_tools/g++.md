[TOC]

# g++

- g++ 是 GNU 组织开发出的编译器软件集合（GCC）下的一个基于命令行的 C++ 编译器；
- 参考资料
  - [g++编译器的使用](https://www.cnblogs.com/lulipro/p/6661763.html)

## 基本使用

- 指定编译结束后输出文件的类型
  - -o <FILE_NAME>：设置输出文件名（可以是可执行文件，也可以是中间文件）
    - 示例：g++ demo.cpp -o main
    - 说明：编译 demo.cpp 文件，输出结果为可执行文件 main
  - -E：对源文件仅进行预处理
    - 示例：g++ demo.cpp -E -o main.i
    - 说明：预处理 demo.cpp 文件，输出结果为预处理后的文件 main.i
  - -S：对源文件仅进行预处理和编译
    - 示例：g++ demo.cpp -S -o main.s
    - 说明：预处理、编译 demo.cpp 文件，输出结果为汇编文件 main.s
  - -c：对源文件仅进行预处理、编译和汇编
    - 示例：g++ demo.cpp -c -o main.o
    - 说明：预处理、编译、汇编 demo.cpp 文件，输出结果为二进制目标文件 main.o
  - -save-temps 保留编译过程的各个中间文件（相当于同时使用 -E -S -c 选项）
    - 示例：g++ demo.cpp -save-temps -o main
    - 说明：编译 demo.cpp 文件，得到可执行文件 main，以及各个阶段的中间文件 demo.i, demo.s, demo.o

- 编译时的警告信息
  - -w：不显示任何警告信息
  - -Wall：显示所有警告信息

- 设定编译时使用的语言标准
  - -std=<语言标准>
    - 示例：-std=c++11
    - 说明：使用C++11标准
  - -ansi：使用 ANSI 标准（禁止 GNU 标准特性，如 asm inline typeof 关键字，以及 Unix var 等预处理宏）。

- 设定编译器的优化级别
  - -O0：不进行优化
  - -O1：缺省值
  - -O2
  - -O3：最高级别的优化

- 查看源文件中 #include 的所有文件
  - -M：查看 #include<> 和 #include"" 的所有文件
    - 示例：g++ demo.cpp -M
      - 说明：在终端列出 demo.cpp 中 #include 的所有文件
    - 示例：g++ demo.cpp -M -o main
      - 说明：保存 demo.cpp 中 #include 的所有文件到 main 文件
  - -MD：同 -M，区别在于输出结果保存至指定的 .d 文件
    - 示例：g++ demo.cpp -MD
      - 说明：保存 demo.cpp 中 #include 的所有文件到 demo.d，同时得到可执行文件 a.out
    - 示例：g++ demo.cpp -MD -o main
      - 说明：保存 demo.cpp 中 #include 的所有文件到 main.d，同时得到可执行文件 main
  - -MM：查看 #include<> 的所有文件
  - -MMD：同 -MM，区别在于输出结果保存至指定的 .d 文件中
  > MM 和 MMD 指令在输出方式上的表现与 M 和 MD 指令保持一致。

- 指定如何处理源文件中的 char 类型
  - -funsigned-char：将程序中的 char 解析为 unsigned char
  - -fno-signed-char：将程序中的 char 解析为非 signed char
  - -fsigned-char：将程序中的 char 解析为 signed char
  - -fno-unsigned-char：将程序中的 char 解析为非 unsigend char

## 其它

- --target-help：显示对特定平台环境进行优化的选项参数
- --version：显示 g++ 的版本信息