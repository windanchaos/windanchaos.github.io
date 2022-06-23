---
title: ELF学习一
date: 2022-06-22 22:24:37
category: 
      - 计算机科学基础
---

Excutable and Linking Format，ELF，有UNIX系统实验室发布并确定为应用程序二进制接口ABI（二进制程序标识所有工具集所遵循的一组运行时约定，包括：编译器、汇编器、连接器和语言运行时支持）的落地文件形式，其重要性不言而喻。

# ELF文件类型

ELF文件是由汇编器和连接器创建，是程序的二进制表示，以提供直接在目标处理器上执行的代码（指令）和数据。

ELF有三类文件类型，参与程序的构建和执行：

- 可重定位 (relocatable file)，也叫静态链接库，包含部分可执行文件格式或者动态链接格式的数据或代码，需与其他两种格式进行整合
- 可执行（executable file），包含程序执行的所有代码和数据信息，被系统读取用于创建进程
- 共享对象文件（shared object file），也叫动态链接库，包含适合在以上两种文件格式中需要链接的代码和数据信息。

我们以C代码来学习，main.c是主函数，引用了fun.c中的printHello函数：

main.c

```C
#include<stdio.h>
extern func(int a);
int g1 = 100;
int g2;
int main(){
  static int a = 1;
  static int b = 0;
  int c = 1;
  func(a+b+c);
  printf("this main!"); 
  return 0;
}
```

fun.c

```c
#include<stdio.h>
int count = 0;
int value;
void func(int sum)
{
  printf("sum is %d\n",sum);
}
```

gcc编译命令帮助：

  **-E                       Preprocess only; do not compile, assemble or link*
  *-S                       Compile only; do not assemble or link* 只编译成汇编代码
  *-c                       Compile and assemble, but do not link* 编译二进制的ELF文件，没有连接
  -o <file>                Place the output into <file>*

我们只研究和ELF有关的gcc操作。下面，编译ELF文件。

```bash
gcc -c fun.c main.c 
```

生成了对应.o的ELF文件。

```bash
gcc -o main main.o fun.o
```

生成了main的可执行ELF文件。

```bash
gcc -shared -fPIC -o fun.so fun.c
```

生成了fun.so的共享ELF文件。



命令readelf 可读取ELF文件，使用帮助查看相关参数。

查看文件的type类型是什么

```bash
readelf -h fun.o
readelf -h fun.so
readelf -h main
```

ELF定义源码在linux文件/user/include/elf.h中，相关的结构都能通过源码获取到。

# ELF内部的数据表示

这里的数据指一切可以表示信息的二进制记录。

ELF文件支持具有8位字节和32位架构的处理器，其目的是在更大（更小）的体系结构中执行，具有平台无关性，因此，ELF的对象文件是以一种独立于执行机器的格式来表示控制数据，而数据则使用目标处理器进行编码和解释，而不管ELF是在哪台机器上创建的。即：

- ELF记录的控制信息无视处理器结构
- ELF记录的操作数据按目标处理器解释

ELF文件格式定义的所有数据结构都遵循特定的大小和对齐规则。如有必要，对应的struct结构体需要填充0以确保4字节对齐，相应的基础数据类型（1、2、4、8字节）均需对齐。处于可移植目的，ELF不实用位（1bit）。

以下是ELF的标准数据申明（代码注释请勿忽略）：

```C
/* Standard ELF types.  */

#include <stdint.h>

/* Type for a 16-bit quantity.  */
typedef uint16_t Elf32_Half;
typedef uint16_t Elf64_Half;

/* Types for signed and unsigned 32-bit quantities.  */
typedef uint32_t Elf32_Word;
typedef int32_t  Elf32_Sword;
typedef uint32_t Elf64_Word;
typedef int32_t  Elf64_Sword;

/* Types for signed and unsigned 64-bit quantities.  */
typedef uint64_t Elf32_Xword;
typedef int64_t  Elf32_Sxword;
typedef uint64_t Elf64_Xword;
typedef int64_t  Elf64_Sxword;

/* Type of addresses.  */
typedef uint32_t Elf32_Addr;
typedef uint64_t Elf64_Addr;

/* Type of file offsets.  */
typedef uint32_t Elf32_Off;
typedef uint64_t Elf64_Off;

/* Type for section indices, which are 16-bit quantities.  */
typedef uint16_t Elf32_Section;
typedef uint16_t Elf64_Section;
```

