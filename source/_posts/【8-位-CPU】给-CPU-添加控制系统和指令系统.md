---
title: 【8 位 CPU】给 CPU 添加控制系统和指令系统
date: 2023-02-25 08:56:59
category:
       - 计算机科学基础
---



CPU计划完结散花:tada: :tada: :tada: 。
# 核心
给每个逻辑元件添加控制单元以达到，不同输入组合对应不同的输出。由于我们已实现了寄存器（一种能够记住1byte的单元），那么遍可以控制其允许输入/输出。
不同的原件，同一时刻的允许输入输出状态就定义了当时单元和单元之间的关系，如A寄存器输出，B是输入，其他不设置，那么此刻完成了A寄存器向B寄存器传输数据的目的。如此类推。
# 控制单元 Control Unit
控制单元是CPU的核心部件，由寄存器控制器、读写控制器及其他输入输入构成。如下：
## 控制单元接线——总览
将寄存器控制器和读写控制器接线，输入32位，对应位实现不同目的：
- 低10位分2组，5+5分别标识写和读，接线到RWC上输入哪个单元读、哪个单元写。
- 第11-15位分别标识源读、源写，目的读、目的写
- 第16-19位位PC计数
- 第20-23位为四则运算组合，一种8种
- 第24-28 为控制ALU单元组合
![](https://testerhome.com/uploads/photo/2023/46bf1f0b-4a56-4117-a8d3-c0dc718b5193.png!large)
## PC
时钟下降沿（1->0)时完成指令计数，重新计数。是控制指令周期用的。

