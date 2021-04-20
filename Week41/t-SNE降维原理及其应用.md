# t-SNE降维原理及其应用

### 概念

降维：就是指采用某种映射方法，将原高维空间中的数据点映射到低维度的空间中。降维的本质是学习一个映射函数 f : x→y，其中x是原始数据点的表达，目前最多使用向量表达形式。 y是数据点映射后的低维向量表达，通常y的维度小于x的维度（当然提高维度也是可以的）。f可能是显式的或隐式的、线性的或非线性的。

## 降维方式

![降维方式分类](https://i.loli.net/2021/04/07/a16Hdn7iKGO4RPM.jpg)

### 线性降维

​		PCA： PCA是最常用的无监督线性降维方法，它的目标是通过某种线性投影，将高维的数据映射到低维的空间中，并期望在所投影的维度上数据的方差最大，以此使用较少的维度，同时保留较多原数据的维度。

​		LDA：线性判别分析LDA是一种有监督的线性降维算法,它的数据集的每个样本是有类别输出的,而PCA是不考虑样本类别输出的无监督降维技术。LDA与PCA不同，它是为了使降维后的数据点尽可能地容易被区分，它的思想用一句话概括，就是**“投影后类内方差最小，类间方差最大”。**

![PCA](https://i.loli.net/2021/04/07/vYtV2jAqZk4Qg3x.png)

![LDA](https://i.loli.net/2021/04/07/bh6NfgZFrz5OR7a.png)

### 非线性降维

线性降维方法，有时候数据之间的非线性关系是很重要的，这时候我们用线性降维会得到很差的结果。对于图像、文本、金融等高维数据，特征之间存在着极为复杂的非线性关系，简单的线性分析无法挖掘出特征之间的蕴含的关联，因此，有必要对内蕴特征进行探讨！

#### 全局

​	ISOMAP：(Isometric Feature Mapping, 等距离特征映射),是一种非线性降维方法,其基于度量MDS,试图保留数据内在的由测地线距离蕴含的几何结构。其算法步骤为，先构建邻接图，然后计算最短路径，最后通过MSD构建低纬的数据嵌入。

#### 局部

​	LLE：局部线性嵌入(Locally Linear Embedding，LLE)是非常重要的降维方法。和传统的PCA，LDA等关注样本方差的降维方法相比，LLE关注于降维时保持样本局部的线性特征（保持原有拓扑结构），由于LLE在降维时保持了样本的局部特征，它广泛的用于图像识别，高维数据可视化等领域。

![各种降维](https://i.loli.net/2021/04/08/6qQkr4F73TRId1f.png)

### 各种降维的优缺点

各种降维方式的优缺点

![优缺点](https://i.loli.net/2021/04/08/I1pzMbLhkZdx5JT.png)

## t-SNE

t-SNE（t-Distributed 随机邻域嵌入），将数据点之间的相似度转换为概率。原始空间中的相似度由高斯联合概率表示，嵌入空间的相似度由“学生t分布”表示。虽然Isomap，LLE和variants等数据降维和可视化方法，更适合展开单个连续的低维的manifold。但如果要准确的可视化样本间的相似度关系，t-SNE表现更好。因为**t-SNE主要是关注数据的局部结构**。

### 数学原理

#### t-SNE公式

同时保留局部结构，除了计算距离外，还将其转换为概率

![t-sne公式1](https://i.loli.net/2021/04/08/CSbfsQEF67iD9pv.png)

### t-SNE前身，SNE

#### 相似性计算

先计算原始空间（高维）的数据的相似性，通过计算每个点和其它点之间的距离，i是资料点，j是除了i以外的其它资料点。计算完之后，将其放入高斯方程，通过高斯分布计算点j为点i邻居的可能性。在低维空间随机计算yi和yj。获得低维空间上i和j是邻居的概率，让在低维空间上j个i两个点的概率和高维空间上两个点的概率越相似越好。

![sne公式1](https://i.loli.net/2021/04/08/NvYpbtjdgxrHa4h.png)

#### 损失函数

使用KL距离来衡量高维空间的分布和低维空间分布的相似程度

![tsne损失函数](https://i.loli.net/2021/04/08/h3tglTKVQu9EOwm.png)

##### KL距离

KL距离，是Kullback-Leibler差异（Kullback-Leibler Divergence）的简称，也叫做相对熵（RelativeEntropy）。**它衡量的是相同事件空间里的两个概率分布的差异情况**。公式为：

![KL公式](https://i.loli.net/2021/04/08/CLcVSXhfzl3YONB.png)



### 缺点

SNE降维之后，可能会存在拥挤的问题，导致即使可以从高维降低到低维，但是仍然无法分辨。

![降维问题](https://i.loli.net/2021/04/08/X3dkMcQrKhtNfiC.png)

#### 解决方式

使用t分布

高斯分布的情况下，远点到3/4的概率在数字上可能差的很小，导致无法有效的区分开3/4的差别。转换成t分布之后，可以有效的区分开远距离的点。

##### ![t分布](https://i.loli.net/2021/04/08/WdBJa8O7IpKxU4V.png)

## t-SNE

高维空间仍然用高斯分布，在低维空间用t分布

![t-sne](https://i.loli.net/2021/04/08/VWJGr3Dt6lUThAy.png)

决定分布情况的参数：σ

σ太大：越拥挤，无法将点有效区分开

σ太小：越离散，不能保留高维数据的局部结构

#### 困惑度

困惑度可以解释为一个点附近的有效近邻点个数。**SNE对困惑度的调整通常选择5-50之间**，给定之后，使用二分搜索的方式寻找合适的σ

![困惑度](https://i.loli.net/2021/04/08/f7W9IU3uZoySVvP.png)



#### 损失函数

![损失函数](https://i.loli.net/2021/04/08/LZMJgdiCpF2E1Ua.png)



### 具体过程

以二维空间为例，假设我们现在需要将二维平面上分布的点降到一维直线上，如果我们直接将这些点投放在x轴或者y轴，不同颜色/cluster的点会会混合在一起。

![具体过程](https://i.loli.net/2021/04/08/hw7ypVLKuP39k6U.png)

#### 第一步

计算二维平面上所有点的相似性(similarity)。

首先计算黑色点和其周围点的距离(此处暂时以两个点为例，黑色和蓝色)，然后将这两个点排放在以黑色点为中心的正态曲线下，接下来计算蓝色点到正态曲线的长度(unscaled similarity distance，也成为similarity score)。

进而，我们获得了黑色点同其余所有点的similarity scores。similarity score大，表明两个点在二维平面上的距离近；相对的，表明两个点在二维平面上的距离远。



![step2](https://i.loli.net/2021/04/08/nMfN9E1QA6hGSlD.png)

#### 第二步

获得黑色点同其余所有点的similarity score后，我们需要对这些scores进行标准化，使得它们加和为1。

为什么要进行标准化处理呢？假设平面上有一个新紫色的cluster(我们暂且认为紫色cluster的分布和蓝色cluster完全一样，只是密度(density)是蓝色cluster的两倍，那么紫色cluster正态曲线的宽度也会是蓝色cluster的两倍(正态曲线的高度和宽度由方差决定))，

进行标准化处理后，这两个cluster的similarity score就是一样的了(t-SNE可以同时保留数据的局部和全局结构)。

接下来我们会获得每一个点同其余所有点的scaled similarity scores，scaled similarity scores代表cluster的相对紧密度。

![step3](https://i.loli.net/2021/04/08/VvCpPniIQ3fToW5.png)

#### 第三步

由于每一个点所对应正态曲线的宽度是由其周围点分布的紧密度来决定的。那么两个点之间，前后两次计算的similarity scores可能会不同。所以t-SNE会将这两个点的similarity score求均值。最终，我们可以获得一个矩阵，每一行/列表示这个点同其他点的similarity score。



![step4](https://i.loli.net/2021/04/08/89jwTMRxgptuc1b.png)

#### 第四步

计算一维直线上所有点的similarity scores。

同之前计算二维平面上点的计算过程一般，选择一个指定的点，然后计算其同周围点的距离，进而获得similarity scores。只是这次使用的曲线从正态分布变为t分布。此时获得的矩阵比上面那个矩阵显得混乱一些。t-SNE每次移动一下直线上的点，移动的目的是为了让上图左边的矩阵变得像右边一样。

![step5](https://i.loli.net/2021/04/08/5QRbXzHDeu3lgOC.png)

### t-SNE优缺点

##### 	  优点

- 对于不相似的点，用一个较小的距离会产生较大的梯度来让这些点排斥开来。

- 这种排斥又不会无限大(梯度中分母)，避免不相似的点距离太远。

  ##### 缺点

- 主要用于可视化，很难用于其他目的。
- t-SNE倾向于保存局部特征，对于本征维数(intrinsic dimensionality)本身就很高的数据集，是不可能完整的映射到2-3维的空间
- 全局结构未明确保留。这个问题可以通过PCA初始化点（使用`init ='pca'`）来缓解。
- 计算量大，耗时间是PCA的百倍，内存占用大。

### 应用

**1、识别肿瘤亚群（医学成像）**

质谱成像（MSI）是一种同时提供组织中数百个生物分子的空间分布的技术。 t-SNE，通过数据的非线性可视化，能够更好地解析生物分子肿瘤内异质性。

**2、 人脸识别**

人脸识别技术已经取得巨大进展，很多诸如PCA之类的算法也已经在该领域被研究过。但是由于降维和分类的困难，人脸识别依然具有挑战性。t-SNE被用于高维度数据降维，然后用其它算法，例如 AdaBoostM2, 随机森林, 逻辑回归, 神经网络等多级分类器做表情分类。



## R语言实现

#### Rtsne包

主要参数

| 参数       | 功能                                                         |
| :--------- | ------------------------------------------------------------ |
| dims       | 参数设置降维之后的维度，默认是2                              |
| perplexity | 困惑度，参数须取值小于(nrow(data)-1)/3                       |
| theta      | 参数越大，结果的准确度越低，默认是0.5                        |
| max_iter   | 最大迭代次数                                                 |
| pca        | 表示是否对输入的原始数据进行PCA分析，然后用分析后的数据进行后续分析 |

1、用t-SNE对iris数据进行降维

```R
remove(list = ls())
BiocManager::install("Rtsne")
library(Rtsne)
iris_unique <- unique(iris) #去重复
tsne_out <- Rtsne(as.matrix(iris_unique[,1:4])) #运行t-SNE
plot(tsne_out$Y,col=iris$Species,asp=1)
```

![test1](https://i.loli.net/2021/04/09/6uURYMvsw31289Q.png)

2、使用MNIST数据集进行t-SNE测试

```R
train<- read.csv("train.csv")  
library(Rtsne)
Labels<-train$label
train$label<-as.factor(train$label)

colors = rainbow(length(unique(train$label)))
names(colors) = unique(train$label)

tsne <- Rtsne(train[,-1], dims = 2, perplexity=30, max_iter = 500)

## 绘图
plot(tsne$Y, t='n', main="tsne")
text(tsne$Y, labels=train$label, col=colors[train$label])
```

![test2](https://i.loli.net/2021/04/09/91Mi4JsjkTSmVxh.png)



#### 参考资料（转自）

1、https://www.youtube.com/watch?v=5d26dO5LVe0（主要参考）

2、https://yuehhua.github.io/slides/（主要参考）

3、https://www.jianshu.com/p/700f017cd330?from=singlemessage（主要参考）

4、https://www.analyticsvidhya.com/blog/2017/01/t-sne-implementation-r-python/

5、https://www.jianshu.com/p/75e805ff247c

6、https://blog.csdn.net/qq_44702847/article/details/95190388

7、https://blog.csdn.net/weixin_34279246/article/details/90102855

8、https://distill.pub/2016/misread-tsne/

9、https://blog.csdn.net/qq_16236875/article/details/89157360

10、http://www.datakit.cn/blog/2017/02/05/t_sne_full.html#25-%E4%B8%8D%E8%B6%B3