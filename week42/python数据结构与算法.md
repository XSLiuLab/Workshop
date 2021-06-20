# Python数据结构与算法(一)
* 大O表示法
* 数据结构
  * 栈
  * 队列
  * 双端队列
* 算法
  * 递归

## 程序运行时间检测

一般来说解决同样的问题，可能有不同的实现方式。我们总是希望一个程序可以快速高效并且节省资源的完成正确的工作， 而同样问题的不同实现方法就会有优劣之分。

例如我们可以用`Python`的`time`模块来检测不同的累计求和算法的效率

### 循环求和

```python
def sumOfN(n):
  start = time.time()
  theSum = 0
  for i in range(1, n + 1):
    theSum = theSum + i
    
  end = time.time()
  return theSum, end - start


for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN(10000))
```

```python
Sum id 50005000 required 0.001001 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.001001 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.000999 seconds
```

看上去耗时很短， 但是如果需要求和的数量级继续增加

```python
for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN(10000))

for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN(100000))

for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN(1000000))
```

```python
Sum id 50005000 required 0.000999 seconds
Sum id 50005000 required 0.001002 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.001001 seconds
Sum id 50005000 required 0.000000 seconds


Sum id 5000050000 required 0.004997 seconds
Sum id 5000050000 required 0.006002 seconds
Sum id 5000050000 required 0.005001 seconds
Sum id 5000050000 required 0.006001 seconds
Sum id 5000050000 required 0.007997 seconds



Sum id 500000500000 required 0.063554 seconds
Sum id 500000500000 required 0.053955 seconds
Sum id 500000500000 required 0.056039 seconds
Sum id 500000500000 required 0.057961 seconds
Sum id 500000500000 required 0.059000 seconds
```

### 无迭代求和

```python
def sumOfN2(n):
  start = time.time()
  theSum = (n * (n + 1)) / 2
  end = time.time()
  return theSum, end - start
```

这时候我们再看不同数量级下的结果

```python
for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN2(10000))

for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN2(100000))

for i in range(5):
  print("Sum id %d required %f seconds" 
        % sumOfN2(1000000))
```

```python
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 50005000 required 0.000000 seconds
Sum id 5000050000 required 0.000000 seconds
Sum id 5000050000 required 0.000000 seconds
Sum id 5000050000 required 0.000000 seconds
Sum id 5000050000 required 0.000000 seconds
Sum id 5000050000 required 0.000000 seconds
Sum id 500000500000 required 0.000000 seconds
Sum id 500000500000 required 0.000000 seconds
Sum id 500000500000 required 0.000000 seconds
Sum id 500000500000 required 0.000000 seconds
Sum id 500000500000 required 0.000000 seconds
```

可以发现无迭代算法的运行时间和输入的数的大小并没有关系。

### 大O表示法

#### 算法时间度量指标

一个算法所实施的操作数量或者步骤数可作为独立于程序的度量指标。

一个程序中，控制流语句起到组织语句的作用，而赋值语句包含了计算和存储。所以多用赋值语句座位衡量算法的指标。

在一段程序中，赋值语句越多，运行时间就越长。例如

```python
def sumOfN(n):
    theSum = 0
    for i in range(1, n + 1):
        theSum = theSum + 1
    return theSum
```

这个函数中的赋值语句的数量为`T(n) = 1 + n`, 也就是函数赋值语句的执行的次数。

#### 时间复杂度

我们通常用`时间复杂度`来描述执行一个算法所消耗的时间。一个通用的方法就是**大O表示法**

如果用动态的眼光来看待上述`T(n)`， 当n无限大时，常量1对整个函数运行时间的影响可以忽略不计， 这时候占主导部分的是`n`

所以上述函数的运行时间的数量级就是`O(n)`， 而无迭代算法本身和输入数据的大小无关，赋值语句是个常量，这种算法时间复杂度就是`O(1)`。

常见的大O数量级函数

