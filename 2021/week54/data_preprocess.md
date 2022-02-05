---
title: 数据预处理
author: wutao
date: 2021-08-20 10:00:00
slug: ML
categories:
  - python
  - ML
index_img: img/data_preprocess.png
---



数据预处理相关知识及 Scikit-learn 的实现，包括 Data transformation，Encoding categorical features，和 Imputation of missing values

<!-- more -->

## 数据转化

为什么要做数据转化（data transformation）：

-   转化数据可以来满足某些模型的统计学假设，比如正态性，同质性，线性等
-   数据转化可以将不同变量的数据缩放到可以比较的范围上，比如数据中一个变量是价格，另一个变量是重量。

数据转化就是在原数据上使用某个函数将原数据进行运算得到转化后的数据，数据转化的方法：

-   单调转化：不改变数据的秩，不依赖于其他数据
-   相对转化（Standardization）
-   概率转化（Smoothing） 

### Standardization

Standardization 指的是将数据减去其均值，除以标准差，使得数据的均值为 0，方差为 1. 注意 Standardization 处理后的数据并不一定服从正态分布。

``` python
from sklearn import preprocessing
import numpy as np
X_train = np.array([[ 1., -1.,  2.],
                    [ 2.,  0.,  0.],
                    [ 0.,  1., -1.]])
scaler = preprocessing.StandardScaler().fit(X_train)
scaler
>> StandardScaler()
```

``` python
scaler.mean_
>> array([1.        , 0.        , 0.33333333])
```

``` python
scaler.scale_
>> array([0.81649658, 0.81649658, 1.24721913])
```

``` python
scaler.scale_ == X_train.std(axis=0) ##这里的scale_就是std
>> array([ True,  True,  True])
```

**fit** 就是从数据中学到东西，这里就是mean 和 std，**transform** 就是利用学到的东西对数据进行转化，这两步也可以合为一步：**fit_transform**。

``` python
X_scaled = scaler.transform(X_train)
X_scaled
>> array([[ 0.        , -1.22474487,  1.33630621],
>>        [ 1.22474487,  0.        , -0.26726124],
>>        [-1.22474487,  1.22474487, -1.06904497]])
```

``` python
##验证一下
print(X_scaled.mean(axis=0))
>> [0. 0. 0.]
print(X_scaled.std(axis=0))
>> [1. 1. 1.]
```

另一种 Scale 的方法为将特征缩放到给定的范围，可以是规定最小最大值，如在 [0,1\] 之间，或者是规定数值的范围，比如最大值和最小值的差在 1 之内，分别通过 `MinMaxScaler` 和 `MaxAbsScaler` 实现。`MinMaxScaler(feature_range=0, 1)` 进行的操作是:

``` python
X_std = (X - X.min(axis=0)) / (X.max(axis=0) - X.min(axis=0))
X_scaled = X_std * (max - min) + min
```

``` python
X_train = np.array([[ 1., -1.,  2.],
                    [ 2.,  0.,  0.],
                    [ 0.,  1., -1.]])
min_max_scaler = preprocessing.MinMaxScaler()
X_train_minmax = min_max_scaler.fit_transform(X_train)
X_train_minmax
>> array([[0.5       , 0.        , 1.        ],
>>        [1.        , 0.5       , 0.33333333],
>>        [0.        , 1.        , 0.        ]])
```

``` python
##用训练集中“学习”到的最大值和最小值来对测试集进行 transform
X_test = np.array([[-3,-1,4]])
X_test_minmax = min_max_scaler.transform(X_test)
X_test_minmax
>> array([[-1.5       ,  0.        ,  1.66666667]])
```

``` python
##获取scale 和 min （学习到的内容）
print(min_max_scaler.scale_)
>> [0.5        0.5        0.33333333]
print(min_max_scaler.min_)
>> [0.         0.5        0.33333333]
```

`MaxAbsScaler` 将每个特征除以该特征的最大值，因此使得特征的数值范围在 [-1,1\] ：

``` python
max_abs_scaler = preprocessing.MaxAbsScaler()
X_train_maxabs = max_abs_scaler.fit_transform(X_train)
X_train_maxabs
>> array([[ 0.5, -1. ,  1. ],
>>        [ 1. ,  0. ,  0. ],
>>        [ 0. ,  1. , -0.5]])
```

``` python
print(max_abs_scaler.scale_ == max_abs_scaler.max_abs_)
>> [ True  True  True]
print(max_abs_scaler.scale_)
>> [2. 1. 2.]
```

### 非线性转化

