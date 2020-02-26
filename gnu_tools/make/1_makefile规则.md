[TOC]

# make

## makefile规则

### 基本写法

- 规则的一般形式：
  ```makefile
  targets ... : prerequisites ...
    command
    ...
  # 或
  targets ... : prerequisites ...; command
    command
    ...
  ```
  - targets：目标文件名，以`空格`分开，可以使用`通配符`；
  - prerequisites：目标文件所依赖的文件（或目标）；
  - command：==当 targets 比 prerequisites 旧== 时所要执行的命令
    - 可以放在 prerequisites 同一行，但要用 `分号` 分隔；
    - 可以使用反斜杠 `\` 将一个比较长的命令拆分成多行；
    - make 默认使用 /bin/bash 执行 command。
- 规则包含两个部分，分别是
  1. 依赖关系
  1. 生成目标的方法
- 目标
  - 最终目标：第一条规则中（的第一个）目标；
  - 其他目标：被最终目标带（依赖）出来的目标。
- 举例（参考[示例0.1](./examples/0.1.sh)）

### 在规则中使用通配符

> 通配符：用来操作一系列比较类似的文件。

- make 支持的通配符
  - `*`：用来匹配任意字符串
    ```makefile
    # 删除任意以 .o 结尾的文件 
    clean:
      rm -f *.o
    ```
  - `?`：
  - `~`：用来匹配目录，包括两种用法
    ```makefile
    # 用法1：当前用户的 $HOME 目录下的 test 目录
    ~/test
    # 用法2：特定用户（xchen）的用户目录下的 test 目录
    ~xchen/test
    # 注：在 MS-DOS 中代表的是环境变量 "HOME" 的值。
    ```

- 在变量中使用通配符
  ```makefile
  # objects 的值就是 *.o，*.o 不会先展开，再赋值给 objects。
  objects = *.o
  # 将通配符展开后赋值给变量
  objects := $(wildcard *.o)
  ```

### 多目标

- 多目标：
  - 应用场景：多个目标依赖于同一个文件，并且对应的命令大致类似
  - 示例：
    ```makefile
    bigoutput littleoutput : text.g
      generate text.g -$(subst output,,$@) > $@
    # 关于 subst 参考函数一节
    # 关于 $@ 参考变量一节
    # 等价于
    bigoutput : text.g
      generate text.g -big > bigoutput
    littleoutput : text.g
      generate text.g -little > littleoutput
    ```

### 静态模式

- 静态模式：
  - 作用：更加容易地定义多目标的规则
  - 一般形式：
    ```makefile
    <targets ...> : <target-pattern> : <prereq-patterns ...>
      <commands>
      ...
    # targets：目标文件的集合，可以包含通配符
    # target-pattern：目标集 targets 的模式
    # prereq-patterns：目标的依赖模式
    ```
  - 示例：
    ```makefile
    objects = foo.o bar.o

    all: $(objects)

    $(objects): %.o: %.c
        $(CC) -c $(CFLAGS) $< -o $@

    # 等价于
    foo.o : foo.c
        $(CC) -c $(CFLAGS) foo.c -o foo.o
    bar.o : bar.c
        $(CC) -c $(CFLAGS) bar.c -o bar.o
    ```
  - 示例：
    ```makefile
    files = foo.elc bar.o lose.o
    
    # 只保留 .o 结尾的文件作为目标集
    $(filter %.o,$(files)): %.o: %.c
        $(CC) -c $(CFLAGS) $< -o $@
    # 只保留 .elc 结尾的文件作为目标集
    $(filter %.elc,$(files)): %.elc: %.el
        emacs -f batch-byte-compile $<
    ```

### 伪目标

- 伪目标：
  - 无法被 make 自动执行。
  - 只是一个标签，不会生成文件。
  - 注意：伪目标不能和文件名重名（否则会失去其作为 `伪目标` 的意义）。

- `.PHONY` 标记：用来避免伪目标与文件名重名
  - 示例：
    ```makefile
    # 无论是否有 clean 这个同名文件，clean 目标一定会被作为伪目标对待
    .PHONE: clean
    clean:
      rm *.o temp
    ```
  - 示例：通过伪目标生成多个可执行文件
    ```makefile
    # 把伪目标作为默认目标（放在第一个）
    # 把要生成的可执行文件指定为伪目标的依赖文件
    all : prog1 prog2 prog3
    .PHONY : all
    
    prog1 : prog1.o utils.o
        cc -o prog1 prog1.o utils.o
    
    prog2 : prog2.o
        cc -o prog2 prog2.o
    
    prog3 : prog3.o sort.o utils.o
        cc -o prog3 prog3.o sort.o utils.o
    ```
  - 示例：把伪目标作为依赖
    ```makefile
    .PHONY : cleanall cleanobj cleandiff
    
    cleanall : cleanobj cleandiff
        rm program
    
    cleanobj :
        rm *.o
    
    cleandiff :
        rm *.diff
    ```

## 利用编译器自动生成依赖关系

- 编译器的 `-M` （GNU 编译器的 `-MM`）选项自动生成每个文件的依赖关系
  - 自动生成依赖关系
    ```makefile
    # 作用：为每一个源文件生成对应的依赖关系
    %.d: %.c
        @set -e; rm -f $@; \
        $(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
        sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
        rm -f $@.$$$$
    # 解释：调整编译器生成文件的内容
    # 例如：把 main.o : main.c defs.h
    # 转换为 main.o main.d : main.c defs.h
    # 转换结果保存在对应的 .d 文件中
    ```
  - 引用自动生成的依赖关系
    ```makefile
    sources = foo.c bar.c
    include $(sources:.c=.d)
    ```

## 指定文件的搜索目录

> 可以指定 make 寻找依赖文件和目标文件时所要搜索的目录。
> 注：==永远最先搜索当前目录==（只有当前目录找不到，才会搜索其他指定的目录）。

- makefile 的 `VPATH` 变量：
  ```makefile
  # 使用 “冒号” 分隔多个目录：先搜索 src 目录；在搜索 ../headers 目录
  VPATH = src:../headers
  ```

- make 关键字 `vpath`：为文件名满足特定==模式==的文件指定搜索目录
  ```makefile
  # vpath <pattern> <directories>：为复合模式 <pattern> 的文件指定搜索目录 <directories>，
  # <pattern> 中必须包含 % 字符
  # 可以连续设置多个 vpath
  # 示例1：在 ../headers 目录中搜索以 .h 结尾的文件；如果找不到，在 /usr/include 目录中继续搜索
  vpath %.h ../headers
  vpath %.h /usr/include

  # vpath <pattern>：清除符合模式 <pattern> 的文件的搜索目录
  # 示例2：清除以 .h 结尾的文件的搜索目录
  vpath %.h

  # vpath：清除所有已被设置好了的文件搜索目录
  # 示例3：清除所有通过 vpath 关键字设置的搜索目录
  vpath
  ```