![](https://gitee.com/limbo1996/picgo/raw/master/png/20210422201628.png)

例如

```python
a = 5
b = 6
c = 10

for i in range(n):
  for j in range(n):
    x = i * j
    y = j * j
    z = i * i
```

上述代码的赋值语句有T(n) = 3 + 3n^2^。时间复杂度为O(n^2^)。

## 线性结构

线性结构指的是一种有序数据项的集合。几种基本的线性结构：

* 栈
* 队列
* 双端队列

### 栈

栈是一系列对象组成的集合，数据项的加入和移除都在同一端，遵循**后进先出**的原则。

在Python中可以用`list`十分容易的实现一个栈

#### 实现

1. 将list的末端作为栈顶

   ```python
   class Stack:
     def __init__(self):
       self.items = []
       
     def isEmpty(self):
       return self.items == []
   
     def push(self, item):
       self.items.append(item)
       
     def pop(self):
       return self.items.pop()
   
     def peek(self):
       return self.items[len(self.items) - 1]
   
     def size(self):
       return len(self.items)
   ```

2. 将list的首端(index = 0)作为栈顶

   ```python
   class Stack_list_index_0:
     def __init__(self):
       self.items = []
       
     def isEmpty(self):
       return self.items == []
   
     def push(self, item):
       self.items.insert(0, item)
       
     def pop(self):
       return self.items.pop(0)
   
     def peek(self):
       return self.items[0]
   
     def size(self):
       return len(self.items)
   ```

   

这两种实现方法的时间复杂度是不同的， 第二种的`push`和`pop`的复杂度都是`O(n)`, 第一种都是`O(1)`

#### 简单应用

##### 简单的括号匹配

正确的括号匹配是我们日常写代码中用到的一个基础功能， 这个功能可以通过一个栈来简单实现
```
给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字串 s ，判断字符串是否有效。
有效字符串需满足：
1. 左括号必须用相同类型的右括号闭合。
2. 左括号必须以正确的顺序闭合。
来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/valid-parentheses
```


```{python}
def parChecker(symbolstring):
  s = Stack()
  balanced = True
  index = 0
  while index < len(symbolstring) and balanced:
    symbol = symbolstring[index]
    if symbol == "(":
      s.push(symbol)
    else:
      if s.isEmpty():
        balanced = False
      else:
        s.pop()
    index = index + 1
  if balanced and s.isEmpty():
    return True
  else:
    return False
```

当然在写代码的过程中不止`()`一种括号，只要将上面代码修改一下， 就可以匹配所有括号

```
def matches(open, close): 
  opens = "([{"
  closers = ")]}" 
  return opens.index(open) == closers.index(close)

def parChecker(symbolstring): 
  s = Stack() 
  balanced = True 
  index = 0
  while index < len(symbolstring) and balanced: 
    symbol = symbolstring[index] 
    if symbol in "([{":
      s.push(symbol) 
    else: 
      if s.isEmpty(): 
        balanced = False 
      else: 
        top = s.pop() 
        if not matches(top,symbol):
          balanced = False 
    index = index + 1 
  
  if balanced and s.isEmpty():
    return True 
  else: 
    return False
```

##### 十进制转化为二进制

将十进制转化为二进制，一般用**除以2求余数**的方法

![](https://gitee.com/limbo1996/picgo/raw/master/png/20210317203056.png)


```{python}
def divideBy2(decNumber):
  remstack = Stack()
  
  while decNumber > 0:
    rem = decNumber % 2 # 求余数
    remstack.push(rem)
    decNumber = decNumber // 2
    
  binString = ""
  while not remstack.isEmpty():
    binString = binString + str(remstack.pop())
    
  return binString
```
```
print(divideBy2(42))

101010
```
当然也可以扩展为N进制

![](https://gitee.com/limbo1996/picgo/raw/master/png/20210317204859.png)

```{python}
def baseConverter(decNumber, base):
  digits = "0123456789ABCDEF"
  
  remstack = Stack()
  
  while decNumber > 0:
    rem = decNumber % base # 求余数
    remstack.push(rem)
    decNumber = decNumber // base
    
  newString = ""
  
  while not remstack.isEmpty():
    newString = newString + digits[remstack.pop()]
    
  return newString
```
### 队列
队列也是一种有次序的数据集合，特征是
> 新数据项的添加总发生在一段， 而现存数据项的移除发生在另一端， 即先进先出

添加的一端称为”尾端”， 移除的一段称为”首端”。

队列只有一个入口一个出口，不允许从中间插入或移除数据。

同样可以用list实现一个简单的list
```{python}
class Queue:
  def __init__(self):
    self.item = []
  def isEmpty(self):
    return self.items == []
  
  def enqueue(self, item):
    self.items.insert(0, item)
    
  def dequenue(self):
    return self.items.pop()
  def size(self):
    return len(self.items)
```
enqueue的时间复杂度为O(n), dequeue的复杂度为O(1)。

#### 简单应用
##### 打印机队列
模拟多人共享一台打印机，“先到先服务”

![](https://gitee.com/limbo1996/picgo/raw/master/png/20210317220247.png)

首先确定生成任务的概率：每小时会有十个学生提交20个作业， 也就是180秒会有一个作业生成并提交。
该问题需要考虑的问题：

  *  打印任务的属性：提交时间， 打印页数
  *  打印队列的属性：打印任务队列
  *  打印机的属性：打印速度，是否忙

```{python}

class Printer:
  def __init__(self, ppm):
    self.pagerate = ppm # 打印速度
    self.currentTask = None # 打印任务
    self.timeRemaining = 0 # 打印时间倒计时
    
  def tick(self): # 打印1秒
    if self.currentTask != None:
      self.timeRemaining = self.timeRemaining - 1
      if self.timeRemaining <= 0:
        self.currentTask = None
        
  def busy(self):
    if self.currentTask != None:
      return True
    else:
      return False
    
  def startNext(self, newtask): # 打印新作业
    self.currentTask = newtask
    self.timeRemaining = newtask.getPages() /self.pagerate * 60 # 页数除打印速度
  
  
class Task:
  def __init__(self, time):
    self.timestamp = time # 生成时间戳
    self.pages = random.randrange(1, 21) # 打印页数
    
  def getStamp(self):
    return self.timestamp
  
  def getPages(self):
    return self.pages
  
  def waitTime(self, currenttime):
    return currenttime - self.timestamp #等待时间 
 
 
  
def newPrintTask(): # 1/ 180的概率生成一个作业
  num = random.randrange(1, 181)
  if num == 180:
    return True
  else:
    return False
  
  
  
  
  
def simulation(numSeconds, pagesPerMinute):# 模拟多长时间和打印机模式
  
  labprinter = Printer(pagesPerMinute)
  printQueue = Queue()
  waitingtimes = []
  
  for currentSecond in range(numSeconds):
    
    if newPrintTask():
      task = Task(currentSecond)
      printQueue.enqueue(task)
    
    if (not labprinter.busy()) and (not printQueue.isEmpty()):
      nexttask = printQueue.dequeue() # 从等待队列中移除进入打印
      waitingtimes.append(nexttask.waitTime(currentSecond)) # 计算等待时间
      
      labprinter.startNext(nexttask)
    
    labprinter.tick()
  
  averageWait = sum(waitingtimes) / len(waitingtimes)
  
  print("Average Wait %f secs %d tasks remaining." % (averageWait, printQueue.size()))
```
```{python}
for i in range(10):
  simulation(3600, 5)

Average Wait 264.541667 secs 0 tasks remaining.
Average Wait 57.928571 secs 0 tasks remaining.
Average Wait 205.458333 secs 0 tasks remaining.
Average Wait 90.000000 secs 1 tasks remaining.
Average Wait 29.923077 secs 0 tasks remaining.
Average Wait 490.153846 secs 2 tasks remaining.
Average Wait 149.333333 secs 0 tasks remaining.
Average Wait 95.636364 secs 0 tasks remaining.
Average Wait 207.636364 secs 0 tasks remaining.
Average Wait 94.312500 secs 0 tasks remaining.
```
### 双端队列
与队列相似，双端队列也有首尾两端，不同的是数据的加入和删除都可以在两端完成。
同样可以使用list实现
```{python}
class Deque:
    def __init__(self):
        self.items = []

    def isEmpty(self):
        return self.items == []

    def addFront(self, item):
        self.items.append(item)

    def addRear(self, item):
        self.items.insert(0, item)

    def removeFront(self):
        return self.items.pop()

    def removeRear(self):
        return self.items.pop(0)

    def size(self):
        return len(self.items)
```
其中addFront/removeFront的复杂度为O(1) 另一组为O(n)。
#### 回文词判定
只需要将需要判定的词从队尾加入Deque， 然后从两端同时移除字符并判定是否相同，直到deque中剩下1个或者0个字符。
```
def palchecker(aString):
    chardeque = Deque()

    for ch in aString:
        chardeque.addRear(ch)
    stillEqual = True

    while chardeque.size() > 1 and stillEqual:
        first = chardeque.removeFront()
        last = chardeque.removeRear()

        if first != last:
            stillEqual = False
    return stillEqual    
```
```
print(palchecker("lsdkjfskf"))
print(palchecker("radar"))
```
```
False
True
```

### 递归
递归是一个简单的算法， 一个明显的特征是函数**在算法流程中调用自身**，这种函数被称为**递归函数**
#### 数列求和
```
# 普通方法
def listsum(numlist):
    theSum = 0
    for i in numlist:
        theSum = theSum + i
    return theSum

# 递归
def listsumRecursion(numlist):
    if len(numlist) == 1:
        return numlist[0]
    else:
        return numlist[0] + listsumRecursion(numlist[1:])
```
递归的几个特性：

* 把问题分解为更小的相同问题，表现为调用自身
* 对最小规模问题的解决简单直接

#### 递归的条件
1. 递归必须要有一个基本的结束条件（最小规模问题的直接解决）
2. 递归算法必须能改变状态向基本结束条件演进
3. 递归算法必须调用自身
   
#### 应用
##### 十进制转换为任意进制
十进制转换为任意进制的本质是不断除以`base`，知道比`base`更小，所以可以用递归一次实现十进制转换为任意进制
```{python}
def toStr(n, base):
    convertString = "0123456789ABCDEF"
    if n < base:
        return convertString[n]
    else:
        return toStr(n // base, base) + convertString[n % base]
```
这个递归的原理如下图

![](https://gitee.com/limbo1996/picgo/raw/master/png/未命名文件(3).png)
#### 递归可视化
##### 分形树
首先了解一下`python`的海龟作图系统`turtle module`， 其意向是模拟海龟在沙滩上爬行留下的痕迹

爬行：`forward(n)`;`backward(n)`

转向：`left(a)`;`right(a)`

抬笔放笔: `penup()`; `pendown()`

笔属性: `pensize(s)`;`pencolor(c)`
```
import turtle
def tree(branch_len):
    if branch_len > 5:
        t.forward(branch_len)
        t.right(20)
        tree(branch_len - 15)
        t.left(40)
        tree(branch_len - 15)
        t.right(20)
        t.backward(branch_len)

t = turtle.Turtle()

t.pencolor('green')
t.pensize(2)
tree(75)
t.hideturtle()
turtle.done()
```
![](https://gitee.com/limbo1996/picgo/raw/master/png/20210423103408.png)