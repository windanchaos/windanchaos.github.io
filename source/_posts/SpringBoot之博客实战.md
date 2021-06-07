---
title: SpringBoot之博客实战
date: 2021-06-07 20:37:19
category: 后端框架和技术

---

# 前言

自学这件事，要坚持下来真的挺耗费精神力的。本来打算把博客系统敲完，遇到面试，要准备，参加面试几轮几轮的面，准备入职的事，又有新面试等等，对入职公司的技术栈的研究涉及go，又大概看了go。测试学院开学，当了助教，也需要上课，答疑解惑。精神分散，还要做家务煮饭什么的，还是比较难办。差点把这个博客计划半途而废了。然后想起来还有件事没有利索，回头继续前进，一定完成！做一件成一件！

2020年6月入职现在的公司开启上班模式后这件事又耽搁了几个月，期间根据公司实际，研习了很多客户端的技术，博客代码的事有中断，后继续，目前是2021年6月7日，实际前前后后已经完成一个多月，打算对第一阶段的博客代码和套路做个总结。下一个阶段的总结应该是要前后端分离，并带上VUE相关内容的。

本文不适合跟操作，仅适合查看涉及的知识点，或扩充一二。

我的项目地址：https://gitee.com/windanchaos/my-blog-v2

师出同门的博客地址（可以大致跟敲）：https://onestar.newstar.net.cn/types/33

李仁密教课的地址（我很多地方没跟，比如持久框架和很多细节）：https://www.bilibili.com/video/BV13t411T72J

# 前置动作

- jQuery速度学习一下，以便在操控界面元素上能有思路
- mybatis速度学习一下，以便脱离视频教程的持久化方法

# 用户故事

三个关键点角色、功能、商业价值。

模板：作为一个（角色），我可以做什么，从而达到什么目的。

# 个人博客系统的用户故事

角色：普通访客、管理员（我）

这里的概念是头一次听到和见到，类似一个产品经理的视角看待问题。

## 访客的用户故事

- 可以分页查看所有博客
- 快速查看博客数最多的6个分类
- 可以查看所有的分类
- 可以查看某个分类下的博客列表
- 查看标记博客最多的10个标签
- 查看所有标签
- 查看标签下的博客列表
- 可以根据年度时间线查看博客列表
- 查看最新的博客列表
- 查看最新的推荐博客
- 可以 查看单个的博客内容
- 可以对博客内容进行评论  ---  未完成
- 可以赞赏   ---  未完成
- 可以微信扫码阅读博客内容  ---  未完成
- 扫码关注我  ---  未完成

## 管理员的用户故事

- 博客的增删改
- 博客分类
- 博客打标签
- 博客标题、分类、标签进行查询
- 博客分类的增删改查
- 标签的增删改查

# 功能规划

根据用户故事，规划出功能树。



# 页面设计

由于是前端的小白，仅仅了解些基础，所以做页面设计前要恶补下基础。

分成四个大的方向，起码要一周时间。

## 设计

页面原型驱动开发。工具axure rp。



## html5

标签有语义。注意语义在html中的作用。

样式主要是css来控制，语义考虑与否看目的和要求，建议追求适度标签的语义。

## css3

less工具，做编码时的css预处理工具，提高效率。

## jQuery

jQuery库包含以下功能：

- HTML 元素选取
- HTML 元素操作
- CSS 操作
- HTML 事件函数
- JavaScript 特效和动画
- HTML DOM 遍历和修改
- AJAX
- Utilities

### jQuery 语法

jQuery 语法是通过选取 HTML 元素，并对选取的元素执行某些操作。

基础语法： **$(selector).action()**

- 美元符号定义 jQuery
- 选择符（selector）"查询"和"查找" HTML 元素
- jQuery 的 action() 执行对元素的操作

## Semantic UI
Semantic UI 已经没有维护了，相对应还持续活跃的它的替代项目Semantic UI React， is the official React integration for Semantic UI。
https://react.semantic-ui.com/

本文仍然使用Semantic UI ，Semantic 是一个用来帮助设计出漂亮的、响应化、人性化的网络框架。 

Semantic UI 把单词和类看作可以交换的概念处理。  任何功能，都是基于可修改而设计的，用简单的短语来触发功能。 

类用自然语言的语法，比如名词/修饰词的关系、次序，以及直观的多元链接概念。

semantic 的部件提供了几种不同类型的定义：元素，组合，视图，模块与行为，这些囊括了界面设计的各个方面。

