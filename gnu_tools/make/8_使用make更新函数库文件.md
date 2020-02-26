[TOC]

# make

## 使用make更新函数库文件

- 函数库文件：就是对 Object 文件的打包文件
- 备注：
  - `$%` 是专属于函数库文件的自动化变量；
  - 在 Unix 下，一般由 ar 命令完成打包工作
- 注意：
  - 在进行函数库打包时，要小心使用 make 的并行机制（`-j` 选项）。原因在于多个 `ar` 命令同一时间运行在同一个函数库打包文件上时，可能会损坏该函数库文件。

### 函数库文件的成员

- 指定函数库文件及其成员：
  - 一般形式：archive(member)
  - 示例：
    ```makefile
    foolib(hack.o): hack.o 
      ar cr foolib hack.o
    ```
  - 示例：指定多个成员
    ```makefile
    foolib(hack.o kludge.o): hack.o kludge.o
      ar cr foolib hack.o kludge.o
    ```
  - 示例：使用通配符指定成员
    ```makefile
    foolib(*.o)
    ```

### 函数库成员的隐含规则

- 如果目标是 a(m) 形式的，那么目标会调整为 m
  - 例如：以 make foo.a(bar.o) 的形式调用 makefile
    - 隐含规则先找 bar.o 的规则
      - 如果没有找到，隐含规则会使用內建规则尝试通过 bar.c 生成 bar.o
    - 然后，在使用 bar.o 文件生成打包文件 foo.a

### 函数库文件的后缀规则

- 可以使用后缀规则和隐含规则来生成函数库打包文件
  - 示例：
    ```makefile
    .c.a:
        $(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $*.o
        $(AR) r $@ $*.o
        $(RM) $*.o

    # 等价于
    (%.o) : %.c
        $(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $*.o
        $(AR) r $@ $*.o
        $(RM) $*.o
    ```