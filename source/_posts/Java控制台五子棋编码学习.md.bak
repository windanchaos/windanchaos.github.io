---
title: Java控制台五子棋编码学习
author: windanchaos
tags: 
       - FromCSDN

category: 
       - Java编程语言

date: 2016-07-07 13:50:58
---
# 目录

# 主要经验

# 游戏描述

参考的是《疯狂Java实战演义》——杨恩雄(文字版)中第一章内容。

# Java源代码

## **GobangGame.java**

```js 
package practise.fiveChess;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class GobangGame {
    private int WIN_COUNT = 5;
    private int posX, posY;
    Chessboard chessboard = new Chessboard();

    public int getPosX() {
        return posX;
    }

    public void setPosX(int posX) {
        this.posX = posX;
    }

    public int getPosY() {
        return posY;
    }

    public void setPosY(int posY) {
        this.posY = posY;
<!-- more -->
    }

    public static void main(String[] args) {
        //游戏初始化
        boolean isOver = false;
        System.out.println("游戏开始!");
        GobangGame gobangGame = new GobangGame();
        Chessboard chessboard = new Chessboard();
        chessboard.initBorad();
        chessboard.printBoard();
        //执行游戏交互
        do {
            try {
                BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                String inputStr = null;
                // 判断输入是否合法
                while ((inputStr = br.readLine()) != null && gobangGame.isValid(inputStr) && isOver == false) {
                    int posX = gobangGame.getPosX();
                    int posY = gobangGame.getPosY();
                    String colorDark = Chessman.BLACK.getChessman();
                    String colorWhite = Chessman.WHITE.getChessman();
                    // 放棋子,如果失败则重放
                    if (!chessboard.setBoardByMan(posX, posY, colorDark)
                            || !chessboard.setBoardByComputer(colorWhite)) {
                        continue;
                    }
                    // 打印棋盘
                    chessboard.printBoard();
                    // 判断是否有赢家
                    if (gobangGame.isWin(chessboard, posX, posY, colorDark)
                            || gobangGame.isWin(chessboard, posX, posY, colorWhite)) {
                        if (gobangGame.isWin(chessboard, posX, posY, colorDark) == true) {
                            System.out.println("比赛结束！" + colorDark + "获得胜利");
                            System.out.println("是否继续游戏？y/n");
                            // 用户确认是否继续游戏，继续则初始化棋盘，否则退出程序
                            if (br.readLine().contentEquals("y")) {
                                chessboard.initBorad();
                                System.out.println("游戏开始!");
                                chessboard.printBoard();
                                continue;
                            } else {
                                isOver = true;
                                break;
                            }
                        }
                        if (gobangGame.isWin(chessboard, posX, posY, colorWhite) == true) {
                            System.out.println("比赛结束！" + colorWhite + "获得胜利");
                            System.out.println("是否继续游戏？y/n");
                            // 用户确认是否继续游戏，继续则初始化棋盘，否则退出程序
                            if (br.readLine().contentEquals("y")) {
                                chessboard.initBorad();
                                System.out.println("游戏开始!");
                                chessboard.printBoard();
                                continue;
                            } else {
                                isOver = true;
                                break;
                            }
                        }
                    }
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
        } while (isOver == false);
        System.out.println("Game Over!");
    }

    // 输入合法性检测
    public boolean isValid(String str) {
        String[] posStrArr = str.split(",");
        try {
            posX = Integer.parseInt(posStrArr[0]);
            posY = Integer.parseInt(posStrArr[1]);
            if (posX > chessboard.BOARD_SIZE || posY > chessboard.BOARD_SIZE || posX < 0 || posY < 0) {
                System.out.println("输入不合法，请输入合法的坐标范围：0--" + (chessboard.BOARD_SIZE - 1));
                return false;
            }
        } catch (NumberFormatException e) {
            //chessboard.printBoard();
            System.out.println("输入不合法，请重新按\"x,y\"的形式输入");
            return false;
        }
        return true;
    }
    //是否继续游戏方法
    public boolean isReplay(String enterStr) {
        if (enterStr == "y" || enterStr == "Y") {
            return true;
        } else {
            return false;
        }
    }

    //以下方法基于输入棋子坐标，按不同方向（基于棋子坐标），东西|南北|东北-西南|西北-东南。
    //东西
    public boolean conetX(Chessboard chessboard, int posX, int posY, String chessColor) {
        String[][] board;
        board = chessboard.getBord();
        int count = 1;
        try {
            int tmpY = posY - 1;
            // 输入点不是起点所在列则判断
            // 输入点左侧
            while (posY >= tmpY && tmpY > 0) {
                if (board[posX][tmpY] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY--;
                }
            }
            // 输入点右侧
            tmpY = posY + 1;
            while (posY <= tmpY && tmpY < chessboard.BOARD_SIZE) {
                if (board[posX][tmpY] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY++;
                }
            }
            if (count >= WIN_COUNT) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println("异常错误:" + e.getMessage());
            return false;
        }
    }

    /**
     * 南北统计
     */
    public boolean conetY(Chessboard chessboard, int posX, int posY, String chessColor) {
        String[][] board;
        board = chessboard.getBord();
        int count = 1;
        try {
            int tmpX = posX - 1;
            // 输入点上方,如果输入的是原点则不计
            while (tmpX >= 0) {
                if (board[tmpX][posY] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpX--;
                }
            }
            // 输入点下方
            tmpX = posX + 1;
            while (posX < tmpX && tmpX < chessboard.BOARD_SIZE) {
                if (board[tmpX][posY] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpX++;
                }
            }
            // 累加后是否符合要求
            if (count >= WIN_COUNT) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            System.out.println("异常错误:" + e.getMessage());
            return false;
        }

    }

    /**
     * 东北\西南斜线方向
     */
    public boolean conetEN(Chessboard chessboard, int posX, int posY, String chessColor) {
        String[][] board;
        board = chessboard.getBord();
        int count = 1;

        try {
            int tmpX1 = posX - 1;
            int tmpY1 = posY - 1;

            // 西北线
            while (tmpX1 < posX && tmpX1 >= 0 && tmpY1 < posY && tmpY1 >= 0) {
                if (board[tmpX1][tmpY1] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY1--;
                    tmpX1--;
                }
            }
            // 东南线
            int tmpX2 = posX + 1;
            int tmpY2 = posY + 1;
            while (tmpX2 > posX && tmpX2 < chessboard.BOARD_SIZE && tmpY2 > posY && tmpY2 < chessboard.BOARD_SIZE) {
                if (board[tmpX2][tmpY2] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY2++;
                    tmpX2++;
                }
            }
            if (count >= WIN_COUNT) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            System.out.println("异常错误:" + e.getMessage());
            return false;
        }
    }

    /**
     * 东北西南斜线方向
     */
    public boolean conetES(Chessboard chessboard, int posX, int posY, String chessColor) {
        String[][] board;
        board = chessboard.getBord();
        int count = 1;
        count = 1;
        try {
            int tmpX1 = posX - 1;
            int tmpY1 = posY + 1;
            // 东北线
            while (tmpX1 < posX && tmpX1 >= 0 && tmpY1 >= posY && tmpY1 < chessboard.BOARD_SIZE) {
                if (board[tmpX1][tmpY1] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY1++;
                    tmpX1--;
                }
            }
            // 西南线
            int tmpX2 = posX + 1;
            int tmpY2 = posY - 1;
            while (tmpX2 < chessboard.BOARD_SIZE && tmpX2 > posX && tmpY2 < posY && tmpY2 >= 0) {
                if (board[tmpX2][tmpY2] != chessColor) {
                    break;
                } else {
                    count++;
                    tmpY2--;
                    tmpX2++;
                }
            }
            if (count >= WIN_COUNT) {
                return true;
            } else {
                return false;
            }

        } catch (Exception e) {
            System.out.println("异常错误:" + e.getMessage());
            return false;
        }
    }

    // 判断所输入打棋子是否能够赢得比赛
    public boolean isWin(Chessboard chessboard, int posX, int posY, String chessColor) {
        boolean isWinx = this.conetX(chessboard, posX, posY, chessColor);
        boolean isWiny = this.conetY(chessboard, posX, posY, chessColor);
        boolean isWinEN = this.conetEN(chessboard, posX, posY, chessColor);
        boolean isWinES = this.conetES(chessboard, posX, posY, chessColor);
        if (isWinx || isWiny || isWinEN || isWinES) {
            return true;
        } else {
            return false;
        }
    }
}
```

