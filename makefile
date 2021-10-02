#########################      Read Me     #########################
# �κΰ汾��vs����֧��makefile�����
# 
# Makefile�ļ�����#��ʼ���н���Ϊע��
# �﷨�����
# http://msdn.microsoft.com/en-us/library/yz1tske6(v=VS.100).aspx
 
# nmake�Ĳ�����ʹ�÷���
# NMAKE [option...] [macros...] [targets...] [@commandfile...]
# �����
# http://msdn.microsoft.com/en-us/library/a23f7tc4(v=VS.100).aspx
 
# ʹ�ñ�makefile�������ʹ������
# nmake DBG=1
# nmake DBG=1 clean
# nmake DBG=1 rebuild
# nmake
# nmake clean
# nmake rebuild
#
# �����makefile�����κ�C���Թ��̣�ֻ��Ҫ�޸������ļ������ü���
# TARGET, TARGET_EXT, DEFFILE, SRCS, LIBS, CFLAGS, CPPFLAGS, LFLAGS
 
######################### Basic Definition #########################
 
# ����꣺ ����=ֵ
# ���ú꣺ $(����)
# ������ͨ���ַ����滻�ķ�ʽ���е�
 
TARGET = pathsync # ����� ����=ֵ
TARGET_EXT = exe  # dll
# DEFFILE = pathsync.def
SRC_C = .\WDL\win32_utf8.c
SRC_CPP = .\WDL\WinGUI\wndsize.cpp .\PathSync\pathsync.cpp .\PathSync\fnmatch.cpp #��Ҫ�������·��
SRC_RC = .\PathSync\res.rc
 
# ��LIBSһ�ж�LIBS����и�ֵ��ͬʱҲ������LIBS��
# ���Ƚ���չ����Ȼ���ٸ�ֵ�µ�ֵ����

LIBS =  $(LIBS) kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib comctl32.lib 
CFLAGS = $(CFLAGS) /MT /O2 /EHsc /c
CPPFLAGS = $(CPPFLAGS) /MT /O2 /EHsc /c
LINK = link.exe
LFLAGS = $(LFLAGS) /nologo /subsystem:windows /RELEASE
 
# ����һ����������ú�ķ�������SRCS��ֵ�����е�.c�滻Ϊ.obj����ΪOBJS���ֵ��
# �ο�Macro Substitution
# http://msdn.microsoft.com/en-us/library/bsd42ets(v=VS.100).aspx
OBJS = $(SRC_C:.c=.obj) $(SRC_CPP:.cpp=.obj) $(SRC_RC:.rc=.res)
 
 
#################### Compile and Link Options #######################
 
#### �ж��Ƿ�����DBG�꣬
#### ����ͨ����nmake��ѡ����ͨ������DBG�������ò�ͬ�ı�������ѡ��
#### ��������ʹ�õ��ж���������!if 
!ifdef DBG
 
#ODIR = ..\debug
LFLAGS = $(LFLAGS) -map -debug  -PDB:$(ODIR)\$(TARGET)_$(TARGET_EXT).pdb
 
!else
 
#ODIR = ..\release
LFLAGS = $(LFLAGS) 
 
!endif
 
 
#########################  Inference Rules  #########################
#
# Description blocks�������飩���﷨����
#
# Ŀ��: ������
#   ����
#
# ��ʾ���ɡ�Ŀ�ꡱ��ѽ�����ڡ������������ʹ�á����
# ����nmakeʱ��Ҫָ�����ɵ�Ŀ�꣬���û��˵����Ĭ��Ϊmakefile�еĵ�һ��Ŀ�ꡣ
# ������������ǿ�ѡ��
 
all : $(TARGET).$(TARGET_EXT)
 
# �ڴ���λ�ڲ�ͬ�ļ��е�ʱ��Ϊ������obj�ļ���.c�ļ���ͬһ��Ŀ¼����Ҫʹ��Foѡ��ָ��obj�ļ����Ŀ¼��
# ����ʹ����Macro Substitution�ķ�ʽ������OBJS,��Ϊ�Ҳ���д�ܶ�$(ODIR)/
# �����ָ��·��������c�ļ���������ɵ�obj�ļ�����./Ҳ����proj�ļ�����Ŀ¼
# ������Fo��������D���η�����ʱ����ʹ��Batch-mode(::)
# Batch-mode�ͷ�Batch����������Ԥ�����Ƶ�����ĺ���ʹ��:����::
# D�����η���ʾ�ļ������е�Ŀ¼���֣�ȥ���ļ�������չ��ʣ�µĲ��֣�
# batch-mode rules �����
# http://msdn.microsoft.com/en-us/library/f2x0zs74(v=VS.100).aspx
# Ԥ������Ƶ����������飩��
# http://msdn.microsoft.com/en-us/library/cx06ysxh.aspx
# �ļ����꣺
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
# rebuild����clean��all,��Ϊrebuild
rebuild : clean all