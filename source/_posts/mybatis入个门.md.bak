---
title: mybatis入个门
date: 2020-04-16 20:18:04
category:
    - 后端框架和技术
---

# MyBatis

ORMapping: Object Relationship Mapping 对象关系映射的一种流行框架。相同技术还有Hibernate。两者对比，可参考：https://www.cnblogs.com/javacatalina/p/6590321.html

ORMapping是Java 到 MySQL 的映射，开发者可以以面面向对象的思想来管理理数据库。

# 使用套路

## 两种使用方式

- **mybatis原生方式**
- **mybatis动态代理**

两者的区别是在获取到sqlsession链接后，操作对象的动作差异。下面举例原生的方式。之后默认用的动态代理。

```java
// statement是mapper中的‘namespace.方法’
String statement = "com.chaosbom.mapper.AccoutMapper.save";
Account account = new Account(1L,"张三","123123",22);
sqlSession.insert(statement,account);
```

mapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.chaosbom.mapper.AccoutMapper">
<insert id="save" parameterType="com.chaosbom.entity.Account">
insert into t_account(username,password,age) values(#{username},#
{password},#{age})
</insert>
</mapper>
```

## 实体对象和表

实体对象是mysql中表字段对应到java的类，通常在代码框架中被叫做entity。下面分别展示了java类和表结构。

<!-- more -->
```java
package com.chaosbom.entity;
import lombok.Data;
@Data
public class Account {
    private int id;
    private String username;
    private String password;
    private int age;
    public Account(String username,String password,int age){
        this.username=username;
        this.password=password;
        this.age=age;
    }
    public Account(int id,String username,String password,int age){
        this.id=id;
        this.username=username;
        this.password=password;
        this.age=age;
    }
}

```

```mysql
create table t_account(
id int primary key auto_increment,
username varchar(11),
password varchar(11),
age int
)
```

## 套路概述

本小节是总体认知。

各种mapper被配置到mybatis的配置文件 ---> mybatis的xml配置文件 ---> 被加载到SqlSession ---> 提供各种mapper的对象，对象的行为等于操作数据库动作。

## 1自定义接口

AccountRepository.java 是定义entity实体行为的接口，行为的实现在对应的mapper中实现，方法名对应map中的id。

```java
package com.chaosbom.repository;
import com.chaosbom.entity.Account;
import java.util.List;
public interface AccountRepository {
    int save(Account account);
    int update(Account account);
    int deleteByID(long id);
    List<Account> findAll();
    Account findByID(long id);
}
```



## 2定义mapper

参考AccountRepository.xml中的内容。

创建接口口对应的 Mapper.xml,定义接口口方方法对应的 SQL 语句句。

MyBatis 框架会根据规则自自动创建接口口实现类的代理理对象。
规则:

- Mapper.xml 中 namespace 为接口口的全类名。
- Mapper.xml 中 statement 的 id 为接口口中对应的方方法名。
- Mapper.xml 中 statement 的 parameterType 和接口口中对应方方法的参数类型一一致。
- Mapper.xml 中 statement 的 resultType 和接口口中对应方方法的返回值类型一一致。

mapper是定义了被映射对象行为的文件。AccountRepository.xml（mapper）的内容

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.chaosbom.repository.AccountRepository">
    <insert id="save" parameterType="com.chaosbom.entity.Account">
        insert into t_account(username,password,age) values (#{username},#{password},#{age})
    </insert>
    <update id="update" parameterType="com.chaosbom.entity.Account">
        update t_account set username=#{username},password=#{password},age=#{age} where id=#{id}
    </update>
    <delete id="delete" parameterType="long">
        delete from t_account where id=#{id}
    </delete>
    <select id="findAll" resultType="com.chaosbom.entity.Account">
        select * from t_account
    </select>
    <select id="findById" parameterType="long"
            resultType="com.chaosbom.entity.Account">
    select * from t_account where id = #{id}
    </select>
</mapper>
```

**mapper中的方法标签**：

- namespace 通常设置为文文件所在包+文文件名的形式。
- insert 标签表示执行行行添加操作。
- select 标签表示执行行行查询操作。
- update 标签表示执行行行更更新操作。
- delete 标签表示执行行行删除操作。
- id 是实际调用用 MyBatis 方方法时需要用用到的参数。
- parameterType 是调用用对应方方法时参数的数据类型。
- resultType是返回结果类型

## 3mybastisconfig中引用mapper配置

mybatisConfig.xml 是mybatis的配置文件。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <!-- 打印SQL-->
        <setting name="logImpl" value="STDOUT_LOGGING" />
    </settings>
    <environments default="dev">
        <environment id="dev">
            <!-- 配置jdbc事务管理-->
            <transactionManager type="JDBC"></transactionManager>
            <!-- 数据库连接池-->
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3307/repeater?useUnicode=true&amp;characterEncoding=UTF-8"/>
                <property name="username" value="root"/>
                <property name="password" value="miang521"/>
            </dataSource>
        </environment>
    </environments>
    <!-- 注册各种mapper.xml -->
    <mappers>
        <mapper resource="com/chaosbom/repository/AccountRepository.xml"></mapper>
    </mappers>
</configuration>
```

## 4调用用接口口的代理理对象完成相关的业务操作

下面展示一个启动的java类

```java
package com.chaosbom;

import com.chaosbom.entity.Account;
import com.chaosbom.entity.Student;
import com.chaosbom.repository.AccountRepository;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.InputStream;
import java.util.List;

public class MybatisProxyTest {
    public static void main(String[] args) {
        InputStream inputStream=MybatisProxyTest.class.getClassLoader().getResourceAsStream("mybatisConfig.xml");
        //下面三行代码是使用mybatis的标准套路，先定义builder，builder读取配置，生成工厂，工厂提供db的链接
        SqlSessionFactoryBuilder builder=new SqlSessionFactoryBuilder();
        SqlSessionFactory factory=builder.build(inputStream);
        SqlSession session=factory.openSession();
        //获取接口的代理对象，动态代理
        AccountRepository repository=session.getMapper(AccountRepository.class);
        //findAll()方法是mapper中定义的，id=findAll
        List<Account> reslut=repository.findAll();
        for(Account account:reslut){
            System.out.println(account.toString());
        }
        session.close();
    }
}

```

# 解决连接查询

主要解决关联查询结果中字段的关系。mybatis是面向查询结果集来的。所以，可以是下面这种形式。主要在resultMap中搞定。

某mapper.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.chaosbom.repository.CustomerRepository">
    <resultMap id="customerMap" type="com.chaosbom.entity.Customer">
        <id column="id" property="id"></id>
        <result column="name" property="name"></result>
        <collection property="goods" ofType="com.chaosbom.entity.Goods">
            <id column="gid" property="id"></id>
            <result column="gname" property="name"></result>
        </collection>
    </resultMap>
    <resultMap id="studentMap" type="com.chaosbom.entity.Student">
        <id column="id" property="id"></id>
        <result column="name" property="name"></result>
        <association property="classes" javaType="com.chaosbom.entity.Classes">
            <id column="cid" property="id"></id>
            <result column="cname" property="name"></result>
        </association>
    </resultMap>
    <select id="findCusGoodsByID" resultType="com.chaosbom.entity.Customer" parameterType="int" resultMap="customerMap">
        select c.id,c.name,g.id as gid,g.name as gname from t_consumer as c,t_consumer_goods as cg,t_goods as g where cg.cid=c.id and cg.gid=g.id and c.id=#{id};
    </select>
        <select id="findByID" resultType="com.chaosbom.entity.Student" parameterType="int" resultMap="studentMap">
        select s.id,s.name,c.id as cid,c.name as cname from t_student as s ,t_classes as c where s.id=#{id} and s.cid=c.id
    </select>
</mapper>
```

# mybatis逆向工程

mybatis需要程序员自己编写sql语句，mybatis官方提供逆向工程，可以针对***\*单表\****自动生成mybatis执行所需要的代码（mapper.java、mapper.xml、pojo…），可以让程序员将更多的精力放在繁杂的业务逻辑上。

企业实际开发中，常用的逆向工程方式：由数据库的表生成java代码。逆向可以做成固定代码，直接用即可。这里不啰嗦了。

https://blog.csdn.net/qq_39056805/article/details/80585941

# mybatis延迟加载

延迟加载也叫懒加载、惰性加载,使用用延迟加载可以提高高程序的运行行行效率,针对于数据持久层的操作,
在某些特定的情况下去访问特定的数据库,在其他情况下可以不不访问某些表,从一一定程度上减少了了 Java
应用用与数据库的交互次数。

查询学生生和班级的时,学生生和班级是两张不不同的表,如果当前需求只需要获取学生生的信息,那么查询学
生生单表即可,如果需要通过学生生获取对应的班级信息,则必须查询两张表。

不不同的业务需求,需要查询不不同的表,根据具体的业务需求来动态减少数据表查询的工作就是延迟加
载。

# mybatis缓存

## 为什么加缓存

使用用缓存可以减少 Java 应用用与数据库的交互次数,从而而提升程序的运行行行效率。比比如查询出 id = 1 的对

象,第一一次查询出之后会自自动将该对象保存到缓存中,当下一一次查询时,直接从缓存中取出对象即可,无无需再次

访问数据库。

## mybatis缓存分类

### 一级缓存

SqlSession级别，默认开启，并且不能关闭。

SqlSession对象中维护这一个HashMap用于储存换出数据，线程隔离。不同的SqlSession 之间缓存数据区域是互相不不影响。

如果 SqlSession 执行行行了了 DML 操作(insert、update、delete),MyBatis 必须将缓存清空以保证数据的准确。

### 二级缓存

Mapper级别，默认关闭，可以开启。

多个sqlsession使用同一个mapper的sql语句操作数据库，得到的数据会存在二级换出区，同样使用的是HashMap存储，线程共享。二级缓存的作用域是mapper下的同一个namespace。二级缓存优先级高于一级缓存。

config中开启

```xml
<settings>
<!-- 打印SQL-->
<setting name="logImpl" value="STDOUT_LOGGING" />
<!-- 开启延迟加载 -->
<setting name="lazyLoadingEnabled" value="true"/>
<!-- 开启二级缓存 -->
<setting name="cacheEnabled" value="true"/>
</settings>
```



mapper中配置二级缓存

```xml
<cache type="org.mybatis.caches.ehcache.EhcacheCache">
<!-- 缓存创建之后,最后一一次访问缓存的时间至至缓存失效的时间间隔 -->
<property name="timeToIdleSeconds" value="3600"/>
<!-- 缓存自自创建时间起至至失效的时间间隔 -->
<property name="timeToLiveSeconds" value="3600"/>
<!-- 缓存回收策略略,LRU表示移除近期使用用最少的对象 -->
<property name="memoryStoreEvictionPolicy" value="LRU"/>
</cache>
```

## 二级缓存的问题

高并发下，缓存机制带来的脏读问题。

# mybatis动态SQL

使用用动态 SQL 可简化代码的开发,减少开发者的工工作量量,程序可以自自动根据业务参数来决定 SQL 的组
成。动态sql是在mapper中添加不同标签来实现。

- if标签

- where标签

- choose、when标签

- trim标签

- set标签

- foreach标签

  一个例子，其他的用法用时再细纠。

  ```xml
  <select id="findByAccount" parameterType="com.southwind.entity.Account"
  resultType="com.southwind.entity.Account">
  select * from t_account
      <where>
          <if test="id!=0">
          id = #{id}
          </if>
          <if test="username!=null">
          and username = #{username}
          </if>
          <if test="password!=null">
          and password = #{password}
          </if>
          <if test="age!=0">
          and age = #{age}
          </if>
      </where>
  </select>
  ```

  

# 有价值的链接

- ## [Mybatis mapper动态代理的原理详解](https://www.cnblogs.com/hopeofthevillage/p/11384848.html)

- [mybatis 缓存的使用， 看这篇就够了](https://blog.csdn.net/weixin_37139197/article/details/82908377)

- [MyBatis源码解析】MyBatis一二级缓存](https://www.cnblogs.com/xrq730/p/6991655.html)

  
