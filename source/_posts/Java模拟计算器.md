---
title: Java模拟计算器
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Java编程语言

date: 2016-07-21 23:18:45
---
一开始懂一点SWING界面皮毛，打算使用SWING绘制出了计算器的界面，花了大概2个下班业余时间，一点一点开始摸索，知道SWING界面布局的基本原理。然后开始按照教材中讲解的过程去实现，结果发现界面根本不是那么做出来的。在网上找到了java的源代码，开始研究阅读和抄写编译。墨迹一周有如下收获。
1、JFrame是整个界面的底层，所有行为都给予它；
2、任何界面元素都需要个容器（Jpanel类）放置，每个容器需要定义一个基本的布局设置（Layout类）。布局中可以放置各种容器及元素。
3、元素过多，编程绘制界面效率比手绘要快。
4、任何类都功能单一为原则。编程中极容易按流程把功能给混淆导致设计的冗余。
5、Java的监听有所理解：为界面元素添加监听器，扩展java监听类并实现其方法，该方法将监听器捕获的动作事件作为传入参数，然后取得动作事件后执行方法内的业务处理逻辑。

参考：[http://blog.csdn.net/frank_softworks/article/details/1629615](http://blog.csdn.net/frank_softworks/article/details/1629615)
源代码：
```js 
package myPractise.Creasy2;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTextField;

import com.sun.xml.internal.ws.policy.privateutil.PolicyUtils.Text;

public class Calculator2 extends JFrame implements ActionListener
{

    /** 计算器上的键的显示名字 */
    private final String[] KEYS = { "7", "8", "9", "/", "sqrt", "4", "5", "6", "*", "%", "1", "2", "3", "-", "1/x", "0",
            "+/-", ".", "+", "=" };
    /** 计算器上的功能键的显示名字 */
    private final String[] COMMAND = { "Backspace", "CE", "C" };
    /** 计算器左边的M的显示名字 */
    private final String[] M = { " ", "MC", "MR", "MS", "M+" };
    /** 计算器上键的按钮 */
<!-- more -->
    private JButton keys[] = new JButton[KEYS.length];
    /** 计算器上的功能键的按钮 */
    private JButton commands[] = new JButton[COMMAND.length];
    /** 计算器左边的M的按钮 */
    private JButton m[] = new JButton[M.length];
    /** 计算结果文本框 */
    private JTextField resultText = new JTextField("0");

    // 标志用户按的是否是整个表达式的第一个数字,或者是运算符后的第一个数字
    private boolean firstDigit = true;
    // 计算的中间结果。
    private double resultNum = 0.0;
    // 当前运算的运算符
    private String operator = "=";
    // 操作是否合法
    private boolean operateValidFlag = true;

    /**
     * 构造函数
     */
    public Calculator2() {
        super();
        // 初始化计算器
        init();
        // 设置计算器的背景颜色
        this.setBackground(Color.LIGHT_GRAY);
        this.setTitle("计算器");
        // 在屏幕(500, 300)坐标处显示计算器
        this.setLocation(500, 300);
        // 不许修改计算器的大小
        this.setResizable(false);
        // 使计算器中各组件大小合适
        this.pack();
    }

    /**
     * 初始化计算器
     */
    public void init()
    {
        // 文本的字体和大小
        resultText.setFont(new Font("宋体", Font.PLAIN, 15));
        // 文本框中的内容采用右对齐方式
        resultText.setHorizontalAlignment(JTextField.RIGHT);
        // 不允许修改结果文本框
        resultText.setEditable(false);
        // 设置文本框背景颜色为白色
        resultText.setBackground(Color.WHITE);
        // 初始化计算器上键的按钮，将键放在一个画板内
        JPanel calckeysPanel = new JPanel();
        // 用网格布局器，4行，5列的网格，网格之间的水平方向间隔为3个象素，垂直方向间隔为3个象素
        calckeysPanel.setLayout(new GridLayout(4, 5, 3, 3));
        for (int i = 0; i < KEYS.length; i++)
        {
            keys[i] = new JButton(KEYS[i]);
            calckeysPanel.add(keys[i]);
            keys[i].setForeground(Color.blue);
        }
        // 运算符键用红色标示，其他键用蓝色表示
        keys[3].setForeground(Color.red);
        keys[8].setForeground(Color.red);
        keys[13].setForeground(Color.red);
        keys[18].setForeground(Color.red);
        keys[19].setForeground(Color.red);

        // 初始化功能键，都用红色标示。将功能键放在一个画板内
        JPanel commandsPanel = new JPanel();
        // 用网格布局器，1行，3列的网格，网格之间的水平方向间隔为3个象素，垂直方向间隔为3个象素
        commandsPanel.setLayout(new GridLayout(1, 3, 3, 3));
        for (int i = 0; i < COMMAND.length; i++)
        {
            commands[i] = new JButton(COMMAND[i]);
            commandsPanel.add(commands[i]);
            commands[i].setForeground(Color.red);
        }

        // 初始化M键，用红色标示，将M键放在一个画板内
        JPanel calmsPanel = new JPanel();
        // 用网格布局管理器，5行，1列的网格，网格之间的水平方向间隔为3个象素，垂直方向间隔为3个象素
        calmsPanel.setLayout(new GridLayout(5, 1, 3, 3));
        for (int i = 0; i < M.length; i++)
        {
            m[i] = new JButton(M[i]);
            calmsPanel.add(m[i]);
            m[i].setForeground(Color.red);
        }

        // 下面进行计算器的整体布局，将calckeys和command画板放在计算器的中部，
        // 将文本框放在北部，将calms画板放在计算器的西部。

        // 新建一个大的画板，将上面建立的command和calckeys画板放在该画板内
        JPanel panel1 = new JPanel();
        // 画板采用边界布局管理器，画板里组件之间的水平和垂直方向上间隔都为3象素
        panel1.setLayout(new BorderLayout(3, 3));
        panel1.add("North", commandsPanel);
        panel1.add("Center", calckeysPanel);

        // 建立一个画板放文本框
        JPanel top = new JPanel();
        top.setLayout(new BorderLayout());
        top.add("Center", resultText);

        // 整体布局，getcontentpane方法是JRame的静态方法
        getContentPane().setLayout(new BorderLayout(3, 5));
        getContentPane().add("North", top);
        getContentPane().add("Center", panel1);
        getContentPane().add("West", calmsPanel);
        // 为各按钮添加事件侦听器
        // 都使用同一个事件侦听器，即本对象。本类的声明中有implements ActionListener
        for (int i = 0; i < KEYS.length; i++)
        {
            keys[i].addActionListener(this);
        }
        for (int i = 0; i < COMMAND.length; i++)
        {
            commands[i].addActionListener(this);
        }
        for (int i = 0; i < M.length; i++)
        {
            m[i].addActionListener(this);
        }
    }

    /*
     * 处理键盘事件 覆盖ActionListenser的方法，接受被监听对象的活动
     */
    @Override
    public void actionPerformed(ActionEvent e)
    {
        String label = e.getActionCommand();
        if (label.equals(COMMAND[0]))
        {
            // 用户按了"Backspace"键方法
            BackspaceWay(label);
        }
        else if (label.equals(COMMAND[1]))
        {
            // 用户按了"CE"键
            resultText.setText("0");
        }
        else if (label.equals(COMMAND[2]))
        {
            // 用户按了"C"键
            resultText.setText("0");
            operator = "=";
            operateValidFlag = true;
        }
        else if ("0123456789.".indexOf(label) >= 0)
        {
            // 用户按了数字键或者小数点键
            NumWay(label);

        }
        else
        {
            // 用户按了运算符键
            CalculatorWay(label);
        }

    }

    public void BackspaceWay(String label)
    {
        String text = resultText.getText();
        if (text.length() > 0)
        {
            text = text.substring(0, text.length() - 1);
            if (text.length() == 0)
            {
                resultText.setText("0");
                operator = "=";
                operateValidFlag = true;
            }
            else
            {
                resultText.setText(text);
            }
        }
    }

    public void NumWay(String label)
    {

        if (firstDigit)
        {
            resultText.setText(label);
        }else if (!label.equals("."))
        {
            resultText.setText(resultText.getText() + label);
        }else if(label.equals(".")&&resultText.getText().indexOf(".")<0) {
            resultText.setText(resultText.getText() + ".");
        }
        firstDigit = false;
    }

    public void CalculatorWay(String label)
    {

        if (operator.equals("/")) {
            // 除法运算
            // 如果当前结果文本框中的值等于0
            if (getNumberFromText() == 0.0) {
                // 操作不合法
                operateValidFlag = false;
                resultText.setText("除数不能为零");
            } else {
                resultNum /= getNumberFromText();
            }
        } else if (operator.equals("1/x")) {
            // 倒数运算
            if (resultNum == 0.0) {
                // 操作不合法
                operateValidFlag = false;
                resultText.setText("零没有倒数");
            } else {
                resultNum = 1 / resultNum;
            }
        } else if (operator.equals("+")) {
            // 加法运算
            resultNum += getNumberFromText();
        } else if (operator.equals("-")) {
            // 减法运算
            resultNum -= getNumberFromText();
        } else if (operator.equals("*")) {
            // 乘法运算
            resultNum *= getNumberFromText();
        } else if (operator.equals("sqrt")) {
            // 平方根运算
            resultNum = Math.sqrt(resultNum);
        } else if (operator.equals("%")) {
            // 百分号运算，除以100
            resultNum = resultNum / 100;
        } else if (operator.equals("+/-")) {
            // 正数负数运算
            resultNum = resultNum * (-1);
        } else if (operator.equals("=")) {
            // 赋值运算
            resultNum = getNumberFromText();
        }
        if (operateValidFlag) {
            // 双精度浮点数的运算
            long t1;
            double t2;
            t1 = (long) resultNum;
            t2 = resultNum - t1;
            if (t2 == 0) {
                resultText.setText(String.valueOf(t1));
            } else {
                resultText.setText(String.valueOf(resultNum));
            }
        }
        // 运算符等于用户按的按钮
        operator = label;
        firstDigit = true;
        operateValidFlag = true;
    }

    public double getNumberFromText(){
        double result = 0;
        try {
            result = Double.valueOf(resultText.getText()).doubleValue();
        } catch (NumberFormatException e) {
        }
        return result;
    }
    public static void main(String[] args)
    {
        Calculator2 calculator2=new Calculator2();
        calculator2.setVisible(true);

    }

}
```
