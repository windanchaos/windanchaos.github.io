---
title: Appium_Python_Api
author: windanchaos
tags: 
       - FromCSDN

category: 
       - 自动化测试

date: 2017-09-27 23:54:22
---
本文转自[TesterHome](https://testerhome.com/topics/3711)《**Appium_Python_Api文档**》

**1.contexts**
contexts(self):
```js 
Returns the contexts within the current session.
    返回当前会话中的上下文，使用后可以识别H5页面的控件

    :Usage:
        driver.contexts
用法 driver.contexts
```

**2. current_context**
current_context(self):

```js 
Returns the current context of the current session.
    返回当前会话的当前上下文
    :Usage:
        driver.current_context
用法driver. current_context
```

**3. context**
context(self):

```js 
Returns the current context of the current session.
    返回当前会话的当前上下文。
    :Usage:
        driver.context
用法driver. Context
```

**4. find_element_by_ios_uiautomation**
find_element_by_ios_uiautomation(self, uia_string):
<!-- more -->

```js 
Finds an element by uiautomation in iOS.
    通过iOS uiautomation查找元素
    :Args:
     - uia_string - The element name in the iOS UIAutomation library

    :Usage:
        driver.find_element_by_ios_uiautomation('.elements()[1].cells()[2]')
用法dr. find_element_by_ios_uiautomation(‘elements’)
```

**5. find_element_by_accessibility_id**
find_element_by_accessibility_id(self, id):

```js 
Finds an element by accessibility id.
    通过accessibility id查找元素
    :Args:
     - id - a string corresponding to a recursive element search using the
     Id/Name that the native Accessibility options utilize

    :Usage:
        driver.find_element_by_accessibility_id()
用法driver.find_element_by_accessibility_id(‘id’)
```

**6.scroll**
scroll(self, origin_el, destination_el):

```js 
Scrolls from one element to another
    从元素origin_el滚动至元素destination_el
    :Args:
     - originalEl - the element from which to being scrolling
     - destinationEl - the element to scroll to

    :Usage:
        driver.scroll(el1, el2)
用法 driver.scroll(el1,el2)
```

**7. drag_and_drop**
drag_and_drop(self, origin_el, destination_el):

```js 
Drag the origin element to the destination element
    将元素origin_el拖到目标元素destination_el
    :Args:
     - originEl - the element to drag
     - destinationEl - the element to drag to
用法 driver.drag_and_drop(el1,el2)
```

**8.tap**
tap(self, positions, duration=None):

```js 
Taps on an particular place with up to five fingers, holding for a certain time
模拟手指点击（最多五个手指），可设置按住时间长度（毫秒）

    :Args:
     - positions - an array of tuples representing the x/y coordinates of
     the fingers to tap. Length can be up to five.
     - duration - (optional) length of time to tap, in ms

    :Usage:
        driver.tap([(100, 20), (100, 60), (100, 100)], 500)
用法 driver.tap([(x,y),(x1,y1)],500)
```

**9. swipe**
swipe(self, start_x, start_y, end_x, end_y, duration=None):

```js 
Swipe from one point to another point, for an optional duration.
    从A点滑动至B点，滑动时间为毫秒
    :Args:
     - start_x - x-coordinate at which to start
     - start_y - y-coordinate at which to start
     - end_x - x-coordinate at which to stop
     - end_y - y-coordinate at which to stop
     - duration - (optional) time to take the swipe, in ms.

    :Usage:
        driver.swipe(100, 100, 100, 400)
用法 driver.swipe(x1,y1,x2,y2,500)
```

**10.flick**
flick(self, start_x, start_y, end_x, end_y):

```js 
Flick from one point to another point.
    按住A点后快速滑动至B点
    :Args:
     - start_x - x-coordinate at which to start
     - start_y - y-coordinate at which to start
     - end_x - x-coordinate at which to stop
     - end_y - y-coordinate at which to stop

    :Usage:
        driver.flick(100, 100, 100, 400)
```

用法 driver.flick(x1,y1,x2,y2)
**11.pinch**
pinch(self, element=None, percent=200, steps=50):

```js 
Pinch on an element a certain amount
    在元素上执行模拟双指捏（缩小操作）
    :Args:
     - element - the element to pinch
     - percent - (optional) amount to pinch. Defaults to 200%
     - steps - (optional) number of steps in the pinch action

    :Usage:
        driver.pinch(element)
```

用法 driver.pinch(element)
**12.zoom**
zoom(self, element=None, percent=200, steps=50):

```js 
Zooms in on an element a certain amount
    在元素上执行放大操作
    :Args:
     - element - the element to zoom
     - percent - (optional) amount to zoom. Defaults to 200%
     - steps - (optional) number of steps in the zoom action

    :Usage:
        driver.zoom(element)
```

用法 driver.zoom(element)
**13.reset**
reset(self):

```js 
Resets the current application on the device.
重置应用(类似删除应用数据)
用法 driver.reset()
```

**14. hide_keyboard**
hide_keyboard(self, key_name=None, key=None, strategy=None):

```js 
Hides the software keyboard on the device. In iOS, use `key_name` to press a particular key, or `strategy`. In Android, no parameters are used.
    隐藏键盘,iOS使用key_name隐藏，安卓不使用参数

    :Args:
     - key_name - key to press
     - strategy - strategy for closing the keyboard (e.g., `tapOutside`)
driver.hide_keyboard()
```

**15. keyevent**
keyevent(self, keycode, metastate=None):

```js 
Sends a keycode to the device. Android only. Possible keycodes can be found in http://developer.android.com/reference/android/view/KeyEvent.html.
    发送按键码（安卓仅有），按键码可以上网址中找到
    :Args:
     - keycode - the keycode to be sent to the device
     - metastate - meta information about the keycode being sent
用法 dr.keyevent(‘4’)
```

**16. press_keycode**
press_keycode(self, keycode, metastate=None):

```js 
Sends a keycode to the device. Android only. Possible keycodes can be found in http://developer.android.com/reference/android/view/KeyEvent.html.
    发送按键码（安卓仅有），按键码可以上网址中找到

    :Args:
     - keycode - the keycode to be sent to the device
     - metastate - meta information about the keycode being sent
用法 driver.press_ keycode(‘4’)
```

dr.keyevent(‘4’)与driver.press_ keycode(‘4’) 功能实现上一样的，都是按了返回键
**17. long_press_keycode**
long_press_keycode(self, keycode, metastate=None):

```js 
Sends a long press of keycode to the device. Android only. Possible keycodes can be
    found in http://developer.android.com/reference/android/view/KeyEvent.html.
    发送一个长按的按键码（长按某键）
   详细的按键代码见这里  http://developer.android.com/reference/android/view/KeyEvent.html.

    :Args:
     - keycode - the keycode to be sent to the device
     - metastate - meta information about the keycode being sent
 用法 driver.long_press_keycode(4)  谢谢@t880216t童鞋反馈
```

**18.current_activity**
current_activity(self):

```js 
Retrieves the current activity on the device.
获取当前的activity
用法 print(driver.current_activity)
```

**19. wait_activity**
wait_activity(self, activity, timeout, interval=1):

```js 
Wait for an activity: block until target activity presents or time out.
    This is an Android-only method.
    等待指定的activity出现直到超时，interval为扫描间隔1秒
即每隔几秒获取一次当前的activity
返回的True 或 False
    :Agrs:
     - activity - target activity
     - timeout - max wait time, in seconds
     - interval - sleep interval between retries, in seconds
用法driver.wait_activity(‘.activity.xxx’,5,2)
```

**20. background_app**
background_app(self, seconds):

```js 
Puts the application in the background on the device for a certain duration.
    后台运行app多少秒
    :Args:
     - seconds - the duration for the application to remain in the background
用法 driver.background_app(5)   置后台5秒后再运行
```

**21.is_app_installed**
is_app_installed(self, bundle_id):

```js 
Checks whether the application specified by `bundle_id` is installed on the device.
    检查app是否有安装
返回 True or False
    :Args:
     - bundle_id - the id of the application to query
用法 driver.is_app_installed(“com.xxxx”)
```

**22.install_app**
install_app(self, app_path):

```js 
Install the application found at `app_path` on the device.
    安装app,app_path为安装包路径
    :Args:
     - app_path - the local or remote path to the application to install
用法 driver.install_app(app_path)
```

**23.remove_app**
remove_app(self, app_id):

```js 
Remove the specified application from the device.
    删除app
    :Args:
     - app_id - the application id to be removed
用法 driver.remove_app(“com.xxx.”)
```

**24.launch_app**
launch_app(self):

```js 
Start on the device the application specified in the desired capabilities.
启动app
用法 driver.launch_app()
```

**25.close_app**
close_app(self):

```js 
Stop the running application, specified in the desired capabilities, on the device.
关闭app
用法 driver.close_app()
启动和关闭app运行好像会出错
```

**26. start_activity**
start_activity(self, app_package, app_activity, /*/*opts):

```js 
Opens an arbitrary activity during a test. If the activity belongs to
    another application, that application is started and the activity is opened.

    This is an Android-only method.
    在测试过程中打开任意活动。如果活动属于另一个应用程序，该应用程序的启动和活动被打开。
这是一个安卓的方法
    :Args:
    - app_package - The package containing the activity to start.
    - app_activity - The activity to start.
    - app_wait_package - Begin automation after this package starts (optional).
    - app_wait_activity - Begin automation after this activity starts (optional).
    - intent_action - Intent to start (optional).
    - intent_category - Intent category to start (optional).
    - intent_flags - Flags to send to the intent (optional).
    - optional_intent_arguments - Optional arguments to the intent (optional).
    - stop_app_on_reset - Should the app be stopped on reset (optional)?
用法 driver.start_activity(app_package, app_activity)
```

**27.lock**
lock(self, seconds):

```js 
Lock the device for a certain period of time. iOS only.
    锁屏一段时间  iOS专有
    :Args:
     - the duration to lock the device, in seconds
用法 driver.lock()
```

**28.shake**
shake(self):

```js 
Shake the device.
摇一摇手机
用法 driver.shake()
```

**29.open_notifications**
open_notifications(self):

```js 
Open notification shade in Android (API Level 18 and above)
打系统通知栏（仅支持API 18 以上的安卓系统）
用法 driver.open_notifications()
```

**30.network_connection**
network_connection(self):

```js 
Returns an integer bitmask specifying the network connection type.
    Android only.
返回网络类型  数值
    Possible values are available through the enumeration `appium.webdriver.ConnectionType`

用法 driver.network_connection
```

**31. set_network_connection**
set_network_connection(self, connectionType):

```js 
Sets the network connection type. Android only.
    Possible values:
        Value (Alias)      | Data | Wifi | Airplane Mode
        -------------------------------------------------
        0 (None)           | 0    | 0    | 0
        1 (Airplane Mode)  | 0    | 0    | 1
        2 (Wifi only)      | 0    | 1    | 0
        4 (Data only)      | 1    | 0    | 0
        6 (All network on) | 1    | 1    | 0
    These are available through the enumeration `appium.webdriver.ConnectionType`
    设置网络类型
    :Args:
     - connectionType - a member of the enum appium.webdriver.ConnectionType

用法  先加载from appium.webdriver.connectiontype import ConnectionType
dr.set_network_connection(ConnectionType.WIFI_ONLY)
ConnectionType的类型有
NO_CONNECTION = 0
AIRPLANE_MODE = 1
WIFI_ONLY = 2
DATA_ONLY = 4
ALL_NETWORK_ON = 6
```

**32. available_ime_engines**
available_ime_engines(self):

```js 
Get the available input methods for an Android device. Package and activity are returned (e.g., ['com.android.inputmethod.latin/.LatinIME'])
    Android only.
返回安卓设备可用的输入法
用法print(driver.available_ime_engines)
```

**33.is_ime_active**
is_ime_active(self):

```js 
Checks whether the device has IME service active. Returns True/False.
    Android only.
检查设备是否有输入法服务活动。返回真/假。
安卓
用法 print(driver.is_ime_active())
```

**34.activate_ime_engine**
activate_ime_engine(self, engine):

```js 
Activates the given IME engine on the device.
    Android only.
    激活安卓设备中的指定输入法，设备可用输入法可以从“available_ime_engines”获取
    :Args:
     - engine - the package and activity of the IME engine to activate (e.g.,
        'com.android.inputmethod.latin/.LatinIME')

用法 driver.activate_ime_engine(“com.android.inputmethod.latin/.LatinIME”)
```

**35.deactivate_ime_engine**
deactivate_ime_engine(self):

```js 
Deactivates the currently active IME engine on the device.
    Android only.
关闭安卓设备当前的输入法
用法 driver.deactivate_ime_engine()
```

**36.active_ime_engine**
active_ime_engine(self):

```js 
Returns the activity and package of the currently active IME engine (e.g.,
    'com.android.inputmethod.latin/.LatinIME').
    Android only.
    返回当前输入法的包名
用法 driver.active_ime_engine
```

**37. toggle_location_services**
toggle_location_services(self):

```js 
Toggle the location services on the device. Android only.
打开安卓设备上的位置定位设置
用法 driver.toggle_location_services()
```

**38.set_location**
set_location(self, latitude, longitude, altitude):

```js 
Set the location of the device
    设置设备的经纬度
    :Args:
     - latitude纬度 - String or numeric value between -90.0 and 90.00
     - longitude经度 - String or numeric value between -180.0 and 180.0
     - altitude海拔高度- String or numeric value
用法 driver.set_location(纬度，经度，高度)
```

**39.tag_name**
tag_name(self):

```js 
This element's ``tagName`` property.
返回元素的tagName属性
经实践返回的是class name
用法 element.tag_name()
```

**40.text**
text(self):

```js 
The text of the element.
    返回元素的文本值
用法 element.text
```

**41.click**
click(self):

```js 
Clicks the element.
  点击元素
用法 element.click()
```

**42.submit**
submit(self):

```js 
Submits a form.
    提交表单
用法 暂无
```

**43.clear**
clear(self):

```js 
Clears the text if it's a text entry element.
    清除输入的内容
用法 element.clear()
```

**44.get_attribute**
get_attribute(self, name):
详见 的[超级链接](https://testerhome.com/topics/2606)

```js 
Gets the given attribute or property of the element.
1、获取 content-desc 的方法为 get_attribute("name") ，而且还不能保证返回的一定是 content-desc （content-desc 为空时会返回 text 属性值）
2、get_attribute 方法不是我们在 uiautomatorviewer 看到的所有属性都能获取的（此处的名称均为使用 get_attribute 时使用的属性名称）：
可获取的：
字符串类型：
name(返回 content-desc 或 text)
text(返回 text)
className(返回 class，只有 API=>18 才能支持)
resourceId(返回 resource-id，只有 API=>18 才能支持)
    This method will first try to return the value of a property with the
    given name. If a property with that name doesn't exist, it returns the
    value of the attribute with the same name. If there's no attribute with
    that name, ``None`` is returned.

    Values which are considered truthy, that is equals "true" or "false",
    are returned as booleans.  All other non-``None`` values are returned
    as strings.  For attributes or properties which do not exist, ``None``
    is returned.

    :Args:
        - name - Name of the attribute/property to retrieve.

    Example::

        # Check if the "active" CSS class is applied to an element.
        is_active = "active" in target_element.get_attribute("class")
用法 暂无
```

**45.is_selected**
is_selected(self):

```js 
Returns whether the element is selected.

    Can be used to check if a checkbox or radio button is selected.
返回元素是否选择。
可以用来检查一个复选框或单选按钮被选中。
用法 element.is_slected()
```

**46.is_enabled**
is_enabled(self):

```js 
Returns whether the element is enabled.
    返回元素是否可用True of False
用法 element.is_enabled()
```

**47.find_element_by_id**
find_element_by_id(self, id_):

```js 
Finds element within this element's children by ID.
    通过元素的ID定位元素
    :Args:
        - id_ - ID of child element to locate.
用法 driver. find_element_by_id(“id”)
```

**48. find_elements_by_id**
find_elements_by_id(self, id_):

```js 
Finds a list of elements within this element's children by ID.
    通过元素ID定位,含有该属性的所有元素
    :Args:
        - id_ - Id of child element to find.
用法 driver. find_elements_by_id(“id”)
```

**49. find_element_by_name 1.5以上的版本已弃用**
find_element_by_name(self, name):

```js 
Finds element within this element's children by name.
     通过元素Name定位（元素的名称属性text）
    :Args:
        - name - name property of the element to find.
用法 driver.find_element_by_name(“name”)
替代方法 driver.find_element_by_xpath("//*[@text='我的']")
还有其它方法的话欢迎补充
```

**50. find_elements_by_name**
find_elements_by_name(self, name):

```js 
Finds a list of elements within this element's children by name.
    通过元素Name定位（元素的名称属性text），含有该属性的所有元素
    :Args:
        - name - name property to search for.
用法 driver.find_element_by_name(“name”)
```

**51. find_element_by_link_text**
find_element_by_link_text(self, link_text):

```js 
Finds element within this element's children by visible link text.
    通过元素可见链接文本定位
    :Args:
        - link_text - Link text string to search for.
用法 driver.find_element_by_link_text(“text”)
```

**52. find_elements_by_link_text**
find_element_by_link_text(self, link_text):

```js 
Finds a list of elements within this element's children by visible link text
    通过元素可见链接文本定位,含有该属性的所有元素
    :Args:
        - link_text - Link text string to search for.
用法 driver.find_elements_by_link_text(“text”)
```

**53. find_element_by_partial_link_text**
find_element_by_partial_link_text(self, link_text):

```js 
Finds element within this element's children by partially visible link text.
    通过元素部分可见链接文本定位
    :Args:
        - link_text - Link text string to search for.
driver. find_element_by_partial_link_text(“text”)
```

**54. find_elements_by_partial_link_text**
find_elements_by_partial_link_text(self, link_text):

```js 
Finds a list of elements within this element's children by link text.
    通过元素部分可见链接文本定位,含有该属性的所有元素
    :Args:
        - link_text - Link text string to search for.
driver. find_elements_by_partial_link_text(“text”)
```

**55. find_element_by_tag_name**
find_element_by_tag_name(self, name):

```js 
Finds element within this element's children by tag name.
    通过查找html的标签名称定位元素
    :Args:
        - name - name of html tag (eg: h1, a, span)
用法  driver.find_element_by_tag_name(“name”)
```

**56. find_elements_by_tag_name**
find_elements_by_tag_name(self, name):

```js 
Finds a list of elements within this element's children by tag name.
   通过查找html的标签名称定位所有元素
    :Args:
        - name - name of html tag (eg: h1, a, span)
用法driver.find_elements_by_tag_name(“name”)
```

**57. find_element_by_xpath**
find_element_by_xpath(self, xpath):

```js 
Finds element by xpath.
    通过Xpath定位元素，详细方法可参阅http://www.w3school.com.cn/xpath/
    :Args:
        xpath - xpath of element to locate.  "//input[@class='myelement']"

    Note: The base path will be relative to this element's location.

    This will select the first link under this element.

    ::

        myelement.find_elements_by_xpath(".//a")

    However, this will select the first link on the page.

    ::

        myelement.find_elements_by_xpath("//a")

用法 find_element_by_xpath(“//*”)
```

**58. find_elements_by_xpath**
find_elements_by_xpath(self, xpath):

```js 
Finds elements within the element by xpath.

    :Args:
        - xpath - xpath locator string.

    Note: The base path will be relative to this element's location.

    This will select all links under this element.

    ::

        myelement.find_elements_by_xpath(".//a")

    However, this will select all links in the page itself.

    ::

        myelement.find_elements_by_xpath("//a")

用法find_elements_by_xpath(“//*”)
```

**59. find_element_by_class_name**
find_element_by_class_name(self, name):

```js 
Finds element within this element's children by class name.
    通过元素class name属性定位元素
    :Args:
        - name - class name to search for.
用法 driver. find_element_by_class_name(“android.widget.LinearLayout”)
```

**60. find_elements_by_class_name**
find_elements_by_class_name(self, name):

```js 
Finds a list of elements within this element's children by class name.
    通过元素class name属性定位所有含有该属性的元素
    :Args:
        - name - class name to search for.
用法 driver. find_elements_by_class_name(“android.widget.LinearLayout”)
```

**61. find_element_by_css_selector**
find_element_by_css_selector(self, css_selector):

```js 
Finds element within this element's children by CSS selector.
    通过CSS选择器定位元素
    :Args:
        - css_selector - CSS selctor string, ex: 'a.nav#home'
```

**62.send_keys**
send_keys(self, /*value):

```js 
Simulates typing into the element.
    在元素中模拟输入（开启appium自带的输入法并配置了appium输入法后，可以输入中英文）
    :Args:
        - value - A string for typing, or setting form fields.  For setting
        file inputs, this could be a local file path.

    Use this to send simple key events or to fill out form fields::

        form_textfield = driver.find_element_by_name('username')
        form_textfield.send_keys("admin")

    This can also be used to set file inputs.

    ::

        file_input = driver.find_element_by_name('profilePic')
        file_input.send_keys("path/to/profilepic.gif")
        # Generally it's better to wrap the file path in one of the methods
        # in os.path to return the actual path to support cross OS testing.
        # file_input.send_keys(os.path.abspath("path/to/profilepic.gif"))
driver.element.send_keys(“中英”)
```

**63. is_displayed**
is_displayed(self):

```js 
Whether the element is visible to a user.    
此元素用户是否可见。简单地说就是隐藏元素和被控件挡住无法操作的元素（仅限 Selenium，appium是否实现了类似功能不是太确定）这一项都会返回 False

用法 driver.element.is_displayed()
```

**64. location_once_scrolled_into_view**
location_once_scrolled_into_view(self):

```js 
"""THIS PROPERTY MAY CHANGE WITHOUT WARNING. Use this to discover
   where on the screen an element is so that we can click it. This method
   should cause the element to be scrolled into view.

   Returns the top lefthand corner location on the screen, or ``None`` if
   the element is not visible.
   暂不知道用法
   """
```

**65.size**
size(self):

```js 
The size of the element.
获取元素的大小（高和宽）

new_size["height"] = size["height"]
new_size["width"] = size["width"]

用法 driver.element.size
```

**66. value_of_css_property**
value_of_css_property(self, property_name):

```js 
The value of a CSS property.
CSS属性

用法 暂不知
```

**67.location**
location(self):

```js 
The location of the element in the renderable canvas.
    获取元素左上角的坐标

用法 driver.element.location
'''返回element的x坐标, int类型'''
driver.element.location.get('x')
'''返回element的y坐标, int类型'''
driver.element.location.get('y')
```

**68.rect**
rect(self):

```js 
A dictionary with the size and location of the element.
    元素的大小和位置的字典
```

**69. get_screenshot_as_base64**
screenshot_as_base64(self):

```js 
Gets the screenshot of the current window as a base64 encoded string
        which is useful in embedded images in HTML.
 获取当前元素的截图为Base64编码的字符串,在HTML中嵌入的图像
 :Usage:
     img_b64 = element.get_screenshot_as_base64
```

**70.execute_script**
execute_script(self, script, /*args):

```js 
Synchronously Executes JavaScript in the current window/frame.
在当前窗口/框架（特指 Html 的 iframe ）同步执行 javascript 代码。你可以理解为如果这段代码是睡眠5秒，这五秒内主线程的 javascript 不会执行
    :Args:
     - script: The JavaScript to execute.
     - \*args: Any applicable arguments for your JavaScript.

    :Usage:
        driver.execute_script('document.title')
```

**71.execute_async_script**
execute_async_script(self, script, /*args):

```js 
Asynchronously Executes JavaScript in the current window/frame.
插入 javascript 代码，只是这个是异步的，也就是如果你的代码是睡眠5秒，那么你只是自己在睡，页面的其他 javascript 代码还是照常执行
    :Args:
     - script: The JavaScript to execute.
     - \*args: Any applicable arguments for your JavaScript.

    :Usage:
        driver.execute_async_script('document.title')
```

**72.current_url**
current_url(self):

```js 
Gets the URL of the current page.
    获取当前页面的网址。
    :Usage:
        driver.current_url
用法 driver.current_url
```

**73. page_source**
page_source(self):

```js 
Gets the source of the current page.
获取当前页面的源。
:Usage:
    driver.page_source
```

**74.close**
close(self):

```js 
Closes the current window.
关闭当前窗口
:Usage:
    driver.close()
```

**75.quit**
quit(self):

```js 
Quits the driver and closes every associated window.
退出脚本运行并关闭每个相关的窗口连接
:Usage:
    driver.quit()
```

**76.get_screenshot_as_file**
get_screenshot_as_file(self, filename):

```js 
Gets the screenshot of the current window. Returns False if there is
       any IOError, else returns True. Use full paths in your filename.
  截取当前窗口的截图，如果有写入错误会返回False，其它返回True
filename 使用绝对路径
    :Args:
     - filename: The full path you wish to save your screenshot to.

    :Usage:
       driver.get_screenshot_as_file('c:/foo.png')
```

**77.get_window_size**
get_window_size(self, filename):

```js 
Gets the width and height of the current window.
获取当前屏幕的分辨率（长和宽）
  :Usage:
      driver.get_window_size()
```
 
```js 

```
