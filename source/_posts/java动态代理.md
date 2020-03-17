---
title: java动态代理
date: 2020-03-16 16:04:35
category:
	- Java编程语言
---



本文是学习Spring框架的副产品。Spring中的AOP涉及动态代理的原理。

# 什么是代理

定义：给目标对象提供一个代理对象，并由代理对象控制对目标对象的引用；

目的：

- 通过引入代理对象的方式来间接访问目标对象，以防止直接访问目标对象给系统带来的不必要的复杂性；
- 通过代理对象对原有业务进行增强



# 代理设计模式

https://www.runoob.com/design-pattern/proxy-pattern.html

静态代理不能解决代码冗余的问题。一般不推荐静态代理（代理的关系用代码直接定义，代理和被代理需要有相同的接口，被代理作为代理对象的成员变量）。

# jdk机制的动态代理

**动态代理有以下特点:**

- 代理对象，不需要实现接口
- 代理对象的生成，是利用JDK的API，动态的在内存中构建代理对象(需要我们指定创建代理对象/目标对象实现的接口的类型)

**动态代理的实现方案**

- jdk代理，通过和目标实现相同接口保证功能一致
- cglib代理（第三方cglib库中的一套api），通过继承保证功能一致

主要涉及：

```java
// 静态方法
static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces,InvocationHandler h )
// 接口
public interface InvocationHandler {....}
```

基本思路是使用上面的方法，动态生成代理对象。

```java
public class ProxyDemo {
    @Test
    public void proxy(){
        //动态代理搭建
        //目标对象
        final UserService userService=new UserServiceImpl();
        InvocationHandler handler=new InvocationHandler() {
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                //额外功能
                System.out.println("代理增加的额外功能，在执行前");
                method.invoke(userService,args);
                System.out.println("代理增加的额外功能，在执行后");
                return null;
            }
        };

        UserService proxy = (UserService)Proxy.newProxyInstance(ProxyDemo.class.getClassLoader(), userService.getClass().getInterfaces(), handler);
        proxy.queryOne(1);
        proxy.insertUser(new User());
    }

```





# Spring动态代理实现AOP

AspectJ 是Spring集成的一个AOP框架。

spring的aop套路：

- 目标类
- 代理类，implement advice的各中AOP接口
- spring配置中增加aop的命名空间和xsi:location
- spring配置中编织代理关系，构建一个动态的代理类。

下面代码演示了，代理前、代理后、环绕代理。

aopContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                           http://www.springframework.org/schema/aop  http://www.springframework.org/schema/aop/spring-aop.xsd">
    <!--目标bean-->
    <bean id="userServervice" class="aop.service.UserServiceImpl"></bean>
    <!-- 额外功能advices-->
    <bean id="myadvice" class="aop.springAOP.MybeforAdvice"></bean>
    <bean id="myafteradvice" class="aop.springAOP.MyafterAdvice"></bean>
    <bean id="myinterceptor" class="aop.springAOP.MymethodInterceptor"></bean>
    <!--编织
    通过目标信息，额外功能信息，组建一个新的Proxy
    -->
    <aop:config>
        <!--
		定义切入点
        execution表达式：（修饰符、返回值、包类方法名(参数)）
        execution(public Integer com.......*(Integer,String))
        -->
        <aop:pointcut id="before" expression="execution(* aop.springAOP.*(..))"/>
        <!--切入点行为和切入点的功能编织-->
        <aop:advisor advice-ref="myadvice" pointcut-ref="before"></aop:advisor>
        <aop:advisor advice-ref="myafteradvice" pointcut-ref="before"></aop:advisor>
        <aop:advisor advice-ref="myinterceptor" pointcut-ref="before"></aop:advisor>
    </aop:config>
</beans>
```

接口及其实现类

```java
package aop.service;

import aop.pojo.User;

public interface UserService {
    Integer insertUser(User user);
    User queryOne(Integer id);

}
```

```java
package aop.service;

import aop.pojo.User;

public class UserServiceImpl implements UserService {
    @Override
    public Integer insertUser(User user) {
        //System.out.println("额外功能");
        System.out.println("insertUser 核心功能");
        return 4;
    }

    @Override
    public User queryOne(Integer id) {
        //System.out.println("额外功能");
        System.out.println("queryOne 核心功能");
        return new User();
    }
}

```

测试类。

```java
package aop.springAOP;

import aop.service.UserService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class aopTest {
    @Test
    public void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("aopContext.xml");
        UserService service = (UserService)context.getBean("userServervice");
        service.queryOne(3);
        System.out.println(service.getClass());
    }
}

```

小结：spring的aop，在xml中完成切入点的定义，核心逻辑是expression表达式。凡是符合表达式的bean方法，都可以被当做切入点。而切入点的行为，是通过关联切入点和切入点行为的bean（实现了advice）来编织的。