响应式式是完全用 **em** 设计的。内置元素 *variations* 的设计可以让你平板电脑或者移动设备上进行内容的调整。  

 https://zijieke.com/semantic-ui/ 

### 布局组件的使用
#### 网格系统
ui grid是Semantic框架中用来进行页面动态布局的工具。
主要用法分为两种：定宽网格和定栏网格

定宽网格：页面一共16栏，明确知道每一块横跨宽度
```
-- ui grid 
  -- ten wide column
  -- six wide column
```
定栏网格：要分为几栏，一般为奇数，偶数可转化为定宽

```
--ui three column grid
    -- column
    -- column
    -- column
```
嵌套

    -- ui three column grid container
        -- column
            -- ui two column grid
            -- column
            -- column
        -- column
        -- column

在semantic UI 中，主要用三个工具来构建网页的框架： segment container grid

他们的作用各不相同：

**segment**: 最基本的作用是作为文本的文本框出现在网页上。 在前面加上vertical后，就可以当成块用。从上向下将网页分成几块，就用：vertical segment 所以，网页从上往下布局，就用：ui vertical segment  

**container**： 用在左右页边距很大的情况，网站的内容集中在中间区域显示。

**grid**： 将网页的某个区域在水平方向上划分成几个区域。

综上：上下划分区域时用segment，左右划分区域时用grid，两边留白显示时用container。  一般网页的套路都是：用segment把网页划分成几个部分，在各个部分中会用到container和grid。

### 关键词

笔者一开始以为掌握了这些关键词，就可以任意组合它们，实际并不是，至于为什么，还不知道。

所以UI的设计上来说，只能说是过渡，曾经耗费了不少时间去研究，最终选择先pass这一块，能跑起来就行。



*mini tiny small medium large big huge massive* 

*basic primary主要 secondary次要 positive积极 negative消极*

*red orange yellow blue olive橄榄绿 green teal水雅兰 purple紫色 pink粉色 grey black violet紫罗兰*

*inverted反压反转*

*vertical 垂直*

*attached 附属的*

*vertical 垂直*

*fade 渐进*

*hidden content*

*animated 能活动*

*visible hidden隐藏和显示*

*loading 加载中*

*compact 紧凑的*

*fluid 充满的*

*float 悬浮*

*fixed 固定的*

*left、right*

*aligned对齐的 left aligned middle top bottom*

*attached 附属的*

*aligned 对齐的*

*active 激活*

*circular 圆角*

*transparent透明的*

*avatar 头像*

*rounded 圆角*

*circular 圆形*

*segment 分段分区*

*secondary 次要的*

*tertiary 比次要还要次要的*

*piled 堆叠的*

*padded加垫的*

*stacked 堆叠的*

*stackable 具备自适应的（grid）*

*divided 分割的*

## 集成插件

### markdow编辑器

 https://pandao.github.io/ 

### 目录生成插件

to do

## thymeleaf的模板技术

视频教程中没有恰当的引入模板，导致浪费挺多精力去处理相同类别的UI。

暂时不清楚视频中为什么没有在html中引用thymeleaf的namespace，导致很多他可以敲出来运行的代码，我不行，所以我自己去学习一下thymeleaf，重新搞一下。

- 定义fragment
- 使用fragment布局

### 常用语法
Thymeleaf的主要作用是把model中的数据渲染到html中，因此其语法主要是如何解析model中的数据。

从以下方面来学习：
- 变量、方法、条件判断、循环、运算 [ 逻辑运算、布尔运算、比较运算、条件运算 ]
- 其它

具体：https://www.cnblogs.com/msi-chen/p/10974009.html

官方文档：https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#standard-expression-syntax

注释：https://www.cnblogs.com/gdjlc/p/11703285.html

fragment:https://blog.csdn.net/wangmx1993328/article/details/84747497

