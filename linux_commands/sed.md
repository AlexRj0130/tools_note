[TOC]

# sed

- 主要用来自动编辑一个或多个文件，简化对文件的反复操作、编写转换程序等
- 参考资料
  - [Linux sed 命令](https://www.runoob.com/linux/linux-comm-sed.html)

## 基本用法

- 一般形式：sed [-hnV] [-e\<script>] [-f\<script文件>] [待处理文本文件]
- 参数说明
  - -e：动作位于命令行脚本
  - -f：动作位于脚本文件
  - -i：直接修改原始文件（默认输出到标准输出，不会修改原始文件）
- 动作说明
  - a：特定行后插入行
  - c：替换特定行
  - d：删除特定行
  - i：特定行前插入行
  - p：打印特定行

### 通过行号操作指定行

- 示例1：sed -e '1,3a'\NewLine demo.txt
  - 说明：把 demo.txt 的第1至3行后均增加一行（共增加3行），内容为 NewLine
    - -e：通过==在命令行中给出的脚本==（即 a\NewLine）对文本文件进行处理
    - -a：在指定行后面插入新的一行
  - 注意：
    - 如果不指定具体的行号，则默认在每一行后面增加一行指定的内容
    - 如果 demo.txt 文件为空，则输出为空
    - 可以用 $ 表示最后一行，则在文件最后插入一行表示为 sed -e '$a'\NewLine demo.txt
- 示例2：sed -e '2,4c'\NewLine demo.txt
  - 说明：把 demo.txt 的第2至4行的（共3行）内容替换为 NewLine（合并为1行）
    - c：使用指定的内容取代指定行的内容
  - 注意：
    - 如果不指定具体的行号，则默认使用 NewLine 替换所有行（替换后总行数不变）
    - 如果 4 大于 demo.txt 中的行数，那么从第 2 行开始，所有内容只被删除，而不会再进行替换
- 示例3：sed -e '2,4d' demo.txt
  - 说明：把 demo.txt 的第2至4行的内容删除
    - d：删除指定行的内容
  - 注意：
    - 如果不指定具体的行号，则删除所有内容
    - 如果 4 大于 demo.txt 中的行数，那么相当于删除第2行和之后的所有内容
- 示例4：sed '1,3i'\NewLine demo.txt
  - 说明：把 demo.txt 的每一行==前==增加一行，内容为 NewLine
  - 注意：
    - 如果不指定具体的行号，则默认在每一行前面增加一行指定的内容
    - 如果 demo.txt 文件为空，则输出为空
- ==示例5==：sed -f script demo.txt
  - 说明：把 demo.txt 的第6行后增加一行，内容为 NewLine
    - -f：通过==在指定文件中给出的脚本==对文本文件进行处理
    - script：为脚本文件，其中的内容为 6a\NewLine
  - 注意：如果 demo.txt 文件的内容小于6行，则输出为 demo.txt 文件的内容（即指定内容不会被插入）

### 通过匹配操作行

- 示例1：sed -e '/Line/a\NewLine' demo.txt
  - 说明：把 demo.txt 中所有包含 Line 的行后均增加一行 NewLine
- 示例2：sed -e '/Line/c\NewLine' demo.txt
  - 说明：把 demo.txt 中所有包含 Line 的行均替换为 NewLine
- 示例3：sed -e '/Line/d' demo.txt
  - 说明：把 demo.txt 中所有包含 Line 的行均删除
- 示例4：sed -e '/Line/i\NewLine' demo.txt
  - 说明：把 demo.txt 中所有包含 Line 的行前均增加一行 NewLine

### 替换匹配的字符（或字符串）

- 示例：sed -e 's/line/NewLine/g' demo.txt
  - 说明：把 demo.txt 中出现的所有字符串 line 替换为 NewLine