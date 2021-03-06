[TOC]

# Extensions

## Vim

---
### 基本操作

- 光标移动
  - k、j、h、l：上、下、左、右
  - b、e、w：上一个单词首、下一个单词尾、下一个单词首
  - 0、$、^：行首、行尾、行第一个字符
  - H、M、L：屏幕顶部、屏幕中部、屏幕底部
  - gg、G：文件首、文件尾
  - :num：第 num 行

- 光标移动（easymotion）
  - \<leader>\<leader> b、e、w：定位前面的单词首、后面的单词尾、后面的单词首
  - \<leader>\<leader> k、j：定位前面的行、后面的行

- 光标移动（通过标记在当前文件内移动）
  - ma：在光标处做一个名称为 a 的标记（可用 a~z, A~Z 标记
    - a~z：当前文件内有效
    - A~Z: 全局有效
  - `a：定位到标记 a
  - 备注：不用输入 ":"，直接输入 m+{a、A即可}

- 编辑操作
  - .：重复上一个编辑操作
  - i、a：光标前、后开始输入
    - I、A：当前行首、尾开始输入
    - o、O：当前行上、下插入空行输入
  - u：撤销
    - ctrl+r：重做
  - d：删除选中的内容
    - dd：删除当前行
    - db、de、dw、d0、d$、dgg、dG、d10gg
  - y：复制选中的内容
    - yy：复制当前行
    - yb、ye、yw、y0、y$、ygg、yG、y10gg

- 查找操作
  - \*、#：向后、向前查找光标所在的单词
  - /xxx、?xxx：向后、向前查找指定的内容
  - n、N：下一处、上一处匹配

- 选择操作
  - v：进入光标模式，然后移动光标即可（除了:num 不可用，其它均可）
  - ctrl+v：然后移动光标即可（除了:num 不可用，其它均可）
    - o：编辑选中块的顶点位置
    - I：插入内容
    - d：删除选中内容
     - D：删除选中内容及后面的所有内容

- 替换操作
  - :%s/old/new/g 搜索整个文件，将所有的old替换为new
  - :%s/old/new/gc 搜索整个文件，将所有的old替换为new，每次替换前需要确认

- 屏幕滚动
  - ctrl+f、ctrl+b：下一页、上一页
  - ctrl+d、ctrl+u：下半页、上半页
  - zz、zt、zb：光标所在行移动至屏幕中间、顶部、底部
  - ctrl+o、i：上一个、下一个浏览的位置

- 多窗口操作(通过重新设置 vscode workbench 快捷键实现)
  - ctrl+w ctrl+s、v 水平、垂直分割窗口
  - ctrl+w h、l、j、k 跳到左、右、下、上侧窗口组
  - ctrl+w ctrl+h、l、j、k 将当前窗口组与左、右、上、下窗口组交换位置

---
### 使用寄存器

> 参考资料：[Vim使用寄存器进行复制和粘贴](https://blog.csdn.net/huangkangying/article/details/38376951)

- 寄存器的使用
  - 把内容加入寄存器：
    - 示例：`"ayy`
    - 说明：将 yy 操作的内容放入 `"a`
  - 使用寄存器的内容：
    - 示例：`"ap`
    - 说明：粘贴 `"a` 中的内容
  - 注：只读寄存器、搜索寄存器由 VIM 自动放入内容
- 寄存器分类
  - 未命名寄存器
    - 内容来源：d、c、s、x、y 命令
  - 数字寄存器（"0 ~ "9，共10个）
    - 内容来源：yank 和 delete 操作
      - "0：最近使用最多的y命令生成的文本内容
      - "1 ~ "9：存放最近使用的d行操作命令生成的文本内容，并在9个寄存器间对内容进行轮流存放（即有新的内容时，将"1的内容推到"2, 2到3，3到4 ...）
  - 字母寄存器（"a ~ "z / "A ~ "Z，共26个）
    - 内容来源：手动放入
      - "a ~ "z：每次指定这些寄存器之一时，产生的文本内容将覆盖掉寄存器中原有的内容
      - "A ~ "Z：每次指定这些寄存器之一时，产生的文本内容将追加到寄存器中原有的内容之后
        - 如果选项'cpoptions'的值中有>符号，则在追加同时会进行行分割，可以通过命令`:set cpo+=>`设置。
  - 只读寄存器（". "% "# ":，共4个）
    - ".：包含最后在vim insert模式下插入的文本内容，也可以通过命令，重复上一次的操作
    - "%：包含当前文件的名字，方便在文件中插入文件名
    - "#：包含当前可选择的文件名，指在当前会话中使用过的文件的名字
  - 系统剪贴板
  - 非行删除内容缓存寄存器（"-）
  - 表达式寄存器
  - GUI 选择寄存器
  - 黑洞寄存器
  - 最后搜索模式寄存器