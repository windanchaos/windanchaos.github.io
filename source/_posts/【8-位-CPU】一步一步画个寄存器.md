---
title: 【8 位 CPU】一步一步画个寄存器
date: 2023-01-22 23:20:32
category: 
       - 计算机科学基础
---

接上篇，仍然是基本电路往更复杂电路组合的逻辑。只不过，这部分电路有个特征，术语叫时序电路，其最基本的特征是相对组合电路来讲的，组合电路特定输入就得到特定输出，时序电路则不然，它的输出和输入的对应关系是不确定的，其电路的输出会接到输入上，最终输出是由输入、输出和电路当前状态决定。话不多说直接上截图。
- R-S触发器，输出Q确定后，Set、Clear、Prs不改变，那么电路是Q值是稳定的，可存储一位二进制。

![](https://testerhome.com/uploads/photo/2023/e99dbf70-4edb-4466-8c02-25d9d34b9ea5.png!large)

- D触发器（R-S)组合起来，加了2个与门电路，具备控制是否可读可写的能力
![](https://testerhome.com/uploads/photo/2023/b3ae68dd-015a-43ee-9140-4fb3399bf81c.png!large)

- D边沿触发器，增加了时钟上升沿才可以操作的电路
![](https://testerhome.com/uploads/photo/2023/11403bbe-0a13-47d3-9246-5930ecb8fc73.png!large)

- T触发器，D基础上接线，具备输出按时钟周期变化的能力，是计数器的基本单元
![](https://testerhome.com/uploads/photo/2023/b5fd8971-196f-4037-8b1a-18668e735c09.png!large)

- D边沿触发器组成一个能存储1byte（8个位）的单元
![](https://testerhome.com/uploads/photo/2023/1cbd3f61-81fc-4a3a-bf3c-223fc0b41ef9.png!large)

- Byte单元增加各种控制输入，就组成1个8位寄存器
![](https://testerhome.com/uploads/photo/2023/bac99be7-d4dc-488e-80a0-d5071e052ed1.png!large)

- 3-8译码器，3个位（000），0和1变化有8种组合情况，特定组合选中特定的Byte单元，具有了寻址概念
![](https://testerhome.com/uploads/photo/2023/77626fcc-faf5-4ea0-b92a-6f5eef8949f0.png!large)

- 8x1电路，Ad是输入的3位地址
![](https://testerhome.com/uploads/photo/2023/576edeff-5512-4af5-a492-0264e6a651b7.png!large)

最后演示一下001号寄存器被选中后的，执行写入和读取的操作。开始是重置255和清零，之后演示从0到8修改寄存器中值。
![](https://testerhome.com/uploads/photo/2023/0f5c7c3d-6436-40ec-b2a7-96cdef9c757e.gif!large)



备注：首次发布在[testerhome](https://testerhome.com/topics/35340)
