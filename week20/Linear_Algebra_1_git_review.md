
### 参考资料：

![查看源图像](Linear_Algebra_1.assets/5a013149N8598768a.jpg)



------



### 引言

- 为什么要讲线性代数
- 线性代数在生信方面的应用



#### 一、二元线性方程组与二阶行列式



消元法解二元线性方程组，消去未知数 <a href="https://www.codecogs.com/eqnedit.php?latex=x_{2}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_{2}" title="x_{2}" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=\left\{\begin{matrix}&space;a_{11}x_{1}&space;&plus;&space;a_{12}x_{2}&space;=&space;b_{1},\\&space;a_{21}x_{1}&space;&plus;&space;a_{22}x_{2}&space;=&space;b_{2}&space;\end{matrix}\right." target="_blank"><img src="https://latex.codecogs.com/gif.latex?\left\{\begin{matrix}&space;a_{11}x_{1}&space;&plus;&space;a_{12}x_{2}&space;=&space;b_{1},\\&space;a_{21}x_{1}&space;&plus;&space;a_{22}x_{2}&space;=&space;b_{2}&space;\end{matrix}\right." title="\left\{\begin{matrix} a_{11}x_{1} + a_{12}x_{2} = b_{1},\\ a_{21}x_{1} + a_{22}x_{2} = b_{2} \end{matrix}\right." /></a>

当<a href="https://www.codecogs.com/eqnedit.php?latex=a_{11}a_{22}-a_{12}a_{21}\neq&space;0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{11}a_{22}-a_{12}a_{21}\neq&space;0" title="a_{11}a_{22}-a_{12}a_{21}\neq 0" /></a>时


<a href="https://www.codecogs.com/eqnedit.php?latex=x_{1}&space;=&space;\frac{b_{1}a_{22}-a_{12}b_{2}}{a_{11}a_{22}-a_{12}a_{21}},&space;\&space;x_{2}&space;=&space;\frac{b_{2}a_{11}-a_{21}b_{1}}{a_{11}a_{22}-a_{12}a_{21}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?x_{1}&space;=&space;\frac{b_{1}a_{22}-a_{12}b_{2}}{a_{11}a_{22}-a_{12}a_{21}},&space;\&space;x_{2}&space;=&space;\frac{b_{2}a_{11}-a_{21}b_{1}}{a_{11}a_{22}-a_{12}a_{21}}" title="x_{1} = \frac{b_{1}a_{22}-a_{12}b_{2}}{a_{11}a_{22}-a_{12}a_{21}}, \ x_{2} = \frac{b_{2}a_{11}-a_{21}b_{1}}{a_{11}a_{22}-a_{12}a_{21}}" /></a>

二行二列的二阶行列式，记作

<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\\&space;a_{21}&space;\&space;\&space;a_{22}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\\&space;a_{21}&space;\&space;\&space;a_{22}&space;\end{vmatrix}" title="\begin{vmatrix} a_{11} \ \ a_{12}\\ a_{21} \ \ a_{22} \end{vmatrix}" /></a>

- 行列式的元素或元

  

<a href="https://www.codecogs.com/eqnedit.php?latex=a_{ij}(i&space;=&space;1,2;j&space;=&space;1,2)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{ij}(i&space;=&space;1,2;j&space;=&space;1,2)" title="a_{ij}(i = 1,2;j = 1,2)" /></a>

- 对角线法（仅适用于二阶和三阶行列式）

  - 主对角线
  - 副对角线

  二阶行列式是主对角线上的两元素之积减去副对角线上两元素之积所得的差。

  <img src="Linear_Algebra_1.assets/image-20201012211338790.png/" alt="image-20201012211338790" style="zoom:67%;" />



#### 二、三阶行列式


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\&space;a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}&space;\end{vmatrix}&space;=&space;a_{11}a_{22}a_{33}&space;&plus;&space;a_{12}a_{23}a_{31}&plus;a_{13}a_{21}a_{32}&space;-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\&space;a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}&space;\end{vmatrix}&space;=&space;a_{11}a_{22}a_{33}&space;&plus;&space;a_{12}a_{23}a_{31}&plus;a_{13}a_{21}a_{32}&space;-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" title="\begin{vmatrix} a_{11} \ \ a_{12}\ \ a_{13}\\ a_{21} \ \ a_{22}\ \ a_{23}\\ a_{31} \ \ a_{32}\ \ a_{33} \end{vmatrix} = a_{11}a_{22}a_{33} + a_{12}a_{23}a_{31}+a_{13}a_{21}a_{32} -a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" /></a>