有两类常用的非线性转化：分位数转化（quantile transforms）和幂转化（power transforms）；这两种转化都是单调转化，因此会保留原始数据的排序信息。在 scikit-learn 中分别使用 `QuantileTransformer` 和 `PowerTransformer` 来进行分位数转化和幂转化。

#### 分位数转化（quantile transforms）

`QuantileTransformer` 是一种非参数的数据转化技术，可以将数据转化到特定的分布（一般是高斯分布或者均匀分布），通过分位数函数来实现。

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/1280px-Quantile_distribution_function.svg.png" style="zoom:50%" />

The cumulative distribution function (shown as F(x)) gives the p values as a function of the q values. The quantile function does the opposite: it gives the q values as a function of the p values.
也就是累积分布函数的自变量是 X 轴，给定一个数可以得到一个概率，而分位数函数是累计分布函数的逆函数，自变量是 y轴。 分位数转化是通过下面的函数作用于原数据得到转化后的数据：
$$
G^{-1}(F(X))
$$
其中 F(X) 是原始数据的累积分布函数，G 是我们想要转化得到的分布的分位数函数。比如我们想要将原始数据转化为均值为0， 方差为 1 的正态分布，那么首先要得到 F(X)，也就是原数据中对应的分位数，然后再用正态分布的分位数函数进行转化。

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210818215720349(1).png)

``` python
import seaborn as sns
import numpy as np
from sklearn.preprocessing import QuantileTransformer
import pandas as pd
#Using mpg data
mpg = pd.read_csv("mpg.csv")

quantile_transformer = QuantileTransformer(random_state=0,  output_distribution='normal')
mpg['mpg_trans'] = pd.Series(quantile_transformer.fit_transform(np.array(mpg['mpg']).reshape(-1, 1))[:,0])
>> C:\Users\lenovo\AppData\Local\Programs\Python\Python39\lib\site-packages\sklearn\preprocessing\_data.py:2612: UserWarning: n_quantiles (1000) is greater than the total number of samples (398). n_quantiles is set to n_samples.
>>   warnings.warn("n_quantiles (%s) is greater than the total number "
mpg[['mpg', 'mpg_trans']].head()
>>     mpg  mpg_trans
>> 0  18.0  -0.554342
>> 1  15.0  -1.020894
>> 2  18.0  -0.554342
>> 3  16.0  -0.831765
>> 4  17.0  -0.708573
```

``` python
a = mpg["mpg"] <= 18.0 ##得到在原数据上的分位数
a.mean()
>> 0.31155778894472363
```

``` python
from scipy.stats import norm
norm.ppf(a.mean()) ##精度不够 
>> -0.49143957727661874
```

``` python
dt = np.random.randn(2000) + np.random.rand(2000)
quantile_transformer = QuantileTransformer(random_state=1,  output_distribution='normal',n_quantiles=2000)
dt_t = quantile_transformer.fit_transform(dt.reshape(-1, 1)) 
```

``` python
dt_all = pd.DataFrame(dt,columns=["original_data"])
dt_all["transformed_data"] = dt_t
dt_all
>>       original_data  transformed_data
>> 0          0.851973          0.328715
>> 1         -0.250760         -0.743418
>> 2          1.597457          1.027570
>> 3          1.169616          0.638326
>> 4          0.206968         -0.274902
>> ...             ...               ...
>> 1995       0.127027         -0.349967
>> 1996       2.971422          2.273244
>> 1997      -0.211433         -0.709138
>> 1998      -0.113255         -0.601851
>> 1999       0.566198          0.063366
>> 
>> [2000 rows x 2 columns]
```

``` python
a = dt <= (dt_all["original_data"][0])
norm.ppf(a.mean())
>> 0.32920598430265113
```

#### 幂转化（power transforms）

Quantile Transformer 是通过 Quantile Function 进行转化，幂转化则是通过 power function 对数据进行转化成正态分布；`PowerTransformer` 提供了两种方法进行转化：Yeo-Johnson transform 和 Box-Cox transform。

Yeo-Johnson transform：
![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210818221510696.png)

Box-Cox transform：
![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210818221517896.png)

可以看到 Box-Cox 只能用到正值上；参数 *λ* 通过最大似然估计得出。

``` python
pt = preprocessing.PowerTransformer(method='box-cox', standardize=False)
X_lognormal = np.random.RandomState(616).lognormal(size=(3, 3))
X_lognormal
>> array([[1.28331718, 1.18092228, 0.84160269],
>>        [0.94293279, 1.60960836, 0.3879099 ],
>>        [1.35235668, 0.21715673, 1.09977091]])
```