### 官方练习
- http://itutorial.thymeleaf.org/exercise/5 utext和text
- http://itutorial.thymeleaf.org/exercise/7 列表、each 数字格式化
- http://itutorial.thymeleaf.org/exercise/8 日期格式化、if条件
- http://itutorial.thymeleaf.org/exercise/9 列表、表格
- http://itutorial.thymeleaf.org/exercise/10  Spring 表达式（四则、静态方法、new对象等）
- http://itutorial.thymeleaf.org/exercise/11 link及action使用
- http://itutorial.thymeleaf.org/exercise/12 th中object的使用
- http://itutorial.thymeleaf.org/exercise/13 在text中引用th的参数，[[${customerName}]]
- http://itutorial.thymeleaf.org/exercise/14 fragment的引用方式
- http://itutorial.thymeleaf.org/exercise/15 fragment及传参、加class
- http://itutorial.thymeleaf.org/exercise/16 文本拼接的三种套路
- http://itutorial.thymeleaf.org/exercise/17  模板中的备注
- http://itutorial.thymeleaf.org/exercise/19 插入标签显示和隐藏
- http://itutorial.thymeleaf.org/exercise/20 Spring Conversion Service
- http://itutorial.thymeleaf.org/exercise/21 根据服务端值生成url
# 技术栈

- springboot
- mybastis
- thymeleaf
- 某前端框架

## 实体设计

- 博客Blog
- 分类Category
- 标签Tag
- 用户User

根据实体设计数据库表。

## mybastis

https://blog.windanchaos.tech/2020/04/16/mybatis%E5%85%A5%E4%B8%AA%E9%97%A8/

dao 是mapper.xml中定义行为的接口，会被Mybatis自动关联处理。
entity 下的类是mapper.xml中对应数据库的数据内容。
service 及其实现，定义业务行为，实现业务行为。在类中申明entity，完成业务逻辑。
controller web层面访问url，调用service。

使用intellj 的 easyCode插件，插件集合了mybatisPlus的功能，配置好db链接后。直接生成：

- entity
- dao
- service
- serviceImpl
- controller
- mapper.xml

### pagehelper实现分页查询

https://blog.csdn.net/csonst1017/article/details/85064029

## 模板和controller层交互

https://blog.csdn.net/weixin_43055096/article/details/87704493

## Springboot

| 包名        | 名称                     | 具体作用                                                     |
| ----------- | ------------------------ | ------------------------------------------------------------ |
| dao         | 数据库访问层             | 与数据打交道，可以是数据库操作，也可以是文件读写操作，甚至是redis缓存操作，总之与数据操作有关的都放在这里，mybatis直接在配置文件中实现接口的每个方法所以没有daoImpl。 |
| entity      | 数据库和对象映射的实体类 | 一般与数据库的表相对应，封装dao层取出来的数据为一个对象，也就是我们常说的pojo，一般只在dao层与service层之间传输。 |
| dto         | 数据传输层               | 一个entity并不能满足我们的业务需求，可能呈现给用户的信息十分之多，这时候就有了dto |
| service     | 业务逻辑(接口)           | 在设计业务接口时候应该站在“使用者”的角度。                   |
| serviceImpl | 业务逻辑接口的实现       | 具体实现业务，一般事务控制写在该层                           |
| controller  | 控制器                   | springmvc就是在这里发挥作用的，一般人叫做controller控制器    |



## 数据库环境
### mysql的容器启动

```bash
docker pull mysql:5.6
docker run -itd --name mysql-blog -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -v `pwd`/data:/var/lib/mysql -e TZ="Asia/Shanghai"  mysql:5.6 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```
### 数据库初始化
和DB建立连接后执行SQL初始化脚本命令。
脚本在代码的resource/db.sql。

## 后端业务逻辑
按套路编写:
- dao
- entity
- vo
- service
- controller

持久层使用的mybatis框架，这里有个mybatis plus的代码自动生成工具，但是我决定不适用，正是因为初学第一遍的时候使用过，虽快但是很多技术细节容易忽略，反而走了弯路。工具，要在理解了技术的原理基础上再用才是事半功倍。

这里理解了分层的套路（还不完整）。

entity、vo或po的关系。前者是DB表在代码中的完整映射，后者是业务页面中业务对象的代码映射。

dao或者mapper，是定义业务行为（行为返回或入参可能是vo、po、entity），并在mybatis配置中有对应的mapper配置——某个sql语句及返回。

service是基于dao、mapper们组织复杂业务逻辑的，在博客里暂时没有体现。

controller是完成访问url和service的中转的。

### 业务逻辑
没什么难的地方，就是数据的增删改查。



### 引入数据库连接池
原因，页面上的每一次mysql语句的执行都会新建连接、断开连接，性能不得行。

sqlsession，https://www.jianshu.com/p/5a72006e7779

### druid中优化
```
SELECT C.id, C.name
FROM category C
	LEFT JOIN blog.article_category AC ON C.id = AC.category_id
WHERE AC.article_id = ?;
```
这一句执行的次数过多，大概是其他的6倍。

