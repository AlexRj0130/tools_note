# 示例6.1：
#   通过自动推导简化示例1.1的编写。
#   用来展示另一种自动推导的使用方法（不建议使用），原因在于
#     1. 文件的依赖关系不够清晰；
#     2. 不便于维护：如果文件比较多时，并且需要加入新的目标文件，更加不容易理清依赖关系。

objects = main.o kbd.o command.o display.o \
    insert.o search.o files.o utils.o

edit : $(objects)
    cc -o edit $(objects)

# 使用自动推导生成目标文件
# 注意：同一个目标文件可以多次出现在不同的行
$(objects) : defs.h
kbd.o command.o files.o : command.h
display.o insert.o search.o files.o : buffer.h

.PHONY : clean
clean :
    rm edit $(objects)