- 对角线法

例：


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;1&&space;2&&space;-4\\&space;-2&&space;2&&space;1\\&space;-3&&space;4&&space;-2&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;1&&space;2&&space;-4\\&space;-2&&space;2&&space;1\\&space;-3&&space;4&&space;-2&space;\end{vmatrix}" title="\begin{vmatrix} 1& 2& -4\\ -2& 2& 1\\ -3& 4& -2 \end{vmatrix}" /></a>

------

#### 逆序数

规定各元素之间有一个标准次序（比如从小到大为标准次序），在任一个排列中，当两个元素的先后次序与标准次序不同时，就说有1个**逆序**，一个排列中所有逆序的总数叫做	**排列的逆序数**。

- 逆序数为奇数的排列叫做**奇排列**

- 逆序数为偶数的排列叫做**偶排列**

  

设n个元素为1至n这n个自然数，规定从小到大为标准次序，假设排列，其中元素 <a href="https://www.codecogs.com/eqnedit.php?latex=p_{i}(i=1,2,...,n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{i}(i=1,2,...,n)" title="p_{i}(i=1,2,...,n)" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex=p_{1}p_{2}\cdots&space;p_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{1}p_{2}\cdots&space;p_{n}" title="p_{1}p_{2}\cdots p_{n}" /></a>

如果比<a href="https://www.codecogs.com/eqnedit.php?latex=p_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{i}" title="p_{i}" /></a> 大的且排在它前面的元素有<a href="https://www.codecogs.com/eqnedit.php?latex=t_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?t_{i}" title="t_{i}" /></a>个，就说这个<a href="https://www.codecogs.com/eqnedit.php?latex=p_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{i}" title="p_{i}" /></a>元素逆序数是<a href="https://www.codecogs.com/eqnedit.php?latex=t_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?t_{i}" title="t_{i}" /></a>，全体元素逆序数之和：


<a href="https://www.codecogs.com/eqnedit.php?latex=t&space;=&space;t_{1}&space;&plus;&space;t_{2}&space;&plus;&space;\cdots&space;&plus;&space;t_{n}&space;=&space;\sum_{t&space;=&space;1}^{n}t_{i}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?t&space;=&space;t_{1}&space;&plus;&space;t_{2}&space;&plus;&space;\cdots&space;&plus;&space;t_{n}&space;=&space;\sum_{t&space;=&space;1}^{n}t_{i}" title="t = t_{1} + t_{2} + \cdots + t_{n} = \sum_{t = 1}^{n}t_{i}" /></a>


举例计算：

求32514的逆序数

答案：【5】

------



#### 三、n阶行列式

先来看三阶行列式：


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}\end{vmatrix}&space;=&space;a_{11}a_{22}a_{33}&space;&plus;&space;a_{12}a_{23}a_{31}&plus;a_{13}a_{21}a_{32}&space;-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}\end{vmatrix}&space;=&space;a_{11}a_{22}a_{33}&space;&plus;&space;a_{12}a_{23}a_{31}&plus;a_{13}a_{21}a_{32}&space;-a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" title="\begin{vmatrix}a_{11} \ \ a_{12}\ \ a_{13}\\ a_{21} \ \ a_{22}\ \ a_{23}\\a_{31} \ \ a_{32}\ \ a_{33}\end{vmatrix} = a_{11}a_{22}a_{33} + a_{12}a_{23}a_{31}+a_{13}a_{21}a_{32} -a_{11}a_{23}a_{32}-a_{12}a_{21}a_{33}-a_{13}a_{22}a_{31}" /></a>

等号右边不管正负号，可以写成<a href="https://www.codecogs.com/eqnedit.php?latex={2p_{2}}a_{3p_{3}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?{2p_{2}}a_{3p_{3}}" title="{2p_{2}}a_{3p_{3}}" /></a>，第一个下标（行标）次序为123，第二个下标（列标）次序为 <a href="https://www.codecogs.com/eqnedit.php?latex=p_{1}p_{2}p_{3}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{1}p_{2}p_{3}" title="p_{1}p_{2}p_{3}" /></a>

带正号列标排列：123，231，312【都是偶排列】