mybatis的一对多和多对一等场景，https://www.cnblogs.com/jimisun/p/9414148.html

可以解决上述问题。


## 前端页面
对应业务，结合后端业务逻辑，先编写简单的博客访问用户的几个页面。基本套路是Model 传参，前端用thymeleaf接住后显示。没有什么太深的难度，甚至thymeleaf提供的语句能在前端操控后端的对象。

- themleaf相关配置
- semantic-UI 资源
- 模仿UI样式写界面
  写的过程中对semantic UI 对前端样式的布局控制、样式等还是不能完全把握，秉着先出东西再优化的原则把界面码出来。

在纯码前端过程中坚持：抛开后台页面也可以预览查看效果。


# 印象深的几个问题
## Spring框架

真的是框架，什么都封装好了，比如request相关的，直接注入，取就好了。用的还不太熟，只知道牛逼。

可大致的概括为，web服务的模型都被具象到了spring框架中，但凡能想到的，它都有解决方案，唯一的问题是自己知不知道了。

还有个拦截器，很厉害。目前还说不出太多。

## 搜索传多个值

一开始管理后台，标题+多个分类查询，没有搞定，后来改成标题+一个分类（其中任一空）。

```xml
<!--查询文章
    这里复杂的where条件，需要包裹在where标签下，不然都执行一遍
    -->
    <select id="searchBlogByCategoryIdAndTitle" resultType="tech.windanchaos.blog.entity.ArticleDes"
            parameterType="tech.windanchaos.blog.entity.SearchBody">
        select A.id, A.title, A.author, A.des, A.create_time,A.published
        from article AS A
        <where>
            1=1
            <if test="title">
                <bind name="pattern" value="'%' + title + '%'"/>
                <choose>
                    <when test="categoryId != null">
                        and A.title like #{pattern} and A.id in (select AC.article_id from article_category as AC where A.id
                        = AC.article_id and AC.category_id=#{categoryId})
                    </when>
                    <otherwise>
                        and A.title like #{pattern}
                    </otherwise>
                </choose>
            </if>
            <if test="!title" >
                <choose>
                    <when test="categoryId != null">
                        and A.id in (select AC.article_id from article_category as AC where A.id = AC.article_id
                        and AC.category_id=#{categoryId})
                    </when>
                    <otherwise>

                    </otherwise>
                </choose>
            </if>
            ;
        </where>

    </select>
```



## mybatis中几个套路

- 上面是一种。

- 获取插入数据的id。

  ```xml
  <insert id="insertArticle" parameterType="tech.windanchaos.blog.entity.Article">
          <selectKey keyProperty="id" order="AFTER" resultType="java.lang.Long">
              SELECT LAST_INSERT_ID()
          </selectKey>
          insert into article (title,author,des,content,create_time,published)
          value
          (#{title},#{author},#{des},#{content},#{create_time},#{published});
      </insert>
  ```

  

- 循环插入

  ```xml
  <!--在insert标签中，加入keyProperty和useGeneratedKeys两个属性-->
      <insert id="insertArticleCategory">
          <if test="cIds !=null">
          insert into article_category (article_id, category_id)
          values
              <foreach collection="cIds" item="cId" index="index"
                       separator="," close=";">
                 (#{id},#{cId})
              </foreach>
          </if>
  
      </insert>
  ```

  ​    



## 静态资源预览

代码调试过程中看不到静态资源，得在前端页面中引用（等于要引用2次，模板的一次，本地的一次）。

## 节省几个页面

我采用了模板的判定逻辑，在能省页面的地方，极致的节省页面（相对教程），所以很多逻辑都在一个页面不同的div下，这是我一个比较自豪的点吧。

## 不足

- 对象之间参数传递用对象还不是很流畅，或者说还有点模糊。

- 性能问题，模板是实时渲染的，在碰到并发的时候，耗资源是一定的。可以把渲染的页面缓存起来，也可以前后端分离后再优化

- 美观和周边缺失

  

# 下一步计划

## 缓存
redis加缓存

https://www.bilibili.com/video/BV1zK411F7gw?p=37 

https://www.bilibili.com/video/BV1zK411F7gw?p=38

## VUE前后端分离

## 分拆业务

现在是集中在一起的，看起来并不规范。

## 丰富周边

- 文章导航
- 个人介绍
- 添加拦截器
