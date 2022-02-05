### 什么是多线程？
这里的多线程其实是指**并行计算**。
简单来讲，就是同时使用多个计算资源来解决一个计算问题，是提高计算机系统计算速度和处理能力的一种有效手段。
基本可以分成以下几种情况：

- 一个问题被分解成为一系列可以并发执行的离散部分；
- 每个部分可以进一步被分解成为一系列离散指令；
- 来自每个部分的指令可以在不同的处理器上被同时执行；
- 需要一个总体的控制/协作机制来负责对不同部分的执行情况进行调度。

平时在一台电脑或者服务器上，将我们的计算任务分散到多个不同的小的核中同时进行处理。
                                                                         ![](https://gitee.com/KKAres/pictures/raw/master/png/20210521150013.png)

### 什么地方可以用到并行计算？
并行操作一般适用于**重复**的操作，比如重复随机按照相同分布生成数据，然后分别同时进行计算。
但诸如迭代，递归等算法就很难用并行实现，这种都叫串行。因为后一个的对象需要前一个对象的信息，只能先算完前一个，再计算后一个内容。


### R中常用的并行操作
下面介绍两种R中常用的并行操作（默认会apply族相关操作）。
#### parallel包
此包最大的优势就是非常的便捷，只需将我们原本的`apply()`修改为`parApply()`；`lapply()`修改为`parLapply()`；`sapply()`修改为我们常用的`parSapply()`等等，然后再在开头和结尾添加上相应的开始并行与结束并行的语句即可。

1. 包中常用函数：
- `detectCores()` 检查当前的可用核数
- `clusterExport()` 配置当前环境
- `makeCluster()` 分配核数
- `stopCluster()` 关闭集群
- `parLapply()` lapply()函数的并行版本：`parLapply()`函数与`lapply()`函数一样的用法，只不过多了一个多核的参数，另外它也是返回的一个列表`list()`。



2. 简单代码实战
```r
install.packages("parallel")
library(parallel)

#首先我们使用lapply()进行下述操作向量化操作：
lapply(1:3, function(x) c(x, x ^ 2, x ^ 3))

#修改为并行方法:
#计算可用线程数，并设置并行使用线程数
cores <- detectCores() - 1
#初始化
cl <- makeCluster(cores)
#然后修改原本我们lapply()的命令：
parLapply(cl, 1:3, function(x) c(x, x ^ 2, x ^ 3))
#最后结束我们的并行，释放我们用到的线程与内存，返还给系统：
stopCluster(cl)
```
在执行的过程中，先前导入外部的包是没有用的，也就是只有在执行的过程中导入才有用。也就是说需要在`parLapply()`执行的`function()`中导入那些需要的包才有用，或者使用parallel包中的`clusterExport()`事先导入需要的包。


3. 注意

有的时候可能因为数据量过大，虽然线程数合适，但是内存爆满错误，解决方法有：

- 使用更少的线程进行并行
- 如果你的电脑内存非常小，有一个简单的方法确定你的最大使用线程：`max cores = memory.limit() / memory.size()`
- 将大量的并行分小部分进行
- 在代码中多使用`rm()`删除没用的变量，使用`gc()`回收内存空间
- 另外也可以采用snowfall包



#### snowfall包
相比于parallel来说，snowfall操作有点复杂，但有着更稳定的优势。很多时候我们将大量的计算任务挂到服务器上进行运行时，更看重的是其稳定性。同样，包里`sfLapply()`的操作是与`lapply()`相对应的。类似地，还有`sfSapply()`、`sfApply()`等函数，其用法与`apply`组中的函数也基本一致。

1. 包中常用函数：
- `detectCores()` 检查当前的可用核数
- `clusterExport()` 配置当前环境
- `sfInit()` 并行初始化（包括分配核数）
- `sfStop()` 关闭集群
- `sfLapply()` lapply()函数的并行版本




2. 简单代码实战

其思路和`parallel` 一样，使用起来都是分为三个主要步骤：初始化并行、操作并行、结束并行并返还内存。
与之前一样操作的代码如下：
```r
install.packages("snowfall")
library(snowfall)  # 载入snowfall包

# 并行初始化
sfInit(parallel = TRUE, cpus = 3)

# 进行lapply的并行操作
sfLapply(1:3, function(x) c(x, x ^ 2, x ^ 3))

# 结束并行，返还内存等资源
sfStop()
```
在实际操作时，我们进行的函数往往没有这么简单，往往还需要依赖一些其它的函数、变量、R包等，这时就不能用上述的方法简单的进行操作了。
下面给出一个具体实际的操作案例，来展示**如何载入**函数中依赖的对象等参数。

```r
#利用上次bootstrap讲到过的鱼塘函数，假设我们需要对3个不同鱼塘进行同样boot运算:
fishes1 <- sample(1:3, size= 1000, replace= T)
fishes1[1:10]= 0
fishes2 <- sample(1:3, size= 1000, replace= T)
fishes2[1:15]= 0
fishes3 <- sample(1:3, size= 1000, replace= T)
fishes3[1:20]= 0

fishes <- list(fishes1,fishes2,fishes3)

#计算鱼塘分布的function
markedfish <- function(data,indices){
  indices= data 
  n= sample(indices, size= 100)
  num= length(n[n==0])
  x= num/100
  return(x)
}
#并行计算的function
myfun <- function(i) {
  results <- boot(data= i, statistic= markedfish, R= 1000)
  d <- print(results)
  p <- plot(results) 
}

sfInit(parallel = T, cpus = 3) #初始化

sfLibrary(boot)     # 载入依赖R包boot

sfExport("fishes")         # 载入依赖的对象
sfExport("markedfish")   # 载入依赖的函数

# 并行计算
result <- sfLapply(fishes, myfun) 
#注意：myfun是自己定义的函数，里面需要用到包boot；变量fishes；函数markedfish。

sfStop() # 结束并行
```
**当函数或者对象非常多时,我们可将所有的对象与函数存到`allfun.R`文件夹中，然后再采用`sfSource('allfun.R')`将所有的对象与函数进行导入，方便快捷。**

3. 注意

实际运行中，发现myfun中不能保存压缩文件（.Rdata等），具体检索了一下仍未知理由是啥，大家可以自行探索一下。

---

- reference：

[https://www.jianshu.com/p/3882ea7b9cc9](https://www.jianshu.com/p/3882ea7b9cc9)
[https://blog.csdn.net/weixin_41929524/article/details/81707053](https://blog.csdn.net/weixin_41929524/article/details/81707053)
[https://blog.csdn.net/weixin_41929524/article/details/81742322](https://blog.csdn.net/weixin_41929524/article/details/81742322)
[https://blog.csdn.net/binyi_10/article/details/77874459#r-%E8%AF%AD%E8%A8%80%E5%A4%9A%E7%BA%BF%E7%A8%8B](https://blog.csdn.net/binyi_10/article/details/77874459#r-%E8%AF%AD%E8%A8%80%E5%A4%9A%E7%BA%BF%E7%A8%8B)
[https://blog.csdn.net/magicbean2/article/details/75174859](https://blog.csdn.net/magicbean2/article/details/75174859)