从上我们可以看出：

Half、Section、word（S）、Xword（S）都是位数无关的。

只有Add地址和Off偏移是地址有关的。

# Headers

header的设计目的是控制结构，描述、定位对应数据的结构和信息。

`readelf -e fun.o`

`readelf -e fun.so`

`readelf -e main`

有3个header：

## ELF文件自身的header

ELF文件自身的header，32位（以下都以32为主）结构体定了文件的header

```c
/* The ELF file header.  This appears at the start of every ELF file.  */

#define EI_NIDENT (16)

typedef struct
{
  unsigned char e_ident[EI_NIDENT];     /* Magic number and other info */
  Elf32_Half    e_type;                 /* Object file type */
  Elf32_Half    e_machine;              /* Architecture */
  Elf32_Word    e_version;              /* Object file version */
  Elf32_Addr    e_entry;                /* Entry point virtual address */
  Elf32_Off     e_phoff;                /* Program header table file offset */
  Elf32_Off     e_shoff;                /* Section header table file offset */
  Elf32_Word    e_flags;                /* Processor-specific flags */
  Elf32_Half    e_ehsize;               /* ELF header size in bytes */
  Elf32_Half    e_phentsize;            /* Program header table entry size */
  Elf32_Half    e_phnum;                /* Program header table entry count */
  Elf32_Half    e_shentsize;            /* Section header table entry size */
  Elf32_Half    e_shnum;                /* Section header table entry count */
  Elf32_Half    e_shstrndx;             /* Section header string table index */
} Elf32_Ehdr;

/* Legal values for e_type (object file type).  */

#define ET_NONE         0               /* No file type */
#define ET_REL          1               /* Relocatable file */
#define ET_EXEC         2               /* Executable file */
#define ET_DYN          3               /* Shared object file */
#define ET_CORE         4               /* Core file */
#define ET_NUM          5               /* Number of defined types */
#define ET_LOOS         0xfe00          /* OS-specific range start */
#define ET_HIOS         0xfeff          /* OS-specific range end */
#define ET_LOPROC       0xff00          /* Processor-specific range start */
#define ET_HIPROC       0xffff          /* Processor-specific range end */
```

e_type中包含了ELF的三大文件类型。



下面是bash中查看main.o的ELF文件头打印内容。

```bash
/*打印的ELF header内容*/
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          936 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         13
  Section header string table index: 12
```

ELF文件排布：

\|     ELF header    \|  Sections  \|  Section header table \|

从上面Header信息中，可得到如下大小相关信息

Header大小： Size of this header:               64 (bytes)

Sections大小：Start of section headers - Header 大小:          936byte -  64bytes

Section header table大小：Size of section headers * Number of section headers = 13 * 64

整个文件大小为：64 + 936- 64 +  13 * 64= 1768bytes

我们使用命令查看main.o的大小输出的也是1768：

```bash
wc -c main.o
```

## section的header

section（翻译为节）的header，描述节的信息。

