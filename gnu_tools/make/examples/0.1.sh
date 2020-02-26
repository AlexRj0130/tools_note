# 示例0.1：
#   有8个c文件和3个头文件。
#   写一个makefile来告诉 make 命令如何编译和链接这几个文件，
#   规则如下：
#     1. 如果这个工程没有编译过，那么我们的所有c文件都要编译并被链接。
#     2. 如果这个工程的某几个c文件被修改，那么我们只编译被修改的c文件，并链接目标程序。
#     3. 如果这个工程的头文件被改变了，那么我们需要编译引用了这几个头文件的c文件，并链接目标程序。

# 通过目标文件，生成最终的可执行文件
edit : main.o kbd.o command.o display.o \
        insert.o search.o files.o utils.o
    cc -o edit main.o kbd.o command.o display.o \
        insert.o search.o files.o utils.o

# 通过.c文件和.h文件生成对应的目标文件
main.o : main.c defs.h
    cc -c main.c
kbd.o : kbd.c defs.h command.h
    cc -c kbd.c
command.o : command.c defs.h command.h
    cc -c command.c
display.o : display.c defs.h buffer.h
    cc -c display.c
insert.o : insert.c defs.h buffer.h
    cc -c insert.c
search.o : search.c defs.h buffer.h
    cc -c search.c
files.o : files.c defs.h buffer.h command.h
    cc -c files.c
utils.o : utils.c defs.h
    cc -c utils.c

# 制定伪目标，用来清空所有生成的文件
clean :
    rm edit main.o kbd.o command.o display.o \
        insert.o search.o files.o utils.o