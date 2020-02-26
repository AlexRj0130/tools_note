[TOC]

# make

## makefile函数

- 在 makefile 中使用函数来处理变量；
- 函数的==返回值可以当做变量来使用==。

### 函数的调用语法

- 一般形式
  ```makefile
  $(<function> <arguments ...>)  # 建议用这种形式
  # 或
  ${<function> <arguments ...>}
  ```
  - function：函数名
  - arguments：函数参数，参数间以逗号 `,` 分隔
  - 备注：函数名和函数参数之间以空格分隔。

### 字符串处理函数

#### subst字符串替换函数

- 一般形式：$(sub \<from>,\<to>,\<text>)
- 作用：把字符串 text 中的 from 子串替换成 to 字串。
- 返回值：被替换后的字符串。
- 示例：
  ```makefile
  $(sub ee,EE, feet on the street)
  ```

#### patsubst模式字符串替换函数

- 一般形式：$(patsubst \<pattern>,\<replacement>,\<text>)
- 作用：把 text 中与模式 pattern 匹配的**单词**（以空格、Tab 或回车分隔的字符）替换为 replacement。
  - 注意：
    - pattern 中可以包含通配符 `%`，表示任意长度的字串
    - replacement 中可以包含通配符 `%`，表示 pattern 中的 % 所代表的字串
- 返回值：被替换后的字符串。
- 示例：
  ```makefile
  objects := foo.o bar.o baz.o
  $(patsubt %.o,%.c,$(objects))

  # 等价于
  $(objects:.o=.c)
  ```

#### strip去空格函数

- 一般形式：$(strip \<string>)
- 作用：去掉 string 字串中的开头和结尾的空白字符
- 返回值：去掉空白字符后的字符串。
- 示例：
  ```makefile
  empty = 
  string = $(empty)        hello world   $(empty)
  $(strip string)  # 结果为 hello world
  ```

#### findstring查找字符串函数

- 一般形式：$(findstring \<target>,\<text>)
- 作用：在字符串 text 中查找 target 字符串
- 返回值：如果找到，则返回 target；否则，返回空串
- 示例：
  ```makefile
  $(findstring, abc, abcdefg)
  ```

#### filter过滤函数

- 一般形式：$(filter \<pattern ...>,\<text>)
  - pattern 中可以包含多个模式
- 作用：从 text 中过滤出符合模式 pattern 的子串
- 返回值：符合模式 pattern 的子串
- 示例：
  ```makefile
  sources := foo.c bar.c baz.s ugh.h
  foo: $(sources)
      cc $(filter %.c %.s,$(sources)) -o foo
  # $(filter %.c %.s,$(sources)) 返回的值是 foo.c bar.c baz.s
  ```

#### filter-out反向过滤函数

- 一般形式：$(filter-out \<pattern ...>,\<text>)
  - pattern 中可以包含多个模式
- 作用：从 text 中过滤掉不符合模式 pattern 的子串
- 返回值：不符合模式 pattern 的子串
- 示例：
  ```makefile
  objects=main1.o foo.o main2.o bar.o
  mains=main1.o main2.o
  # $(filter-out $(mains),$(objects)) 返回值是 foo.o bar.o
  ```

#### sort排序函数

- 一般形式：$(sort \<list>)
- 作用：给字符串 list 中的单词按升序排序（单词以空白字符分隔）
  - 注意：list 中相同的单词会被去重
- 返回值：排序后的字符串
- 示例：
  ```makefile
  $(sort foo bar lost)  # 返回值是 bar foo lost
  ```

#### word取单词函数

- 一般形式：$(word \<index>,\<text>)
- 作用：从 text 中取第 index 个单词（index 从 1 开始）
- 返回值：取到的单词
  - 注意：如果 index 大于 text 中单词的数量，那么返回空串
- 示例：
  ```makefile
  $(word 2, foo bar baz)  # 返回值是 bar
  ```

#### wordlist取单词串函数

- 一般形式：$(wordlist \<begin-index>,\<end-index>,\<text>)
- 作用：从 text 中取 begin-index（包含）到 end-index （包含）之间的单词串
- 返回值：取到的单词串
  - 注意：
    - 如果 begin-index 大于 text 中单词的数量，那么返回空串
    - 如果 end-index 大于 text 中单词的数量，那么返回从 begin-index 到 text 结束的单词串
- 示例：
  ```makefile
  $(wordlist 2, 3, foo bar baz)  # 返回值是 bar baz
  ```

#### words统计单词个数函数

- 一般形式：$(words \<text>)
- 作用：统计 text 中单词的个数
- 返回值：text 中单词的个数
- 示例：
  ```makefile
  $(words, foo bar baz)  # 返回值是 3
  ```

#### firstword取首单词函数

- 一般形式：$(firstword \<text>)
- 作用：从 text 中取出第一个单词
- 返回值：text 中的第一个单词
- 示例：
  ```makefile
  $(firstword foo bar baz)  # 返回值是 foo
  ```

### 文件名操作函数

> 每个函数的字符串参数都会被当做==一个或一系列==的文件名。

#### dir取目录函数

- 一般形式：$(dir \<filenames ...>)
- 作用：从文件名序列 filenames 中取出目录部分
  - 备注：目录部分指的是最后一个反斜杠`/`之前的部分（如果没有，就返回 `./`）
- 返回值：文件名序列 filenames 中的目录部分
- 示例：
  ```makefile
  $(dir src/foo.c hacks)  # 返回值是 src/ ./
  ```

#### notdir取文件名函数

- 一般形式：$(notdir \<filenames ...>)
- 作用：从文件名序列 filenames 中取出非目录（文件名和拓展名）部分
- 返回值：文件名序列 filenames 中的非目录部分
- 示例：
  ```makefile
  $(notdir src/foo.c hacks)  # 返回值是 foo.c hacks
  ```

