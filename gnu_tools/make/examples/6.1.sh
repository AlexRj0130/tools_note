# 示例6.1：
#   通过自动推导简化示例1.1的编写。

# 使用变量
objects = main.o kbd.o command.o display.o \
    insert.o search.o files.o utils.o

edit : $(objects)
    cc -o edit $(objects)

# 使用自动推导生成目标文件
main.o : defs.h
kbd.o : defs.h command.h
command.o : defs.h command.h
display.o : defs.h buffer.h
insert.o : defs.h buffer.h
search.o : defs.h buffer.h
files.o : defs.h buffer.h command.h
utils.o : defs.h

# 伪目标
.PHONY : clean
clean :
    rm edit $(objects)