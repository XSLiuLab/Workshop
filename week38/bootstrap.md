### 简介
Bootstrap（自助法、自举法）是非参数统计中一种重要的估计统计量方差进而进行区间估计的统计方法。指用原样本自身的数据再抽样得出新的样本及统计量，根据其意现在普遍将其译为“自助法”或“自举法”。其最初由美国斯坦福大学统计学教授Efron在1977年提出。作为现代统计学较为流行的一种统计方法，Bootstrap在小样本时效果很好。


### 统计学原理
1.Bootstrap的一般的抽样方式都是“有放回地全抽”，意思就是抽取的Bootstrap样本量与原样本相同，只是在抽样方式上采取有放回地抽，（其实样本量也要视情况而定，不一定非要与原样本量相等）这样的抽样可以进行B次，每次都可以求一个相应的统计量/估计量，最后看看这个统计量的稳定性如何（用方差表示）。 

![](https://gitee.com/KKAres/pictures/raw/master/png/bootstrap.png)
核心思想就是重抽样。如图，如果不知道总体分布（或叫理论分布），那么，对总体分布的最好猜测便是由样本数据提供的（经验）分布。
自助法的要点是：①假定观察值便是总体；②由这一假定的总体抽取样本，即再抽样。
由原始数据经过**重复有放回抽样**所获得的与原始数据集含量相等的样本称为再抽样样本(resamples)或自助样本(bootstrapsamples)。如果将由原始数据集计算所得的统计量称为观察统计量(observed statistic)，那么由再抽样样本计算所得的统计量称为自助统计量(bootstrap statistic)。自助法的关键思想是假设自助统计量与观察统计量间的关系等同于观察统计量与真值间的关系成立，可表示为：
**自助统计量：：观察统计量<=>观察统计量：：真值**
其中，“：：”表示二者间的关系，“<=>”表示等价于。也就是说，通过对自助统计量的研究，就可以了解有关观察统计量与真值的偏离情况。
其基本思路如下：
  （1） 采用再抽样技术(有返还的抽样(sampling with replacement)方式)从原始样本中抽取一定数量（自己给定）的样本，此过程允许重复抽样;
  （2） 根据抽出的样本计算给定的统计量T;
  （3） 重复上述N次（一般大于1000），得到N个统计量T;
  （4） 计算上述N个统计量T的样本方差，得到统计量的方差。

2.Bootstrap和常规统计方法之间的主要区别
主要区别在于对抽样分布的估计方式。
常规的假设检验程序通常假定数据遵循特殊的分布，如[T检验](https://mp.weixin.qq.com/s?__biz=MzIxNzc1Mzk3NQ==&mid=2247483879&idx=1&sn=62c4f96a9fb331363304678bbb5dd0cd&chksm=97f5b1ffa08238e9873944636d225b723e850b3dc7552caf8da06866c5c911c82f352af71584&token=352508908&lang=zh_CN&scene=21#wechat_redirect)、[方差分析](https://mp.weixin.qq.com/s?__biz=MzIxNzc1Mzk3NQ==&mid=2247483907&idx=1&sn=0f1085f312d000e995b6914b3b20a78f&chksm=97f5b21ba0823b0dfbcee511b9e5296fa7de232ed9e3496ef23c4d57bb53a4ee985bcdae1c85&token=271527172&lang=zh_CN&scene=21#wechat_redirect)等参数检验要求正态分布，并使用样本数据的性质、实验设计和检验统计量来估计抽样分布的方程式。因此为了获得有效的结果，需要考虑适当的测试统计数据并满足检验的前提假设。
与此相比，bootstrap不对数据的分布做任何假设。对于bootstrap估计抽样分布的方法，将一项研究获得的样本数据进行多次重抽样，创建多个模拟样本集，该方法中**不考虑原数据集的固有分布特征，以及特定的前提假设等**。因此所获得的每个模拟数据集都允许有自己的任意的属性，例如均值，使用直方图表示这些均值的分布时，可以观察到均值的抽样分布特征。随后，使用获得的抽样分布作为置信区间和假设检验的基础。
此外，如果样本均值服从正态分布或其它特定理论分布，则bootstrap就不存在优势（非参数方法普遍存在这个特点，其它如[置换检验](https://mp.weixin.qq.com/s?__biz=MzIxNzc1Mzk3NQ==&mid=2247484565&idx=1&sn=1cf88df58e7f34aa85dbdcb207249663&chksm=97f5b48da0823d9baac724631a3775bbc33249e407e7aa4e6171060acbb4be352bc331095e91&token=1741038315&lang=zh_CN&scene=21#wechat_redirect)、[Kruskal-Wallis检验](https://mp.weixin.qq.com/s?__biz=MzIxNzc1Mzk3NQ==&mid=2247483969&idx=1&sn=212c14116b4604687aad1081dab6ebc2&chksm=97f5b259a0823b4fe3126c2c10146c473798d43bf46b219f78e51a0f5d3e4649cd9518a093e4&token=585453689&lang=zh_CN&scene=21#wechat_redirect)、[Wilcoxon检验](https://mp.weixin.qq.com/s?__biz=MzIxNzc1Mzk3NQ==&mid=2247483969&idx=1&sn=212c14116b4604687aad1081dab6ebc2&chksm=97f5b259a0823b4fe3126c2c10146c473798d43bf46b219f78e51a0f5d3e4649cd9518a093e4&token=271527172&lang=zh_CN&scene=21#wechat_redirect)等），此时参数检验方法仍是首选。


### 相关R包boot的应用
boot扩展了自助法和重抽样的相关用途，可以借助它实现对一个统计量（如单个均值、单个中位数等，为一个数值）或多个统计量（如多变量间的相关系数、一列回归系数等，为一个数值向量）使用自助法。
基本有三个步骤：
(1) 写一个能返回待研究统计量值的函数。如果只有单个统计量（如中位数），函数应该返回一个数值；如果有一列统计量（如一列回归系数），函数应该返回一个向量。
(2) 为生成R中自助法所需的有效统计量重复数，使用boot()函数对上面所写的函数进行处理。
(3) 使用boot.ci()函数获取(2)生成的统计量的置信区间。
```r
#生成boot对象
bootobject <- boot(data = , statistic = , R = , …)
##参数介绍：
### data 为向量、矩阵或数据框
### statistic 生成k个统计量以供自举的函数（k=1时对单个统计量进行自助抽样）
###           函数需要包括indices参数，以便boot()函数用它从每个重复中选择实例
### R 为自助抽样的次数
### ... 其他对生成待研究统计量有用的参数，可在函数中传输
##boot()函数调用统计量函数R次，每次都从1：nrow(data)中生成一列有放回的随机指标，这些指标被统计量函数用来选择样本。
##统计量将根据所选样本进行计算，结果存储在bootobject中，其中返回元素有：
##t0:从原始数据得到的k个统计量的观测值/t:一个R*k的矩阵，每行即k个统计量的自助重复值。
##一旦生成自助样本，可通过print()和plot()来检查结果。

#获取统计量的置信区间
boot.ci(bootobject, conf = , type = )
##参数介绍：
### conf 预期的置信区间，默认conf = 0.95
### type 返回置信区间的类型，可能为norm, basic, stud, perc, bca, all（默认为all）
###      其设定了获取置信区间的方法。比如perc方法（分位数）展示的是样本均值，bca将根据偏差对区间做简单调整。      
```
这里举个简单的例子运用一下boot的bootstrap的功能。
问题：假设有一个鱼塘有1000条鱼，但人们不知道该鱼数量。（设定统计期间鱼的数量没有发生变化）如果要估计整个鱼塘的数量可以进行如下操作：

```r
#创造鱼塘(非正态分布)，设一个随机数代表一条鱼
fishes <- sample(1:3, size= 1000, replace= T)
fishes
qqnorm(fishes)
qqline(fishes)
```
（*此Q-Q图，Q是quantile的缩写，即分位数。 **分位数就是将数据从小到大排序，然后切成100份，看不同位置处的值。**比如中位数，就是中间位置的值。Q-Q图的x轴为分位数，y轴为分位数对应的样本值。x-y是散点图的形式，通过散点图可以拟合出一条直线， **如果这条直线是从左下角到右上角的一条直线，则可以判断数据符合正态分布，否则则不可以。**）

把鱼塘封闭，排除干扰因素。然后捞10条鱼上来并做好标记（假设标记不会损坏，也不会脱落），再把它们放回鱼塘。等待一个晚上甚至一天，保证鱼群充分混合，即随机抽样。然后开始捞鱼，每次捞100条，记录**有标记的鱼的数量以及比例**，再放回去，再等一晚，再捞100条，记录数据……重复整个过程1000次，建立分布。按照这个分布可以计算每次捞上来的带标记鱼比例的置信区间，以此推断整个鱼塘的鱼数量。
```r
#用0标记十条鱼
fishes[1:10]= 0
fishes
#首要任务是写一个获取有标记的鱼的数量以及比例的函数
library(boot)
markedfish <- function(data,indices){
  indices= data 
  n= sample(indices, size= 100)
  num= length(n[n==0])
  x= num/100
  return(x)
}
#开始自助抽样
results <- boot(data= fishes, statistic= markedfish, R= 1000)
#boot对象输出
print(results)
plot(results)
#则其95%置信区间可得
boot.ci(results, type= c("perc"))
```
统计后发现每次捕鱼中标记鱼的比例的95%置信区间为[0-0.03]，所以，我们可以鱼塘中鱼的数量的区间为（100/0,100/0.03]。所以在小样本的时候，bootstrap效果才较好。如果是大样本，bootstrap的效果就不怎么好，比如你想统计海里有多少条鱼，很明显捞鱼标记的方法就不适用。


### 参考
[https://blog.csdn.net/gsthyx/article/details/108053023](https://blog.csdn.net/gsthyx/article/details/108053023)
[https://mp.weixin.qq.com/s/NAs4g0h4VTOs0FKyYW1CGg](https://mp.weixin.qq.com/s/NAs4g0h4VTOs0FKyYW1CGg)
R in Action-Data analysis and graphics with R - SECOND EDITION（ROBERT I. KABACOFF ; ISBN: 9781617291388）