## 寄存器控制 RC
说明，W\R是5位输入，通过一个5-32译码器转换成0-32，可识别32个寄存器。
![](https://testerhome.com/uploads/photo/2023/1317f0bf-2c5e-40d3-bc27-41569615919f.png!large)

## 读写控制器RWC
读写控制器也是5位输入，接寄存器控制器
![](https://testerhome.com/uploads/photo/2023/9dd4e5b2-30d7-44b0-830a-3445f09a9649.png!large)

## ALU
A、B是8位输入，OP是3位，3-8译码器，转为1-8，可支持8种运算。
1=加法    2=减法   3=加1   4=减1   5=And    6=OR   7=XOR    8=取反
![](https://testerhome.com/uploads/photo/2023/a1fbf119-52c4-42dd-a8ec-b1a224c2d35c.png!large)

## 内存控制器MC
RAM代表内存，MC为其控制单元
![](https://testerhome.com/uploads/photo/2023/ed3d26de-70ea-4d41-b941-0bcecb4ce211.png!large)

## CPU接线

![](https://testerhome.com/uploads/photo/2023/a271acf2-c048-4198-b22e-934f82953808.png!large)

# 指令系统
## 执行的模式
通电之后，时钟定时脉动，提供给整个电路电压变化。通过control Uinit旁边的ROM中写入指令（32位的01组合数），CU（control Unit） 的PC每加1，则指令ROM读取的index +1，输入后从CU的d进入，完成对整个单元的控制。
![](https://testerhome.com/uploads/photo/2023/ccc237ff-1176-40c3-a961-44ad763572e2.png!large)
- 取指令：先从RAM中把指令取到IR寄存器，目的操作数取到DST中，原操作数取到SRC中。
- 译指令，IR指令进入CU中，从L1输入，DST从L2输入，SRC从L3输入——拼出  控制信息 + 操作单元 的组合

最后对这些电路按设计转成代码，代码备注也由说明
## 管脚代码

```python
# 寄存器，RAM=MC
MSR = 1
MAR = 2
MDR = 3
# RAM就是MC控制器
RAM = 4
IR = 5
DST = 6
SRC = 7
A = 8
B = 9
C = 10
D = 11
DI = 12
SI = 13
SP = 14
BP = 15
CS = 16
DS = 17
SS = 18
ES = 19
VEC = 20
T1 = 21
T2 = 22

# 寄存器输出到总线上
MSR_OUT = MSR
MAR_OUT = MAR
MDR_OUT = MDR
RAM_OUT = RAM
IR_OUT = IR
DST_OUT = DST
SRC_OUT = SRC
A_OUT = A
B_OUT = B
C_OUT = C
D_OUT = D
DI_OUT = DI
SI_OUT = SI
SP_OUT = SP
BP_OUT = BP
CS_OUT = CS
DS_OUT = DS
SS_OUT = SS
ES_OUT = ES
VEC_OUT = VEC
T1_OUT = T1
T2_OUT = T2

# 写入寄存器,暂时没搞懂为什么左移5位
_DST_SHIFT = 5
MSR_IN = MSR << _DST_SHIFT
MAR_IN = MAR << _DST_SHIFT
MDR_IN = MDR << _DST_SHIFT
RAM_IN = RAM << _DST_SHIFT
IR_IN = IR << _DST_SHIFT
DST_IN = DST << _DST_SHIFT
SRC_IN = SRC << _DST_SHIFT
A_IN = A << _DST_SHIFT
B_IN = B << _DST_SHIFT
C_IN = C << _DST_SHIFT
D_IN = D << _DST_SHIFT
DI_IN = DI << _DST_SHIFT
SI_IN = SI << _DST_SHIFT
SP_IN = SP << _DST_SHIFT
BP_IN = BP << _DST_SHIFT
CS_IN = CS << _DST_SHIFT
DS_IN = DS << _DST_SHIFT
SS_IN = SS << _DST_SHIFT
ES_IN = ES << _DST_SHIFT
VEC_IN = VEC << _DST_SHIFT
T1_IN = T1 << _DST_SHIFT
T2_IN = T2 << _DST_SHIFT

# 电路中11-14位作为RWC单元的输入，控制S和D的读写，软件层面确认不同时读写同一个单元
# src中的值对应的寄存器，读取其值
SRC_R = 1 << 10
SRC_W = 1 << 11
DST_R = 1 << 12
DST_W = 1 << 13

PC_CS = 1 << 14
PC_WE = 1 << 15
PC_EN = 1 << 16
PC_OUT = PC_CS
PC_IN = PC_CS | PC_WE | PC_EN
PC_INC = PC_CS | PC_WE

# ALU
_OP_SHIFT = 17
OP_ADD = 0
OP_SUB = 1 << _OP_SHIFT
# 加减1
OP_INC = 2 << _OP_SHIFT
OP_DEC = 3 << _OP_SHIFT
OP_AND = 4 << _OP_SHIFT
OP_OR = 5 << _OP_SHIFT
OP_XOR = 6 << _OP_SHIFT
OP_NOT = 7 << _OP_SHIFT
ALU_OUT = 1 << 20
ALU_PSW = 1 << 21
ALU_INT_W = 1 << 22
ALU_INT = 1 << 23

ALU_STI = ALU_INT_W
ALU_CLI = ALU_INT_W | ALU_INT

# cyc标识当前指令执行完了，需要重置微程序的pc数
CYC = 1 << 30
HLT = 1 << 31

# 二地址指令和一地址 指令
ADDR2 = 1 << 7
ADDR1 = 1 << 6
ADDR2_SHIFT = 4
ADDR1_SHIFT = 2

# 四种寻址方式
AM_INS = 0  # 立即数
AM_REG = 1  # 寄存器
AM_DIR = 2  # 内存直接寻址
AM_RAM = 3  # 寄存器间接寻址


```
## 控制器代码controller.py
```python
# 控制器

import os
import assembly as ASM
import pin

dirname = os.path.dirname(__file__)
filename = os.path.join(dirname, 'micro.bin')
micro = [pin.HLT for _ in range(0x10000)]
# 跳转转移指令
CJMPS = {ASM.JO, ASM.JNO, ASM.JZ, ASM.JNZ, ASM.JP, ASM.JNP}


def compile_addr2(addr, ir, psw, index):
    global micro
    # 操作
    op = ir & 0xf0
    amd = (ir >> 2) & 3  # 3 = 011
    ams = ir & 3
    INST = ASM.INSTRUCTIONS[2]
    if op not in INST:
        micro[addr] = pin.CYC
        return
    am = (amd, ams)
    if am not in INST[op]:
        micro[addr] = pin.CYC
        return
    EXEC = INST[op][am]
    if index < len(EXEC):
        micro[addr] = EXEC[index]
    else:
        micro[addr] = pin.CYC


def get_condition_jump(exec, op, psw):
    overflow = psw & 1
    zero = psw & 2
    parity = psw & 4
    if op == ASM.JO and overflow:
        return exec
    if op == ASM.JNO and not overflow:
        return exec
    if op == ASM.JZ and zero:
        return exec
    if op == ASM.JNZ and not zero:
        return exec
    if op == ASM.JP and parity:
        return exec
    if op == ASM.JNP and not parity:
        return exec
    return [pin.CYC]


def get_interrupt(exec, op, psw):
    interrupt = psw & 8
    if interrupt:
        return exec
    return [pin.CYC]


def compile_addr1(addr, ir, psw, index):
    global micro
    global CJMPS
    op = ir & 0xfc
    amd = ir & 3
    INST = ASM.INSTRUCTIONS[1]
    if op not in INST:
        micro[addr] = pin.CYC
        return
    if amd not in INST[op]:
        micro[addr] = pin.CYC
        return
    EXEC = INST[op][amd]
    if op in CJMPS:
        EXEC = get_condition_jump(EXEC, op, psw)
    if op == ASM.INT:
        EXEC = get_interrupt(EXEC, op, psw)
    if index < len(EXEC):
        micro[addr] = EXEC[index]
    else:
        micro[addr] = pin.CYC


def compile_addr0(addr, ir, psw, index):
    global micro
    # 操作
    op = ir
    INST = ASM.INSTRUCTIONS[0]
    if op not in INST:
        micro[addr] = pin.CYC
        return
    EXEC = INST[op]
    if index < len(EXEC):
        micro[addr] = EXEC[index]
    else:
        micro[addr] = pin.CYC


# 2^16次方是16进制的10000
# for循环对下标就行遍历赋值，ROM列有16个，一行一条指令。
# 16位组成:ir[8]+psw[4]+cyc[4],与运算高位和低位双截断
for addr in range(0x10000):
    ir = addr >> 8
    psw = (addr >> 4) & 0xf
    cyc = addr & 0xf
    # 小于取址长度，则写入取指令，6个时钟沿
    if cyc < len(ASM.FETCH):
        micro[addr] = ASM.FETCH[cyc]
        continue
    addr2 = ir & (1 << 7)
    addr1 = ir & (1 << 6)
    # 取指令之后的index
    index = cyc - len(ASM.FETCH)
    if addr2:
        compile_addr2(addr, ir, psw, index)
    elif addr1:
        compile_addr1(addr, ir, psw, index)
    else:
        compile_addr0(addr, ir, psw, index)
with open(filename, 'wb') as file:
    for var in micro:
        value = var.to_bytes(4, byteorder='little')
        file.write(value)
print('micro instruction compile finished! ')

```
## 程序代码 compiler.py
主要完成汇编转机器码的工作
```python
import os
import pin
import assembly as ASM
import re

dirname = os.path.dirname(__file__)
inputFileName = os.path.join(dirname, 'program.asm')
outputFileName = os.path.join(dirname, 'program.bin')

# 代码的正则，分号是注释
annotation = re.compile(r"(.*?);.*")
# 代码
codes = []
# 标记，对应的代码
marks = {}
OP2 = {
    'MOV': ASM.MOV,
    'ADD': ASM.ADD,
    'CMP': ASM.CMP,
    'SUB': ASM.SUB,
    'AND': ASM.AND,
    'OR': ASM.OR,
    'XOR': ASM.XOR,
}
OP1 = {
    'INC': ASM.INC,
    'DEC': ASM.DEC,
    'NOT': ASM.NOT,
    'JMP': ASM.JMP,
    'JO': ASM.JO,
    'JNO': ASM.JNO,
    'JZ': ASM.JZ,
    'JNZ': ASM.JNZ,
    'JP': ASM.JP,
    'JNP': ASM.JNP,
    'PUSH': ASM.PUSH,
    'POP': ASM.POP,
    'CALL': ASM.CALL,
    'INT': ASM.INT,
}
OP0 = {
    'NOP': ASM.NOP,
    'HLT': ASM.HLT,
    'RET': ASM.RET,
    'STI': ASM.STI,
    'CLI': ASM.CLI,
    'IRET': ASM.IRET,
}

OP2SET = set(OP2.values())
OP1SET = set(OP1.values())
OP0SET = set(OP0.values())

# 可操作的寄存器
REGISTERS = {
    'A': pin.A,
    'B': pin.B,
    'C': pin.C,
    'D': pin.D,
    'SS': pin.SS,
    'CS': pin.CS,
    'SP': pin.SP,
}


class Code(object):
    # 代码
    CODE = 1
    # 标记
    LABEL = 2

    def __init__(self, number, source: str, code_type=CODE):
        self.number = number
        self.source = source.upper()
        self.op = None
        self.dst = None
        self.src = None
        self.code_type = code_type
        # 代码行
        self.index = 0
        self.prepare_source()

    def get_op(self):
        if self.op in OP2:
            return OP2[self.op]
        if self.op in OP1:
            return OP1[self.op]
        if self.op in OP0:
            return OP0[self.op]
        raise SyntaxError(self)

    # 获取操作数类型和其操作值
    def get_am(self, addr):
        global marks
        if not addr:
            return None, None
        if addr in marks:
            # 一行代码占3个字节
            return pin.AM_INS, marks[addr].index * 3
        if addr in REGISTERS:
            return pin.AM_REG, REGISTERS[addr]
        if re.match(r'^[0-9]+$', addr):
            return pin.AM_INS, int(addr)
        if re.match(r'^0X[0-9A-F]+$', addr):
            return pin.AM_INS, int(addr, 16)
        # 匹配直接寻址，内存单元取址送出10进制
        match = re.match(r'^\[([0-9]+)\]$', addr)
        if match:
            return pin.AM_DIR, int(match.group(1))
        # 匹配直接寻址，内存单元取址送出16进制
        match = re.match(r'^\[0X([0-9A-F]+)\]$', addr)
        if match:
            return pin.AM_DIR, int(match.group(1), 16)
        # 寄存器间接寻址，即将寄存器中的值作为ROM下标取出值送出
        match = re.match(r'^\[(.+)\]$', addr)
        if match and match.group(1) in REGISTERS:
            return pin.AM_RAM, REGISTERS[match.group(1)]
        raise SyntaxError(self)

    # 文本预处理，获取到指令-源操作数-目的操作数
    def prepare_source(self):
        if self.source.endswith(":"):
            self.type = self.LABEL
            self.name = self.source.strip(':')
            return
        # 逗号分割，如果大于2就是错误
        tup = self.source.split(',')
        if len(tup) > 2:
            raise SyntaxError(self)
        if len(tup) == 2:
            self.src = tup[1].strip()
        # 将指令和操作数分开
        tup = re.split(r' +', tup[0])
        if len(tup) > 2:
            raise SyntaxError(self)
        elif len(tup) == 2:
            self.dst = tup[1].strip()
        self.op = tup[0].strip()

    # 计算指令-目的操作数-源操作数的二进制值
    def compile_code(self):
        op = self.get_op()
        amd, dst = self.get_am(self.dst)
        ams, src = self.get_am(self.src)
        if src is not None and (amd, ams) not in ASM.INSTRUCTIONS[2][op]:
            raise SyntaxError(self)
        if src is None and dst and amd not in ASM.INSTRUCTIONS[1][op]:
            raise SyntaxError(self)
        if src is None and dst is None and op not in ASM.INSTRUCTIONS[0]:
            raise SyntaxError(self)
        amd = amd or 0
        ams = ams or 0
        dst = dst or 0
        src = src or 0
        if op in OP2SET:
            ir = op | (amd << 2) | ams
        elif op in OP1SET:
            ir = op | amd
        else:
            ir = op
        return [ir, dst, src]

    def __repr__(self):
        return f'[{self.number}] - {self.source}'


class SyntaxError(Exception):
    def __init__(self, code: Code, *args, **kwargs):
        super.__init__(*args, **kwargs)
        self.code = code


def compile_program():
    global codes
    global marks
    with open(inputFileName, encoding='utf8') as file:
        lines = file.readlines()
    # 遍历行
    for index, line in enumerate(lines):
        # 去掉空格符
        source = line.strip()
        # 去掉分号及后的备注，分号就是标识代码用的（简版）,冒号是标识LAB的
        if ';' in source:
            match = annotation.match(source)
            source = match.group(1)
            code = Code(index + 1, source)
            codes.append(code)
            continue
        if source.endswith(":"):
            codes.append(Code(index + 2, source, Code.LABEL))
            continue
        if not source:
            continue
    result = []
    current = None
    # 从后往前遍历代码行
    for var in range(len(codes) - 1, -1, -1):
        code = codes[var]
        if code.code_type == Code.CODE:
            current = code
            result.insert(0, code)
            continue
        if code.type == Code.LABEL:
            # 这里指向的是code的引用，后边的遍历改index不影响
            marks[code.name] = current
            continue
        raise SyntaxError(code)
    # 更新索引index
    for index, var in enumerate(result):
        var.index = index
    with open(outputFileName, 'wb') as file:
        for code in result:
            values = code.compile_code()
            for value in values:
                if value is not None:
                    result = value.to_bytes(1, byteorder='little')
                    file.write(result)


def main():
    try:
        compile_program()
    except SyntaxError as e:
        print(f'Syntax Error at {e.code}')
    print(f'program compile finished')


if __name__ == '__main__':
    main()


```
## 汇编定义代码assembly.py
主要定义，不同指令的电路组合状态。电路组合状态从管脚中定义的基本电路控制单元，或运算得到。
```python
import pin

# 汇编

# 取址
FETCH = [
    pin.PC_OUT | pin.MAR_IN,
    pin.RAM_OUT | pin.IR_IN | pin.PC_INC,

    pin.PC_OUT | pin.MAR_IN,
    pin.RAM_OUT | pin.DST_IN | pin.PC_INC,

    pin.PC_OUT | pin.MAR_IN,
    pin.RAM_OUT | pin.SRC_IN | pin.PC_INC,
]
# 指令定义
MOV = 0 | pin.ADDR2
ADD = (1 << pin.ADDR2_SHIFT) | pin.ADDR2
SUB = (2 << pin.ADDR2_SHIFT) | pin.ADDR2
CMP = (3 << pin.ADDR2_SHIFT) | pin.ADDR2
AND = (4 << pin.ADDR2_SHIFT) | pin.ADDR2
OR = (5 << pin.ADDR2_SHIFT) | pin.ADDR2
XOR = (6 << pin.ADDR2_SHIFT) | pin.ADDR2

INC = (0 << pin.ADDR1_SHIFT) | pin.ADDR1
DEC = (1 << pin.ADDR1_SHIFT) | pin.ADDR1
NOT = (2 << pin.ADDR1_SHIFT) | pin.ADDR1
JMP = (3 << pin.ADDR1_SHIFT) | pin.ADDR1
# 条件转移
# 溢出和非溢出
JO = (4 << pin.ADDR1_SHIFT) | pin.ADDR1
JNO = (5 << pin.ADDR1_SHIFT) | pin.ADDR1
# 零和非0
JZ = (6 << pin.ADDR1_SHIFT) | pin.ADDR1
JNZ = (7 << pin.ADDR1_SHIFT) | pin.ADDR1
# 奇数和非奇数
JP = (8 << pin.ADDR1_SHIFT) | pin.ADDR1
JNP = (9 << pin.ADDR1_SHIFT) | pin.ADDR1
PUSH = (10 << pin.ADDR1_SHIFT) | pin.ADDR1
POP = (11 << pin.ADDR1_SHIFT) | pin.ADDR1
CALL = (12 << pin.ADDR1_SHIFT) | pin.ADDR1
INT = (13 << pin.ADDR1_SHIFT) | pin.ADDR1

# SUB = (2 << pin.ADDR2_SHIFT) | pin.ADDR2
# SUB = (2 << pin.ADDR2_SHIFT) | pin.ADDR2
# SUB = (2 << pin.ADDR2_SHIFT) | pin.ADDR2
# 0操作数指令
# 啥也不干
NOP = 0
RET = 1
# 中断返回
IRET = 2
# 开中断
STI = 3
# 关中断
CLI = 4
# 停止
HLT = 0x3f  # 111111

INSTRUCTIONS = {
    2: {
        MOV: {
            # 立即数寻址，将立即数放入SRC寄存器，存入DST种存放的具体寄存器（地址）中,这里只定义指令动作，具体执行之后解析
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_W | pin.SRC_OUT,
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_W | pin.SRC_R,
            ],
            (pin.AM_REG, pin.AM_DIR): [
                pin.SRC_OUT | pin.MAR_IN,
                pin.DST_W | pin.RAM_OUT,
            ],
            (pin.AM_REG, pin.AM_RAM): [
                pin.SRC_R | pin.MAR_IN,
                pin.DST_W | pin.RAM_OUT,
            ],
            (pin.AM_DIR, pin.AM_INS): [
                pin.DST_OUT | pin.MAR_IN,
                pin.RAM_IN | pin.SRC_OUT,
            ],
            (pin.AM_DIR, pin.AM_DIR): [
                pin.SRC_OUT | pin.MAR_IN,
                pin.RAM_OUT | pin.T1_IN,
                pin.DST_OUT | pin.MAR_IN,
                pin.RAM_IN | pin.T1_OUT,
            ],
            (pin.AM_DIR, pin.AM_RAM): [
                pin.SRC_R | pin.MAR_IN,
                pin.RAM_OUT | pin.T1_IN,
                pin.DST_OUT | pin.MAR_IN,
                pin.RAM_IN | pin.T1_OUT,
            ],
            (pin.AM_RAM, pin.AM_INS): [
                pin.DST_R | pin.MAR_IN,
                pin.RAM_IN | pin.SRC_OUT,
            ],
            (pin.AM_RAM, pin.AM_REG): [
                pin.DST_R | pin.MAR_IN,
                pin.RAM_IN | pin.SRC_R,
            ],
            (pin.AM_RAM, pin.AM_DIR): [
                pin.SRC_OUT | pin.MAR_IN,
                pin.RAM_OUT | pin.T1_IN,
                pin.DST_R | pin.MAR_IN,
                pin.RAM_IN | pin.T1_OUT,
            ],
            (pin.AM_RAM, pin.AM_RAM): [
                pin.SRC_R | pin.MAR_IN,
                pin.RAM_OUT | pin.T1_IN,
                pin.DST_R | pin.MAR_IN,
                pin.RAM_IN | pin.T1_OUT,
            ],
        },
        ADD: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_ADD | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW,
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_ADD | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW,
            ],
        },
        CMP: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_SUB | pin.ALU_PSW,
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_SUB | pin.ALU_PSW,

            ],
        },
        SUB: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_SUB | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_SUB | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
        },
        AND: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_AND | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_AND | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
        },
        OR: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_OR | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_OR | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
        },
        XOR: {
            (pin.AM_REG, pin.AM_INS): [
                pin.DST_R | pin.A_IN,
                pin.SRC_OUT | pin.B_IN,
                pin.OP_XOR | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
            (pin.AM_REG, pin.AM_REG): [
                pin.DST_R | pin.A_IN,
                pin.SRC_R | pin.B_IN,
                pin.OP_XOR | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
        },
    },
    1: {
        INC: {
            pin.AM_REG: [
                pin.DST_R | pin.A_IN,
                pin.OP_INC | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW
            ],
        },
        DEC: {
            pin.AM_REG: [
                pin.DST_R | pin.A_IN,
                pin.OP_DEC | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW,
            ],
        },
        NOT: {
            pin.AM_REG: [
                pin.DST_R | pin.A_IN,
                pin.OP_NOT | pin.ALU_OUT | pin.DST_W | pin.ALU_PSW,
            ],
        },
        JMP: {
            # 立即数写入到PC
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JO: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JNO: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JZ: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JNZ: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JP: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        JNP: {
            pin.AM_INS: [
                pin.DST_OUT | pin.PC_IN
            ],
        },
        PUSH: {
            pin.AM_INS: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 读取目的寄存器的值到RAM，地址由MSR+MAR
                pin.DST_OUT | pin.RAM_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN,
            ],
            pin.AM_REG: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 读取目的寄存器的值到RAM，地址由MSR+MAR
                pin.DST_R | pin.RAM_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN,
            ],
        },
        POP: {
            pin.AM_REG: [
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                pin.SP_OUT | pin.MAR_IN,
                # RAM读取值到目的寄存器，地址由MSR+MAR
                pin.DST_W | pin.RAM_OUT,
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_INC,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN,
            ],
        },
        CALL: {
            pin.AM_INS: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 保存当前pc到RAM
                pin.PC_OUT | pin.RAM_IN,
                # 读取目的寄存器的值PC
                pin.DST_OUT | pin.PC_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN,
            ],
            pin.AM_REG: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 保存当前pc到RAM
                pin.PC_OUT | pin.RAM_IN,
                # 读取目的寄存器的值PC
                pin.DST_R | pin.PC_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN,
            ],
        },
        INT: {
            pin.AM_INS: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 保存当前pc到RAM
                pin.PC_OUT | pin.RAM_IN,
                # 读取目的寄存器的值PC
                pin.DST_OUT | pin.PC_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN | pin.ALU_PSW | pin.ALU_CLI,
            ],
            pin.AM_REG: [
                # 栈顶指针减一获取栈地址
                pin.SP_OUT | pin.A_IN,
                pin.SP_IN | pin.ALU_OUT | pin.OP_DEC,
                pin.SP_OUT | pin.MAR_IN,
                # 栈段地址送到MSR寄存器
                pin.SS_OUT | pin.MSR_IN,
                # 保存当前pc到RAM
                pin.PC_OUT | pin.RAM_IN,
                # 读取目的寄存器的值PC
                pin.DST_R | pin.PC_IN,
                # 恢复MSR到代码段
                pin.CS_OUT | pin.MSR_IN | pin.ALU_PSW | pin.ALU_CLI,
            ],
        },

    },
    0: {
        NOP: [pin.CYC],
        HLT: [pin.HLT],
        RET: [
            # 栈段地址送到MSR寄存器
            pin.SS_OUT | pin.MSR_IN,
            pin.SP_OUT | pin.MAR_IN,
            # RAM读取值写回PC计数器
            pin.PC_IN | pin.RAM_OUT,
            pin.SP_OUT | pin.A_IN,
            pin.SP_IN | pin.ALU_OUT | pin.OP_INC,
            # 恢复MSR到代码段
            pin.CS_OUT | pin.MSR_IN,
        ],
        IRET: [
            # 栈段地址送到MSR寄存器
            pin.SS_OUT | pin.MSR_IN,
            pin.SP_OUT | pin.MAR_IN,
            # RAM读取值写回PC计数器
            pin.PC_IN | pin.RAM_OUT,
            pin.SP_OUT | pin.A_IN,
            pin.SP_IN | pin.ALU_OUT | pin.OP_INC,
            # 恢复MSR到代码段
            pin.CS_OUT | pin.MSR_IN | pin.ALU_PSW | pin.ALU_STI,
        ],
        STI: [
            pin.ALU_PSW | pin.ALU_STI,
        ],
        CLI: [
            pin.ALU_PSW | pin.ALU_CLI,
        ],
    }
}

```
## 实现的指令
### 二地址指令
- MOV
- ADD
- CMP
- SUB
- AND
- OR
- XOR

### 一地址指令
- INC
- DEC
- NOT
- JMP 跳转
- JO 溢出跳转
- JNO 非溢出跳转
- JZ 零转
- JNZ
- JP 奇偶
- JNP 
- PUSH
- POP
- CALL
- INT中断（内部的）

### 零地址指令
- NOP
- HLT
- RET call对应恢复
- IRET 中断恢复
- STI start中断
- CLI close中断

## 演示
下面演示汇编代码的执行。
```
MOV D,3;
MOV C,4;
ADD D,C;
HLT;
```
该代码先被汇编解析代码编译到program.bin的二进制文件中，加载CPU的RAM，作为程序源。
然后控制器代码生成的二进制文件加载到CPU的ROM中，作为指令源。
最后，加法的输出结果是一个是7，在ALU旁输出和D寄存器中都是。。。
![](https://testerhome.com/uploads/photo/2023/e56a756c-f8ab-4a79-833e-f836edce129f.gif)