```c
/* Section header.  */

typedef struct
{
  Elf32_Word    sh_name;                /* Section name (string tbl index) */
  Elf32_Word    sh_type;                /* Section type */
  Elf32_Word    sh_flags;               /* Section flags */
  Elf32_Addr    sh_addr;                /* Section virtual addr at execution */
  Elf32_Off     sh_offset;              /* Section file offset */
  Elf32_Word    sh_size;                /* Section size in bytes */
  Elf32_Word    sh_link;                /* Link to another section */
  Elf32_Word    sh_info;                /* Additional section information */
  Elf32_Word    sh_addralign;           /* Section alignment */
  Elf32_Word    sh_entsize;             /* Entry size if section holds table */
} Elf32_Shdr;

/* 截取 section header */
Section Headers:
  [Nr] Name              Type             Address           Offset
       Size              EntSize          Flags  Link  Info  Align
  [ 0]                   NULL             0000000000000000  00000000
       0000000000000000  0000000000000000           0     0     0
  [ 1] .text             PROGBITS         0000000000000000  00000040
       0000000000000044  0000000000000000  AX       0     0     1
  [ 2] .rela.text        RELA             0000000000000000  000002a8
       0000000000000078  0000000000000018   I      10     1     8
  [ 3] .data             PROGBITS         0000000000000000  00000084
       0000000000000008  0000000000000000  WA       0     0     4
  [ 4] .bss              NOBITS           0000000000000000  0000008c
       0000000000000004  0000000000000000  WA       0     0     4
  [ 5] .rodata           PROGBITS         0000000000000000  0000008c
       000000000000000b  0000000000000000   A       0     0     1
  [ 6] .comment          PROGBITS         0000000000000000  00000097
       000000000000002e  0000000000000001  MS       0     0     1
  [ 7] .note.GNU-stack   PROGBITS         0000000000000000  000000c5
       0000000000000000  0000000000000000           0     0     1
  [ 8] .eh_frame         PROGBITS         0000000000000000  000000c8
       0000000000000038  0000000000000000   A       0     0     8
  [ 9] .rela.eh_frame    RELA             0000000000000000  00000320
       0000000000000018  0000000000000018   I      10     8     8
  [10] .symtab           SYMTAB           0000000000000000  00000100
       0000000000000180  0000000000000018          11    11     8
  [11] .strtab           STRTAB           0000000000000000  00000280
       0000000000000028  0000000000000000           0     0     1
  [12] .shstrtab         STRTAB           0000000000000000  00000338

```

section中的类型（Type），类型对节section的内容和语义进行了分了。具体参考下节section。

Offset是在文件中偏移位置（即该部分起始地址），Size为其大小。通过这2部分，就可以确认每个section的位置大小。由上一小节内容，我们知道elf 文件的header有64bytes，16进制为0x40，所以我们可以知道.tex的offset值00000040，是紧跟在elf的文件header之后的。使用命令验证：

```bash
objdump -h main.o
```

得到如下内容，也即各section的排布顺序：

```bash 
Sections:
Idx Name          Size      VMA               LMA               File off  Algn
  0 .text         00000044  0000000000000000  0000000000000000  00000040  2**0
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, CODE
  1 .data         00000008  0000000000000000  0000000000000000  00000084  2**2
                  CONTENTS, ALLOC, LOAD, DATA
  2 .bss          00000004  0000000000000000  0000000000000000  0000008c  2**2
                  ALLOC
  3 .rodata       0000000b  0000000000000000  0000000000000000  0000008c  2**0
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
  4 .comment      0000002e  0000000000000000  0000000000000000  00000097  2**0
                  CONTENTS, READONLY
  5 .note.GNU-stack 00000000  0000000000000000  0000000000000000  000000c5  2**0
                  CONTENTS, READONLY
  6 .eh_frame     00000038  0000000000000000  0000000000000000  000000c8  2**3
                  CONTENTS, ALLOC, LOAD, RELOC, READONLY, DATA
```



## program的header

program的header，用于告知操作系统如何创建进程。program的header在可执行和共享文件中有。

