[TOC]

# Compile Tools

## Abstract

- C和C++编译器是集成的。他们都要用四个步骤中的一个或多个处理输入文件: 
  - 预处理(preprocessing)
  - 编译(compilation)
  - 汇编(assembly)
  - 连接(linking)
  >  源文件后缀名标识源文件的语言，但是对编译器来说，后缀名控制着缺省设定
- 文件类型与文件后缀名  
  后缀名 | 文件类型 | 后续操作
  :---: | :---: | :---: 
  .c | C源程序 | 预处理，编译，汇编
  .C .cc .cxx | C++源程序 | 预处理，编译，汇编 
  .m | Objective-C源程序 | 预处理，编译，汇编
  .i | 预处理后的C文件 | 编译，汇编
  .ii | 预处理后的C++文件 | 编译，汇编
  .s | 汇编语言源程序 | 汇编
  .S | 汇编语言源程序 | 预处理，汇编
  .h | 预处理文件 | 预处理 
  .o | 目标文件 | 链接
  .a | 归档库文件 | 链接
  > 注：对于 .i 文件
  >  - gcc 编译器识别为预处理后的 C 文件，并设定 C 形式的链接；
  >  - g++ 编译器识别为预处理后的 C++ 文件，并设定 C++ 形式的链接。

## 基本使用注意事项

- 除非使用了-c， -S，或 -E 选项（或者编译错误阻止了完整的过程），否则连接总是最后的步骤；
- 在连接阶段中，所有对应于源程序的 .o 文件, -l 库文件，无法识别的文件名（包括指定的 .o 目标文件和.a 库文件）按命令行中的顺序传递给连接器；
- 选项必须分立给出，例如：\'-dr\' 完全不同于 '-d -r '。