带负号列标排列：132，213，321【都是奇排列】



经过一番操作，t是列标排列的逆序数，三阶行列式可以写成：


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\&space;a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}&space;\end{vmatrix}=\sum&space;(-1)^{t}a_{1p_{1}}a_{2p_{2}}a_{3p_{3}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;a_{11}&space;\&space;\&space;a_{12}\&space;\&space;a_{13}\\&space;a_{21}&space;\&space;\&space;a_{22}\&space;\&space;a_{23}\\&space;a_{31}&space;\&space;\&space;a_{32}\&space;\&space;a_{33}&space;\end{vmatrix}=\sum&space;(-1)^{t}a_{1p_{1}}a_{2p_{2}}a_{3p_{3}}" title="\begin{vmatrix} a_{11} \ \ a_{12}\ \ a_{13}\\ a_{21} \ \ a_{22}\ \ a_{23}\\ a_{31} \ \ a_{32}\ \ a_{33} \end{vmatrix}=\sum (-1)^{t}a_{1p_{1}}a_{2p_{2}}a_{3p_{3}}" /></a>

- **定义**  推广到n阶行列式

  

<a href="https://www.codecogs.com/eqnedit.php?latex=\sum&space;(-1)^{t}a_{1p_{1}}a_{2p_{2}}\cdots&space;a_{np_{n}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\sum&space;(-1)^{t}a_{1p_{1}}a_{2p_{2}}\cdots&space;a_{np_{n}}" title="\sum (-1)^{t}a_{1p_{1}}a_{2p_{2}}\cdots a_{np_{n}}" /></a>
记作：


<a href="https://www.codecogs.com/eqnedit.php?latex=D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a_{nn}&space;\end{vmatrix}" title="D = \begin{vmatrix} a_{11} &a_{12} &\cdots &a_{1n} \\ a_{21} &a_{22} &\cdots &a_{2n} \\ \vdots &\vdots & &\vdots \\ a_{n1} &a_{n2} &\cdots &a_{nn} \end{vmatrix}" /></a>

- 对角行列式

证明n阶行列式


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;\lambda&space;_{1}&space;&&space;&&space;&&space;&&space;\\&space;&&space;&\lambda&space;_{2}&space;&&space;\\&space;&&space;&&space;&\ddots&space;&&space;\\&space;&&space;&&space;&&space;&\lambda&space;_{n}&space;\end{vmatrix}=&space;\lambda&space;_{1}\lambda&space;_{2}\cdots&space;\lambda&space;_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;\lambda&space;_{1}&space;&&space;&&space;&&space;&&space;\\&space;&&space;&\lambda&space;_{2}&space;&&space;\\&space;&&space;&&space;&\ddots&space;&&space;\\&space;&&space;&&space;&&space;&\lambda&space;_{n}&space;\end{vmatrix}=&space;\lambda&space;_{1}\lambda&space;_{2}\cdots&space;\lambda&space;_{n}" title="\begin{vmatrix} \lambda _{1} & & & & \\ & &\lambda _{2} & \\ & & &\ddots & \\ & & & &\lambda _{n} \end{vmatrix}= \lambda _{1}\lambda _{2}\cdots \lambda _{n}" /></a>

其中没有写出来的元素都是0，左端称为**对角行列式**



- 上下三角形行列式

  主对角线以下（上）的元素都为0的行列式叫做**上（下）三角形行列式**，它的值与对角行列式一样

证明以下行列式


<a href="https://www.codecogs.com/eqnedit.php?latex=D=\begin{vmatrix}&space;a_{11}&&space;&&space;&&space;0&&space;\\&space;a_{21}&a_{22}&&space;&&space;&&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;\ddots&space;&&space;&&space;\\&space;a_{n1}&&space;a_{n2}&&space;\cdots&space;&a_{nn}&space;\end{vmatrix}&space;=&space;a_{11}a_{22}\cdots&space;a_{nn}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=\begin{vmatrix}&space;a_{11}&&space;&&space;&&space;0&&space;\\&space;a_{21}&a_{22}&&space;&&space;&&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;\ddots&space;&&space;&&space;\\&space;a_{n1}&&space;a_{n2}&&space;\cdots&space;&a_{nn}&space;\end{vmatrix}&space;=&space;a_{11}a_{22}\cdots&space;a_{nn}" title="D=\begin{vmatrix} a_{11}& & & 0& \\ a_{21}&a_{22}& & & \\ \vdots & \vdots & \ddots & & \\ a_{n1}& a_{n2}& \cdots &a_{nn} \end{vmatrix} = a_{11}a_{22}\cdots a_{nn}" /></a>

------

#### 对换

**定理1**	一个排列中的任意两个元素对换，排列改变奇偶性

**先证相邻对换**：

原排列如下


<a href="https://www.codecogs.com/eqnedit.php?latex=a_{1}...a_{l}abb_{1}...b_{m}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{1}...a_{l}abb_{1}...b_{m}" title="a_{1}...a_{l}abb_{1}...b_{m}" /></a>
对换ab


<a href="https://www.codecogs.com/eqnedit.php?latex=a_{1}...a_{l}bab_{1}...b_{m}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{1}...a_{l}bab_{1}...b_{m}" title="a_{1}...a_{l}bab_{1}...b_{m}" /></a>
如果a<b，a的逆序数增加1，b的逆序数不变的，如果a>b，b的逆序数减少1，a的逆序数不变，因此奇偶性发生了改变。

**再证任意对换**：

设排列<a href="https://www.codecogs.com/eqnedit.php?latex=a_{1}...a_{l}ab_{1}...b_{m}bc_{1}...c_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{1}...a_{l}ab_{1}...b_{m}bc_{1}...c_{n}" title="a_{1}...a_{l}ab_{1}...b_{m}bc_{1}...c_{n}" /></a>，讲a和b进行对换，先做m次相邻对换变成，<a href="https://www.codecogs.com/eqnedit.php?latex=a_{1}...a_{l}abb_{1}...b_{m}c_{1}...c_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{1}...a_{l}abb_{1}...b_{m}c_{1}...c_{n}" title="a_{1}...a_{l}abb_{1}...b_{m}c_{1}...c_{n}" /></a>，b移动到a后，再做m+1次对换变成，<a href="https://www.codecogs.com/eqnedit.php?latex=a_{1}...a_{l}bb_{1}...b_{m}ac_{1}...c_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?a_{1}...a_{l}bb_{1}...b_{m}ac_{1}...c_{n}" title="a_{1}...a_{l}bb_{1}...b_{m}ac_{1}...c_{n}" /></a>，完成a和b的对换，总共做了2m+1次相邻变换，所以变换前后两个排列的奇偶性相反。



**定理2**	n阶行列式也可定义为

其中t为行标排列	<a href="https://www.codecogs.com/eqnedit.php?latex=p_{1}p_{2}...p_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{1}p_{2}...p_{n}" title="p_{1}p_{2}...p_{n}" /></a>	的逆序数


<a href="https://www.codecogs.com/eqnedit.php?latex=D=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" title="D=\sum (-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots a_{p_{n}n}" /></a>

------



#### 四、行列式的性质

- 转置行列式

  <a href="https://www.codecogs.com/eqnedit.php?latex=D^{T}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D^{T}" title="D^{T}" /></a>称为行列式D的转置行列式
  
  
<a href="https://www.codecogs.com/eqnedit.php?latex=D=\begin{vmatrix}&space;a_{11}&&space;a_{21}&space;&&space;\cdots&space;&&space;a_{n1}&space;\\&space;a_{12}&&space;a_{22}&&space;\cdots&space;&&space;a_{n2}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;a_{1n}&&space;a_{2n}&&space;\cdots&space;&&space;a_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=\begin{vmatrix}&space;a_{11}&&space;a_{21}&space;&&space;\cdots&space;&&space;a_{n1}&space;\\&space;a_{12}&&space;a_{22}&&space;\cdots&space;&&space;a_{n2}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;a_{1n}&&space;a_{2n}&&space;\cdots&space;&&space;a_{nn}&space;\end{vmatrix}" title="D=\begin{vmatrix} a_{11}& a_{21} & \cdots & a_{n1} \\ a_{12}& a_{22}& \cdots & a_{n2} \\ \vdots & \vdots & & \vdots \\ a_{1n}& a_{2n}& \cdots & a_{nn} \end{vmatrix}" /></a>
  

<a href="https://www.codecogs.com/eqnedit.php?latex=D^{T}=\begin{vmatrix}&space;a_{11}&&space;a_{12}&space;&&space;\cdots&space;&&space;a_{1n}&space;\\&space;a_{21}&&space;a_{22}&&space;\cdots&space;&&space;a_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;a_{n1}&&space;a_{n2}&&space;\cdots&space;&&space;a_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D^{T}=\begin{vmatrix}&space;a_{11}&&space;a_{12}&space;&&space;\cdots&space;&&space;a_{1n}&space;\\&space;a_{21}&&space;a_{22}&&space;\cdots&space;&&space;a_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;a_{n1}&&space;a_{n2}&&space;\cdots&space;&&space;a_{nn}&space;\end{vmatrix}" title="D^{T}=\begin{vmatrix} a_{11}& a_{12} & \cdots & a_{1n} \\ a_{21}& a_{22}& \cdots & a_{2n} \\ \vdots & \vdots & & \vdots \\ a_{n1}& a_{n2}& \cdots & a_{nn} \end{vmatrix}" /></a>



##### 性质1	行列式与它的转置行列式相等

证明：

记D的转置行列式为：


<a href="https://www.codecogs.com/eqnedit.php?latex=D^{T}=\begin{vmatrix}&space;b_{11}&&space;b_{12}&space;&&space;\cdots&space;&&space;b_{1n}&space;\\&space;b_{21}&&space;b_{22}&&space;\cdots&space;&&space;b_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;b_{n1}&&space;b_{n2}&&space;\cdots&space;&&space;b_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D^{T}=\begin{vmatrix}&space;b_{11}&&space;b_{12}&space;&&space;\cdots&space;&&space;b_{1n}&space;\\&space;b_{21}&&space;b_{22}&&space;\cdots&space;&&space;b_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;b_{n1}&&space;b_{n2}&&space;\cdots&space;&&space;b_{nn}&space;\end{vmatrix}" title="D^{T}=\begin{vmatrix} b_{11}& b_{12} & \cdots & b_{1n} \\ b_{21}& b_{22}& \cdots & b_{2n} \\ \vdots & \vdots & & \vdots \\ b_{n1}& b_{n2}& \cdots & b_{nn} \end{vmatrix}" /></a>



<a href="https://www.codecogs.com/eqnedit.php?latex=b_{ji}=a_{ij}(i,j&space;=&space;1,2,...,n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?b_{ji}=a_{ij}(i,j&space;=&space;1,2,...,n)" title="b_{ji}=a_{ij}(i,j = 1,2,...,n)" /></a>，按照定义：


<a href="https://www.codecogs.com/eqnedit.php?latex=D^{T}=\sum&space;(-1)^{t}b_{1p_{1}}b_{2p_{2}}\cdots&space;b_{np_{n}}=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D^{T}=\sum&space;(-1)^{t}b_{1p_{1}}b_{2p_{2}}\cdots&space;b_{np_{n}}=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" title="D^{T}=\sum (-1)^{t}b_{1p_{1}}b_{2p_{2}}\cdots b_{np_{n}}=\sum (-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots a_{p_{n}n}" /></a>

由定理2，<a href="https://www.codecogs.com/eqnedit.php?latex=D=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=\sum&space;(-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots&space;a_{p_{n}n}" title="D=\sum (-1)^{t}a_{p_{1}1}a_{p_{2}2}\cdots a_{p_{n}n}" /></a>，因此<a href="https://www.codecogs.com/eqnedit.php?latex=D=D^{T}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=D^{T}" title="D=D^{T}" /></a>

通过这个性质可知，行列式的行和列地位相当，凡是行具有的性质，列也一样，反过来说也成立。



##### 性质2	互换行列式的两行（列），行列式变号

证明：

假设行列式<a href="https://www.codecogs.com/eqnedit.php?latex=D_{1}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D_{1}" title="D_{1}" /></a>是由原行列式交换i，j两行得到的


<a href="https://www.codecogs.com/eqnedit.php?latex=D_{1}=\begin{vmatrix}&space;b_{11}&&space;b_{12}&space;&&space;\cdots&space;&&space;b_{1n}&space;\\&space;b_{21}&&space;b_{22}&&space;\cdots&space;&&space;b_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;b_{n1}&&space;b_{n2}&&space;\cdots&space;&&space;b_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D_{1}=\begin{vmatrix}&space;b_{11}&&space;b_{12}&space;&&space;\cdots&space;&&space;b_{1n}&space;\\&space;b_{21}&&space;b_{22}&&space;\cdots&space;&&space;b_{2n}&space;\\&space;\vdots&space;&&space;\vdots&space;&&space;&&space;\vdots&space;\\&space;b_{n1}&&space;b_{n2}&&space;\cdots&space;&&space;b_{nn}&space;\end{vmatrix}" title="D_{1}=\begin{vmatrix} b_{11}& b_{12} & \cdots & b_{1n} \\ b_{21}& b_{22}& \cdots & b_{2n} \\ \vdots & \vdots & & \vdots \\ b_{n1}& b_{n2}& \cdots & b_{nn} \end{vmatrix}" /></a>

当<a href="https://www.codecogs.com/eqnedit.php?latex=k\neq&space;i,j" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k\neq&space;i,j" title="k\neq i,j" /></a>时，<a href="https://www.codecogs.com/eqnedit.php?latex=b_{kp}&space;=&space;a_{kp}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?b_{kp}&space;=&space;a_{kp}" title="b_{kp} = a_{kp}" /></a>，当<a href="https://www.codecogs.com/eqnedit.php?latex=k=i,j" target="_blank"><img src="https://latex.codecogs.com/gif.latex?k=i,j" title="k=i,j" /></a>时，<a href="https://www.codecogs.com/eqnedit.php?latex=b_{ip}&space;=&space;a_{jp}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?b_{ip}&space;=&space;a_{jp}" title="b_{ip} = a_{jp}" /></a>，<a href="https://www.codecogs.com/eqnedit.php?latex=b_{jp}&space;=&space;a_{ip}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?b_{jp}&space;=&space;a_{ip}" title="b_{jp} = a_{ip}" /></a>，于是


<a href="https://www.codecogs.com/eqnedit.php?latex=D_{1}=\sum&space;(-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D_{1}=\sum&space;(-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}" title="D_{1}=\sum (-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex==\sum&space;(-1)^{t}a_{1p_{1}}...a_{jp_{i}}...a_{ip_{j}}...a_{np_{n}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?=\sum&space;(-1)^{t}a_{1p_{1}}...a_{jp_{i}}...a_{ip_{j}}...a_{np_{n}}" title="=\sum (-1)^{t}a_{1p_{1}}...a_{jp_{i}}...a_{ip_{j}}...a_{np_{n}}" /></a>

<a href="https://www.codecogs.com/eqnedit.php?latex==\sum&space;(-1)^{t}a_{1p_{1}}...a_{ip_{j}}...a_{jp_{i}}...a_{np_{n}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?=\sum&space;(-1)^{t}a_{1p_{1}}...a_{ip_{j}}...a_{jp_{i}}...a_{np_{n}}" title="=\sum (-1)^{t}a_{1p_{1}}...a_{ip_{j}}...a_{jp_{i}}...a_{np_{n}}" /></a>

1...i...j...n为自然排列，t为<a href="https://www.codecogs.com/eqnedit.php?latex=p_{1}...p_{i}...p_{j}...p_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{1}...p_{i}...p_{j}...p_{n}" title="p_{1}...p_{i}...p_{j}...p_{n}" /></a>的逆序数，设<a href="https://www.codecogs.com/eqnedit.php?latex=p_{1}...p_{j}...p_{i}...p_{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_{1}...p_{j}...p_{i}...p_{n}" title="p_{1}...p_{j}...p_{i}...p_{n}" /></a>的逆序数为<a href="https://www.codecogs.com/eqnedit.php?latex=t_{1}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?t_{1}" title="t_{1}" /></a>，故<a href="https://www.codecogs.com/eqnedit.php?latex=(-1)^{t}&space;=&space;-(-1)^{t_{1}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?(-1)^{t}&space;=&space;-(-1)^{t_{1}}" title="(-1)^{t} = -(-1)^{t_{1}}" /></a>


<a href="https://www.codecogs.com/eqnedit.php?latex=D_{1}=-\sum&space;(-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}=-D" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D_{1}=-\sum&space;(-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}=-D" title="D_{1}=-\sum (-1)^{t}b_{1p_{1}}...b_{ip_{i}}...b_{jp_{j}}...b_{np_{n}}=-D" /></a>


##### 推论	如果行列式有两行（列）完全相同，则此行列式等于0

因为这两行互换的结果是<a href="https://www.codecogs.com/eqnedit.php?latex=D=-D" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=-D" title="D=-D" /></a>，所以<a href="https://www.codecogs.com/eqnedit.php?latex=D=0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D=0" title="D=0" /></a>



##### 性质3	行列式的某一行（列）中所有的元素都乘以同一个数k，等于用数k乘以此行列式

**推论**	**行列式的某一行（列）中所有的元素的公因子可以提到行列式记号的外面**



##### 性质4	行列式中如果有两行（列）元素成比例，则此行列式等于零



##### 性质5 	若行列式的某一列（行）的元素都是两数之和，例如第i列的元素都是两数之和：



<a href="https://www.codecogs.com/eqnedit.php?latex=D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&(a_{1i}&plus;a{}'_{1i})&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&(a_{2i}&plus;a{}'_{2i})&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&(a_{ni}&plus;a{}'_{ni})&space;&a_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&(a_{1i}&plus;a{}'_{1i})&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&(a_{2i}&plus;a{}'_{2i})&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&(a_{ni}&plus;a{}'_{ni})&space;&a_{nn}&space;\end{vmatrix}" title="D = \begin{vmatrix} a_{11} &a_{12} &\cdots &(a_{1i}+a{}'_{1i}) &a_{1n} \\ a_{21} &a_{22} &\cdots &(a_{2i}+a{}'_{2i}) &a_{2n} \\ \vdots &\vdots & &\vdots &\vdots \\ a_{n1} &a_{n2} &\cdots &(a_{ni}+a{}'_{ni}) &a_{nn} \end{vmatrix}" /></a>


**则$D$等于下列两个行列式之和**


<a href="https://www.codecogs.com/eqnedit.php?latex=D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a_{1i}&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a_{2i}&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a_{ni}&space;&a_{nn}&space;\end{vmatrix}&plus;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a{}'_{1i}&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a{}'_{2i}&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a{}'_{ni}&space;&a_{nn}&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?D&space;=&space;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a_{1i}&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a_{2i}&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a_{ni}&space;&a_{nn}&space;\end{vmatrix}&plus;\begin{vmatrix}&space;a_{11}&space;&a_{12}&space;&\cdots&space;&a{}'_{1i}&space;&a_{1n}&space;\\&space;a_{21}&space;&a_{22}&space;&\cdots&space;&a{}'_{2i}&space;&a_{2n}&space;\\&space;\vdots&space;&\vdots&space;&&space;&\vdots&space;&\vdots&space;\\&space;a_{n1}&space;&a_{n2}&space;&\cdots&space;&a{}'_{ni}&space;&a_{nn}&space;\end{vmatrix}" title="D = \begin{vmatrix} a_{11} &a_{12} &\cdots &a_{1i} &a_{1n} \\ a_{21} &a_{22} &\cdots &a_{2i} &a_{2n} \\ \vdots &\vdots & &\vdots &\vdots \\ a_{n1} &a_{n2} &\cdots &a_{ni} &a_{nn} \end{vmatrix}+\begin{vmatrix} a_{11} &a_{12} &\cdots &a{}'_{1i} &a_{1n} \\ a_{21} &a_{22} &\cdots &a{}'_{2i} &a_{2n} \\ \vdots &\vdots & &\vdots &\vdots \\ a_{n1} &a_{n2} &\cdots &a{}'_{ni} &a_{nn} \end{vmatrix}" /></a>




##### 性质6	把行列式的某一列（行）的各元素乘以同一数然后加到另一列（行）对应的元素上去，行列式不变

尝试计算一下:


<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{vmatrix}&space;3&space;&&space;1&space;&&space;-1&space;&&space;2\\&space;-1&space;&&space;1&&space;3&&space;-4\\&space;2&space;&&space;0&&space;1&&space;-1\\&space;1&space;&&space;-5&&space;3&&space;-3&space;\end{vmatrix}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{vmatrix}&space;3&space;&&space;1&space;&&space;-1&space;&&space;2\\&space;-1&space;&&space;1&&space;3&&space;-4\\&space;2&space;&&space;0&&space;1&&space;-1\\&space;1&space;&&space;-5&&space;3&&space;-3&space;\end{vmatrix}" title="\begin{vmatrix} 3 & 1 & -1 & 2\\ -1 & 1& 3& -4\\ 2 & 0& 1& -1\\ 1 & -5& 3& -3 \end{vmatrix}" /></a>


答案：【40】


