2022.2.18 workshop

## Database

### 基础词汇

**数据库（database，DB）**：相互有关联关系的数据集，以其最基础单元“表”的形式存储；

​                                                 **长期存储**在计算机内，**有组织**、可共享的大量数据集合。其中数据按照一定的数据模型组织、描述和存储，具有较小冗余度（redundancy）、较高的数据独立性（independency）与易扩展性（scalability）,可为各种用户**共享**。



**数据库管理系统（database management system，DBMS）**:介于用户与操作系统之间的数据管理软件，创建与操纵（增删改查）数据框的系统软件；

​		①数据定义功能；

​		②数据组织、存储与管理；

​		③数据操纵功能（增删改查）；

​		④数据库事务管理与运行管理（并发性控制，安全性、完整性，故障修复）

​		⑤数据库建立与维护；

​		⑥其他功能（数据库之间互访和互操作）；

常用的DBMS（均为关系型数据管理系统）：

​		Oracle（优秀但收费）、MySQL、DB2（适合海量数据）与MS SqlServer(仅win)等；



**数据库应用程序（database app，DBAP）**:供用户使用的完成某功能的应用程序；

**数据库**系统：由数据库、数据库管理系统、应用程序和数据库管理员（database administrator,DBA）组成的存储、管理、处理和维护数据的系统。广义”数据库“。

![image-20220224085710660](C:\Users\wangx\AppData\Roaming\Typora\typora-user-images\image-20220224085710660.png)

### 数据库中的数据是如何存储的------数据模型



​		数据模型是对现实世界数据特征的抽象（真实模拟现实世界；易为人理解；可在计算机上实现），由**数据结构**（数据本身-数据之间联系）、**数据操作**和**完整性约束**（状态变化所需要满足条件规则的集合）三部分组成。

​		数据模型是数据库系统的核心和基础。

**数据模型：**

​		**概念模型**：为了实现用户的需求定义的模型，主要是初步表达用户需求；

​		**逻辑模型：**按照用户观点对数据进行建模，主要用于数据库设计。

​				 逻辑模型具体包括：层次模型(hierarchical model ,只有一个父节点的有序树)、网状模型(network model)、**关系模型**(relational model)、面向对象数据模型(object oriented data model)、对象关系数据模型(object relational data model)、半结构化模型(semistructure data model)等。

​		**物理模型**：表示数据在系统内部的表示方法和存取方法，实现数据的物理存储。包括数据的存储位置，索引存放位置，存储文件位置和存储策略等存储细节问题。



**关系模型**

关系模型由一组关系组成，每个关系都是一张规范的二维表。



关系模式：关系名（属性1，属性2，---，属性n）



**分布式数据库**

​		一个应用程序可以对数据库进行透明操作，数据库中的数据分别在不同的局部数据库中存储、由不同的 DBMS进行管理、在不同的机器上运行、由不同的操作系统支持、被不同的通信网络连接在一起。

关系数据库：若干具有关联关系的表的集合。

### **数据库中的数据是如何被操作的---SQL语言**



**SQL（structure query language）**:结构化查询语言数据库通信语言（一套标准编程语言，90%DBMS通用，微小差异）

1. DQL	数据查询语言    select

2. DML	数据操作语言    对数据进行增删改

3. DDL	数据定义语言    对数据结构进行新建create,删除drop,修改alter等

4. TCL	事务控制语言      提交事务commit 回滚事务rollback

5. DCL	事务控制语言    授权grant,撤销revoke

   

**建立数据库**

建立数据库与表；





## MySQL  

![image-20220224085753450](C:\Users\wangx\AppData\Roaming\Typora\typora-user-images\image-20220224085753450.png)

##### MySQL优势：

​		体积小，方便，免费



##### MySQL安装

​		①官网下载安装（[MySQL :: MySQL Downloads](https://www.mysql.com/downloads/)）

​				解压安装（社区版免费）

​		②实例配置

​				**开发机器**

​				**端口号port**，一个软件的唯一代表，通常与IP地址在一起，用于定位一台计算机上的某个服务或应用，具有唯一性。MySQL默认端口号3306

​				**字符编码方式，** UTF8，在Manual selected defult character set 下

​				**配置环境变量,**可勾选path，或手动配置

​				设置MySQL**超级管理员密码**，用户名root，（可选择激活root账户远程访问，即是否允许另一台电脑上使用）

​		③卸载

​				双击安装包remove卸载

​				删除目录，包括program x86下MySQL文件夹、隐藏目录programData下MySQL文件夹，

MySQL安装完成之后默认自启动（服务/属性/选择启动方式），

win中启动MySQL：cmd/net start MySQL

​									cmd/net start MySQL

MySQL-table

行（row）:数据

列（column）:字段

可规定行列属性：字符类型，是否要求唯一等



**MySQL使用**

特点：命令不区分大小写；路径不识别中文；

正则表达式与python一致

本地登录：cmd/masql -uroot -p

连接服务器：Navicat



**MySQL数据类型**

整数类型：BIT、BOOL、TINY INT、SMALL INT、MEDIUM INT、 **INT**、 BIG INT

浮点数类型：**FLOAT、DOUBLE**、DECIMAL（定点数-精确值）

字符串类型：**CHAR**、VARCHAR（ 变长字符串 ）、TINY TEXT、TEXT（文本，区分大小写）、MEDIUM TEXT、LONGTEXT、TINY BLOB、BLOB（二进制）、MEDIUM BLOB、LONG BLOB

日期类型：Date（ 2008-12-2 ）、DateTime（ 2008-12-2 22:06:44 ）、TimeStamp、Time（22:06:44）、Year（ 2009 ）；

其他数据类型：BINARY、VARBINARY、ENUM、SET、Geometry、Point、MultiPoint、LineString、MultiLineString、Polygon、GeometryCollection等



 指定数据类型的时候一般是采用从小原则，比如能用TINY INT的最好就不用INT，提高运行效率。



**MySQL常用命令：**

查看MySQL版本号：select version

查看有哪些库：show database**s**;

使用库：use 库名;   关闭close 库名

查看当前所用库：select databases（）

**创建库**：create database 库名;

**创建表**：create table 表名(字段1  字段1属性，---，字段n  字段n属性 );

**查看**有哪些表：show tables;

查看表中**内容**：select * from 表名   ---输出整个表

​                            desc 表名---输出表头（结构），数据类型，desc 是describe缩写；

​                            **筛选**

​                          	  select 列名

​                        	    from 表名

​	                        条件筛选 --where 筛选条件（and  or not）                                         where score > 60

​                            模糊查找 --  --where 列名 not like/like "字符串"/like "字符串"             where name like "王%“                

​                                               ”%“匹配0或多个字符；“_”匹配任意单个字符；转义字符“\”

​	                        排序 --order by 列名 asc(升序)/desc（降序）                                       order by  score asc

​                               多联表查询

​                          	  select 列名

​                        	    from 表名1 列1，表名2 列2

​                                where 表1.列1=表2.列1 筛选条件

**修改表**

插入元组            insert into  表（列n）

​                           value(列n)

删除元组          delect from 表名 where 筛选条件          保留数据格式

​                         完全删除用   drop table 表名,库同理

更新元组          update 表名 

​                          set 更新操作，如A增幅50，A=A*50%

**以上均可与与select联用，对已有表格中满足条件信息进行操作。



**导入数据**

```mysql
 LOAD DATA LOCAL INFILE 'data.txt' INTO TABLE mytbl;
```

导出数据

```mysql
SELECT * FROM runoob_tbl 
INTO OUTFILE '/tmp/output.txt';
```

退出：exit;



​				