```C
/* Program segment header.  */

typedef struct
{
  Elf32_Word    p_type;                 /* Segment type */
  Elf32_Off     p_offset;               /* Segment file offset */
  Elf32_Addr    p_vaddr;                /* Segment virtual address */
  Elf32_Addr    p_paddr;                /* Segment physical address */
  Elf32_Word    p_filesz;               /* Segment size in file */
  Elf32_Word    p_memsz;                /* Segment size in memory */
  Elf32_Word    p_flags;                /* Segment flags */
  Elf32_Word    p_align;                /* Segment alignment */
} Elf32_Phdr;

/* program header */
Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000400040 0x0000000000400040
                 0x00000000000001f8 0x00000000000001f8  R E    8
  INTERP         0x0000000000000238 0x0000000000400238 0x0000000000400238
                 0x000000000000001c 0x000000000000001c  R      1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000
                 0x0000000000000754 0x0000000000000754  R E    200000
  LOAD           0x0000000000000e10 0x0000000000600e10 0x0000000000600e10
                 0x0000000000000224 0x0000000000000228  RW     200000
  DYNAMIC        0x0000000000000e28 0x0000000000600e28 0x0000000000600e28
                 0x00000000000001d0 0x00000000000001d0  RW     8
  NOTE           0x0000000000000254 0x0000000000400254 0x0000000000400254
                 0x0000000000000044 0x0000000000000044  R      4
  GNU_EH_FRAME   0x0000000000000600 0x0000000000400600 0x0000000000400600
                 0x000000000000003c 0x000000000000003c  R      4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     10
  GNU_RELRO      0x0000000000000e10 0x0000000000600e10 0x0000000000600e10
                 0x00000000000001f0 0x00000000000001f0  R      1
```





# sections

section代表的是一段连续的地址空间，包含了除header（section、elf 文件、program）外的所有信息。section的header参考上一节。

节的类型，源码：

```C
/* Legal values for sh_type (section type).  */

#define SHT_NULL          0             /* Section header table entry unused */
#define SHT_PROGBITS      1             /* Program data */
#define SHT_SYMTAB        2             /* Symbol table */
#define SHT_STRTAB        3             /* String table */
#define SHT_RELA          4             /* Relocation entries with addends */
#define SHT_HASH          5             /* Symbol hash table */
#define SHT_DYNAMIC       6             /* Dynamic linking information */
#define SHT_NOTE          7             /* Notes */
#define SHT_NOBITS        8             /* Program space with no data (bss) */
#define SHT_REL           9             /* Relocation entries, no addends */
#define SHT_SHLIB         10            /* Reserved */
#define SHT_DYNSYM        11            /* Dynamic linker symbol table */
#define SHT_INIT_ARRAY    14            /* Array of constructors */
#define SHT_FINI_ARRAY    15            /* Array of destructors */
#define SHT_PREINIT_ARRAY 16            /* Array of pre-constructors */
#define SHT_GROUP         17            /* Section group */
#define SHT_SYMTAB_SHNDX  18            /* Extended section indeces */
#define SHT_NUM           19            /* Number of defined types.  */
#define SHT_LOOS          0x60000000    /* Start OS-specific.  */
#define SHT_GNU_ATTRIBUTES 0x6ffffff5   /* Object attributes.  */
#define SHT_GNU_HASH      0x6ffffff6    /* GNU-style hash table.  */
#define SHT_GNU_LIBLIST   0x6ffffff7    /* Prelink library list */
#define SHT_CHECKSUM      0x6ffffff8    /* Checksum for DSO content.  */
#define SHT_LOSUNW        0x6ffffffa    /* Sun-specific low bound.  */
#define SHT_SUNW_move     0x6ffffffa
#define SHT_SUNW_COMDAT   0x6ffffffb
#define SHT_SUNW_syminfo  0x6ffffffc
#define SHT_GNU_verdef    0x6ffffffd    /* Version definition section.  */
#define SHT_GNU_verneed   0x6ffffffe    /* Version needs section.  */
#define SHT_GNU_versym    0x6fffffff    /* Version symbol table.  */
#define SHT_HISUNW        0x6fffffff    /* Sun-specific high bound.  */
#define SHT_HIOS          0x6fffffff    /* End OS-specific type */
#define SHT_LOPROC        0x70000000    /* Start of processor-specific */
#define SHT_HIPROC        0x7fffffff    /* End of processor-specific */
#define SHT_LOUSER        0x80000000    /* Start of application-specific */
#define SHT_HIUSER        0x8fffffff    /* End of application-specific */
```

