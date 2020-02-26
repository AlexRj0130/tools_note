[TOC]

# make

## make的运行

- 默认情况下，make 会执行当前目录下的 Makefile 文件（一切都是自动的）；
- 也可以自行控制 make 如何执行。

### make的退出码

- `0`：表明执行成功；
- `1`：表明运行时出现错误（可以是任何错误）；
- `2`：表明使用了 make 的 `-q` 选项，并且 make 使得一些目标不需要更新。

### 指定makefile

- GNU make 默认依次寻找当前目录下的以下文件
  - GNUmakefile（GNU make 支持）
  - makefile
  - Makefile（建议）
- 使用 make 的 `-f`（`--file` 或 `--makefile`）选项指定自定义的文件名，例如
  ```shell
  make -f xchen.mk
  ```
  - 注意：如果不止一次地使用了 `-f` 参数，那么所有指定的 makefile 将被**连在一起**传递给 make。

### 指定目标

- 默认情况下，makefile 中的第一个目标作为==最终目标==；
- 通过在 make 命令后跟指定目标名可以让 make 将其作为最终目标，并执行。
  - 注意：最终目标不能以 `-` 开头，也不能包含 `=` 字符。
  - 备注：
    - **伪目标**可以作为最终目标；
    - 没有明确写出来的目标，但是可以由 make 隐含推导出来的目标也可以作为最终目标；
    - 环境变量 `MAKECMDGOALS` 中存放用户指定的最终目标列表

### 检查规则

- 如果不需要运行 makefile 中的规则（只检查编写好的命令，或执行的序列），可以使用下述 make 选项
  - `-n`（`--just-print` 或 `--dry-run` 或 `--recon`）：不管目标是否更新，不执行参数而只打印命令（包括规则和规则下的命令），用来调试 makefile。
  - `-t`（`--touch`）：更新目标文件的时间（假装重新生成了目标文件，但实际没有）
  - `-q`（`--question`）：寻找目标，如果找到，则什么也不输出（也不会编译）；否则，打印错误信息
  - `-W <file>`（`--what-if=<file>` 或 `--assume-new=<file>` 或 `--new-file=<file>`）：寻找依赖于源文件 file 的命令，并运行找到的命令。

### make的参数

- `-b`（`-m`）：
  - 功能：忽略和其它版本 make 的兼容性
- `-B`(`--always-make`)：
  - 功能：重新编译所有目标（忽略新旧关系）
- `-C <dir>`（`--directory=<dir>`）：
  - 功能：指定读取 makefile 的目录
  - 备注：如果有多个 `-C` 选项，则后面的路径以前面的路径作为相对路径，并以最后的目录作为被指定目录。
- `-debug [=<options>]`：
  - 功能：输出 make 的调试信息，可选以下几种级别
    - `a`(all)：输出所有调试信息
    - `b`(basic)：输出简单的调试信息（不输出不需要重新编译的目标）
    - `v`(verbose)：输出的信息包括被解析的 makefile，不需要重编译的依赖文件及依赖目标等
    - `i`(implicit)：输出所有的隐含规则
    - `j`(jobs)：输出执行规则中的命令的详细信息（例如命令的 PID、返回码等）
    - `m`(makefile)：输出读取、更新、执行 makefile 的信息
- `-d`：
  - 功能：相当于 `debug=a`
- `-e`（`--environment-overrides`）：
  - 功能：指明环境变量的值覆盖 makefile 中定义的变量的值
- `-f=<file>`（`--file=<file>` 或 `--makefile=<file>`）：
  - 功能：指定需要执行的 makefile
- `-h`（`--help`）：
  - 功能：显示帮助信息
- `-i`（`--ignore-errors`）：
  - 功能：在执行时忽略所有的错误
- `-I <dir>`（`--include-dir=<dir>`）：
  - 功能：指定一个包含 makefile 的搜索目录
  - 备注：可以使用多个 `-I` 参数来指定多个目录。
- `-j [<jobsnum>]`（`--jobs[=<jobsnum>]`）：
  - 功能：指定同时运行命令的个数
  - 备注：
    - 如果没有这个参数，make 在运行命令时能运行多少就运行多少；
    - 如果有多个这个参数，那么仅最后一个生效；
    - 在 MS-DOS 系统中该参数无效。
- `-k`（`--keep-going`）：
  - 功能：出错也不停止运行
  - 备注：如果生成一个目标失败，那么依赖于其上的目标就不会被执行了。
- `-l <load>`（`--load-average[=<load>]`，`--max-load[=<load>`]）：
  - 功能：指定 make 运行时的负载
- `-n`（`--just-print`，`--dry-run`，`--recon`）：
  - 功能：仅输出执行过程中的命令序列，但并不实际执行命令。
- `-o <file>`（`--old-file=<file>`，`--assume-old=<file>`）：
  - 功能：不重新生成指定的 file（即使这个目标 file 依赖的文件比它新）
- `-p`（`--print-data-base`）：
  - 功能：输出 makefile 中的所有数据，包括所有的规则和变量。
  - 备注：
    - 这个参数会让一个简单的 makefile 输出一堆信息；
    - 如果只想输出信息而不执行 makefile，可以使用 make -qp 命令；
    - 如果只想查看执行 makefile 前的预设变量和规则，可以使用 make -p -f /dev/null 命令
      - 会输出包含着当前 makefile 文件的文件名和行号
- `-q`（`--question`）：
  - 功能：不运行命令，也不输出
  - 备注：仅仅检查所指定的目标是否需要更新，如果返回 0，需要更新；返回 2，发生错误。
- `-r`（`--no-builtin-rules`）：
  - 功能：禁止 make 使用任何隐含规则。
- `-R`（`--no-builtin-variables`）：
  - 功能：禁止 make 使用任何作用于变量上的隐含规则。
- `-s`（`--slient`，`--quiet`）：
  - 功能：在运行命令时不输出命令的输出。
- `-S`（`--no-keep-going`，`--stop`）：
  - 功能：取消 `-k` 选项的作用。
  - 备注：因为有些选项是从 MAKEFLAGS 中继承的。
- `-t`（`--touch`）：
  - 功能：阻止生成目标的命令运行
  - 备注：原理是把目标的修改日期改成最新的。
- `-v`（`--version`）：
  - 功能：输出 make 程序的版本等信息。
- `-w`（`--print-directory`）：
  - 功能：输出运行 makefile 之前和之后的信息。
  - 备注：该选项对于跟踪和调试嵌套调用很有用。
- `--no-print-directory`：
  - 功能：关闭 `-w` 选项。
- `-W <file>`（`--what-if=<file>`，`--new-file=<file>`，`--assume-file=<file>`）：
  - 功能：假定 file 需要更新
    - 如果和 `-n` 选项使用，那么该参数将输出更新该目标时的动作
    - 如果没有 `-n` 选项，那么就和 `-t` 选项作用一致。
- `--warn-undefined-variables`：
  - 功能：只要 make 发现有未定义的变量，就输出警告信息。