#### suffix取后缀函数

- 一般形式：$(suffix \<filenames ...>)
- 作用：从文件名序列 filenames 中取出各个文件名的后缀（拓展名）
- 返回值：文件名 filenames 中各个文件的后缀
  - 注意：如果文件没有后缀，则返回空串
- 示例：
  ```makefile
  $(suffix src/foo.c src-1.0/bar.c hacks)  # 返回值是 .c .c  
  ```

#### basename取前缀函数

- 一般形式：$(basename \<filenames ...>)
- 作用：从文件名序列 filenames 中取出各个文件名的前缀部分（包括目录和文件名，不包括拓展名）
- 返回值：文件名 filenames 中各个文件的前缀
  - 注意：如果文件没有前缀，则返回空串
- 示例：
  ```makefile
  $(basename src/foo.c src-1.0/bar.c hacks)  # 返回值是 src/foo src-1.0/bar hacks
  ```

#### addsuffix添加后缀函数

- 一般形式：$(addsuffix \<suffix>,\<filenames...>)
- 作用：给文件名序列 filenames 中的各个文件名添加指定后缀 suffix
- 返回值：添加后缀后的文件名序列
- 示例：
  ```makefile
  $(addsuffix .c,foo bar)  # 返回值是 foo.c bar.c
  ```

#### addprefix添加前缀函数

- 一般形式：$(addprefix \<prefix>,\<filenames...>)
- 作用：给文件名序列 filenames 中的各个文件名添加指定前缀 prefix
- 返回值：添加前缀后的文件名序列
- 示例：
  ```makefile
  $(addprefix src/,foo bar)  # 返回值是 src/foo src/bar
  ```

#### join字符串连接函数
- 一般形式：$(join \<list1>,\<list2>)
- 作用：把 list2 中的单词对应地加到 list1 中的单词后面
  - 注意：
    - 如果 list1 的单词个数比 list2 多，那么 list1 中多出来的单词保持原样；
    - 如果 list1 的单词个数比 list2 少，那么 list2 中多出来的单词原样复制到 list1 后面。
- 返回值：连接后的字符串
- 示例：
  ```makefile
  $(join aaa bbb , 111 222 333)  # 返回值是 aaa111 bbb222 333
  $(join aaa bbb ccc, 111 222)  # 返回值是 aaa111 bbb222 ccc
  ```

### 其它函数

#### foreach

- 一般形式：$(foreach \<var>,\<list>,\<text>)
- 作用：把 list 中的单词逐个取出放到 var 所指定的变量中，然后再执行 text 所包含的表达式
  - 注意：var 是一个**临时**的局部变量，其作用域仅在 foreach 函数中。
- 返回值：多个由空格分隔的字符串组成的长字符串
  - 备注：每执行一次，text 所包含的表达式会返回一个字符串。
- 示例：
  ```makefile
  names := a b c d
  files := $(foreach n,$(names),$(n).o)  # 返回值是 a.o b.o c.o d.o
  ```

#### if

- 一般形式：
  ```makefile
  $(if <condition>,<then-part>)
  $(if <condition>,<then-part>,<else-part>)
  ```
- 作用：如果 condition 表达式返回的不是空字符串，执行 then-part；否则，执行 else-part。
- 返回值：如果执行的是 then-part，则返回值就是 then-part 的返回值；否则，就是 else-part 的返回值。

#### call

- 一般形式：$(call \<expression>,\<parm1>,\<parm2>,...,\<parmn>)
- 作用：当执行该函数时，expression 中的变量（如 $(1)，$(2) 等等）会被参数 parm1, parm2 等等依次取代。
- 返回值：返回 expression 表达式的返回值
- 示例：
  ```makefile
  reverse =  $(2) $(1)
  foo = $(call reverse,a,b)  # 返回值是 b a
  ```

#### origin

- 一般形式：$(origin <variable-name>)
  - 注意：variable-name 是变量的名字，不应该是引用。所以，最好不要在 variable-name 中使用 `$` 字符。
- 作用：返回变量的来源
- 返回值：变量的来源，包括以下几种
  - `undefined`：变量没有被定义过
  - `default`：默认定义的变量（例如 `CC`）
  - `environment`：环境变量
  - `file`：变量定义在 makefile 中
  - `command line`：变量定义在命令行中 
  - `override`：变量被 override 指示符重新定义
  - `automatic`：变量是个自动化变量
- 示例：
  ```makefile
  ifdef bletch
  ifeq "$(origin bletch)" "environment"
      bletch = barf, gag, etc.
  endif
  ```

#### shell

- 一般形式：$(shell <shell-command>)
- 作用：执行操作系统命令
- 返回值：返回操作系统命令执行后的输出
- 注意：这个函数会重新生成一个 shell 来执行命令，所以，如果大量使用，对系统性能有害。
- 示例：
  ```makefile
  contents := $(shell cat foo)
  files := $(shell echo *.c)
  ```

### 控制make的函数

#### error

- 一般形式：$(error <text ...>)
- 作用：把 text 作为 makefile 的运行时的错误信息进行输出，然后由调用者决定是否让 make 继续执行
- 返回值：无
- 示例：
  ```makefile
  # 如果定义了 ERROR_001 变量，则产生 error 调用
  ifdef ERROR_001
      $(error error is $(ERROR_001))
  endif

  # 如果执行了 err 伪目标，则产生 error 调用
  ERR = $(error found an error!)

  .PHONY: err
  err: $(ERR)
  ```

#### warning

> 与 error 函数类似，只不过不会让 make 退出，而是让 make 输出一段警告信息，然后继续执行。