部分汉语翻译（内容摘自：黄俊的混沌学堂知识星球，有增改）

SHT_NULL：该值将节标记为非活动状态 

SHT_PROGBITS：该值保存着由程序定义的节信息，其格式和含义完全由程序决定（程序是什么？考虑下谁生成了目标文件） 

SHT_SYMTAB 和 SHT_DYNSYM：表示当前节保存着一个符号表。SHT_SYMTAB 表示提供了用于链接器静态链接的符号，其作为一个完整的符号表，它可能包含许多动态链接中不需要的符号，因此，一个对象文件也可以包含一个 SHT_DYNSYM 的节用于保存动态链接符号的最小集合，以节省空间。所以我们可以通过strip去掉完整符号表，但这会导致不能进行静态链接 。SYM = symbol。

SHT_DYNAMIC：表示当前节保存动态链接信息 

SHT_STRTAB：表示当前节为字符串表 

SHT_RELA：表示当前节保存着带有显式加数的重定位表项，例如对象文件的32位类的Elf32_Rela类型（后面会说这里的加数是什么）

SHT_REL：表示该节保存着没有显式加数的重定位表项。一个ELF文件可能有多个重定位的section。

SHT_HASH：表示当前节保存着一个符号哈希表。所有参与动态链接的对象文件必须包含一个符号哈希表 

SHT_NOTE：表示当前节保存文件的注释信息 

SHT_NOBITS：表示不占任何空间的节信息，虽然该节不包含字节，但是sh_offset成员包含概念上的文件偏移量 

SHT_SHLIB：该节类型是保留的，但具有未指定的语义。包含这种类型的部分的程序不符合ABI规范 

SHT_LOPROC 与 SHT_HIPROC：这个范围内的值为特定于处理器的语义保留 

SHT_LOUSER：该类型的节表示应用程序保留的索引范围的下界 

SHT_HIUSER：该类型的节表示应用程序保留的索引范围的上限 



下面重点介绍几个重要Section Type。

## String table

字符串表节保存以空白符结尾的字符串序列。ELF文件使用这些字符串来表示符号和节名。使用方式，是符号保存一个指向支付串标的索引下标，结束字符是空白符。

## symbol table 

一个ELF文件的符号表保存了**需要**进行重定位程序的符号定义。

在Section Header中，type为SYMTAB的就是。

`readelf -s fun.o`

`readelf -s fun.so`

`readelf -s main.o`

有2个符号表，分别是.dynsym 、.symtab，其中.o的静态链接文件没有.dynsym。

源码定义的结构体：

```C
/* Symbol table entry.  */

typedef struct
{
  Elf32_Word    st_name;                /* Symbol name (string tbl index) */
  Elf32_Addr    st_value;               /* Symbol value */
  Elf32_Word    st_size;                /* Symbol size */
  unsigned char st_info;                /* Symbol type and binding */
  unsigned char st_other;               /* Symbol visibility */
  Elf32_Section st_shndx;               /* Section index */
} Elf32_Sym;

```

st_name，目标文件的字符串标的索引下标。

st_value，关联符号值（Symbol Values）

在不同的对象文件（ELF）中解释不同：

- 可重定位文件中，节index是SHN_COMMON，st_value保存的是一个符号的对齐约束
- 可重定位文件中，st_value保存的是是一个已定义的节偏移量，即st_shndx标识开始的地方开始的偏移量。
- 在可执行和共享文件中，st_value保存一个用户内存排布的虚拟地址。