``` python
pt.fit_transform(X_lognormal)
>> array([[ 0.49024349,  0.17881995, -0.1563781 ],
>>        [-0.05102892,  0.58863195, -0.57612414],
>>        [ 0.69420009, -0.84857822,  0.10051454]])
```

``` python
pt.lambdas_
>> array([4.92011847, 0.86296593, 1.15354435])
```

### Normalization

Normalization 将样本缩放到具有单位范数，是对单个样本的操作，方法是：对每个样本计算其 p-范数，然后对该样本中每个元素除以该范数。p-范数的定义为：

$$
||X||_p=(|x_1|^p+|x_2|^p+...+|x_n|^p)^{\frac{1}{p}}
$$

sklearn 中有两种方法可以进行 Normalization：`normalize` 函数和 `Normalizer` 类，可以通过 `norm` 参数指定使用的范数类型（l1,l2,max）。

``` python
##normalize
X = [[ 1., -1.,  2.],
     [ 2.,  0.,  0.],
     [ 0.,  1., -1.]]
X_normalized = preprocessing.normalize(X, norm='max')
X_normalized 
>> array([[ 0.5, -0.5,  1. ],
>>        [ 1. ,  0. ,  0. ],
>>        [ 0. ,  1. , -1. ]])
```

Normalizer 和一般的 Transformer 类一样，都有 `fit` 和 `transform` 方法，但是这里的fit其实没有作用，因为Normalization是对单个样本作用的，不需要从数据中“学习”。

``` python
##Normalizer
normalizer = preprocessing.Normalizer().fit(X)
normalizer
>> Normalizer()
normalizer.transform(X)
>> array([[ 0.40824829, -0.40824829,  0.81649658],
>>        [ 1.        ,  0.        ,  0.        ],
>>        [ 0.        ,  0.70710678, -0.70710678]])
```

### 自定义转化

有些时候我们想要进行的转化可能是数据特异的，scikit learn 中可能没有预置的方法供我们使用，但是其提供了`FunctionTransformer` 来将已经写好的函数转化成 transformer。比如想要把一个数据框中的所有数值变量中大于 5 的数值都变成5：

``` python
from sklearn.preprocessing import FunctionTransformer
def trunc_5(x):
    num_cols = [col for col in x.columns if str(x[col].dtype) != "object"]
    for i in num_cols:
        x[i] = [5 if j > 5 else j for j in x[i]]
    return x

trunc5_transformer = FunctionTransformer(trunc_5)
```

``` python
x = [[1,2],
     [4,6],
     [7,8]]
X = pd.DataFrame(x)
trunc5_transformer.fit_transform(X)
>>    0  1
>> 0  1  2
>> 1  4  5
>> 2  5  5
```

## 编码类别变量

对于类别变量，通常有 3 种处理策略： 

- 直接丢弃 
-  顺序编码 – OrdinalEncoder  
- One hot 编码 – OneHotEncoder 

``` python
enc = preprocessing.OrdinalEncoder()
X = [['male', 'from US', 'uses Safari'], 
     ['female', 'from Europe', 'uses Firefox']]
enc.fit(X)
>> OrdinalEncoder()
enc.transform([['female', 'from US', 'uses Safari']])
>> array([[0., 1., 1.]])
```

One hot 编码是将有 n 个类别的变量转化为 n 个 0，1的特征，每个特征中只有一个值为 1 其他都是 0 ：

``` python
enc = preprocessing.OneHotEncoder()
enc.fit(X)
>> OneHotEncoder()
enc.transform([['female', 'from US', 'uses Safari'],
               ['male', 'from Europe', 'uses Safari']]).toarray()
>> array([[1., 0., 0., 1., 0., 1.],
>>        [0., 1., 1., 0., 0., 1.]])
```

默认是自动推断每个特征的类别值，可以通过 `categories_` 属性来获取，也可以通过 `categories` 参数来指定，好处是不局限于训练数据（使用 fit 的数据）的类别：

``` python
genders = ['female', 'male']
locations = ['from Africa', 'from Asia', 'from Europe', 'from US']
browsers = ['uses Chrome', 'uses Firefox', 'uses IE', 'uses Safari']
enc = preprocessing.OneHotEncoder(categories=[genders, 
                                              locations, 
                                              browsers])

X = [['male', 'from US', 'uses Safari'], 
     ['female', 'from Europe', 'uses Firefox']]
enc.fit(X)
>> OneHotEncoder(categories=[['female', 'male'],
>>                           ['from Africa', 'from Asia', 'from Europe',
>>                            'from US'],
>>                           ['uses Chrome', 'uses Firefox', 'uses IE',
>>                            'uses Safari']])
enc.transform([['female', 'from Asia', 'uses Chrome']]).toarray() 
>> array([[1., 0., 0., 1., 0., 0., 1., 0., 0., 0.]])
```

