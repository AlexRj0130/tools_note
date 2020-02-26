[TOC]

# make

## makefile变量

- makefile 变量就是一个==字符串==（可以把它理解成 C 语言中的宏）
  - 可以理解成在执行期间变量可以原地展开成对应的字符串（可以简化 makefile 的书写）；
  - 与宏不同的是，可以改变 makefile 变量的值。
- makefile 变量可以被用在 `目标`，`依赖目标`，`命令` 或 makefile 的其它部分中；
- makefile 变量名大小写敏感（推荐使用首字母大写的驼峰法命名变量，以便与系统变量区分）。

### 自定义变量

#### 变量的声明

- 注：声明变量时要给定初值
- 示例：
  ```makefile
  # 声明一个名称为 objects 的变量，其值为 main.o kbd.o
  # 行尾的 “\” 用来书写跨行的字符串
  objects = main.o \
            kbd.o
  ```

#### 变量的使用

```makefile
# 使用 $() 引用变量的值
$(objects)
```

#### 追加变量的值

- 使用 `+=` 给变量追加值
  - 示例：
    ```makefile
    objects = main.o foo.o bar.o utils.o
    objects += another.o
    # objects 的值为 main.o foo.o bar.o utils.o another.o
    ```
  - 示例：
    ```makefile
    variable := value
    variable += more
    # 等价于
    variable := value
    variable := $(variable) more

    variable = value
    variable += more
    # 等价于
    variable = $(variable) more  # 递归定义（make 会自动解决，所以无需担心）
    ```
  - 备注：
    - 如果变量没有被定义过，则 `+=` 自动变成 `=`；
    - 如果变量已经定义过，则 `+=` 会继承于前次操作的赋值符。

#### 变量中的变量

- 使用其它变量作为变量的值
  - 方式1：使用 `=` 操作符，左侧为变量，右侧为变量的值
    - 示例：
      ```makefile
      foo = $(bar)
      bar = $(ugh)
      ugh = Huh?
      
      all:
          echo $(foo)
      ```
    - 注意：被引用的变量可以定义在引用之后（可能产生递归定义，make 可以检测递归定义并报错）。
  - 方式2：使用 `:=` 操作符，左侧为变量，右侧为变量的值
    - 示例：
      ```makefile
      x := foo
      y := $(x) bar
      x := later

      # 等价于
      y := foo bar
      x := later
      ```
      - 注意：只能使用前面定义好的变量（所以不会产生递归定义）
    - 示例：
      ```makefile
      ifeq (0,${MAKELEVEL})
      cur-dir   := $(shell pwd)
      whoami    := $(shell whoami)
      host-type := $(shell arch)
      MAKE := ${MAKE} host-type=${host-type} whoami=${whoami}
      endif
      ```
    - 示例：定义一个变量，==其值是一个空格==
      ```makefile
      nullstring :=
      space := $(nullstring) # end of the line 
      ```
      - 备注：Empty 变量 nullstring 标识变量的值开始；注释 # 标识变量值的终止，从而定义一个空格。
  - 方式3：使用 `?=` 操作符，左侧为变量，右侧为值
    - 示例：
      ```makefile
      FOO ?= bar

      # 等价于
      ifeq ($(origin FOO), undefined)
          FOO = bar
      endif
      ```
      - 注意：如果 FOO 没有定义过，那么定义变量 FOO 的值为 bar；否则，什么都不做。 

#### 变量的高级用法

- 用法1：变量值的替换
  - 一般形式：$(var:a=b)
    - 说明：把变量 `var` 中所有以 ==`a` 字串==结尾的字串 `a` 替换成字串 `b`。
    - 示例：
      ```makefile
      foo := a.o b.o c.o
      bar := $(foo:.o=.c)
      # bar 的值为 a.c b.c c.c
      ```
  - 静态模式
    - 示例：
      ```makefile
      foo := a.o b.o c.o
      bar := $(foo:%.o=%.c)
      # bar 的值为 a.c b.c c.c
      ```
    - 注意：模式中必须包含一个 `%` 字符