st_info在符号表中显示为Type字段和Bind字段，Type提供了关联实体的一般分类：

```C
/* How to extract and insert information held in the st_info field.  */

#define ELF32_ST_BIND(val)              (((unsigned char) (val)) >> 4)
#define ELF32_ST_TYPE(val)              ((val) & 0xf)
#define ELF32_ST_INFO(bind, type)       (((bind) << 4) + ((type) & 0xf))
/* Legal values for ST_TYPE subfield of st_info (symbol type).  */

#define STT_NOTYPE      0               /* Symbol type is unspecified */
#define STT_OBJECT      1               /* Symbol is a data object */
#define STT_FUNC        2               /* Symbol is a code object */
#define STT_SECTION     3               /* Symbol associated with a section */
#define STT_FILE        4               /* Symbol's name is file name */
#define STT_COMMON      5               /* Symbol is a common data object */
#define STT_TLS         6               /* Symbol is thread-local data object*/
#define STT_NUM         7               /* Number of defined types.  */
#define STT_LOOS        10              /* Start of OS-specific */
#define STT_GNU_IFUNC   10              /* Symbol is indirect code object */
#define STT_HIOS        12              /* End of OS-specific */
#define STT_LOPROC      13              /* Start of processor-specific */
#define STT_HIPROC      15              /* End of processor-specific */
```



Bind字段，决定了该符号记录的可见性和行为。

```C
/* Legal values for ST_BIND subfield of st_info (symbol binding).  */

#define STB_LOCAL       0               /* Local symbol */
#define STB_GLOBAL      1               /* Global symbol */
#define STB_WEAK        2               /* Weak symbol */
#define STB_NUM         3               /* Number of defined types.  */
#define STB_LOOS        10              /* Start of OS-specific */
#define STB_GNU_UNIQUE  10              /* Unique symbol.  */
#define STB_HIOS        12              /* End of OS-specific */
#define STB_LOPROC      13              /* Start of processor-specific */
#define STB_HIPROC      15              /* End of processor-specific */

```

主要关注STB_LOCAL、STB_GLOBAL、STB_WEAK。

STB_GLOBAL和STB_WEAK区别主要体现在，当连接器组合几个可重定位文件时，不允许STB_GLOBAL符号有相同名称的多个定义。但是，如果已定义的全局符号存在了，则用同名弱符号不会报错，此时忽略弱符号。

```bash
readelf -s main.o

Symbol table '.symtab' contains 16 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS main.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 
     6: 0000000000000004     4 OBJECT  LOCAL  DEFAULT    3 a.2180
     7: 0000000000000000     4 OBJECT  LOCAL  DEFAULT    4 b.2181
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT    7 
     9: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 
    10: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
    11: 0000000000000000     4 OBJECT  GLOBAL DEFAULT    3 g1
    12: 0000000000000004     4 OBJECT  GLOBAL DEFAULT  COM g2
    13: 0000000000000000    68 FUNC    GLOBAL DEFAULT    1 main
    14: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND func
    15: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND printf
```

Ndx是section的header table中的index，其中UND不在main中。

g1、g2全局Object（数据对象），所属的section不一样。g2 COMMON存放未初始化的全局变量，.bss未初始化的静态变量，初始化为0的全局或静态变量（两者区别）。

局部Objecta和b存放位置不同，a初始化了，b初始化为0（并没什么用）。 a.2180 和b.2181，是名称修饰，防止重复。

## Relocation section

 **重定位Relocation基本概念：是将符号引用和符号定义连接起来的过程，比如编译中静态链接库合并到一起时，各自文件中的内存相对地址更新到新文件中的地址。**又比如，一个程序调用一个函数时，相关调用指令（call sum）必须在执行时将调用符号分配适当的目标地址（call 0x800001）。换句话说，可重定位文件必须提供具有描述如何修改节内容的信息，从而允许可执行和共享目标文件保存进程装载执行所需要的正确信息。

