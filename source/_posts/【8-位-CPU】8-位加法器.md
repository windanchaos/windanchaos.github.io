---
title: 【8 位 CPU】8 位加法器
date: 2023-01-17 00:09:39
category: 
       - 计算机科学基础
---

使用工具：https://www.logiccircuit.org/
工具中有基本的逻辑电路单元、输入输出、分线器、晶振模拟器、显示装置模拟单元等。
最基本的思想是：通过基本电路的接线，确立输入-输出规则，类似函数的入参和返回值，便构成一个功能电路单元。单元套单元组成新单元，如此往复。“一生二，二生三，三生万物”。

如下：半加器是异或、与门电路接线构成。2个输入2个输出。

- 半加器 HA(HalfAdder)
![](https://testerhome.com//uploads/photo/2023/9ed140ce-6277-459b-a365-c33293175b2f.png!large)

- 半加器组成个全加器 FA(FullAdder)

![](https://testerhome.com//uploads/photo/2023/52094bbc-a4e2-4c0e-9e8b-3788b01193ac.png!large)

- 8位的求反RE
![](https://testerhome.com//uploads/photo/2023/b8010e1d-8608-4bcd-97f1-470532c871a3.png!large)
- 半加器组合成8位的计算器
![](/uploads/photo/2023/96acc38c-c9d8-473c-ab8f-9895a3001888.png!large)



备注：首次发布在[testerhome](https://testerhome.com/topics/35311)