还有一种可能发生的情况就是：在需要 transform 的数据中出现了在训练数据中没有学习到的类别或者在 `categories` 中没有指定的类别，这个时候可以设置 `handle_unknown` 参数为 `ignore`（默认是 error），会将所有的 one hot 特征设为 0：

``` python
enc = preprocessing.OneHotEncoder(handle_unknown="ignore")
X = [['male', 'from US', 'uses Safari'], ['female', 'from Europe', 'uses Firefox']]
enc.fit(X)
>> OneHotEncoder(handle_unknown='ignore')
enc.transform([['female', 'from Asia', 'uses Chrome']]).toarray()
>> array([[1., 0., 0., 0., 0., 0.]])
```

也可以使用 `drop` 参数将类别变量编码成 n-1 个新的变量而不是 n 个新的变量（n 是类别变量的类别数），也就是通过 `drop` 指定在编码时要丢弃的类别。这种方法可以有效的避免输入数据的共线性，比如在（非正则化的）线性回归中共线性会造成协方差矩阵不可逆。  `drop` 参数可以取 `first`，表示丢弃每个特征的第一个类别，如果只有一个类别那么这个特征会被丢弃，也可以取 `if_binary`，表示只丢弃有两个类别的特征的第一个类别，有一个类别或者多于两个类别的特征的类别不会被丢弃，还可以是一个数组（array），表示某个特征中要丢弃的类别。

``` python
##first
X = [['male', 'from US', 'uses Safari'], 
     ['female', 'from Europe', 'uses Firefox']]
drop_enc = preprocessing.OneHotEncoder(drop='first').fit(X)
drop_enc.categories_
>> [array(['female', 'male'], dtype=object), array(['from Europe', 'from US'], dtype=object), array(['uses Firefox', 'uses Safari'], dtype=object)]
drop_enc.transform(X).toarray()
>> array([[1., 1., 1.],
>>        [0., 0., 0.]])
```

``` python
##if_binary
X = [['male', 'US', 'Safari'],
     ['female', 'Europe', 'Firefox'],
     ['female', 'Asia', 'Chrome']]
drop_enc = preprocessing.OneHotEncoder(drop='if_binary').fit(X)
drop_enc.categories_
>> [array(['female', 'male'], dtype=object), array(['Asia', 'Europe', 'US'], dtype=object), array(['Chrome', 'Firefox', 'Safari'], dtype=object)]
drop_enc.transform(X).toarray()
>> array([[1., 0., 0., 1., 0., 0., 1.],
>>        [0., 0., 1., 0., 0., 1., 0.],
>>        [0., 1., 0., 0., 1., 0., 0.]])
```

`OneHotEncoder` 也支持对缺失值的处理，将缺失值作为一个新的类别：

``` python
X = [['male', 'Safari'],
     ['female', None],
     [np.nan, 'Firefox']]
enc = preprocessing.OneHotEncoder(handle_unknown='error').fit(X)
enc.categories_
>> [array(['female', 'male', nan], dtype=object), array(['Firefox', 'Safari', None], dtype=object)]
enc.transform(X).toarray() 
>> array([[0., 1., 0., 0., 1., 0.],
>>        [1., 0., 0., 0., 0., 1.],
>>        [0., 0., 1., 1., 0., 0.]])
```

``` python
##如果一个特征同时含有 np.nan 和 None， 会被视为两个不一样的类别
X = [['Safari'], [None], [np.nan], ['Firefox']]
enc = preprocessing.OneHotEncoder(handle_unknown='error').fit(X)
enc.transform(X).toarray()
>> array([[0., 1., 0., 0.],
>>        [0., 0., 1., 0.],
>>        [0., 0., 0., 1.],
>>        [1., 0., 0., 0.]])
```

## 缺失值的填充

缺失值填充有两类方法：

-   单变量：对第 i 个特征中的缺失值只使用该特征的某些信息来进行填充（`impute.SimpleImputer`）
-   多变量：对第 i 个特征中的缺失值使用整个数据集的信息来填充（`impute.IterativeImputer`）

### 单变量填充

