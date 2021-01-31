`GenomicRanges`是Bioconductor里面用来展示基因组位置、处理基因组区间的一个基础性的包

这个包主要通过引进3个类来进行对基因组的操作:

-   *GRanges:* 基因组区间

-   *GPos*：基因组位置

-   *GRangesList*：一组基因组区间

``` r
library(GenomicRanges)
```

## GRanges

*GRanges*类储存的是一系列基因组区间，每个区间都有一个起始位点和终止位点，可用来存储基因组特征的位置(比如转录本，外显子等)；可以通过`GRanges`函数来创建：

``` r
gr <- GRanges(
    seqnames = Rle(c("chr1", "chr2", "chr1", "chr3"), c(1, 3, 2, 4)),
    ranges = IRanges(start = 101:110, end = 111:120, names = head(letters, 10)),
    strand = Rle(strand(c("-", "+", "*", "+", "-")), c(1, 2, 2, 3, 2)),
    score = 1:10,
    GC = seq(1, 0, length=10))
gr
## GRanges object with 10 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
##   f     chr1   106-116      + |         6 0.444444444444444
##   g     chr3   107-117      + |         7 0.333333333333333
##   h     chr3   108-118      + |         8 0.222222222222222
##   i     chr3   109-119      - |         9 0.111111111111111
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

`Rle`函数是`IRanges`包提供的用来存储序列信息的函数(序列信息中有很多的重复内容)：

``` r
test1 <- Rle(c("chr1", "chr2", "chr1"), c(1000, 3000, 2000))
test2 <- c(rep("chr1",1000),rep("chr2",3000),rep("chr1",2000))

##比较
identical(as.vector(test1), test2)
## [1] TRUE

object.size(test1)
## 1320 bytes
object.size(test2)
## 48160 bytes
```

创建的这个*GRanges*对象有10个基因组区间，可以看到`|`符号将数据分成左右两个部分；左边的是基因组坐标(包括seqnames,ranges, 和strand)，右边是元数据(metadata),也就是一些注释信息

对于基因组位置，我们可以通过`seqnames()`,`ranges()`,`strand()`函数来提取：

``` r
seqnames(gr)
## factor-Rle of length 10 with 4 runs
##   Lengths:    1    3    2    4
##   Values : chr1 chr2 chr1 chr3
## Levels(3): chr1 chr2 chr3

ranges(gr)
## IRanges object with 10 ranges and 0 metadata columns:
##         start       end     width
##     <integer> <integer> <integer>
##   a       101       111        11
##   b       102       112        11
##   c       103       113        11
##   d       104       114        11
##   e       105       115        11
##   f       106       116        11
##   g       107       117        11
##   h       108       118        11
##   i       109       119        11
##   j       110       120        11

strand(gr)
## factor-Rle of length 10 with 5 runs
##   Lengths: 1 2 2 3 2
##   Values : - + * + -
## Levels(3): + - *
```

也可以整体地提取左边和右边的内容：

``` r
##提取左边的基因组位置信息
granges(gr)
## GRanges object with 10 ranges and 0 metadata columns:
##     seqnames    ranges strand
##        <Rle> <IRanges>  <Rle>
##   a     chr1   101-111      -
##   b     chr2   102-112      +
##   c     chr2   103-113      +
##   d     chr2   104-114      *
##   e     chr1   105-115      *
##   f     chr1   106-116      +
##   g     chr3   107-117      +
##   h     chr3   108-118      +
##   i     chr3   109-119      -
##   j     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

##提取右边的元数据信息
mcols(gr)
## DataFrame with 10 rows and 2 columns
##       score                GC
##   <integer>         <numeric>
## a         1                 1
## b         2 0.888888888888889
## c         3 0.777777777777778
## d         4 0.666666666666667
## e         5 0.555555555555556
## f         6 0.444444444444444
## g         7 0.333333333333333
## h         8 0.222222222222222
## i         9 0.111111111111111
## j        10                 0
mcols(gr)$score
##  [1]  1  2  3  4  5  6  7  8  9 10
```

### 拆分,和并GRanges对象

GRanges对象可以通过`split`函数进行拆分，拆分后产生的是GRangesList对象：

``` r
sp <- split(gr,rep(1:2,each=5))
sp
## GRangesList object of length 2:
## $1 
## GRanges object with 5 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
## 
## $2 
## GRanges object with 5 ranges and 2 metadata columns:
##     seqnames  ranges strand | score                GC
##   f     chr1 106-116      + |     6 0.444444444444444
##   g     chr3 107-117      + |     7 0.333333333333333
##   h     chr3 108-118      + |     8 0.222222222222222
##   i     chr3 109-119      - |     9 0.111111111111111
##   j     chr3 110-120      - |    10                 0
## 
## -------
## seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

