---
title: Appium的实现理解
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2018-07-21 11:54:10
---
本文转自：[TesterHome的文章](https://testerhome.com/topics/7352)

本文针对appium(version:1.6.4-beta)「比较粗糙」的介绍了下它的源码的实现流程。难免有不妥支出，有任何问题，可直接沟通交流。
（本文中没有相应的测试）

## Appium的架构

[](https://myersguo.github.io/public/appium-packages.png)
![appium](https://windanchaos.github.io/images/thub.io-public-appium-packages-.png)
[](https://myersguo.github.io/publichttps://windanchaos.github.io/images/appium_ios.png)

![appium](https://windanchaos.github.io/images/thub.io-public-images-appium_ios-.png)
[](https://myersguo.github.io/publichttps://windanchaos.github.io/images/apium_android.png)

![appium](https://windanchaos.github.io/images/thub.io-public-images-apium_android-.png)

下载appium的源码，并安装依赖：
```js 
git clone https://github.com/appium/appium.git
npm install
```

启动appium:

```js 
node .
```

这个启动命令实际是执行的：

```js 
node build\main.js
```
(package.json中指定了main入口)：
```js 
...
 "main": "./build/lib/main.js",
<!-- more -->
  "bin": {
    "appium": "./build/lib/main.js"
  },
...
```

/build/main.js是由/lib/main.js经babel翻译后的结果，所以，我们来看下/lib/main.js来理解appium的流程。
(备注：由于appium源码执行都是执行的编译后的方法，即build目录下，因此如果你想要调试进行测试，需要在各个模块build目录下更改调试,如果更改源码，需要gulp transpile进行编译)

[](https://myersguo.github.io/publichttps://windanchaos.github.io/images/appium_uml.png)
![appium uml](https://windanchaos.github.io/images/thub.io-public-images-appium_uml-.png)

appium server端实现了HTTP REST API接口，将client端发来的API请求，解析，发送给执行端。apium server,以及其他的driver（android,ios）都实现了basedriver类。basedriver定义了session的创建，命令的执行方式(cmd执行)。

appium server(appium driver)大致的流程为：

我们看一下[appium server的源码](https://github.com/appium/appium/blob/master/lib/main.js)实现。
```js 
import { server as baseServer } from 'appium-base-driver';
import getAppiumRouter from './appium';
...

async function main (args = null) {
  //解析参数
  let parser = getParser();
  let throwInsteadOfExit = false;
  if (args) {
    args = Object.assign({}, getDefaultArgs(), args);
    if (args.throwInsteadOfExit) {
      throwInsteadOfExit = true;
      delete args.throwInsteadOfExit;
    }
  } else {
    args = parser.parseArgs();
  }
  await logsinkInit(args);
  await preflightChecks(parser, args, throwInsteadOfExit);
  //输出欢迎信息
  await logStartupInfo(parser, args);
  //注册接口路由,参见(appium-base-driver\lib\jsonwp\Mjsonwp.js)
  let router = getAppiumRouter(args);
  //express server类(appium-base-driver\lib\express\server.js)
  //将注册的路由，传递给express注册.
  let server = await baseServer(router, args.port, args.address);
  try {
    //是否为appium grid的node节点
    if (args.nodeconfig !== null) {
      await registerNode(args.nodeconfig, args.address, args.port);
    }
  } catch (err) {
    await server.close();
    throw err;
  }

  process.once('SIGINT', async function () {
    logger.info(`Received SIGINT - shutting down`);
    await server.close();
  });

  process.once('SIGTERM', async function () {
    logger.info(`Received SIGTERM - shutting down`);
    await server.close();
  });

  logServerPort(args.address, args.port);

  return server;
}
...
//路由
//appium.js,下面会讲解路由解析
function getAppiumRouter (args) {
  let appium = new AppiumDriver(args);
  return routeConfiguringFunction(appium);
}
```

#### URL路由解析

上面说道，路由注册。所有支持的请求都[METHOD_MAP](https://github.com/appium/appium-base-driver/blob/master/lib/mjsonwp/routes.js)这个全局变量里面。它是一个path:commd的对象集合。路由执行过程是：

我们来详细看一下(routeConfiguringFunction)到底做了什么(appium-base-driver\lib\mjsonwp\Mjsonwp.js):
```js 
function routeConfiguringFunction (driver) {
  if (!driver.sessionExists) {
    throw new Error('Drivers used with MJSONWP must implement `sessionExists`');
  }
  if (!(driver.executeCommand || driver.execute)) {
    throw new Error('Drivers used with MJSONWP must implement `executeCommand` or `execute`');
  }
  // return a function which will add all the routes to the driver
  return function (app) {
    //[METHOD_MAP](#route_config),是所有的路由配置,key为path,value为method的数组
   //对METHOD_MAP的配置进行绑定
    for (let [path, methods] of _.toPairs(METHOD_MAP)) {
      for (let [method, spec] of _.toPairs(methods)) {
        // set up the express route handler
        buildHandler(app, method, path, spec, driver, isSessionCommand(spec.command));
      }
    }
  };
}
//路由绑定
//示例：
/*
  '/wd/hub/session': {
    POST: {command: 'createSession', payloadParams: {required: ['desiredCapabilities'], optional: ['requiredCapabilities', 'capabilities']}}
  },
即:
method: POST
path: /wd/hub/session
spec: array
driver: appium
*/
function buildHandler (app, method, path, spec, driver, isSessCmd) {
  let asyncHandler = async (req, res) => {
    let jsonObj = req.body;
    let httpResBody = {};
    let httpStatus = 200;
    let newSessionId;
    try {
      //判断是否是创建session命令(包含createSession,getStatus,getSessions) 
      //是否有session
      if (isSessCmd && !driver.sessionExists(req.params.sessionId)) {
        throw new errors.NoSuchDriverError();
      }
      //设置了代理则透传
      if (isSessCmd && driverShouldDoJwpProxy(driver, req, spec.command)) {
        await doJwpProxy(driver, req, res);
        return;
      }
      //命令是否支持
      if (!spec.command) {
        throw new errors.NotImplementedError();
      }
      //POST参数检查 
      if (spec.payloadParams && spec.payloadParams.wrap) {
        jsonObj = wrapParams(spec.payloadParams, jsonObj);
      }
      if (spec.payloadParams && spec.payloadParams.unwrap) {
        jsonObj = unwrapParams(spec.payloadParams, jsonObj);
      }
      checkParams(spec.payloadParams, jsonObj);
      //构造参数
      let args = makeArgs(req.params, jsonObj, spec.payloadParams || []);
      let driverRes;
      if (validators[spec.command]) {
        validators[spec.command](...args);
      }
      //!!!!执行命令
      //捕获返回值
      if (driver.executeCommand) {
        driverRes = await driver.executeCommand(spec.command, ...args);
      } else {
        driverRes = await driver.execute(spec.command, ...args);
      }

      // unpack createSession response
      if (spec.command === 'createSession') {
        newSessionId = driverRes[0];
        driverRes = driverRes[1];
      }
      ...
    } catch (err) {
      [httpStatus, httpResBody] = getResponseForJsonwpError(actualErr);
    }
    if (_.isString(httpResBody)) {
      res.status(httpStatus).send(httpResBody);
    } else {
      if (newSessionId) {
        httpResBody.sessionId = newSessionId;
      } else {
        httpResBody.sessionId = req.params.sessionId || null;
      }

      res.status(httpStatus).json(httpResBody);
    }
  };
  // add the method to the app
  app[method.toLowerCase()](path, (req, res) => {
    B.resolve(asyncHandler(req, res)).done();
  });
}
```

[lib\appium.js](https://github.com/appium/appium/blob/master/lib/appium.js)

上面说了

```js 
appium server
```
已经启动了，第一件事情，当然是创建***session***,然后把command交给这个session的不同driver去执行了。
appium先根据caps进行session创建（

```js 
getDriverForCaps
```
）,然后保存InnerDriver到当前session,以后每次执行命令(executeDCommand)会判断是否为appiumdriver的命令，不是则转给相应的driver去执行命令(android,ios等)。
```js 
async createSession (caps, reqCaps) {
  caps = _.defaults(_.clone(caps), this.args.defaultCapabilities);
  let InnerDriver = this.getDriverForCaps(caps);
  this.printNewSessionAnnouncement(InnerDriver, caps);

  if (this.args.sessionOverride && !!this.sessions && _.keys(this.sessions).length > 0) {
    for (let id of _.keys(this.sessions)) {
      log.info(`    Deleting session '${id}'`);
      try {
        await this.deleteSession(id);
      } catch (ign) {
      }
    }
  }

  let curSessions;
  try {
    curSessions = this.curSessionDataForDriver(InnerDriver);
  } catch (e) {
    throw new errors.SessionNotCreatedError(e.message);
  }

  let d = new InnerDriver(this.args);
  let [innerSessionId, dCaps] = await d.createSession(caps, reqCaps, curSessions);
  this.sessions[innerSessionId] = d;
  this.attachUnexpectedShutdownHandler(d, innerSessionId);
  d.startNewCommandTimeout();

  return [innerSessionId, dCaps];
}
  async executeCommand (cmd, ...args) {
  if (isAppiumDriverCommand(cmd)) {
    return super.executeCommand(cmd, ...args);
  }

  let sessionId = args[args.length - 1];
  return this.sessions[sessionId].executeCommand(cmd, ...args);
}
```

在basedriver中

```js 
executeDCommand
```
其实是调用类的

```js 
cmd
```
定义的方法。

我们以

```js 
uiautomator2
```
(\appium-uiautomator2-driver\build\lib)为例看一下它的

```js 
cmd
```
执行情况。

以

```js 
getAttribute
```
(appium-uiautomator2-driver\lib\commands\element.js)为例说明：
```js 
commands.getAttribute = async function (attribute, elementId) {
  return await this.uiautomator2.jwproxy.command(`/element/${elementId}/attribute/${attribute}`, 'GET', {});
};
```

***appium 通过adb forward将主机的HTTP请求转发到设备中***

```js 
await this.adb.forwardPort(this.opts.systemPort, DEVICE_PORT);
//主机端口号:8200,8299
//设备端口号：6790
```
