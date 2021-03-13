+++
# 使用Latex写论文

+++

## 前言
最近写文章的时候，发现修改时调整参考文献的引用，是一件非常麻烦的事情，于是找到了一种简便的方法进行调整，发现了用Latex写论文原来这么好用。
<!--more-->


## 主要内容
- LaTex基本语法
- 模板的使用
- 文献的引用
- 排版的调整
- 特殊符号的引用
- 图片表格的插入

## 使用的工具
- Overleaf —— Online LaTeX Editor（推荐）

优点：不用本地搭建环境；在线编辑并渲染；部分投稿期刊直接提供链接模板。
- MacTeX—— For mac

mac的我还没有安过，仅列出来供参考。
- TexWorks —— For windows（我觉得很好用）。

除了上面列出来的，还有很多其他的，根据自己的喜好使用吧。
## 基本语法

- 整体框架

注意到一个部分有开始也有结束，中间就是这个部分的内容。

```powershell
\documentclass{article}

\begin{document}
First document. This is a simple example, with no 
extra parameters or packages included.
\end{document}
```

- preamble

在LaTex中，所有在document内容之前的都称为**preamble**,在**preamble**中可以定义整个文档的格式、使用的语言、你需要使用到的宏包、以及其他的元素。举例：

```powershell
\documentclass[12pt, letterpaper]{article} %设置
\usepackage[utf8]{inputenc} %加载了名叫inputenc的宏包，设置使用utf-8来编码。
```
在`[]`方括号中都是一些参数的选择，**documentclass**中设置了字体大小为12pt（默认的字体大小是10pt），纸张大小为信纸，其他的设置可以看[<font color=blue>Overleaf的文档说明</font>](https://www.overleaf.com/learn/latex/Page_size_and_margins)。

这些内容也属于preamble：

标题
```powershell
\title{First document}
```

作者
```powershell
\author{cat}
```

日期
```powershell
\date{March 2021}
```

谢言
```powershell
\thanks{funded by the Overleaf team}
```

- document内容

字体的简单格式可以通过以下代码实现：
```powershell
Some of the \textbf{greatest} %字体加粗
discoveries in \underline{science} %加入下划线
were made by \textbf{\textit{accident}}. %斜体
```

<center>
    <img src= "https://i.loli.net/2021/03/06/TwKB3A8SGqklEPn.png" width="800"/>
</center>


还有更多的字体变换可以更改，具体参考[<font color=blue>字体格式</font>](https://www.overleaf.com/learn/latex/Bold,_italics_and_underlining)，来个简单的应用示例感受一下它的实用性。

## Overleaf 示例
### 1. 模板的使用

#### 进入 [<font color=blue>Overleaf模板</font>](https://www.overleaf.com/latex/templates)，选择合适的模板

这其中包括[<font color=blue>国科大的毕业论文模板</font>](https://www.overleaf.com/latex/templates/thesis-template-for-the-university-of-chinese-academy-of-sciences/fhbvbjrrgtwx)、[<font color=blue>开题报告模板</font>](https://www.overleaf.com/latex/templates/research-proposal-template-for-ucas/tcjqfcxgsbfr)，以及各种杂志期刊、简历、信件、海报、报告、作业和写书的模板等等（部分期刊杂志会提供Overleaf的模板）。
<center class="half">
    <img src="https://i.loli.net/2021/03/05/SoAgT5dBGfaK3Y1.png" width="400"/>
    <img src="https://i.loli.net/2021/03/05/osz41c38kgprZf6.png" width="400"/>
</center>

#### 以论文写作为例

随便打开一个[<font color=blue>模板</font>](https://www.overleaf.com/latex/templates/submission-template-for-journal-of-photonics-research/jhgrbsdsmdpw)，最右边是实时的渲染结果，中间是可以编辑的部分，左边是模板的目录下文件。

<center>
    <img src= "https://i.loli.net/2021/03/05/VEvczSxWZDHLP4m.png" width="800"/>
</center>

左边的目录下存储了4个文件：
- 以`.bib`结尾的文件

通常用来存储引用文献的信息，其中引用文献需要用特定的格式——BibTex存储，可以通过谷歌学术、百度学术或者其它方式进行导出（谷歌学术的导出功能经常会崩溃），如何使用Bibtex格式进行文献引用请跳转
[<font color=blue>点击跳转</font>](#jump)。


- 以`.bst`结尾的文件

这个文件通常由期刊或杂志提供，设置了参考文献出现的文章结尾的方式，比如：设置排序方式，设置作者名称是缩写还是全称，标题的大小写等等，一般不需要自行维护，而且可以根据自己的需求来在`.tex`中重新调整。

- 以`.tex`结尾的文件

这个是进行文档内容编辑的文件，可以在这个文件中加载宏包，进行内容以及格式的更改。

- 以`.cls`结尾的文件

这个文件通常是类文件，通过文档最前面的`\documentclass`导入，这里的`\documentclass[options]{class}`是用来指定文档类型的，可以通过options参数来定制文档类的属性，不同的选项之间需要用逗号隔开，比如这里的`\documentclass[final,3p]{CSP}`，其中`final`指的不在页面的边缘标记一个黑色框，这个3p对它的解释是：

> formats the article to the look and feel of the final format of model 3+ journals.

我没明白这个3+model是什么意思，但是通过调试，发现这个数字越大，页面距就越大。

另外别的模板中还存在这些文件：
- `.bbl`文件

这是编译之后形成的文件，这里直接就显示了编译后的形式，可以直接下载PDF文件。

- `.sty`文件

这是包文件，通常使用`\usepackage`导入。


### 2. 内容的编辑以及参考文献的引用

#### 内容的编辑

载入宏包的方法是在文档开始前`\begin{document}`，写入`\usepackage{package}`

这里介绍几个常用的宏包：

- 数学公式 - amsmath

- 插图 - graphicx

- 颜色 - xcolor

- 表格 - array

- 中文 - ctex, xecjk

- 西文 otf 字体 - fontspec

- 英文下划线 - geometry

特别的，当要使用英文下划线`-`时，比如写入sigminer包中的函数名`read_maf`时，并不能直接识别下划线，需要载入该包来处理，或者给每处下划线改成`\_`也可以不用载入包来识别。

- 超链接 - hyperref

语法：`\usepackage[options]{hyperref}`

示例：加入超链接，同时将文献也超链接到reference中，并且设置超链接的颜色，常用的设为蓝色或者黑色。

```powershell
\usepackage[backref, colorlinks,linkcolor=blue]{hyperref}
```
<center>
    <img src= "https://i.loli.net/2021/03/05/SOYXw9Rno5UtEp8.png" width="600"/>
</center>
<span id="jump"></span>

#### 文献的引用
- 保存引用文献信息

如下图所示，谷歌学术中可以直接得到BibTex这种引用格式，将文献信息存储在`.txt`中，然后更改后缀为`.bib`即可。
<center>
    <img src= "https://i.loli.net/2021/03/05/axyi3UvhgADkQHP.png" width="800"/>
</center>

点击 **BibTex** 后会弹出下图所示页面，复制内容至`.bib`文件内即可。

<center>
    <img src= "https://i.loli.net/2021/03/06/tQrgZIBhNTMbuwa.png" width="650"/>
</center>


- 在**tex**文件中对引用格式进行设置

在文档结束位置`\end{document}`前，增加对参考文献格式以及引用的设置，比如：
```powershell
\bibliographystyle{bibft}\it
\bibliography{bibfile}
```
**bibft**是模板自带并自己命名的格式文件，这是由`.cls`文件定义的，bibfile就是制作好的**bibtex**文件，

注意这里的文献引用格式有很多种，除了模板中定义的格式，可以通过参数的调整将格式更改为自己想要的，比如常用的，在方括号中标注数字，并且根据文献引用的先后顺序对reference排序：
```powershell
\begin{document}
\bibliographystyle{unsrt}

\bibliographystyle{unsrt} %根据引用顺序自动排序
\bibliography{bibfile.bib} %引用文献的文件
\end{document}
```

我认为最方便的地方就是这里，<font color=red>能够根据文献引用的顺序对reference进行自动排序</font>。

- 在**tex**文件中进行引用

通常在正文中有很常见的几种文献引用格式：
温哥华格式（上标形式）
哈佛格式（直接显示作者和发表年份）
IEEE 格式（方括号内标注引用顺序）

在文中一般使用`\cite{}`进行引用，括号中的内容就是BibTex中的第一个参数，这个是可以自定义的，通常都是作者的姓或者名+发表年份+论文题目的首个单词。

```powershell
@inproceedings{song2013hierarchical,
  title={Hierarchical representation using NMF},
  author={Song, Hyun Ah and Lee, Soo-Young},
  booktitle={International conference on neural information processing},
  pages={466--473},
  year={2013},
  organization={Springer}
}
```
另外还有宏包`natbib`，通过不同形式的cite比如：

`\citet`：
```powershell
\citet{jon90}
##
Jones et al. (1990)
```

`\citep`：
```powershell
\citep{jon90}	
##
(Jones et al., 1990)
```

`\citeyear`：
```powershell
\citeyearpar{jon90}
##
(1990)
```

......

该宏包的使用方式如下。

```powershell
\usepackage[option]{natbib}

\bibliographystyle{natbib}
\bibliography{bibfile}
```

### 3. 表格的制作

分为以下两个部分：
- 手动输入表格（适合小型表格）
- 其他工具进行表格转换
1. Excel中的表格

可以在Excel中使用插件：**Excel2Latex**，该插件能够将Excel表格转化为LaTex的表格形式。

2. Word中的表格

可以使用pandoc直接转换为`.tex`格式，不过转换之后不是完美的，可能需要手动调整一下。

示例：
```powershell
pandoc test.docx -o test.tex
```

3. 其他文件形式的表格

比如在R当中得到的表格，可以使用`stargazer`包把结果输出为LaTex格式，或者`xtable`包。

以`xtable`包为例：
```R
> install.packages("xtable") #安装xtable
> library(xtable) #载入
> data(iris) # 示例数据
> xtable(head(iris),digits=3,caption="Head of Iris Data")
#将iris数据前6行
# 保留三位小数
#标题设为"Head of Iris Data"，导出为LaTex格式
% latex table generated in R 4.0.2 by xtable 1.8-4 package
% Sat Mar  6 20:04:47 2021
\begin{table}[ht]
\centering
\begin{tabular}{rrrrrl}
  \hline
 & Sepal.Length & Sepal.Width & Petal.Length & Petal.Width & Species \\ 
  \hline
1 & 5.100 & 3.500 & 1.400 & 0.200 & setosa \\ 
  2 & 4.900 & 3.000 & 1.400 & 0.200 & setosa \\ 
  3 & 4.700 & 3.200 & 1.300 & 0.200 & setosa \\ 
  4 & 4.600 & 3.100 & 1.500 & 0.200 & setosa \\ 
  5 & 5.000 & 3.600 & 1.400 & 0.200 & setosa \\ 
  6 & 5.400 & 3.900 & 1.700 & 0.400 & setosa \\ 
   \hline
\end{tabular}
\caption{Head of Iris Data} 
\end{table}
```

#### 表格的介绍

表格的基本格式和要素如下（2行2列表格）：


```powershell
\documentclass{article} 
\usepackage{float}%提供float浮动环境
\usepackage{makecell} %%用来基线
\begin{table}[h]
\centering %%表居中
\caption{table} %%表格标题

\begin{tabular}{|c|c|} %%{cc} 表示各列元素对齐方式，left-l,right-r,center-c，两个c表示两列，｜表示增加垂直方向基线
\hline %%\hline 在此行下面画一横线
a & b \\\hline
c & d\\
\hline
\end{tabular}
\end{table}
 
\end{document}
```
<center>
    <img src= "https://i.loli.net/2021/03/05/NL1CgnIHEfRGp9k.png" width="400"/>
</center>

当表格太大或者太小的时候，有非常多的解决办法，可以通过调整字体的长或宽，也可以直接整体调整表格的大小，本质都是通过在`tabular`类外，套上调整表格的参数设置。

通过调整字体的宽度（mm是百分比，60mm就是60%）：
```
\resizebox{\textwidth}{60mm}{}
```

通过调整表格的大小：
```powershell
\usepackage{graphicx}
\begin{table}

\caption{表格标题}
\scalebox{0.9}{ %缩小至原来的90%
\begin{tabular}
……
\end{tabular}}
\end{table}
```

文献中常用的三线表可以通过以下Latex实现：
```powershell
\documentclass{article} 
\usepackage{float}%提供float浮动环境
\usepackage{booktabs} %%提供命令\toprule、\midrule、\bottomrule
\usepackage{makecell} %%用来基线
\usepackage{geometry}
\usepackage{amsmath}
%\geometry{papersize={40cm,80cm}}
\geometry{left=1cm,right=1cm,top=3cm,bottom=1cm}
\begin{document}
 
%经典三线表
\begin{table}[H] %%H为当前位置
\caption{\textbf{test title}}%标题
\centering%把表居中
\begin{tabular}{ccc}%四个c代表该表一共四列，内容全部居中
\toprule[1.5pt]%第一道横线
year & month & day \\
\midrule%第二道横线 
2021 & 3 & 5 \\

\bottomrule[1.5pt]%第三道横线
\end{tabular}
\end{table}

\end{document}
```

<center>
    <img src= "https://i.loli.net/2021/03/05/1CZlSqB8jIXNmED.png" width="400"/>
</center>

### 4. 图片的引入

LaTeX插入图片时，支持格式有各种：png, pdf, jpg, eps等等。

- 准备图片

将图片全部保存在目录下的同一个文件夹下，方便查找，注意图片的命名尽量避免中文，特殊字符等等(这里就只用了一个文件，我就直接放在目录下了)。

- 图片基本语法

必须加载graphicx等包来支持图片的导入。

```
\documentclass{article}
\usepackage{graphicx}
\graphicspath{ {images/} }

\begin{document}
The universe is immense and it seems to be homogeneous, 
in a large scale, everywhere we look at.

\includegraphics{universe}

There's a picture of a galaxy above
\end{document}
```

- 给图片进行排版（排版有很多种，现在展示的是两个图片并排）

<center>
    <img src= "https://i.loli.net/2021/03/05/FdrtzSjuc7I9mDg.png" width="400"/>
</center>


```powershell
\usepackage{graphicx} %%插入图片的宏包
\usepackage{float} %%设置图片浮动位置的宏包
\usepackage{subfigure} %%插入多图时用子图显示的宏包
\begin{figure}   %%旋转子系统姿态角
  \centering
  \subfigure{
    \label{fig:subfig:a} %% label for first subfigure
    \includegraphics[width=4cm,height=4cm]{taoziyu.jpg}}
  \hspace{1in}
  \subfigure{
    \label{fig:subfig:b} % label for second subfigure
    \includegraphics[width=4cm,height=4cm]{taoziyu.jpg}}
  \caption{The same cute cat (a) cute cat1. (b) cute cat2.}
  %% caption用于图表的标题
  \label{fig:attitude}  %% label for entire figure
\end{figure}
```


## 参考资料
- [<font color=blue>Overleaf官方文档</font>](https://www.overleaf.com/learn)
- [<font color=blue>BibTex的使用方法</font>](https://www.cnblogs.com/parrynee/archive/2010/03/02/1676369.html)
- [<font color=blue>latex documentclass 及相关布局</font>](https://blog.csdn.net/wei_love_2017/article/details/86617235)
- [<font color=blue>document class</font>](https://latexref.xyz/Document-class-options.html)
- [<font color=blue>LaTex - 从出门到掉到坑</font>](https://zhuanlan.zhihu.com/p/43981639)
- [<font color=blue>LaTex插入图形，表格</font>](https://blog.csdn.net/miracle_fans/article/details/78233304)
- [<font color=blue>LaTeX排版札记</font>](https://zhuanlan.zhihu.com/p/32925549)

- [<font color=blue>用R语言快速生成Latex表格</font>](https://blog.csdn.net/joshua_hit/article/details/60608787)
- [<font color=blue>LaTeX高效写作系列：word表格转LaTeX</font>](https://www.jianshu.com/p/60de8893f731)

