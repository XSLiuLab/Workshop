# SQL

**Structured Query Language**:结构化查询语言，用来访问和操作数据库系统。SQL既可以查询，也可以修改



参考：

* https://www.runoob.com/sql/sql-tutorial.html
* https://www.liaoxuefeng.com/wiki/1177760294764384
* https://www.runoob.com/python/python-mysql.html

## 关系型数据

* 关系模型

![关系模型](https://gitee.com/limbo1996/picgo/raw/master/png/20201010210743.png)

关系模型就像时二维表格，通过行号和列号来唯一确定，数据像是一个Excel表格

| ID   | 姓名 | 班级ID | 性别 | 年龄 |
| ---- | ---- | ------ | ---- | ---- |
| 1    | a    | 201    | M    | 9    |
| 2    | b    | 202    | F    | 8    |
| 3    | c    | 202    | M    | 8    |
| 4    | d    | 201    | F    | 9    |

| ID   | 名称       | 班主任 |
| ---- | ---------- | ------ |
| 201  | 二年级一班 | xxx    |
| 202  | 二年级二班 | yyy    |

## 主流的数据库

1. 商用数据库，例如：[Oracle](https://www.oracle.com/)，[SQL Server](https://www.microsoft.com/sql-server/)，[DB2](https://www.ibm.com/db2/)等；
2. 开源数据库，例如：[MySQL](https://www.mysql.com/)，[PostgreSQL](https://www.postgresql.org/)等；
3. 桌面数据库，以微软[Access](https://products.office.com/access)为代表，适合桌面应用程序使用；
4. 嵌入式数据库，以[Sqlite](https://sqlite.org/)为代表，适合手机应用和桌面程序

## MySQL安装

安装MySQL

下载地址(https://dev.mysql.com/downloads/)

```shell
sudo apt-get install mysql-server
```

## MySQL启动

```shell
mysql -u root -p
```

输入密码，没有密码直接回车。

输入`exit`退出，但MySQL服务器仍在后台运行。

## 关系模型

表的每一行成为**记录**(Record).

每一列成为**字段**。

关系行数据库的表和表之间可以建立“一对多”，“多对一”，“一对一”的关系。

例如：

> 班级列表中每一行对应一个班级，一个班级对应多个学生，所以班级表和学生表的关系是一对多

在关系性数据库中，关系是通过**主键**和**外键**来维护的

### 主键

对于关系表，一个重要的约束就是两条记录不能重复，即不完全相同，能通过某个字段唯一的区分开，这个字段称之为**主键**

如果把`name`当作主键，那通过名字`小明`和`小红`,就可以确定记录，但是没有办法储存同名的记录。

对于主键的要求，最关键的是**一旦插入最好不要修改**。



所有涉及信息的字段一般都不用来作为主键：手机号，邮箱等等。

主键最好是完全业务无关的字段，一般命名为`id`。

#### 联合主键

关系数据库实际上允许通过多个字段唯一标识记录，即两个或者更多字段都设置为主键，这种的称之为**联合主键**。

> 只要不是所有主键列都重复即可

### 外键

| id   | name | ...  |
| ---- | ---- | ---- |
| 1    | 小明 | ...  |
| 2    | 小红 | ...  |

| id   | name | ..   |
| ---- | ---- | ---- |
| 1    | 一班 | ...  |
| 2    | 二班 | ...  |

以上两个表，我们通过主键可以确定唯一的一个学生的记录和一个班级的记录，但是如何将两个数据链接起来？

在第一张表中加入一列`class_id`与班级的某条记录相对应

| id   | class_id | name | ...  |
| ---- | -------- | ---- | ---- |
| 1    | 1        | xxx  | .... |
| 2    | 1        | yyy  | ...  |
| 5    | 2        | zzz  | ...  |

这样就可以根据`class_id`直接定位`students`对应哪条记录。

外键是通过定义实现的

```mysql
ALTER TABLE students
ADD CONSTRAINT fk_class_id
FOREIGN KEY (class_id)
REFERENCES classes (id);
```

外键约束的名称`fk_class_id`可以任意，`FOREIGN KEY (class_id)`指定了`class_id`作为外键，`REFERENCES classes (id)`指定了这个外键将关联到`classes`表的`id`列（即`classes`表的主键）。

通过定义外键约束，关系数据库可以保证无法插入无效的数据。

> 如果classes表不存在`id=99`的记录，那`students`表就无法插入`class_id=99`的记录

#### 多对多

当出现多对多的情况，一个老师对应多个班级，一个班级对应多个老师。

多对多实际上是通过两个一对多关系实现的，即通过一个中间表，关联两个一对多关系

`teachers`表：

| id   | name   |
| :--- | :----- |
| 1    | 张老师 |
| 2    | 王老师 |
| 3    | 李老师 |
| 4    | 赵老师 |

`classes`表：

| id   | name |
| :--- | :--- |
| 1    | 一班 |
| 2    | 二班 |

中间表`teacher_class`关联两个一对多关系：

| id   | teacher_id | class_id |
| :--- | :--------- | :------- |
| 1    | 1          | 1        |
| 2    | 1          | 2        |
| 3    | 2          | 1        |
| 4    | 2          | 2        |
| 5    | 3          | 1        |
| 6    | 4          | 2        |

#### 一对一

| id   | student_id | mobile      |
| :--- | :--------- | :---------- |
| 1    | 1          | 135xxxx6300 |
| 2    | 2          | 138xxxx2209 |
| 3    | 5          | 139xxxx8086 |

`students`表中每个学生有自己的联系方式，如果把联系方式存在另一个表中，就形成了“一对一”

### 索引

索引的应用场景是在记录非常多的时候，可以实现快速查找

索引是关系数据库中对某一列或者多割裂的值进行预排序的数据结构。通过索引，可以不必扫描，而是直接定位。

例如，对于`students`表：

| id   | class_id | name | gender | score |
| :--- | :------- | :--- | :----- | :---- |
| 1    | 1        | 小明 | M      | 90    |
| 2    | 1        | 小红 | F      | 95    |
| 3    | 1        | 小军 | M      | 88    |

如果要经常根据`score`列进行查询，就可以对`score`列创建索引：

```mysql
ALTER TABLE students
ADD INDEX idx_score (score);
```

使用`ADD INDEX idx_score (score)`就创建了一个名称为`idx_score`，使用列`score`的索引。索引名称是任意的，索引如果有多列，可以在括号里依次写上，例如：

```mysql
ALTER TABLE students
ADD INDEX idx_name_score (name, score);
```

索引的效率取决于索引列的值，即该列的值如果互不相同，那么索引效率就越高。

可以对一张表创建多个索引。索引的优点是提高了查询效率，缺点是在插入、更新和删除记录时，需要同时修改索引，因此，索引越多，插入、更新和删除记录的速度就越慢。

对于主键，关系数据库会自动对其创建主键索引。使用主键索引的效率是最高的，因为主键会保证绝对唯一。

#### 唯一索引

有的列虽然不适合作为主键但是却需要唯一：比如身份证，邮箱。

这是可以给该列添加唯一索引

```mysql
ALTER TABLE students
ADD UNIQUE INDEX uni_name (name);
```

通过`UNIQUE`关键字我们就添加了一个唯一索引.

也可以只对某一列添加一个唯一约束而不创建唯一索引,因为索引所占用磁盘空间：

```mysql
ALTER TABLE students
ADD CONSTRAINT uni_name UNIQUE (name);
```

这种情况下，`name`列没有索引，但仍然具有唯一性保证。

## 查询数据

### 示例数据准备

SQL脚本

```sql
-- 如果test数据库不存在，就创建test数据库：
CREATE DATABASE IF NOT EXISTS test;

-- 切换到test数据库
USE test;

-- 删除classes表和students表（如果存在）：
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS students;

-- 创建classes表：
CREATE TABLE classes (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 创建students表：
CREATE TABLE students (
    id BIGINT NOT NULL AUTO_INCREMENT,
    class_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 插入classes记录：
INSERT INTO classes(id, name) VALUES (1, '一班');
INSERT INTO classes(id, name) VALUES (2, '二班');
INSERT INTO classes(id, name) VALUES (3, '三班');
INSERT INTO classes(id, name) VALUES (4, '四班');

-- 插入students记录：
INSERT INTO students (id, class_id, name, gender, score) VALUES (1, 1, '小明', 'M', 90);
INSERT INTO students (id, class_id, name, gender, score) VALUES (2, 1, '小红', 'F', 95);
INSERT INTO students (id, class_id, name, gender, score) VALUES (3, 1, '小军', 'M', 88);
INSERT INTO students (id, class_id, name, gender, score) VALUES (4, 1, '小米', 'F', 73);
INSERT INTO students (id, class_id, name, gender, score) VALUES (5, 2, '小白', 'F', 81);
INSERT INTO students (id, class_id, name, gender, score) VALUES (6, 2, '小兵', 'M', 55);
INSERT INTO students (id, class_id, name, gender, score) VALUES (7, 2, '小林', 'M', 85);
INSERT INTO students (id, class_id, name, gender, score) VALUES (8, 3, '小新', 'F', 91);
INSERT INTO students (id, class_id, name, gender, score) VALUES (9, 3, '小王', 'M', 89);
INSERT INTO students (id, class_id, name, gender, score) VALUES (10, 3, '小丽', 'F', 85);

-- OK:
SELECT 'ok' as 'result:';
```

### 基本查询

> SELECT * FROM <表名>;

```sql
mysql> SELECT * FROM students;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
+----+----------+--------+--------+-------+
10 rows in set (0.00 sec)
```

`SELECT`是关键字，表示要执行一个查询，`*`表示所有列，`FROM`表示从哪个表查询

```sql
mysql> SELECT * FROM classes;
+----+--------+
| id | name   |
+----+--------+
|  1 | 一班   |
|  2 | 二班   |
|  3 | 三班   |
|  4 | 四班   |
+----+--------+
4 rows in set (0.00 sec)
```

`SELECT`并不一定要`FROM`

```sql
mysql> SELECT 100 + 200;
+-----------+
| 100 + 200 |
+-----------+
|       300 |
+-----------+
1 row in set (0.00 sec)
```

不带`FROM`的`SELECT`的一个用途是用来判断当前的数据库链接是否有效。

### 条件查询

即根据条件选择子集。

使用`WHERE`。

> SELECT * FROM <表名> WHERE <表达式>

```sql
mysql> SELECT * FROM students WHERE score >= 80;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  5 |        2 | 小白   | F      |    81 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
+----+----------+--------+--------+-------+
8 rows in set (0.00 sec)
```

条件可以用`AND`,`OR`,`NOT`链接

* AND

```sql
mysql> SELECT * FROM students WHERE score >= 80 AND gender = 'M';
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  3 |        1 | 小军   | M      |    88 |
|  7 |        2 | 小林   | M      |    85 |
|  9 |        3 | 小王   | M      |    89 |
+----+----------+--------+--------+-------+
4 rows in set (0.02 sec)
```

* OR

```sql
mysql> SELECT * FROM students WHERE score >= 80 OR gender = 'M';
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
+----+----------+--------+--------+-------+
9 rows in set (0.01 sec)
```

* NOT

```sql
mysql> SELECT * FROM students WHERE NOT class_id = 2;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
+----+----------+--------+--------+-------+
7 rows in set (0.00 sec)
```

`NOT class_id = 2`等价于`class_id <> 2`

组合三个条件需要用`()`

```sql
mysql> SELECT * FROM students WHERE (score < 80 OR score > 90) AND gender = 'M';
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  6 |        2 | 小兵   | M      |    55 |
+----+----------+--------+--------+-------+
1 row in set (0.00 sec)
```

常用表达式

| 条件                 | 表达式举例1     | 表达式举例2      | 说明                                              |
| :------------------- | :-------------- | :--------------- | :------------------------------------------------ |
| 使用=判断相等        | score = 80      | name = 'abc'     | 字符串需要用单引号括起来                          |
| 使用>判断大于        | score > 80      | name > 'abc'     | 字符串比较根据ASCII码，中文字符比较根据数据库设置 |
| 使用>=判断大于或相等 | score >= 80     | name >= 'abc'    |                                                   |
| 使用<判断小于        | score < 80      | name <= 'abc'    |                                                   |
| 使用<=判断小于或相等 | score <= 80     | name <= 'abc'    |                                                   |
| 使用<>判断不相等     | score <> 80     | name <> 'abc'    |                                                   |
| 使用LIKE判断相似     | name LIKE 'ab%' | name LIKE '%bc%' | %表示任意字符，例如'ab%'将匹配'ab'，'abc'，'abcd' |

### 投影查询

即只希望返回某些列而不是所有列

```sql
mysql> SELECT class_id, score, name FROM students;
+----------+-------+--------+
| class_id | score | name   |
+----------+-------+--------+
|        1 |    90 | 小明   |
|        1 |    95 | 小红   |
|        1 |    88 | 小军   |
|        1 |    73 | 小米   |
|        2 |    81 | 小白   |
|        2 |    55 | 小兵   |
|        2 |    85 | 小林   |
|        3 |    91 | 小新   |
|        3 |    89 | 小王   |
|        3 |    85 | 小丽   |
+----------+-------+--------+
10 rows in set (0.00 sec)
```

同时可以给每一列起一个别名，结果的列名可以和原来表的列名不同。

```sql
mysql> SELECT id, score point, name FROM students;
+----+-------+--------+
| id | point | name   |
+----+-------+--------+
|  1 |    90 | 小明   |
|  2 |    95 | 小红   |
|  3 |    88 | 小军   |
|  4 |    73 | 小米   |
|  5 |    81 | 小白   |
|  6 |    55 | 小兵   |
|  7 |    85 | 小林   |
|  8 |    91 | 小新   |
|  9 |    89 | 小王   |
| 10 |    85 | 小丽   |
+----+-------+--------+
10 rows in set (0.00 sec)
```

同样支持`WHERE`

```sql
mysql> SELECT id, score points, name FROM students WHERE gender = "M";
+----+--------+--------+
| id | points | name   |
+----+--------+--------+
|  1 |     90 | 小明   |
|  3 |     88 | 小军   |
|  6 |     55 | 小兵   |
|  7 |     85 | 小林   |
|  9 |     89 | 小王   |
+----+--------+--------+
5 rows in set (0.02 sec)
```

### 排序

查询时默认是按照主键排序的，如果有根据其他条件排序的需求。可以使用`ORDER BY`.

默认是由低到高

```sql
mysql> SELECT id, name, score FROM students ORDER BY score;
+----+--------+-------+
| id | name   | score |
+----+--------+-------+
|  6 | 小兵   |    55 |
|  4 | 小米   |    73 |
|  5 | 小白   |    81 |
|  7 | 小林   |    85 |
| 10 | 小丽   |    85 |
|  3 | 小军   |    88 |
|  9 | 小王   |    89 |
|  1 | 小明   |    90 |
|  8 | 小新   |    91 |
|  2 | 小红   |    95 |
+----+--------+-------+
10 rows in set (0.02 sec)
```

由高到底添加`DESC`

```sql
mysql> SELECT id, name, score FROM students ORDER BY score DESC;
+----+--------+-------+
| id | name   | score |
+----+--------+-------+
|  2 | 小红   |    95 |
|  8 | 小新   |    91 |
|  1 | 小明   |    90 |
|  9 | 小王   |    89 |
|  3 | 小军   |    88 |
|  7 | 小林   |    85 |
| 10 | 小丽   |    85 |
|  5 | 小白   |    81 |
|  4 | 小米   |    73 |
|  6 | 小兵   |    55 |
+----+--------+-------+
10 rows in set (0.00 sec)
```

按照多列排序

```sql
mysql> SELECT id, name,gender, score FROM students ORDER BY score DESC, gender;
+----+--------+--------+-------+
| id | name   | gender | score |
+----+--------+--------+-------+
|  2 | 小红   | F      |    95 |
|  8 | 小新   | F      |    91 |
|  1 | 小明   | M      |    90 |
|  9 | 小王   | M      |    89 |
|  3 | 小军   | M      |    88 |
| 10 | 小丽   | F      |    85 |
|  7 | 小林   | M      |    85 |
|  5 | 小白   | F      |    81 |
|  4 | 小米   | F      |    73 |
|  6 | 小兵   | M      |    55 |
+----+--------+--------+-------+
10 rows in set (0.00 sec)

```

```sql
mysql> SELECT id, name, gender, score 
    -> FROM students
    -> WHERE  class_id = 1
    -> ORDER BY score DESC;
+----+--------+--------+-------+
| id | name   | gender | score |
+----+--------+--------+-------+
|  2 | 小红   | F      |    95 |
|  1 | 小明   | M      |    90 |
|  3 | 小军   | M      |    88 |
|  4 | 小米   | F      |    73 |
+----+--------+--------+-------+
4 rows in set (0.02 sec)
```

### 分页查询

也就是对查询结果取子集

用`LIMIT <M> OFFSET <N>`

```sql
mysql> SELECT id, name, gender, score  FROM students ORDER BY score DESC LIMIT 3 OFFSET 0; 
+----+--------+--------+-------+
| id | name   | gender | score |
+----+--------+--------+-------+
|  2 | 小红   | F      |    95 |
|  8 | 小新   | F      |    91 |
|  1 | 小明   | M      |    90 |
+----+--------+--------+-------+
3 rows in set (0.00 sec)

```

`LIMIT 3 OFFSET 0 `表示从0号记录开始， 每次最多取3条

`OFFSET`超过了最大数量不会报错，只是会返回空的结果集。

```sql
mysql> SELECT id, name, gender, score  FROM students ORDER BY score DESC LIMIT 3 OFFSET 10;


Empty set (0.00 sec)
```

`OFFSET`是可选的，如果只写`LIMIT 15`，那么相当于`LIMIT 15 OFFSET 0`。

在MySQL中，`LIMIT 15 OFFSET 30`还可以简写成`LIMIT 30, 15`。

使用`LIMIT  OFFSET `分页时，随着`N`越来越大，查询效率也会越来越低。

### 聚合查询

对于统计总数，平均时这类计算`sql`提供了了专门的函数

查询多少条记录，用`COUNT()`

```sql
mysql> SELECT COUNT(*) FROM students;
+----------+
| COUNT(*) |
+----------+
|       10 |
+----------+
1 row in set (0.00 sec)
```

聚合查询同样可以使用`WHERE`条件

```sql
mysql> SELECT COUNT(*) boys FROM students WHERE gender = 'M';
+------+
| boys |
+------+
|    5 |
+------+
1 row in set (0.00 sec)
```

其他聚合函数

| 函数 | 说明                                   |
| :--- | :------------------------------------- |
| SUM  | 计算某一列的合计值，该列必须为数值类型 |
| AVG  | 计算某一列的平均值，该列必须为数值类型 |
| MAX  | 计算某一列的最大值                     |
| MIN  | 计算某一列的最小值                     |

```sql
mysql> SELECT SUM(score) num 
    -> FROM students 
    -> WHERE gender = 'M';
+------+
| num  |
+------+
|  407 |
+------+
1 row in set (0.08 sec)
```

注意，`MAX()`和`MIN()`函数并不限于数值类型。如果是字符类型，`MAX()`和`MIN()`会返回排序最后和排序最前的字符。

#### 分组

想要一次统计所有班级学生数量.

使用`GROUP BY` 

```sql
mysql> SELECT COUNT(*) num FROM students GROUP BY class_id;
+-----+
| num |
+-----+
|   4 |
|   3 |
|   3 |
+-----+
3 rows in set (0.00 sec)
```

加入具体的班级ID

```sql
mysql> SELECT class_id, COUNT(*) num FROM students GROUP BY class_id;
+----------+-----+
| class_id | num |
+----------+-----+
|        1 |   4 |
|        2 |   3 |
|        3 |   3 |
+----------+-----+
3 rows in set (0.00 sec)

```

### 多表查询

`SELECT`可以同时从多张表中查询数据

```sql
mysql> SELECT * FROM students, classes;
+----+----------+--------+--------+-------+----+--------+
| id | class_id | name   | gender | score | id | name   |
+----+----------+--------+--------+-------+----+--------+
|  1 |        1 | 小明   | M      |    90 |  1 | 一班   |
|  1 |        1 | 小明   | M      |    90 |  2 | 二班   |
|  1 |        1 | 小明   | M      |    90 |  3 | 三班   |
|  1 |        1 | 小明   | M      |    90 |  4 | 四班   |
|  2 |        1 | 小红   | F      |    95 |  1 | 一班   |
|  2 |        1 | 小红   | F      |    95 |  2 | 二班   |
|  2 |        1 | 小红   | F      |    95 |  3 | 三班   |
|  2 |        1 | 小红   | F      |    95 |  4 | 四班   |
|  3 |        1 | 小军   | M      |    88 |  1 | 一班   |
|  3 |        1 | 小军   | M      |    88 |  2 | 二班   |
|  3 |        1 | 小军   | M      |    88 |  3 | 三班   |
|  3 |        1 | 小军   | M      |    88 |  4 | 四班   |
|  4 |        1 | 小米   | F      |    73 |  1 | 一班   |
|  4 |        1 | 小米   | F      |    73 |  2 | 二班   |
|  4 |        1 | 小米   | F      |    73 |  3 | 三班   |
|  4 |        1 | 小米   | F      |    73 |  4 | 四班   |
|  5 |        2 | 小白   | F      |    81 |  1 | 一班   |
|  5 |        2 | 小白   | F      |    81 |  2 | 二班   |
|  5 |        2 | 小白   | F      |    81 |  3 | 三班   |
|  5 |        2 | 小白   | F      |    81 |  4 | 四班   |
|  6 |        2 | 小兵   | M      |    55 |  1 | 一班   |
|  6 |        2 | 小兵   | M      |    55 |  2 | 二班   |
|  6 |        2 | 小兵   | M      |    55 |  3 | 三班   |
|  6 |        2 | 小兵   | M      |    55 |  4 | 四班   |
|  7 |        2 | 小林   | M      |    85 |  1 | 一班   |
|  7 |        2 | 小林   | M      |    85 |  2 | 二班   |
|  7 |        2 | 小林   | M      |    85 |  3 | 三班   |
|  7 |        2 | 小林   | M      |    85 |  4 | 四班   |
|  8 |        3 | 小新   | F      |    91 |  1 | 一班   |
|  8 |        3 | 小新   | F      |    91 |  2 | 二班   |
|  8 |        3 | 小新   | F      |    91 |  3 | 三班   |
|  8 |        3 | 小新   | F      |    91 |  4 | 四班   |
|  9 |        3 | 小王   | M      |    89 |  1 | 一班   |
|  9 |        3 | 小王   | M      |    89 |  2 | 二班   |
|  9 |        3 | 小王   | M      |    89 |  3 | 三班   |
|  9 |        3 | 小王   | M      |    89 |  4 | 四班   |
| 10 |        3 | 小丽   | F      |    85 |  1 | 一班   |
| 10 |        3 | 小丽   | F      |    85 |  2 | 二班   |
| 10 |        3 | 小丽   | F      |    85 |  3 | 三班   |
| 10 |        3 | 小丽   | F      |    85 |  4 | 四班   |
+----+----------+--------+--------+-------+----+--------+
40 rows in set (0.12 sec)
```

返回的是两个表的“乘积”，结果集的列数是`students`表和`classes`表的列数之和，行数是`students`表和`classes`表的行数之积。

对于重复的名字可以设置别名

```sqlite
SELECT
    students.id sid,
    students.name,
    students.gender,
    students.score,
    classes.id cid,
    classes.name cname
FROM students, classes;
```

### 连接查询

将多个表连接，确定一个主表作为结果集，有选择地把其他的表连接上。

比如：

选取`students`中的学生信息

```sql
mysql> SELECT * FROM students;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
+----+----------+--------+--------+-------+
10 rows in set (0.00 sec)
```

虽然有`class_id`，但是我们想添加上班级具体的名字

就要用到连接查询，根据`students`表中的`class_id`找到`classes`中的对应的`name`列。

```sql
mysql> SELECT s.id, s.name, s.class_id, s.gender,s.score, c.name class_name
    -> FROM students s
    -> INNER JOIN classes c
    -> ON s.class_id = c.id;
+----+--------+----------+--------+-------+------------+
| id | name   | class_id | gender | score | class_name |
+----+--------+----------+--------+-------+------------+
|  1 | 小明   |        1 | M      |    90 | 一班       |
|  2 | 小红   |        1 | F      |    95 | 一班       |
|  3 | 小军   |        1 | M      |    88 | 一班       |
|  4 | 小米   |        1 | F      |    73 | 一班       |
|  5 | 小白   |        2 | F      |    81 | 二班       |
|  6 | 小兵   |        2 | M      |    55 | 二班       |
|  7 | 小林   |        2 | M      |    85 | 二班       |
|  8 | 小新   |        3 | F      |    91 | 三班       |
|  9 | 小王   |        3 | M      |    89 | 三班       |
| 10 | 小丽   |        3 | F      |    85 | 三班       |
+----+--------+----------+--------+-------+------------+
10 rows in set (0.03 sec)
```

注意INNER JOIN查询的写法是：

1. 先确定主表，仍然使用`FROM <表1>`的语法；
2. 再确定需要连接的表，使用`INNER JOIN <表2>`的语法；
3. 然后确定连接条件，使用`ON <条件...>`，这里的条件是`s.class_id = c.id`，表示`students`表的`class_id`列与`classes`表的`id`列相同的行需要连接；
4. 可选：加上`WHERE`子句、`ORDER BY`等子句。

有`INNER JOIN`就有`OUTER JOIN`

```sql
mysql> SELECT s.id, s.name, s.class_id, s.gender, s.score, c.name class_name
    -> FROM students s
    ->RIGHT OUTER JOIN classes c
    -> ON s.class_id = c.id;
+------+--------+----------+--------+-------+------------+
| id   | name   | class_id | gender | score | class_name |
+------+--------+----------+--------+-------+------------+
|    1 | 小明   |        1 | M      |    90 | 一班       |
|    2 | 小红   |        1 | F      |    95 | 一班       |
|    3 | 小军   |        1 | M      |    88 | 一班       |
|    4 | 小米   |        1 | F      |    73 | 一班       |
|    5 | 小白   |        2 | F      |    81 | 二班       |
|    6 | 小兵   |        2 | M      |    55 | 二班       |
|    7 | 小林   |        2 | M      |    85 | 二班       |
|    8 | 小新   |        3 | F      |    91 | 三班       |
|    9 | 小王   |        3 | M      |    89 | 三班       |
|   10 | 小丽   |        3 | F      |    85 | 三班       |
| NULL | NULL   |     NULL | NULL   |  NULL | 四班       |
+------+--------+----------+--------+-------+------------+
11 rows in set (0.00 sec)
```

执行上述RIGHT OUTER JOIN可以看到，和INNER JOIN相比，RIGHT OUTER JOIN多了一行，多出来的一行是“四班”，但是，学生相关的列如`name`、`gender`、`score`都为`NULL`。

原因是`students`表中没有四班地

有RIGHT OUTER JOIN，就有LEFT OUTER JOIN，以及FULL OUTER JOIN。它们的区别是：

INNER JOIN只返回同时存在于两张表的行数据，由于`students`表的`class_id`包含1，2，3，`classes`表的`id`包含1，2，3，4，所以，INNER JOIN根据条件`s.class_id = c.id`返回的结果集仅包含1，2，3。

RIGHT OUTER JOIN返回右表都存在的行。如果某一行仅在右表存在，那么结果集就会以`NULL`填充剩下的字段。

## 修改数据

### INSERT

#### 基本语法

> INSERT INTO <表名>  (字段) VALUES (值);

```sql
mysql> INSERT INTO students(class_id, name, gender, score) VALUES (2, 'XX', 'M', 80);
Query OK, 1 row affected (0.22 sec)

mysql> SELECT * FROM students;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
| 11 |        2 | XX     | M      |    80 |
+----+----------+--------+--------+-------+
11 rows in set (0.00 sec)
```

注意并没有列出`id`字段的值，因为`id`字段是一个自增主键，此外如果有字段是有默认值的，也可以不列出来。

字段顺序不一定和数据库表中的顺序一样，但是值得顺序必须和字段顺序一样。

一次添加多条记录

```sql
mysql> INSERT INTO students(class_id, name, gender, score)
    -> VALUES
    -> (1, 'yy', 'M', 87),
    -> (1, 'zz', 'F', 100);
Query OK, 2 rows affected (0.11 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM students;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | 小明   | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
| 11 |        2 | XX     | M      |    80 |
| 12 |        1 | yy     | M      |    87 |
| 13 |        1 | zz     | F      |   100 |
+----+----------+--------+--------+-------+
13 rows in set (0.00 sec)
```

### UPADTE

更新数据

#### 基本语法

```
UPDATE <表名> SET 字段1=值1, 字段2=值2, ... WHERE ...;
```

把`id = 1`的记录的`name`改为cc

```sql
mysql> UPDATE students
    -> SET name = 'cc'
    -> WHERE id = 1;
Query OK, 1 row affected (0.18 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> SELECT * FROM students;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | cc     | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | 小白   | F      |    81 |
|  6 |        2 | 小兵   | M      |    55 |
|  7 |        2 | 小林   | M      |    85 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
| 11 |        2 | XX     | M      |    80 |
| 12 |        1 | yy     | M      |    87 |
| 13 |        1 | zz     | F      |   100 |
+----+----------+--------+--------+-------+
13 rows in set (0.00 sec)
```

更新多条记录

```sql
mysql> UPDATE students
    -> SET name = 'qq', score = 77 
    -> WHERE id >= 5 AND id <= 7
    -> ;
Query OK, 3 rows affected (0.16 sec)
Rows matched: 3  Changed: 3  Warnings: 0

mysql> SELECT * FROM students
    -> ;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | cc     | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    73 |
|  5 |        2 | qq     | F      |    77 |
|  6 |        2 | qq     | M      |    77 |
|  7 |        2 | qq     | M      |    77 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
| 11 |        2 | XX     | M      |    80 |
| 12 |        1 | yy     | M      |    87 |
| 13 |        1 | zz     | F      |   100 |
+----+----------+--------+--------+-------+
13 rows in set (0.00 sec)
```

```sql
mysql> UPDATE students
    -> SET score = score + 10
    -> WHERE score < 80;
Query OK, 4 rows affected (0.11 sec)
Rows matched: 4  Changed: 4  Warnings: 0

mysql> SELECT * FROM students
    -> ;
+----+----------+--------+--------+-------+
| id | class_id | name   | gender | score |
+----+----------+--------+--------+-------+
|  1 |        1 | cc     | M      |    90 |
|  2 |        1 | 小红   | F      |    95 |
|  3 |        1 | 小军   | M      |    88 |
|  4 |        1 | 小米   | F      |    83 |
|  5 |        2 | qq     | F      |    87 |
|  6 |        2 | qq     | M      |    87 |
|  7 |        2 | qq     | M      |    87 |
|  8 |        3 | 小新   | F      |    91 |
|  9 |        3 | 小王   | M      |    89 |
| 10 |        3 | 小丽   | F      |    85 |
| 11 |        2 | XX     | M      |    80 |
| 12 |        1 | yy     | M      |    87 |
| 13 |        1 | zz     | F      |   100 |
+----+----------+--------+--------+-------+
13 rows in set (0.00 sec)
```

`UPDATE`语句可以没有`WHERE`条件，例如：

```
UPDATE students SET score=60;
```

这时，整个表的所有记录都会被更新。所以，在执行`UPDATE`语句时最好先用`SELECT`语句来测试`WHERE`条件是否筛选出了期望的记录集，然后再用`UPDATE`更新。

### DELETE

#### 基本语法

```sql
DELETE FROM <表名> WHERE ...;
```

删除`students`表中的`id = 1`的记录 

```sql
mysql> DELETE FROM students WHERE id = 1;
Query OK, 0 rows affected (0.00 sec)
```

```sql
mysql> SELECT *  FROM students;
+----+----------+------+--------+-------+
| id | class_id | name | gender | score |
+----+----------+------+--------+-------+
|  2 |        1 | 小红 | F      |    95 |
|  3 |        1 | 小军 | M      |    88 |
|  4 |        1 | 小米 | F      |    73 |
|  5 |        2 | 小白 | F      |    81 |
|  6 |        2 | 小兵 | M      |    55 |
|  7 |        2 | 小林 | M      |    85 |
|  8 |        3 | 小新 | F      |    91 |
|  9 |        3 | 小王 | M      |    89 |
| 10 |        3 | 小丽 | F      |    85 |
+----+----------+------+--------+-------+
9 rows in set (0.00 sec)
```

`WHERE`的用法同前面相似，一样可以一次删除多条记录。

如果`WHERE`条件没有匹配到任何记录，那不会报错，也不会有记录被删除。但是如果不带`WHERE`那就会删除整个数据。

所以一般是先用`SELECT`测试，看是否成功选出了期望的数据，在删除

## 操作数据库

在一个运行的`MySQL`服务器上，实际可以创建多个数据库。



### 列出所有数据库

```SQL
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test               |
+--------------------+
5 rows in set (0.00 sec)
```

其中，`information_schema`、`mysql`、`performance_schema`和`sys`是系统库。



### 创建新的数据库

```sql
mysql> CREATE DATABASE test;
Query OK, 1 row affected (0.01 sec)
```

### 删除数据库

```sql
mysql> DROP DATABASE test;
Query OK, 0 rows affected (0.01 sec)
```

对一个数据库进行操作时，要首先将其切换为当前数据库：

```sql
mysql> USE test;
Database changed
```

### 表

列出当前数据库所有的表

```SQL
mysql> SHOW TABLES;
+----------------+
| Tables_in_test |
+----------------+
| classes        |
| students       |
+----------------+
2 rows in set (0.00 sec)
```

查看一个表的结构

```sql
mysql> DESC students;
+----------+--------------+------+-----+---------+----------------+
| Field    | Type         | Null | Key | Default | Extra          |
+----------+--------------+------+-----+---------+----------------+
| id       | bigint       | NO   | PRI | NULL    | auto_increment |
| class_id | bigint       | NO   |     | NULL    |                |
| name     | varchar(100) | NO   |     | NULL    |                |
| gender   | varchar(1)   | NO   |     | NULL    |                |
| score    | int          | NO   |     | NULL    |                |
+----------+--------------+------+-----+---------+----------------+
5 rows in set (0.00 sec)
```

还可以使用以下命令查看创建表的SQL语句：

```sql
mysql> SHOW CREATE TABLE students;
+----------+-------------------------------------------------------+
| students | CREATE TABLE `students` (                             |
|          |   `id` bigint(20) NOT NULL AUTO_INCREMENT,            |
|          |   `class_id` bigint(20) NOT NULL,                     |
|          |   `name` varchar(100) NOT NULL,                       |
|          |   `gender` varchar(1) NOT NULL,                       |
|          |   `score` int(11) NOT NULL,                           |
|          |   PRIMARY KEY (`id`)                                  |
|          | ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 |
+----------+-------------------------------------------------------+
1 row in set (0.00 sec)
```

创建表使用`CREATE TABLE`语句，而删除表使用`DROP TABLE`语句：

```sql
mysql> DROP TABLE students;
Query OK, 0 rows affected (0.01 sec)
```

新加一列

```sql
ALTER TABLE students ADD COLUMN birth VARCHAR(10) NOT NULL;
```

修改列

```sql
ALTER TABLE students CHANGE COLUMN birth birthday VARCHAR(20) NOT NULL;
```

删除列

```sql
ALTER TABLE students DROP COLUMN birthday;
```

## Python 操作MySQL数据库

```python
import  

conn = pymysql.connect(user = 'root', password = 'wx19960323', database = 'test')


cursor = conn.cursor()

sql = "SELECT * FROM students;"
cursor.execute(sql)

results = cursor.fetchall()


for row in results:
    print(row)

```

```python
(1, 1, '小明', 'M', 90)
(2, 1, '小红', 'F', 95)
(3, 1, '小军', 'M', 88)
(4, 1, '小米', 'F', 73)
(5, 2, '小白', 'F', 81)
(6, 2, '小兵', 'M', 55)
(7, 2, '小林', 'M', 85)
(8, 3, '小新', 'F', 91)
(9, 3, '小王', 'M', 89)
(10, 3, '小丽', 'F', 85)
```