- 用法2：将变量的值再当成变量
  - 示例：
    ```makefile
    x = y
    y = z
    a := $($(x))
    # a 的值为 z
    ```
  - 示例：
    ```makefile
    x = $(y)
    y = z
    z = Hello
    a := $($(x))
    # a 的值为 Hello
    ```
  - 示例：
    ```makefile
    x = variable1
    variable2 := Hello
    y = $(subst 1,2,$(x))
    z = y
    a := $($($(z)))
    # a 的值为 Hello
    ```
  - 示例：使用多个变量的值组成一个变量的名字
    ```makefile
    first_second = Hello
    a = first
    b = second
    all = $($a_$b)
    # a 的值为 Hello
    ```
  - 示例：使用变量的值传递函数的名字
    ```makefile
    ifdef do_sort
        func := sort
    else
        func := strip
    endif
    
    bar := a d b g q c
    
    foo := $($(func) $(bar))
    ```
  - 示例：将变量的值作为的变量放在操作符左边
    ```makefile
    dir = foo
    $(dir)_sources := $(wildcard $(dir)/*.c)
    define $(dir)_print
    lpr $($(dir)_sources)
    endef
    ```

#### 多行变量

- 一般形式：
  ```makefile
  define <variable>
  <value_1>
  <value_2>
  ...
  endef
  ```
  - define 后为变量的名字
  - 变量的值可以包括函数、命令、文字、或其它变量
    - 如果是命令，需要以 `Tab` 键开头，否则不会被作为命令。
- 作用：定义变量，其值可以包含换行
- 示例：
  ```makefile
  define two-lines
      echo foo
      echo $(bar)
  endef
  ```

#### override指示符

- 一般形式：
  ```makefile
  # 重新赋值
  override <variable> = <value>
  override <variable> := <value>

  # 追加赋值
  override <variable> += <more value>

  # 定义多行变量
  override define foo
  bar
  endef
  ```
- 作用：在 makefile 中覆盖通过 make 的命令行参数设置的变量值
- 备注：如果变量是通过 make 的命令行参数设置的，那么默认会忽略在 makefile 中对该变量的赋值（除非使用了 override 关键字）。

### 环境变量

- 系统的环境变量可以被载入到 makefile 中
- 以下情况系统环境变量会被覆盖
  - makefile 中定义了这个变量
  - 执行 make 时，命令行参数传入了这个变量
- 执行 make 时，使用 `-e` 选项可以使系统环境变量覆盖 makefile 中定义的变量
- 备注：当 make 嵌套调用时，上层 makefile 中定义的并 export 的变量，以及通过命令行设置的变量，会以==系统环境变量==的方式传递到下层的 makefile 中。
- 注意：不要把许多变量都定义在系统环境变量中，因为太多的系统环境变量可能会带来麻烦。

### 目标变量

- 一般形式：
  ```makefile
  <target ...> : <variable-assignment>;
  <target ...> : override <variable-assignment>
  ```
  - variable-assignment 可以是各种合法的赋值表达式，例如 `=`, `:=`, `+=`, `?=`
- 作用：将变量的作用范围限定在==特定规则及其连带规则==中，而不会影响规则链以外的全局变量的值。
- 示例：
  ```makefile
  # 对于规则 prog, prog.o, foo.o bar.o 来说，CFLAGS 的值均为 -g
  # 而不论在其他的作用范围内该变量的值为多少
  prog : CFLAGS = -g
  prog : prog.o foo.o bar.o
      $(CC) $(CFLAGS) prog.o foo.o bar.o
  prog.o : prog.c
      $(CC) $(CFLAGS) prog.c
  foo.o : foo.c
      $(CC) $(CFLAGS) foo.c
  bar.o : bar.c
      $(CC) $(CFLAGS) bar.c
  ```
- 备注：override 关键字的作用同自定义变量。

### 模式变量

- 一般形式：
  ```makefile
  <pattern ...> : <variable-assignment>
  <pattern ...> : override <variable-assignment>
  ```
- 作用：将变量定义在==符合指定模式的所有目标上==。
- 备注：override 关键字的作用同自定义变量。