`SimpleImputer` 可以将缺失值填充为提供的固定值，或者使用缺失值所在列的某些统计量（比如均值，中位值，出现最多的值等）来填充缺失值。主要参数有 3 个：

-   `missing_values`：int, float, str, np.nan or None 默认np.nan，指定缺失值的类型
-   `strategy`：mean, median, most_frequent, constant
-   `fill_value`：当 `strategy` 为 constant 时填充的值

``` python
import numpy as np
from sklearn.impute import SimpleImputer
imp = SimpleImputer(missing_values=np.nan, strategy='mean')
imp.fit([[1, 2], [np.nan, 3], [7, 6]])
>> SimpleImputer()
X = [[np.nan, 2], [6, np.nan], [7, 6]]
print(X)
>> [[nan, 2], [6, nan], [7, 6]]
print(imp.transform(X))
>> [[4.         2.        ]
>>  [6.         3.66666667]
>>  [7.         6.        ]]
```

``` python
##分类变量
import pandas as pd
df = pd.DataFrame([["a", "x"],
                   [np.nan, "y"],
                   ["a", np.nan],
                   ["b", "y"]], dtype="category")
imp = SimpleImputer(strategy="most_frequent")
print(imp.fit_transform(df))
>> [['a' 'x']
>>  ['a' 'y']
>>  ['a' 'y']
>>  ['b' 'y']]
```

### 多变量填充

多变量填充是使用全部数据建模的方式进行填充缺失值：含有缺失值的特征被视为 y，而其他特征当作 x，对 （x, y）拟合回归模型，然后利用这个模型来预测 y 中的缺失值：

``` python
from sklearn.experimental import enable_iterative_imputer
from sklearn.impute import IterativeImputer
imp = IterativeImputer(max_iter=10, random_state=0)
imp.fit([[1, 2], [3, 6], [4, 8], [np.nan, 3], [7, np.nan]])
>> IterativeImputer(random_state=0)
X_test = [[np.nan, 2], [6, np.nan], [np.nan, 6]]
print(np.round(imp.transform(X_test)))
>> [[ 1.  2.]
>>  [ 6. 12.]
>>  [ 3.  6.]]
```

### 标记缺失值

除了对缺失值进行填充，标记缺失值也是一种有用的方法，通常和填充一起使用，在 Scikit-learn 中通过 `MissingIndicator` 实现（前面的 `SimpleImputer` 和 `IterativeImputer` 都有一个 `add_indicator` 的参数，设置为 True 时可以直接将`MissingIndicator` 的结果和原来的数据合并）。

``` python
from sklearn.impute import MissingIndicator
X = np.array([[-1, -1, 1, 3],
              [4, -1, 0, -1],
              [8, -1, 1, 0]])
indicator = MissingIndicator(missing_values=-1)
mask_missing_values_only = indicator.fit_transform(X)
mask_missing_values_only ##默认只返回有缺失值的列
>> array([[ True,  True, False],
>>        [False,  True,  True],
>>        [False,  True, False]])
```

``` python
##可以设置 feature 指定返回的列或者所有列
indicator = MissingIndicator(missing_values=-1, features="all")
mask_all = indicator.fit_transform(X)
mask_all
>> array([[ True,  True, False, False],
>>        [False,  True, False,  True],
>>        [False,  True, False, False]])
```

当在 Pipeline 中使用 `MissingIndicator` 时需要改用 `FeatureUnion` （或者 `ColumnTransformer`）来将标记生成的列和原数据合并:

``` python
from sklearn.datasets import load_iris
from sklearn.impute import SimpleImputer, MissingIndicator
from sklearn.model_selection import train_test_split
from sklearn.pipeline import FeatureUnion, make_pipeline
from sklearn.tree import DecisionTreeClassifier
X, y = load_iris(return_X_y=True)
mask = np.random.randint(0, 2, size=X.shape).astype(bool)##随机生成 0 1，转化成 T F
X[mask] = np.nan
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=100,
                                               random_state=0)

transformer = FeatureUnion(
      transformer_list=[
            ('features', SimpleImputer(strategy='mean')),
            ('indicators', MissingIndicator())])
transformer = transformer.fit(X_train, y_train)
results = transformer.transform(X_test)
print(X_test.shape)
>> (100, 4)
print(results.shape) 
>> (100, 8)
```

``` python
##然后就可以在 pipeline 中使用：
clf = make_pipeline(transformer, DecisionTreeClassifier())
clf = clf.fit(X_train, y_train)
results = clf.predict(X_test)
```
