[TOC]

# make

- 参考资料
  - [跟我一起写 Makefile](https://seisman.github.io/how-to-write-makefile/overview.html)

## 简介

- make 命令执行时，需要一个 makefile 文件；
- makefile 文件用来指导 make 命令怎样去编译和链接程序；
- makefile 关系到了整个工程的编译规则：makefile 中定义了一系列的规则，这些规则指定了哪些文件需要先编译，哪些文件需要后编译，哪些文件需要重新编译，甚至于进行更复杂的功能操作（makefile 中可以指定执行操作系统的命令）；
- makefile 带来的好处：“自动化编译”（一次投入，持续产出）；

## makefile介绍

### makefile的规则

```makefile
target ...: prerequisties ...
    command
    ...
    ...
```

- target：可以是 object file（目标文件）、可执行文件、或标签（参见伪目标）;
- prerequisties：生成 target 时所依赖的文件和/或其他target；
- command：该 target 要执行的命令（可以是任意的 shell 命令）。
- [示例0.1](./examples/0.1.sh)
- ==注意：==
  - ==prerequisties 中如果有一个以上的文件比 target 文件新（修改时间），command 所定义的命令就会被执行。==
  - make 并不管命令是如何工作的，它只管执行所定义的命令。

**关于伪目标**

- 特点：不依赖任何文件或目标（所以它后面所定义的 `命令` 不会被自动执行）。
  - 示例0.1 中的 clean 就是一个伪目标。
  - 显式执行方法：`make clean`

### makefile的组成

1. 显式规则：说明如何生成一个或多个目标文件
    - 由 makefile 的编写者明确指出的要生成的文件、文件的依赖文件以及生成的命令。
1. 隐含规则：make 通过自动推导功能自动添加的规则
    - 自动地添加一些常见的规则，用来简化 makefile 的书写。
1. 变量定义：变量一般都是字符串
    - 当 makefile 被执行时，变量会被展开在相应的引用位置上。
1. 文件指示：包括三个部分，分别是
    1. 在一个 makefile 中引用另一个 makefile
        - 作用：被包含的文件的内容会原模原样的展开在当前文件的引用位置（类似于 C 中的 #include）
        - 一般形式：include \<filename>
        - 依次在以下几个位置寻找被引用的 makefile：
          - 当前目录
          - -I（--include-dir）选项指定的目录；
          - \<prefix>/include（一般为 /usr/local/bin 或 /usr/include）目录。
        - 示例:
          ```makefile
          # include 前面可以有一些空字符，但绝对不能以 Tab 键开始
          # include 和 <filename> 可以用一个或多个空格隔开，可以一次性引用多个 makefile 文件
          # include 多个 makefile 文件时，makefile 文件名可以使用通配符、makefile 变量
          bar = a.mk b.mk c.mk
          include foo.make
          include *.mk $(bar)
          ```
        - 备注：环境变量 `MAKEFILES` 中的 makefile 会被 make 自动的做一个类似于 include 的动作，因此会影响到每一个执行的 makefile（所以不建议使用这个环境变量）。
    1. 根据情况指定 makefile 中有效地部分（类似于 C 中的 #if）
    1. 定义多行的命令
1. 注释：使用 `#` 添加行级注释

### makefile的文件名

- 默认文件名：
  - makefile
  - Makefile：建议用这个。
  - GNUmakefile：最好不要用这个，因为是 GNU 识别的，可能不被其他 make 识别。
- 指定自定义文件名（-f 选项）：
  - 例1：make -f MyMakefile
  - 例2：make --file MyMakefile

## make介绍

### make是如何工作的

- make 的执行步骤（以 GNU make 为例）：
  1. 读入所有的 Makefile;
  1. 读入被 include 的其它 Makefile;
  1. 初始化文件中的变量；
  1. 推导隐含规则，并分析所有规则；
  1. 为所有的目标文件创建依赖关系链；
      - make 基于`依赖性`工作；
      - 在搜索依赖性的过程中，如果出现错误，那么 make 直接报错并退出。
  1. 根据依赖关系，决定哪些目标要重新生成；
  1. 执行生成命令
- 备注：
  - makefile 文件中的==第一个目标==（target）作为最终目标（如示例0.1中的目标 `edit`）；
  - 重新生成目标的条件：目标文件不存在，或是目标文件所依赖的文件的修改时间更新;
  - 对于所定义的命令的错误，或是编译不成功，make 根本不理。

## 编写makefile时应该定义的伪目标

- all：所有目标的目标
  - 功能：编译所有目标
- clean：
  - 功能：删除所有被 make 创建的文件
- install：
  - 功能：安装已编译好的程序（把目标拷贝到指定的路径下）
- print：
  - 功能：列出改变过的源文件
- tar：
  - 功能：把源程序打包备份成一个 tar 文件
- dist：
  - 功能：把打包后的 tar 文件压缩成 Z 或 gz 文件
- TAGS：
  - 功能：更新所有的目标（以便完整地重新编译）
- check：
  - 功能：测试 makefile 的流程
- test
  - 功能：测试 makefile 的流程