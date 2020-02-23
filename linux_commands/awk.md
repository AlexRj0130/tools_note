[TOC]

# awk

- awk 命令依次处理==一行==内容;
- 因此善于处理==日志==、==CSV文件==等每行格式都相同的文件。
- 参考文档
  - [awk 入门教程](http://www.ruanyifeng.com/blog/2018/11/awk.html)


## 基本用法

- 一般形式：awk [条件] 动作 文件名
  - 示例1：awk '{print $0}' demo.txt
    - 说明：逐行打印 demo.txt 文件中的内容
      - print：打印命令
      - $0：代表当前行
  - 示例2：awk -F ':' '{print $1, $3}' demo.txt
    - 说明：逐行打印 demo.txt 中每行的第1列和第3列的内容
      - awk 默认根据空格和制表符，将一行内容分成若干个列，依次用 $1、$2...代替;
      - 使用 -F 参数可以自行指定分隔符
      - $1 和 $3 之间的逗号可以在打印时会被使用输出分隔符替换
  - 示例3：awk -F "[: \\t]" '{print "col2=" \$2 ", col4=" \$4}' demo.txt
    - 说明：逐行打印 demo.txt 中每行的第2列和第4列的内容，期间使用冒号、空格和制表符将行分为列
      - 使用 print 命令时，通过使用双引号，可以原样打印指定内容
      - 使用 -F 时，可以通过双引号中间的方括号中的内容，指定多个分隔符
  - 注：
    - “[条件]” 可省，默认为"真"
    - 如果需要处理的是管道 “|” 传来的数据，可以省略文件名 

## 变量

- $0：代表当前行
- $1\~\$n：代表第1~n列
- NF：代表当前行包含的列数
  - 示例：awk 'print $(NF-1) $NF' demo.txt
  - 说明：逐行打印 demo.txt 中的倒数第2列和倒数第1列的内容
- NR：代表当前处理行的行号
  - 示例：awk 'print NR ")" $0' demo.txt
  - 说明：逐行打印 demo.txt 中的各行，并在行首添加行号
- FILENAME：代表当前文件名
- FS：列分隔符，默认为空格和制表符
- RS：行分隔符，默认为换行符
- OFS：输出时的列分隔符，默认为空格
- ORS：输出时的行分隔符，默认为换行符
- OFMT：输出数字时的格式，默认为 %0.6g
- 
## 条件

- 示例1：awk '/usr/ {print $0}' demo.txt
  - 说明：逐行打印 demo.txt 中包含 usr 的行
    - “//” 之间包含的是一个正则表达式
- 示例2：awk 'NR % 2 == 1 && NR >= 5 {print $0}' demo.txt
  - 说明：逐行打印 demo.txt 中行号大于等于5的奇数行 
- 示例3：awk ' $1 == "alice" || $2 != "bob" {print $0}' demo.txt
  - 说明：逐行打印 demo.txt 中第一列为 alice 且第二列不为 bob 的行

## if语句

- 示例1：awk '{if (\$1 == "alice") print NR}' demo.txt
  - 说明：逐行打印 demo.txt 中第一列为 alice 的行号
- 示例2：awk '{if (\$1 == "alice" print NR; else print NR ")" \$0)}'
  - 说明：逐行处理 demo.txt 中的内容，如果第一列为 alice，则打印行号；否则，打印行号和改行内容

## [内置函数](https://www.gnu.org/software/gawk/manual/html_node/Built_002din.html#Built_002din)

> 函数：用来对获取到的数据进行处理。

- 一些常用的内置函数
  - toupper()：将字符转换为大写
  - tolower()：将字符转换为小写
  - length()：计算字符串的长度
  - substr()：获取字符串的子串
    - 示例1：awk 'print substr($1, 3)' demo.txt
      - 说明：逐行打印 demo.txt 中第一列中从第3个字符开始到末尾的内容
    - 示例2：awk 'print substr($1, 3, 5)' demo.txt
      - 说明：逐行打印 demo.txt 中第一列中从第3个字符开始共5个字符的内容
  - sin()：计算正弦值
  - cos()：计算余弦值
  - sqrt()：计算平方根
  - rand()：返回一个随机数

