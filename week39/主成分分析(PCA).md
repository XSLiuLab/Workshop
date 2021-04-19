# 主成分分析 Principal Component Analysis

## 定义

### 百度：

通过正交变换将一组可能存在相关性的变量转换为一组线性不相关的变量，转换后的这组变量被称为主成分。换句话来说是，当变量较多时，有些变量所反应的信息是重复的，主成分分析可以将重复信息的变量删去，尽量保留下相关性不高的变量，这些变量能更好的反应数据的特征。多用于数据的降维。

### wiki：

PCA is used in exploratory data analysis and for making predictive models. It is commonly used for dimensionality reduction by projecting each data point onto only the first few principal components to obtain lower-dimensional data while preserving as much of the data's variation as possible. The first principal component can equivalently be defined as a direction that**maximizes the variance of the projected data**. The$$i^{th}$$principal component can be taken as a direction orthogonal to the first$$i-1$$principal components that maximizes the variance of the projected data.

## 更好的描述：

PCA是将n维特征映射到k维上，k维是全新的正交特征，将原有的n维特征的基础上重新构造成k维特征。它的工作就是先找到一个坐标轴，是全部数据映射到这个坐标轴的方差最大，让后再取一个与第一个坐标轴垂直并且方差做大的坐标轴，依次直接取到n维。

### 数据降维理解的简单例子

比如在一堆运动员中，我们想确定这个运动员是谁，这些信息中，相较于国籍，性别，年龄这些非重要的因素，他们的专业项目更有利于我们来确定他们的是谁，所以说这算是主成分之一。

## 计算原理

图片来源：[StatQuest系列视频](https://www.youtube.com/watch?v=FgakZw6K1QQ&list=PLQbq_FuiHHA2cTHpDhaiLRwJLh6CFOGMh&index=3&fileGuid=KxyhJ6cqkWWGTk8V)

![图片](https://uploader.shimo.im/f/6FWcjliCGFAcqtU3.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)
首先是以这三组不同的数据为例，分别可以用一维，二维，三维的坐标系来展示出来，我们可以根据它们的分布来判断每组数据的状态。i.e.

但是对于四维或更多的数据，我们不能很好的直观的展示出数据的数据的特征，所以需要进行降维的处理。

对于首先我们还是使用2维的数据，这样方便理解。![图片](https://uploader.shimo.im/f/OlTTahOOlLPLu0Zk.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)

中心化：我们求出这个数据中横纵坐标的均值，并将它所对应的点定为原点。接下来我们要做的是拟合一条直线，这条直线要满足所有点到该直线的距离最短，也就是最小二乘法来确定。![图片](https://uploader.shimo.im/f/aWzQgEuBTfjmnlyO.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)

那么为啥么要用这个距离最短来拟合这条曲线呢？下面有一个很好的例子：

![图片](https://uploader.shimo.im/f/wI1wOXxxCDFteLDS.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)
这种情况是各点恰巧再同一条直线上，当我们移动坐标系到这条直线上时，仅由数据的横坐标就可以反应数据的整体情况。

![图片](https://uploader.shimo.im/f/y3R2ct2du5NRCtwu.gif?fileGuid=KxyhJ6cqkWWGTk8V)


因为y轴为零，所以它对数据没有影响，并且这个横坐标也改为了房价和面积这两个综合因素。

![图片](https://uploader.shimo.im/f/ZDtxsC1Nzt04T2Yl.png!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)
话题回来，当不是这种极端情况的时候，所有数据点不是通过同一条直线的时候，此时需要拟合这条直线，而我们的目的是让另一个因素对数据的影响量最小，所以我们要取这个距离的最小值。

![图片](https://uploader.shimo.im/f/FvEkKW1qBgMFqptQ.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)

由于勾股定理我们可以知道，求垂直距离的最小值，也即是求该点投影到这条直线的到原点距离平方的最大值。

拟合出的这条曲线我们成为PC1（主成分1）。

![图片](https://uploader.shimo.im/f/7VJV8ExvgEWjde0r.jpg!thumbnail?fileGuid=KxyhJ6cqkWWGTk8V)


通过上述的的方式我们就完成了这个数据的主成分分析。这主要是从一步步绘图的层面来进行的。

另一方面我们可以从向量的角度来看一下怎样通过主成分分析给它降维：

这个主要参考的是知乎的这个内容：[马同学](https://www.zhihu.com/question/41120789/answer/481966094?fileGuid=KxyhJ6cqkWWGTk8V)


#参考内容

[https://www.zhihu.com/question/41120789/answer/481966094](https://www.zhihu.com/question/41120789/answer/481966094?fileGuid=KxyhJ6cqkWWGTk8V)

[https://www.youtube.com/watch?v=FgakZw6K1QQ&list=PLQbq_FuiHHA2cTHpDhaiLRwJLh6CFOGMh&index=2](https://www.youtube.com/watch?v=FgakZw6K1QQ&list=PLQbq_FuiHHA2cTHpDhaiLRwJLh6CFOGMh&index=2&fileGuid=KxyhJ6cqkWWGTk8V)