合并GRanges对象可以使用`c`和`append`函数：

``` r
c(sp[[1]],sp[[2]])
## GRanges object with 10 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
##   f     chr1   106-116      + |         6 0.444444444444444
##   g     chr3   107-117      + |         7 0.333333333333333
##   h     chr3   108-118      + |         8 0.222222222222222
##   i     chr3   109-119      - |         9 0.111111111111111
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

##or
append(sp[[1]],sp[[2]])
## GRanges object with 10 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
##   f     chr1   106-116      + |         6 0.444444444444444
##   g     chr3   107-117      + |         7 0.333333333333333
##   h     chr3   108-118      + |         8 0.222222222222222
##   i     chr3   109-119      - |         9 0.111111111111111
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

### 对GRanges对象取子集

可以通过`[`操作符来选取子集：

``` r
gr[2:3]
## GRanges object with 2 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

指定第二个参数来选取特定的**metadata信息：**

``` r
gr[2:3,"GC"]
## GRanges object with 2 ranges and 1 metadata column:
##     seqnames    ranges strand |                GC
##        <Rle> <IRanges>  <Rle> |         <numeric>
##   b     chr2   102-112      + | 0.888888888888889
##   c     chr2   103-113      + | 0.777777777777778
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

也可以通过这种取子集的方式对GRanges对象进行修改：

``` r
singles <- split(gr, names(gr))##拆分
grMod <- gr
grMod[2] <- singles[[1]]##将第二行替换成第一行
head(grMod, n=3)
## GRanges object with 3 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr1   101-111      - |         1                 1
##   c     chr2   103-113      + |         3 0.777777777777778
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

### 区间操作

GRanges对象的基本区间特征可以使用`start` `end` `width` `range`函数来获得：

``` r
g <- gr[1:3]
g <- append(g, singles[[10]])
g
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

###起始
start(g)
## [1] 101 102 103 110

##终止
end(g)
## [1] 111 112 113 120

###区间长度
width(g)
## [1] 11 11 11 11

###range
range(g)
## GRanges object with 3 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1   101-111      -
##   [2]     chr2   102-113      +
##   [3]     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

GRanges用来操作区间的函数可以分为3类：

-   *intra-range methods*

-   *inter-range methods*

-   *between-range methods*

intra-range对每个区间进行操作：

``` r
###flank取区间的上游或下游
##每个区间的上游10bp
flank(g,10)
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   112-121      - |         1                 1
##   b     chr2    92-101      + |         2 0.888888888888889
##   c     chr2    93-102      + |         3 0.777777777777778
##   j     chr3   121-130      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

##每个区间的下游10bp
flank(g,10,start = FALSE)
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1    91-100      - |         1                 1
##   b     chr2   113-122      + |         2 0.888888888888889
##   c     chr2   114-123      + |         3 0.777777777777778
##   j     chr3   100-109      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

###shift移动区间
shift(g,5)
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   106-116      - |         1                 1
##   b     chr2   107-117      + |         2 0.888888888888889
##   c     chr2   108-118      + |         3 0.777777777777778
##   j     chr3   115-125      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

shift(g,-5)
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1    96-106      - |         1                 1
##   b     chr2    97-107      + |         2 0.888888888888889
##   c     chr2    98-108      + |         3 0.777777777777778
##   j     chr3   105-115      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

###resize拓展区间
resize(g,30)
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1    82-111      - |         1                 1
##   b     chr2   102-131      + |         2 0.888888888888889
##   c     chr2   103-132      + |         3 0.777777777777778
##   j     chr3    91-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

resize(g,30,fix = "end")
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-130      - |         1                 1
##   b     chr2    83-112      + |         2 0.888888888888889
##   c     chr2    84-113      + |         3 0.777777777777778
##   j     chr3   110-139      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210128155320852.png)

inter-range 涉及在单个GRanges对象中的区间比较：

``` r
###reduce 合并重复的区间
reduce(g)
## GRanges object with 3 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1   101-111      -
##   [2]     chr2   102-113      +
##   [3]     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

###gap 获取区间的间隔
gaps(g)
## GRanges object with 3 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1     1-100      -
##   [2]     chr2     1-101      +
##   [3]     chr3     1-109      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

##由于没有提供染色体的长度，所以从1开始到指定的区间end结束
##提供染色体长度
seqlengths(g) <- c(249250621, 243199373, 198022430)
seqlengths(g)
##      chr1      chr2      chr3 
## 249250621 243199373 198022430

gaps(g)
## GRanges object with 12 ranges and 0 metadata columns:
##        seqnames        ranges strand
##           <Rle>     <IRanges>  <Rle>
##    [1]     chr1   1-249250621      +
##    [2]     chr1         1-100      -
##    [3]     chr1 112-249250621      -
##    [4]     chr1   1-249250621      *
##    [5]     chr2         1-101      +
##    ...      ...           ...    ...
##    [8]     chr2   1-243199373      *
##    [9]     chr3   1-198022430      +
##   [10]     chr3         1-109      -
##   [11]     chr3 121-198022430      -
##   [12]     chr3   1-198022430      *
##   -------
##   seqinfo: 3 sequences from an unspecified genome

###disjoin 重组GRanges对象得到互不重叠的区间
disjoin(g)
## GRanges object with 5 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1   101-111      -
##   [2]     chr2       102      +
##   [3]     chr2   103-112      +
##   [4]     chr2       113      +
##   [5]     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome

###coverage 计算重叠的程度
coverage(g)
## RleList of length 3
## $chr1
## integer-Rle of length 249250621 with 3 runs
##   Lengths:       100        11 249250510
##   Values :         0         1         0
## 
## $chr2
## integer-Rle of length 243199373 with 5 runs
##   Lengths:       101         1        10         1 243199260
##   Values :         0         1         2         1         0
## 
## $chr3
## integer-Rle of length 198022430 with 3 runs
##   Lengths:       109        11 198022310
##   Values :         0         1         0
```

Between-range 计算不同的GRanges对象之间的关系：

``` r
###union 将GRanges视为位置的集合,取并集
g2 <- head(gr,n=2)
g
## GRanges object with 4 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome
g2
## GRanges object with 2 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

union(g,g2)
## GRanges object with 3 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1   101-111      -
##   [2]     chr2   102-113      +
##   [3]     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome

###intersect 取交集
intersect(g,g2)
## GRanges object with 2 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr1   101-111      -
##   [2]     chr2   102-112      +
##   -------
##   seqinfo: 3 sequences from an unspecified genome

###setdiff 取差集
setdiff(g,g2)
## GRanges object with 2 ranges and 0 metadata columns:
##       seqnames    ranges strand
##          <Rle> <IRanges>  <Rle>
##   [1]     chr2       113      +
##   [2]     chr3   110-120      -
##   -------
##   seqinfo: 3 sequences from an unspecified genome
```

当两个GRanges是相关联的时候，也就是要对两个对象进行成对操作(如对象1的第一行和对象2的第一行取交集等)，可以使用以`p`开头(parallel)的一系列操作：

``` r
g3 <- g[1:2]
ranges(g3[1]) <- IRanges(start=105, end=112)
g3
## GRanges object with 2 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   105-112      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   -------
##   seqinfo: 3 sequences from an unspecified genome
punion(g2, g3)
## GRanges object with 2 ranges and 0 metadata columns:
##     seqnames    ranges strand
##        <Rle> <IRanges>  <Rle>
##   a     chr1   101-112      -
##   b     chr2   102-112      +
##   -------
##   seqinfo: 3 sequences from an unspecified genome

pintersect(g2, g3)
## GRanges object with 2 ranges and 3 metadata columns:
##     seqnames    ranges strand |     score                GC       hit
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric> <logical>
##   a     chr1   105-111      - |         1                 1      TRUE
##   b     chr2   102-112      + |         2 0.888888888888889      TRUE
##   -------
##   seqinfo: 3 sequences from an unspecified genome

psetdiff(g2, g3)
## GRanges object with 2 ranges and 0 metadata columns:
##     seqnames    ranges strand
##        <Rle> <IRanges>  <Rle>
##   a     chr1   101-104      -
##   b     chr2   102-101      +
##   -------
##   seqinfo: 3 sequences from an unspecified genome
```

## GRangesList

当一个基因组特征由多个区间构成，那么用一个组合对象GRangesList来表示更有意义：

``` r
###两个转录本
gr1 <- GRanges(
    seqnames = "chr2",
    ranges = IRanges(103, 106),
    strand = "+",
    score = 5L, GC = 0.45)

##第二个转录本有两个外显子
gr2 <- GRanges(
    seqnames = c("chr1", "chr1"),
    ranges = IRanges(c(107, 113), width = 3),
    strand = c("+", "-"),
    score = 3:4, GC = c(0.3, 0.5))
grl <- GRangesList("txA" = gr1, "txB" = gr2)
grl
## GRangesList object of length 2:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
## 
## $txB 
## GRanges object with 2 ranges and 2 metadata columns:
##       seqnames  ranges strand | score  GC
##   [1]     chr1 107-109      + |     3 0.3
##   [2]     chr1 113-115      - |     4 0.5
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths
```

在GRanges上的方法在GRangesList上返回的就是list：

``` r
seqnames(grl)
## RleList of length 2
## $txA
## factor-Rle of length 1 with 1 run
##   Lengths:    1
##   Values : chr2
## Levels(2): chr2 chr1
## 
## $txB
## factor-Rle of length 2 with 1 run
##   Lengths:    2
##   Values : chr1
## Levels(2): chr2 chr1
strand(grl)
## RleList of length 2
## $txA
## factor-Rle of length 1 with 1 run
##   Lengths: 1
##   Values : +
## Levels(3): + - *
## 
## $txB
## factor-Rle of length 2 with 2 runs
##   Lengths: 1 1
##   Values : + -
## Levels(3): + - *
```

需要注意的是不同于GRanges的`mcols`方法，在GRangesList上返回的是列表层面的信息：

``` r
mcols(grl)
## DataFrame with 2 rows and 0 columns

###需要unlist来combine GRangesList中的GRanges
mcols(unlist(grl))
## DataFrame with 3 rows and 2 columns
##         score        GC
##     <integer> <numeric>
## txA         5      0.45
## txB         3       0.3
## txB         4       0.5
```

在GRangesList上的区间操作和单独的GRanges类似：

``` r
start(grl)
## IntegerList of length 2
## [["txA"]] 103
## [["txB"]] 107 113

end(grl)
## IntegerList of length 2
## [["txA"]] 106
## [["txB"]] 109 115

width(grl)
## IntegerList of length 2
## [["txA"]] 4
## [["txB"]] 3 3

##这些操作返回的是整数列表
class(width(grl))
## [1] "CompressedIntegerList"
## attr(,"package")
## [1] "IRanges"
sum(width(grl))
## txA txB 
##   4   6

###intra-, inter- and between-range对每个GRanges对象操作
shift(grl, 20)
## GRangesList object of length 2:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   123-126      + |         5      0.45
## 
## $txB 
## GRanges object with 2 ranges and 2 metadata columns:
##       seqnames  ranges strand | score  GC
##   [1]     chr1 127-129      + |     3 0.3
##   [2]     chr1 133-135      - |     4 0.5
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths

coverage(grl)
## RleList of length 2
## $chr2
## integer-Rle of length 106 with 2 runs
##   Lengths: 102   4
##   Values :   0   1
## 
## $chr1
## integer-Rle of length 115 with 4 runs
##   Lengths: 106   3   3   3
##   Values :   0   1   0   1
```

GRangesList的行为和list类似，也可以通过`[`,`[[`或者`$`来取子集：`[`返回的是GRangesList对象，`[[`和`$`返回的是GRanges对象

``` r
grl[1]
## GRangesList object of length 1:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths
grl[[1]]
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
##   -------
##   seqinfo: 2 sequences from an unspecified genome; no seqlengths
grl["txA"]
## GRangesList object of length 1:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths
grl$txB
## GRanges object with 2 ranges and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr1   107-109      + |         3       0.3
##   [2]     chr1   113-115      - |         4       0.5
##   -------
##   seqinfo: 2 sequences from an unspecified genome; no seqlengths

class(grl[1])
## [1] "CompressedGRangesList"
## attr(,"package")
## [1] "GenomicRanges"
class(grl[[1]])
## [1] "GRanges"
## attr(,"package")
## [1] "GenomicRanges"
```

## 区间重叠

区间重叠的操作也属于上面提到的*between-range methods(*比较两个对象的区间),主要有3个函数：`findOverlaps`,`countOverlaps`和`subsetByOverlaps`

`findOverlaps`输入是query(查找对象)和subject(目标对象)，返回的是一个Hit对象

``` r
gr
## GRanges object with 10 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   a     chr1   101-111      - |         1                 1
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
##   f     chr1   106-116      + |         6 0.444444444444444
##   g     chr3   107-117      + |         7 0.333333333333333
##   h     chr3   108-118      + |         8 0.222222222222222
##   i     chr3   109-119      - |         9 0.111111111111111
##   j     chr3   110-120      - |        10                 0
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths

grl
## GRangesList object of length 2:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
## 
## $txB 
## GRanges object with 2 ranges and 2 metadata columns:
##       seqnames  ranges strand | score  GC
##   [1]     chr1 107-109      + |     3 0.3
##   [2]     chr1 113-115      - |     4 0.5
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths

findOverlaps(gr, grl)
## Hits object with 5 hits and 0 metadata columns:
##       queryHits subjectHits
##       <integer>   <integer>
##   [1]         2           1
##   [2]         3           1
##   [3]         4           1
##   [4]         5           2
##   [5]         6           2
##   -------
##   queryLength: 10 / subjectLength: 2

###queryHits 是query中的index，subjectHits表示在subject哪一个元素与query相应的元素overlap

seqnames(grl[["txB"]][2])[1] <- "chr2"
grl
## GRangesList object of length 2:
## $txA 
## GRanges object with 1 range and 2 metadata columns:
##       seqnames    ranges strand |     score        GC
##          <Rle> <IRanges>  <Rle> | <integer> <numeric>
##   [1]     chr2   103-106      + |         5      0.45
## 
## $txB 
## GRanges object with 2 ranges and 2 metadata columns:
##       seqnames  ranges strand | score  GC
##   [1]     chr1 107-109      + |     3 0.3
##   [2]     chr2 113-115      - |     4 0.5
## 
## -------
## seqinfo: 2 sequences from an unspecified genome; no seqlengths

findOverlaps(gr, grl)
## Hits object with 6 hits and 0 metadata columns:
##       queryHits subjectHits
##       <integer>   <integer>
##   [1]         2           1
##   [2]         3           1
##   [3]         4           1
##   [4]         4           2
##   [5]         5           2
##   [6]         6           2
##   -------
##   queryLength: 10 / subjectLength: 2
```

`countOverlaps` 计算在query中匹配到subject的元素个数

``` r
countOverlaps(gr, grl)
## a b c d e f g h i j 
## 0 1 1 2 1 1 0 0 0 0
```

`subsetByOverlaps` 在query中提取至少与subject重复一次的元素：

``` r
subsetByOverlaps(gr,grl)
## GRanges object with 5 ranges and 2 metadata columns:
##     seqnames    ranges strand |     score                GC
##        <Rle> <IRanges>  <Rle> | <integer>         <numeric>
##   b     chr2   102-112      + |         2 0.888888888888889
##   c     chr2   103-113      + |         3 0.777777777777778
##   d     chr2   104-114      * |         4 0.666666666666667
##   e     chr1   105-115      * |         5 0.555555555555556
##   f     chr1   106-116      + |         6 0.444444444444444
##   -------
##   seqinfo: 3 sequences from an unspecified genome; no seqlengths
```