在Section Header中，Type是RELA或REL的就是。

```C
/* Relocation table entry without addend (in section of type SHT_REL).  */

typedef struct
{
  Elf32_Addr    r_offset;               /* Address */
  Elf32_Word    r_info;                 /* Relocation type and symbol index */
} Elf32_Rel;

/* Relocation table entry with addend (in section of type SHT_RELA).  */

typedef struct
{
  Elf32_Addr    r_offset;               /* Address */
  Elf32_Word    r_info;                 /* Relocation type and symbol index */
  Elf32_Sword   r_addend;               /* Addend */
} Elf32_Rela;
```

r_offset不同目标文件的重定位表象的解释略有不同：

- 可重定位文件，r_offset保存着一个从节开头到需要重定位的内存单元的字节偏移量。
- 可执行和共享文件中，r_offset保存的是虚拟地址，用户内存排布标识。

```shell
readelf -r main.o
readelf -r fun.o
readelf -r fun.so

```

r_info表示符号表索引以及重定位类型（地址解析类型）。

一个重定位节引用另外2个节，符号表和要修改的节。节头的sh_info和sh_link成员，在上面的节信息中描述，指定了这些关系。

## 特殊的节

```bash
readelf -l main
```

Section to Segment mapping，节和段segment的映射。是个特殊的节，用于保存程序信息和控制信息。不清楚为什么被划分到 program headers类别中。.systab和.rel(.rela)上面两节描述了。

- .init：表示该节保存了进程初始化代码的可执行指令。也就是说，当一个程序开始运行时，将会在调用主程序入口点（C程序的main函数）之前执行这一部分的代码
- .bss：表示该节保存着未初始化的数据，这些数据构成了程序的数据内存排布。根据定义，当程序开始运行时，系统用零初始化这些数据。节类型 SHT_NOBITS 表示该节不占用文件空间。
- .data 和 .data1：表示该节保存着已经初始化的数据，这些数据构成了程序的数据内存排布
- .dynamic：表示该节保存动态链接信息
- .dynstr：表示该节保存动态链接所需的字符串，最常见的是表示符号表项相关名称的字符串
- .dynsym：表示该节保存着动态链接符号表
- .fini：表示该节保存了进程终止代码的可执行指令。也就是说，当一个程序正常退出时将会执行这一部分的代码
- .got：表示该节保存了全局偏移量表
- .hash：表示该节保存了符号hash表
- .plt：表示该节保存了程序连接表信息
- .rel name 和 .rela name：表示该节保存着重定位信息。如果文件中有一个包含重定位的可加载段，则节的属性将包含 SHF_ALLOC 。通常，name 由重定位的节提供。因此.text 的重定位节的名称通常为.rel.text 或 .rela.text
- .rodata 和 .rodata1：表示该节保存只读数据，这些数据通常会在进程中形成一个不可写的数据段
- .shstrtab：表示该节保存节的名字
- .strtab：表示该节保存字符串信息，最常见的是表示与符号表项关联的名称的字符串
- .symtab：表示该节保存符号表信息
- .text：表示当前节包含程序的可执行的指令序列信息
- .comment：持有注释信息
- .interp：表示该节保存程序动态链接器的路径名。如果文件中有一个包含该节的可加载段，该节的属性将包括SHF_ALLOC位
- .line：表示该节保存用于符号调试的行号信息，它描述了源程序和机器码之间的对应关系
- .note：表示该节保存了标注信息
- .debug：表示该节保存了用于调试的符号信息



# 参考

elf官方文档：

https://refspecs.linuxfoundation.org/elf/elf.pdf

知识星球混沌学堂—黄俊：

https://articles.zsxq.com/id_iwals7svgn0g.html

https://articles.zsxq.com/id_ohm2xh6becp2.html

https://articles.zsxq.com/id_n35kk7n2sf0e.html