## Chessman.java

```js 
public enum Chessman {
    BLACK("●"), WHITE("○");
    private String chessman;
    private Chessman(String chessman) {
        this.chessman = chessman;
    }
    public String getChessman() {
        return this.chessman;
    }
}
```

## Chessboard.java

```js 
package practise.fiveChess;

public class Chessboard {

    static int  BOARD_SIZE=22;
    String[][] board=new String[BOARD_SIZE][BOARD_SIZE];
    //初始化棋盘
    public void initBorad(){
        for (Integer i = 0; i < BOARD_SIZE; i++) {
            for (Integer j = 0; j < BOARD_SIZE; j++) {
                board[i][j]="╂";
            }
        }
    }
    //打印棋盘
    public void printBoard(){
        for (int i = 0; i < BOARD_SIZE; i++) {
            //System.out.print(i);
            for (int j = 0; j < BOARD_SIZE; j++) {
                System.out.print(board[i][j]);
            }
            System.out.println();
        }
    }

    //人执黑棋下棋落子
    public boolean setBoardByMan(int posX,int posY,String color){
            if(board[posX][posY]!="╂"){ 
                System.out.println("输入位置已有棋子，请重新输入");
                return false;
            }else{
                board[posX][posY]="●";
                return true;
            }
    }
    //电脑执白棋
    public boolean setBoardByComputer(String color){
        int posX,posY;
        posX=(int)((Math.random())*BOARD_SIZE);
        posY=(int)((Math.random())*BOARD_SIZE);
        if(board[posX][posY]!="╂"){ 
            setBoardByComputer(color);
            return false;
        }else{
            board[posX][posY]="○";
            return true;
        }

    }
    //返回棋盘，二维数组
    public String[][] getBord(){
        return board;
    }

}
```
