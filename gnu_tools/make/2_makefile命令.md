[TOC]

# make

## makefile命令

- 命令必须以 Tab 键开头（除非命令紧跟在依赖规则后面）；
- 各行命令之间的空行或空格会被忽略（如果空行以 Tab 开头，则为空命令）；
- **命令的规则与操作系统的 Shell 命令行一致**；
- make 按顺序逐条执行各行命令。

### 显式正在执行的命令行

- 默认情况下，make 会把==将要执行的命令行==显示到屏幕上；
- 在命令行前使用 `@` 字符可以使 make 不显示该行命令；
  - 示例：
    ```makefile
    @echo 正在编译xxx模块......
    ```
- 在执行 make 时，使用 `-s`（`--slient` 或 `--quite`）选项，将全面禁止显示被执行的命令行；
- 在执行 make 时，使用 `-n`（`--just-print`）选项，将按照执行顺序显示各行命令（但不具体执行）。

### 命令的执行

- 如果需要让上一条命令的执行结果应用在下一条命令时，则必须把两条命令写在同一行，并使用分号分隔
  - 示例：
    ```makefile
    exec:
      cd /home/xchen; pwd
    ```

### 命令的出错

- 一旦一条命令执行完成后返回**错误**，将终止执行当前规则（有可能会终止执行所有规则）；
- 在**某行命令**前添加一个减号 `-`，则无论该行命令是否执行成功，均继续往下执行；
- 使用 `.IGNORE` 作为某个规则的目标，将忽略该规则中的所有命令执行过程中的错误；
- 在执行 make 时，使用 `-k`（`--keep-going`）选项，将终止命令出错所属规则的执行，但继续执行其他规则；
- 在执行 make 时，使用 `-i`（`--ignore-errors`）选项，将忽略执行过程中的所有错误。

### 定义命令包

- 命令包：将相同的命令序列定义为一个变量（类似于 C 的宏）
  - 示例：
    ```makefile
    # 定义命令包
    define run-yacc
    yacc $(firstword $^)
    mv y.tab.c $@
    endef

    # 引用命令包
    foo.c : foo.y
        $(run-yacc)
    ```


## 嵌套执行make

- 在全局 makefile 中调用局部 makefile
  - 示例：
    ```makefile
    # 进入到子目录 ./subdir，然后执行定义好的宏 $(MAKE)
    # 定义宏 $(MAKE) 可以便于维护 make 命令所需的参数
    subsystem:
        cd subdir && $(MAKE)
    
    # 等价于
    subsystem:
        $(MAKE) -C subdir
    ```

- 从全局 makefile 传递参数到局部 makefile（不会覆盖局部 makefile 中所定义的变量，除非指定了 `-e` 选项）
  - 示例：传递指定变量
    ```makefile
    export variable = value
    
    # 等价于
    variable = value
    export variable

    # 等价于
    export variable := value

    # 等价于
    variable := value
    export variable
    ```
  - 示例：传递指定变量
    ```makefile
    export variable += value

    # 等价于
    variable += value
    export variable
    ```
  - 示例：传递所有变量
    ```makefile
    export
    ```
  - 示例：禁止传递指定变量
    ```makefile
    variable = value
    unexport variable
    ```
  - 注：对于 `SHELL` 和 `MAKEFLAGS` 变量，总是传递到局部 makefile
    - 对于 `MAKEFLAGS` 变量：在调用全局 makefile 时指定了 make 命令的参数，或者在全局 makefile 中定义了该变量，则 `MAKEFLAGS` 变量中将包含这些参数；
      - make 命令的 `-C`，`-f`， `-h`， `o`， `w` 参数不会被传递到局部。
      - 示例：避免传递 `MAKEFLAGS` 变量到局部
        ```makefile
          subsystem:
              cd subdir && $(MAKE) MAKEFLAGS=
        ```

- 显示嵌套调用过程中 make 的当前工作目录
  - 在调用 make 时，使用 `-w` 选项即可
  - 或者，使用 `-C` 选项在 makefile 中调用局部 makefile，`-w` 选项将自动打开
  - 注：如果在调用 make 时使用了 `-s` 选项，则 `-w` 将失效。 