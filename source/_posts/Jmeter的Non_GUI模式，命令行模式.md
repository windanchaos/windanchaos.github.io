---
title: Jmeter的Non_GUI模式，命令行模式
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 性能测试

date: 2017-11-17 10:28:52
---
For load testing, you must run JMeter in this mode (Without the GUI) to get the optimal results from it. To do so, use the following command options:
-n This specifies JMeter is to run in non-gui mode -t [name of JMX file that contains the Test Plan]. -l [name of JTL file to log sample results to]. -j [name of JMeter run log file]. -r Run the test in the servers specified by the JMeter property " remote_hosts" -R [list of remote servers] Run the test in the specified remote servers -g [path to CSV file] generate report dashboard only -e generate report dashboard after load test -o output folder where to generate the report dashboard after load test. Folder must not exist or be empty

The script also lets you specify the optional firewall/proxy server information:

-H [proxy server hostname or ip address] -P [proxy server port]

**Example**

```js 
jmeter -n -t my_test.jmx -l log.jtl -H my.proxy.server -P 8000
```

If the property jmeterengine.stopfail.system.exit is set to true (default is false), then JMeter will invoke System.exit(1) if it cannot stop all threads. Normally this is not necessary.

reference:
[http://jmeter.apache.org/usermanual/get-started.html/#running](http://jmeter.apache.org/usermanual/get-started.html#running)