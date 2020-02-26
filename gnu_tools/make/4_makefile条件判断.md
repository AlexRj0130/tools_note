[TOC]

# make

## makefile条件判断

- 通过条件判断，可以让 make 根据运行时的不同情况选择不同的执行分支。
- 条件表达式可以用来比较变量的值，或者比较变量和常量的值。

- 一般形式
  ```makefile
  <conditional-directive>
  <text-if-true>
  endif

  # 以及
  <conditional-directive>
  <text-if-true>
  else
  <text-if-false>
  endif
  ```
  - conditional-directive：表示**条件关键字**，共有四个，分别是：
    - ifeq (<arg1>, <arg2>)：比较参数 arg1 和 arg2 的值是否相同
    - ifneq (<arg1>, <arg2>)：比较参数 arg1 和 arg2 的值是否不同
    - ifdef <variable-name>：判断参数 variable-name 的值是否非空
      - 注意：只是用来测试一个变量是否有值，并不会把变量扩展到当前位置
    - ifndef <variable-name>：判断参数 variable-name 的值是否为空
  - 注意：
    - conditional-directive，else 以及 endif 三行前均**不允许**以 `Tab` 键作为开始。
    - ==不要把自动化变量（如 `$@`） 放入条件表达式中==，因为 make 在读取 makefile 时就开始计算条件表达式的值，而自动化变量在运行时才有值。
- 示例
  ```makefile
  bar = 
  foo = $(bar)
  foo2 = 

  # ifeq 条件关键字
  ifeq ($(foo), $(bar))
      echo "foo equal with bar"
  else
      echo "foo not equal with bar"

  # ifneq 条件关键字
  ifneq ($(foo), $(bar))
      echo "foo not equal with bar"
  else
      echo "foo equal with bar"

  # ifdef 条件关键字
  ifdef foo
      frobozz = yes  # 执行这个
  else
      frobozz = no

  # ifndef 条件关键字
  ifndef foo2
      frobozz2 = no  # 执行这个
  else
      froobozz2 = yes
  ```