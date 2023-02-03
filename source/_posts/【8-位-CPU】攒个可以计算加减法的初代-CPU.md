---
title: 【8 位 CPU】攒个可以计算加减法的初代 CPU
date: 2023-01-31 17:20:59
category: 
       - 计算机科学基础
---



利用已有的电路部件，搭建一个可以计算加法和减法的电路。

![](https://testerhome.com/uploads/photo/2023/6b0628c7-0333-4ccc-8e24-85c3a927117c.png!large)

上面的MC、RAM、PC、Reg、ALU都有控制选中（CS片选）、可写（不可写则可读）的输入，选中时对应灯泡点亮示意。
使用16位中的13位二进制的01来对应。
通过不同的排列组合即可定义每个时钟周期电路的状态（哪些单元可以被操控读写）。

下面是对应电路的控制单元的标识，或运算一组和，就是控制电路了。
```python
import os
# 指令相关
# ABC寄存器
A_WE = 1
A_CS = 1 << 1

B_WE = 1 << 2
B_CS = 1 << 3

C_WE = 1 << 4
C_CS = 1 << 5

# 0为加，1为减
ALU_SUB = 1 << 6
ALU_EN = 1 << 7

MC_CS = 1 << 8
MC_WE = 1 << 9

PC_CS = 1 << 10
PC_WE = 1 << 11
PC_EN = 1 << 12
#空操作，未接线
NOTHING =  1 << 14
#停止（不再产生时钟信号）
HLT = 1 << 15

dirname = os.path.dirname(__file__)
fileName = os.path.join(dirname,'ins.bin')

micro = [
#启动电源PC=0    
#空操作，用于清0，清0后PC=1
NOTHING,
# PC加1，从RAM中读取1下标的数到A寄存器，PC=2
MC_CS|A_CS|A_WE|PC_WE|PC_EN|PC_CS,
# PC加1，从RAM中读取2下标的数到B寄存器,PC=3
MC_CS|B_CS|B_WE|PC_WE|PC_EN|PC_CS,
# 读取A、B寄存器数到ALU单元并计算
ALU_EN|A_CS|B_CS,
#ALU计算结果输出到C寄存器
ALU_EN|C_CS|C_WE,
# PC=3，控制MC操控ROM可写，写入C寄存器读取的值
MC_CS|MC_WE|C_CS,
HLT
]
# 二进制指令输出到ins.bin文本，通过ciruit加载到ROM中。
with open(fileName,'wb') as file:
    for value in micro:
        file.write(value.to_bytes(2,byteorder='little'))

print("finished compile")

```
以下是加法的gif演示（减法免了），演示从RAM中读取5和3到寄存器，使用ALU单元求和，输出到C寄存器，再写回到RAM。
![](https://testerhome.com/uploads/photo/2023/7f0c6d7a-281d-4230-b87a-8ab3edca4e46.gif!large)

备注：首次发布在[testerhome](https://testerhome.com/topics/35381)
