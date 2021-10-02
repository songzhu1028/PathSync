#########################      Read Me     #########################
# 任何版本的vs都是支持makefile编译的
# 
# Makefile文件中以#开始到行结束为注释
# 语法详见：
# http://msdn.microsoft.com/en-us/library/yz1tske6(v=VS.100).aspx
 
# nmake的参数和使用方法
# NMAKE [option...] [macros...] [targets...] [@commandfile...]
# 详见：
# http://msdn.microsoft.com/en-us/library/a23f7tc4(v=VS.100).aspx
 
# 使用本makefile编译可以使用命令
# nmake DBG=1
# nmake DBG=1 clean
# nmake DBG=1 rebuild
# nmake
# nmake clean
# nmake rebuild
#
# 用这个makefile编译任何C语言工程，只需要修改少量的几个配置即可
# TARGET, TARGET_EXT, DEFFILE, SRCS, LIBS, CFLAGS, CPPFLAGS, LFLAGS
 
######################### Basic Definition #########################
 
# 定义宏： 宏名=值
# 引用宏： $(宏名)
# 引用是通过字符串替换的方式进行的
 
TARGET = pathsync # 定义宏 宏名=值
TARGET_EXT = exe  # dll
# DEFFILE = pathsync.def
SRC_C = .\WDL\win32_utf8.c
SRC_CPP = .\WDL\WinGUI\wndsize.cpp .\PathSync\pathsync.cpp .\PathSync\fnmatch.cpp #需要给出相对路径
SRC_RC = .\PathSync\res.rc
 
# 如LIBS一行对LIBS宏进行赋值，同时也引用了LIBS宏
# 会先将宏展开，然后再赋值新的值给宏

LIBS =  $(LIBS) kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib 
CFLAGS = $(CFLAGS) /MT /O2 /EHsc /c
CPPFLAGS = $(CPPFLAGS) /MT /O2 /EHsc /c
LINK = link.exe
LFLAGS = $(LFLAGS) /nologo /subsystem:windows /RELEASE
 
# 这是一种特殊的引用宏的方法，将SRCS宏值中所有的.c替换为.obj后，作为OBJS宏的值。
# 参考Macro Substitution
# http://msdn.microsoft.com/en-us/library/bsd42ets(v=VS.100).aspx
OBJS = $(SRC_C:.c=.obj) $(SRC_CPP:.cpp=.obj) $(SRC_RC:.rc=.res)
 
 
#################### Compile and Link Options #######################
 
#### 判断是否定义了DBG宏，
#### 这里通过在nmake的选项中通过设置DBG宏来设置不同的编译链接选项
#### 其他可以使用的判断语句包括：!if 
!ifdef DBG
 
#ODIR = ..\debug
LFLAGS = $(LFLAGS) -map -debug  -PDB:$(ODIR)\$(TARGET)_$(TARGET_EXT).pdb
 
!else
 
#ODIR = ..\release
LFLAGS = $(LFLAGS) 
 
!endif
 
 
#########################  Inference Rules  #########################
#
# Description blocks（描述块）的语法规则：
#
# 目标: 依赖项
#   命令
#
# 表示生成“目标”需呀依赖于“依赖项”，生成使用“命令”
# 运行nmake时需要指明生成的目标，如果没有说明，默认为makefile中的第一个目标。
# 依赖项和命令是可选的
 
all : $(TARGET).$(TARGET_EXT)
 
# 在代码位于不同文件夹的时候，为了生成obj文件和.c文件在同一个目录，需要使用Fo选项指定obj文件输出目录。
# 这里使用了Macro Substitution的方式来定义OBJS,因为我不想写很多$(ODIR)/
# 如果不指定路径，无论c文件在那里，生成的obj文件都在./也就是proj文件所在目录
# 设置了Fo并且用了D修饰服，这时不能使用Batch-mode(::)
# Batch-mode和非Batch的区别是在预定义推导规则的后是使用:还是::
# D宏修饰符表示文件名宏中的目录部分（去掉文件名和扩展名剩下的部分）
# batch-mode rules 详见：
# http://msdn.microsoft.com/en-us/library/f2x0zs74(v=VS.100).aspx
# 预定义的推导规则（描述块）：
# http://msdn.microsoft.com/en-us/library/cx06ysxh.aspx
# 文件名宏：
# http://msdn.microsoft.com/en-us/library/cbes8ded.aspx
 
.c.obj:
    $(CC) /Fo:$@ $(CFLAGS) $<
.cpp.obj:
    $(CPP) /Fo:$@ $(CPPFLAGS) $<
.rc.res:
    $(RC) $(RFLAGS) $<
$(TARGET).$(TARGET_EXT) : $(OBJS)
    $(LINK) /OUT:$@ $(LFLAGS) $** $(LIBS)

.PHONY:clean rebuild
clean :
    del /Q $(OBJS) $(TARGET).$(TARGET_EXT) $(TARGET)_$(TARGET_EXT).pdb
# rebuild，先clean再all,即为rebuild
rebuild : clean all