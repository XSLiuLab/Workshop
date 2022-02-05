# 用Python构建网络爬虫

爬虫是是通过网页的链接地址来寻找网页获取相关信息的一种程序。

* 搜索引擎抓取网页信息
* 爬虫抢票
* 比价平台

## 基础知识

### HTML标签

![](https://limbo1996.oss-cn-shanghai.aliyuncs.com/img/20201130205447.png)

`<h1>-<h6>`

```HTML
<h1>This is a heading</h1>
<h2>This is a heading</h2>
<h3>This is a heading</h3>
```

## 爬虫的基本流程

1. 发送请求
2. 解析返回内容
3. 提取想要的内容并保存

### 基本库

`Requests`, `re`

> pip install requests
>
> pip install bs4

### Requests

| `requests.request()` | 构造一个请求           |
| -------------------- | ---------------------- |
| `requests.get()`     | 获取HTML网页的主要方法 |
| `requests.head()`    | 获取HTML的头信息       |
| `requests.post()`    | 向HTML提交POST         |

```python
import requests
# 访问百度网页
r = requests.get('http://www.baidu.com')
# 查看状态码
r.status_code # 200 代表成功
```

```html
'<!DOCTYPE html>\r\n<!--STATUS OK--><html> <head><meta http-equiv=content-type content=text/html;charset=utf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><link rel=stylesheet type=text/css href=http://s1.bdstatic.com/r/www/cache/bdorz/baidu.min.css><title>ç\x99¾åº¦ä¸\x80ä¸\x8bï¼\x8cä½\xa0å°±ç\x9f¥é\x81\x93</title></head> <body link=#0000cc> <div id=wrapper> <div id=head> <div class=head_wrapper> <div class=s_form> <div class=s_form_wrapper> <div id=lg> <img hidefocus=true src=//www.baidu.com/img/bd_logo1.png width=270 height=129> </div> <form id=form name=f action=//www.baidu.com/s class=fm> <input type=hidden name=bdorz_come'
```

```python
>>> r.encoding
'ISO-8859-1'
>>> r.encoding = 'utf-8'
>>> r.text
```

```html
'<!DOCTYPE html>\r\n<!--STATUS OK--><html> <head><meta http-equiv=content-type content=text/html;charset=utf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><link rel=stylesheet type=text/css href=http://s1.bdstatic.com/r/www/cache/bdorz/baidu.min.css><title>百度一下，你就知道</title></head> <body link=#0000cc> <div id=wrapper> <div id=head> <div class=head_wrapper> <div class=s_form> <div class=s_form_wrapper> <div id=lg> 
```

```python
def getHTMLText(url):
    try:
        r = requests.get(url, timeout=30)
        r.raise_for_status() #如果状态码不是200， 引发异常
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return "Error"
```

#### 附加额外信息

对于带参数的URL， 可以传入一个dict作为`params`参数

```python
>>> r = requests.get("http://www.douban.com/search", params={'q':'python', 'cat':'1001'})
>>> r.url
'http://www.douban.com/search?q=python&cat=1001'
```

##### 附加头信息

```python
import requests
header = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko)Chrmoe/52.0.2743 Safari/537.36'
}
r = requests.get('http://www.zhihu.com/explore', headers = header)
print(r.text)
```

不加`headers`

```html
<html>
<head><title>400 Bad Request</title></head>
<body bgcolor="white">
<center><h1>400 Bad Request</h1></center>
<hr><center>openresty</center>
</body>
</html>
```

加上`header`

```JSON
汽车时，如何选择一台安全性更高的车型？","url":"https:\u002F\u002Fwww.zhihu.com\u002Fquestion\u002F431928237","type":"question","id":431928237,"answerCount":7},{"followerCount":15,"title":"安全带这一看似很简单的机构，为什么能在关键时刻挽救人的生命？科学原理在哪？","url":"https:\u002F\u002Fwww.zhihu.com\u002Fquestion\u002F431928500","type":"question","id":431928500,"answerCount":5},{"followerCount":727,"title":"哪些汽车安全配置是购车过程中如果有预算就尽量去满足的？","url":"https:\u002F\u002Fwww.zhihu.com\u002Fquestion\u002F350787653","type":"question","id":350787653,"answerCount":92}],"logo":"https:\u002F\u002Fpic1.zhimg.com\u002F50\u002Fv2-da260e19fd38ef931cc98ab11a75d814_720w.jpg?source=b1f6dc53","urlToken":"autosafety"},"wonderfulcar":{"startAt":1606492801,"name":"这车，真好看","title":"这车，真好看","color":"#15110b","banner":"https:\u002F\u002Fpic1.zhimg.com\u002F50\u002Fv2-d66c561f6f2d14c63cbb579f7e4b8f2b_720w.jpg?source=b1f6dc53",
```

#### 获取二进制文件

```python
import requests
r = requests.get("https://github.com/favicon.ico")# 获取GITHUB图标
print(r.text)
print(r.content)#返回响应数据，不进行解码，可以根据实际情况自己解码
with open('favicon.ico', 'wb') as f:
    f.write(r.content)
```

### 爬取猫眼排名前100的电影

```python
import json
from requests.exceptions import RequestException
import re
import time
import requests

def get_one_page(url): #获取页面信息
    try:
        headers = {
            'User-Agent':'Mozilla/5.0(Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36(KHTML, like Gecko)Chrmoe/65.0.3325.162 Safari/537.36'
        }
        response = requests.get(url, headers = headers)
        if response.status_code == 200:
            return response.text
        return None
    except RequestException:
        return None
    
def parse_one_page(html):#分析第一页
    pattern = re.compile('<dd>.*?board-index.*?>(.*?)</i>.*?data-src="(.*?)".*?name".*?a.*?>(.*?)</a>.*?star.*?>(.*?)</p>.*?releasetime.*?>(.*?)</p>.*?integer.*?>(.*?)</i>.*?fraction.*?>(.*?)</i>.*?</dd>', re.S)
    items = re.findall(pattern, html)
    print(items)
    for item in items:

        yield{
            'index' : item[0],
            'image' : item[1],
            'title' : item[2],
            'actor' : item[3].strip()[3:],
            'time' : item[4].strip()[5:],
            'score' : item[5] + item[6]
        }
    
def write_to_file(content):#写入文件
    with open('result.txt', 'a', encoding='utf-8') as f:
        f.write(json.dumps(content, ensure_ascii=False) + '\n')

def main(offset):#读取其余页面
    url = 'http://maoyan.com/board/4?offset=' + str(offset)
    html = get_one_page(url)
    for item in parse_one_page(html):
        print(item)
        write_to_file(item)

if __name__ == '__main__':
    for i in range(10):
        main(offset = i * 10)
        time.sleep(1)
```

### Robots协议

```python
#分析robots协议
>>> from urllib.robotparser import RobotFileParser
>>> rp = RobotFileParser()
>>> rp.set_url('http://www.jianshu.com/robots.txt')
>>> rp.read()
>>> print(rp.can_fetch('*', 'http://www.jianshu.com/p/b67554025d7d'))
False
```

### 解析库

`BeautifulSoup`库用来解析`requests`库爬取返回的对象

```python
import requests
from bs4 import BeautifulSoup 

url = "http://python123.io/ws/demo.html"

r = requests.get(url)

demo = r.text

soup = BeautifulSoup(demo, "html.parser")# 选择解析方式，在初始化时就可以完成对不完整的HTML的修正补全

print(soup.prettify()) # 可以以更好阅读的方式输出HTML
```

```HTML
'<html><head><title>This is a python demo page</title></head>\r\n<body>\r\n<p class="title"><b>The demo python introduces several python courses.</b></p>\r\n<p class="course">Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:\r\n<a href="http://www.icourse163.org/course/BIT-268001" class="py1" id="link1">Basic Python</a> and <a href="http://www.icourse163.org/course/BIT-1001870001" class="py2" id="link2">Advanced Python</a>.</p>\r\n</body></html>'
```

```HTML
<html>
 <head>
  <title>
   This is a python demo page
  </title>
 </head>
 <body>
  <p class="title">
   <b>
    The demo python introduces several python courses.
   </b>
  </p>
  <p class="course">
   Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:
   <a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">
    Basic Python
   </a>
   and
   <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">
    Advanced Python
   </a>
   .
  </p>
 </body>
</html>
```

#### 标签的名字

```python
>>> soup.a.name
'a'
>>> soup.a.parent.name
'p'
>>> soup.p.parent.name
'body'
```

#### 标签的属性

对于标签，有两个重要的属性，`name`和`attrs`

```python
>>> tag =  soup.a
>>> type(tag) # bs4.element.Tag
<class 'bs4.element.Tag'>
>>> tag.attrs # 打印该标签的所有属性
{'href': 'http://www.icourse163.org/course/BIT-268001', 'class': ['py1'], 'id': 'link1'}
>>> tag.attrs['class']# ['py1']
['py1']
>>> type(tag.attrs) # dict
<class 'dict'>
```

#### 字符串提取

```python
>>> soup.a
<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a>
>>> soup.a.string
'Basic Python'
```

#### 遍历标签

> **.contents：**获取Tag的所有子节点，返回一个list
>
> .children**：**获取Tag的所有子节点，返回一个生成器
>
> .parent：获取Tag的父节点
>
> .parents：递归得到父辈元素的所有节点，返回一个生成器
>
> .next_sibling
>
> .previous_sibling：查询兄弟节点



```python
>>> soup.body.contents #获取body的所有子节点，返回列表 
['\n', <p class="title"><b>The demo python introduces several python courses.</b></p>, '\n', <p class="course">Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:
<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a> and <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>.</p>, '\n']

>>> for i in soup.body.children:# 遍历子节点
...     print(i)
... 


<p class="title"><b>The demo python introduces several python courses.</b></p>


<p class="course">Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:
<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a> and <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>.</p>


```

```python
>>> soup.title.parent # 查询父节点
<head><title>This is a python demo page</title></head>
```

```python
>>> soup.a.next_sibling # 查询兄弟节点
' and '
>>> soup.a.next_sibling.next_sibling
<a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>
>>> soup.a.previous_sibling
'Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:\r\n'
```

#### 解析标签



##### 搜索特定标签

```python
>>> demo
'<html><head><title>This is a python demo page</title></head>\r\n<body>\r\n<p class="title"><b>The demo python introduces several python courses.</b></p>\r\n<p class="course">Python is a wonderful general-purpose programming language. You can learn Python from novice to professional by tracking the following courses:\r\n<a href="http://www.icourse163.org/course/BIT-268001" class="py1" id="link1">Basic Python</a> and <a href="http://www.icourse163.org/course/BIT-1001870001" class="py2" id="link2">Advanced Python</a>.</p>\r\n</body></html>'
>>> for link in soup.find_all('a'):
...     print(link.get('href'))
... 
http://www.icourse163.org/course/BIT-268001
http://www.icourse163.org/course/BIT-1001870001
```

```python
>>> soup.find_all('a')
[<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a>, <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>]
>>> soup.find_all(['a', 'b'])
[<b>The demo python introduces several python courses.</b>, <a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a>, <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>]
```

##### 搜索属性

```python
>>> soup.find_all(id = 'link1')
[<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a>]
```

```python
>>> soup.find_all(id = re.compile('link'))
[<a class="py1" href="http://www.icourse163.org/course/BIT-268001" id="link1">Basic Python</a>, <a class="py2" href="http://www.icourse163.org/course/BIT-1001870001" id="link2">Advanced Python</a>]
```



### 爬取大学排名

```python
# -*- coding: utf-8 -*-
"""
中国大学排名定向爬虫
"""
import requests
from bs4 import BeautifulSoup
import bs4


url = 'https://www.shanghairanking.cn/rankings/bcur/2020'

def getHTMLText(url): # 获取url链接内容
    try:
        r = requests.get(url, timeout=30)
        r.raise_for_status()
        r.encoding = r.apparent_encoding
        return r.text
    except:
        return "链接失败"



def fillUnivList(ulist, html): # 解析HTML内容
    soup = BeautifulSoup(html, "html.parser")
    '''
    查看网页源代码可以发现所有的大学信息放在
    tbody中
    每个大学都有一个专属的 tr，是tbody的子标签
    另外tr下的子属性是td，存储了大学的具体信息，如排名，姓名，省市等
    所以首先提取所有的tbody
    在tbody中检索tr和td即可
    '''
    for tr in soup.find('tbody').children: #遍历所有tr
        if isinstance(tr, bs4.element.Tag):
            tds = tr('td')# 在每个tr中检索td，存储为list
            ulist.append([tds[0].contents[0].strip("\n          "), 
                        tds[1].a.string,
                        tds[5].string.strip("\n          ")])

def printUnivList(ulist, num):
    '''
    因为中文输出的对齐问题
    产生这个问题的原因是因为，在中文字符输出完成但是没有占满时，系统自动用
    西文字符填充，导致不对其，使用chr(12288)代表中文中的空格
    '''
    tplt = "{0:^10}\t{1:{3}^10}\t{2:^10}" #格式化输出信息，第二个替换中添加{3}代表使用format的第三个参数替换
    print(tplt.format("排名", 
                        "学校名称",
                        "总分",
                        chr(12288)))
    for i in range(num):
        u = ulist[i]
        print(tplt.format(u[0],
                            u[1],
                            u[2],
                            chr(12288)))

    
def main():
    uinfo = []
    html = getHTMLText(url)
    fillUnivList(uinfo, html)
    printUnivList(uinfo, 20)




main()
```

```python
>>> main()
    排名        　　　学校名称　　　        总分    
    1           　　　清华大学　　　       38.2   
    2           　　　北京大学　　　       36.1   
    3           　　　浙江大学　　　       33.9   
    4           　　上海交通大学　　       35.4   
    5           　　　南京大学　　　       35.1   
    6           　　　复旦大学　　　       36.6   
    7           　中国科学技术大学　       40.0   
    8           　　华中科技大学　　       31.9   
    9           　　　武汉大学　　　       31.7   
    10          　　　中山大学　　　       30.3   
    11          　　西安交通大学　　       34.3   
    12          　哈尔滨工业大学　　       32.7   
    13          　北京航空航天大学　       32.8   
    14          　　北京师范大学　　       34.8   
    15          　　　同济大学　　　       33.4   
    16          　　　四川大学　　　       32.5   
    17          　　　东南大学　　　       33.7   
    18          　　中国人民大学　　       34.5   
    19          　　　南开大学　　　       32.4   
    20          　　北京理工大学　　       31.9 
```

参考：

[URL](https://zh.wikipedia.org/wiki/%E7%BB%9F%E4%B8%80%E8%B5%84%E6%BA%90%E5%AE%9A%E4%BD%8D%E7%AC%A6)

[HTML](https://www.w3school.com.cn/html/html_primary.asp)

《Python3网络爬虫实战》

[Python网络爬虫与信息提取](https://www.icourse163.org/course/BIT-1001870001?tid=1450316449)