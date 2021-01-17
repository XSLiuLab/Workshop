# forcats

In R, factors are used to work with categorical variables, variables that have a fixed and known set of possible values. They are also useful when you want to display character vectors in a non-alphabetical order.

forcats 这个包是用来处理因子的，是tidyverse包的核心，提供了处理分类变量的工具。

#### factors

##### 简单的例子：(R for data science)

先创建一个变量包含月份信息

```R
 > x1 <- c("Dec", "Apr", "Jan", "Mar")
 > x2 <- c("Dec", "Apr", "Jam", "Mar")
 > sort(x1)
 [1] "Apr" "Dec" "Jan" "Mar"
```

我们可以看到X2当你拼写错误时，并没有什么提醒，并且sort后的结果并没有按照月份的顺序来，那么如果我们想要按照月份的顺序该怎么做？我们可以用因子解决这些问题。首先需要我们创建月份的因子水平列表。

```R
> month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
> y1 <- factor(x1, levels = month_levels)
> y1
[1] Dec Apr Jan Mar
12 Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct ... Dec
> sort(y1)
[1] Jan Mar Apr Dec
12 Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct ... Dec

> y2 <- factor(x2, levels = month_levels)
> y2
[1] Dec  Apr  <NA> Mar 
12 Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct ... Dec
```

创建因子后可以看到排序是按照月份进行的，并且x2里拼写错误被NA替代。

如果不设置levels，直接用factors对向量进行处理，那么会按照字母表的顺序对因子进行排序。

~~~R
> factor(x1)
[1] Dec Apr Jan Mar
Levels: Apr Dec Jan Mar
~~~

如果想要levels的顺序与数据出现的顺序一致，那么可以在levels里面设置unique(x)或者用fct_inorder

~~~R
> f1 <- factor(x1, levels = unique(x1))
> f1
[1] Dec Apr Jan Mar
Levels: Dec Apr Jan Mar
> f2 <- x1 %>% factor() %>% fct_inorder()
> f2
[1] Dec Apr Jan Mar
Levels: Dec Apr Jan Mar
~~~

#### forcats

下面详细介绍一下这个包的用途：

The goal of the **forcats** package is to provide a suite of tools that solve common problems with factors, including changing the order of levels or the values. Some examples include:

- `fct_reorder()`: Reordering a factor by another variable.
- `fct_infreq()`: Reordering a factor by the frequency of values.
- `fct_relevel()`: Changing the order of a factor by hand.
- `fct_lump()`: Collapsing the least/most frequent values of a factor into “other”.

```R
### installation
# The easiest way to get forcats is to install the whole tidyverse:
install.packages("tidyverse")
library("tidyverse")
# Alternatively, install just forcats:
install.packages("forcats")
library("forcats")
```

##### fct_lump:将最少或者出现最频繁的因子压缩为其他。

```R
> starwars %>% 
+   filter(!is.na(species)) %>%
+   count(species, sort = TRUE)
# A tibble: 37 x 2
   species      n
   <chr>    <int>
 1 Human       35
 2 Droid        6
 3 Gungan       3
 4 Kaminoan     2
 5 Mirialan     2
 6 Twi'lek      2
 7 Wookiee      2
 8 Zabrak       2
 9 Aleena       1
10 Besalisk     1
# ... with 27 more rows

> starwars %>%
+     filter(!is.na(species)) %>%
+     mutate(species = fct_lump(species, n = 3)) %>%
+     count(species)
# A tibble: 4 x 2
  species     n
  <fct>   <int>
1 Droid       6
2 Gungan      3
3 Human      35
4 Other      39

```

##### fct_infreq 通过值出现的频率对因子进行排序

我们画图的时候经常会出现不按照值的大小进行排序的情况，会使得画出来的图很丑，那么就需要我们按照值的大小进行排序。

~~~
> ggplot(starwars, aes(x = eye_color)) + 
+     geom_bar() + 
+     coord_flip()
~~~

![](https://picgo-wx.oss-cn-shanghai.aliyuncs.com/img/135cebc2ceb840424a197fc44334b98.png)



~~~
> starwars %>%
  mutate(eye_color = fct_infreq(eye_color)) %>%
  ggplot(aes(x = eye_color)) + 
  geom_bar() + 
  coord_flip()
~~~

![](https://picgo-wx.oss-cn-shanghai.aliyuncs.com/img/0f5f13b5b9afc0435f0038ce3cdaa90.png)

fct_reorder:通过其他的值对因子顺序进行修改

~~~R
> relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )
#> `summarise()` ungrouping output (override with `.groups` argument)

> ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
~~~

![](https://picgo-wx.oss-cn-shanghai.aliyuncs.com/img/4f8b1ec29061935af6acd71d6b781ee.png)



It is difficult to interpret this plot because there’s no overall pattern. We can improve it by reordering the levels of `relig` using `fct_reorder()`. `fct_reorder()` takes three arguments:

- `f`, the factor whose levels you want to modify.
- `x`, a numeric vector that you want to use to reorder the levels.
- Optionally, `fun`, a function that’s used if there are multiple values of `x` for each value of `f`. The default value is `median`.

~~~R
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()
~~~



![](https://picgo-wx.oss-cn-shanghai.aliyuncs.com/img/92b08333e8d0a5fda2363f26cb7a7ed.png)

##### fct_recode()：修改每个水平的值

~~~R
> gss_cat %>% count(partyid)
# A tibble: 10 x 2
   partyid                n
   <fct>              <int>
 1 No answer            154
 2 Don't know             1
 3 Other party          393
 4 Strong republican   2314
 5 Not str republican  3032
 6 Ind,near rep        1791
 7 Independent         4119
 8 Ind,near dem        2499
 9 Not str democrat    3690
10 Strong democrat     3490

>  gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)
# A tibble: 10 x 2
   partyid                   n
   <fct>                 <int>
 1 No answer               154
 2 Don't know                1
 3 Other party             393
 4 Republican, strong     2314
 5 Republican, weak       3032
 6 Independent, near rep  1791
 7 Independent            4119
 8 Independent, near dem  2499
 9 Democrat, weak         3690
10 Democrat, strong       3490
~~~

还可以将多个原来的水平修改为一个新的水平。

~~~R
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  count(partyid)
~~~

##### fct_collapse : 是fct_recode的加强版，可以同时将多个水平的转换为一个。

~~~
> gss_cat %>%
+   mutate(partyid = fct_collapse(partyid,
+         other = c("No answer", "Don't know", "Other party"),
+         rep = c("Strong republican", "Not str republican"),
+         ind = c("Ind,near rep", "Independent", "Ind,near dem"),
+         dem = c("Not str democrat", "Strong democrat")
+   )) %>%
+   count(partyid)
# A tibble: 4 x 2
  partyid     n
  <fct>   <int>
1 other     548
2 rep      5346
3 ind      8409
4 dem      7180

~~~

##### fct_relevel:手动调整level的顺序

~~~R
> f <- factor(c("a", "b", "c", "d"), levels = c("b", "c", "d", "a"))
> fct_relevel(f)
[1] a b c d
Levels: b c d a
> fct_relevel(f, "a")###a作为第一个
[1] a b c d
Levels: a b c d
> fct_relevel(f, "b", "a")### b,a作为前两个，其他按照原来的顺序
[1] a b c d
Levels: b a c d
> # Move to the third position
>  fct_relevel(f, "a", after = 2)
[1] a b c d
Levels: b c a d
> #Relevel to the end
>  fct_relevel(f, "a", after = Inf)
[1] a b c d
Levels: b c d a
>  fct_relevel(f, "a", after = 3)
[1] a b c d
Levels: b c d a
> # Relevel with a function
> fct_relevel(f, sort)
[1] a b c d
Levels: a b c d
> fct_relevel(f, sample)
[1] a b c d
Levels: c d b a
>  df  <- forcats::gss_cat[, c("rincome", "denom")]
> View(df)
> lapply(df, levels)
$rincome
 [1] "No answer"      "Don't know"     "Refused"        "$25000 or more"
 [5] "$20000 - 24999" "$15000 - 19999" "$10000 - 14999" "$8000 to 9999" 
 [9] "$7000 to 7999"  "$6000 to 6999"  "$5000 to 5999"  "$4000 to 4999" 
[13] "$3000 to 3999"  "$1000 to 2999"  "Lt $1000"       "Not applicable"

$denom
 [1] "No answer"            "Don't know"           "No denomination"     
 [4] "Other"                "Episcopal"            "Presbyterian-dk wh"  
 [7] "Presbyterian, merged" "Other presbyterian"   "United pres ch in us"
[10] "Presbyterian c in us" "Lutheran-dk which"    "Evangelical luth"    
[13] "Other lutheran"       "Wi evan luth synod"   "Lutheran-mo synod"   
[16] "Luth ch in america"   "Am lutheran" 
> df2 <- lapply(df, fct_relevel, "Don't know", after = Inf)
> lapply(df2, levels)
$rincome
 [1] "No answer"      "Refused"        "$25000 or more" "$20000 - 24999"
 [5] "$15000 - 19999" "$10000 - 14999" "$8000 to 9999"  "$7000 to 7999" 
 [9] "$6000 to 6999"  "$5000 to 5999"  "$4000 to 4999"  "$3000 to 3999" 
[13] "$1000 to 2999"  "Lt $1000"       "Not applicable" "Don't know"    

$denom
 [1] "No answer"            "No denomination"      "Other"               
 [4] "Episcopal"            "Presbyterian-dk wh"   "Presbyterian, merged"
 [7] "Other presbyterian"   "United pres ch in us" "Presbyterian c in us"
...............  
[28] "Am baptist asso"      "Not applicable"       "Don't know"
~~~

##### fct_relabel: 可以修改因子的标签

~~~R
> gss_cat$partyid %>% fct_count()
# A tibble: 10 x 2
   f                      n
   <fct>              <int>
 1 No answer            154
 2 Don't know             1
 3 Other party          393
 4 Strong republican   2314
 5 Not str republican  3032
 6 Ind,near rep        1791
 7 Independent         4119
 8 Ind,near dem        2499
 9 Not str democrat    3690
10 Strong democrat     3490
> gss_cat$partyid %>% fct_relabel(~ gsub(",", "...", .x)) %>% fct_count()
# A tibble: 10 x 2
   f                      n
   <fct>              <int>
 1 No answer            154
 2 Don't know             1
 3 Other party          393
 4 Strong republican   2314
 5 Not str republican  3032
 6 Ind...near rep      1791
 7 Independent         4119
 8 Ind...near dem      2499
~~~

##### fct_anon:  labels 的顺序随机打乱

##### 参数：prefix A character prefix to insert in front of the random labels.

~~~R
> gss_cat$relig %>% fct_count()
# A tibble: 16 x 2
   f                           n
   <fct>                   <int>
 1 No answer                  93
 2 Don't know                 15
 3 Inter-nondenominational   109
 4 Native american            23
 .....
 > gss_cat$relig %>% fct_anon() %>% fct_count()
# A tibble: 16 x 2
   f         n
   <fct> <int>
 1 01       71
 2 02       93
 3 03      109
 4 04     5124
 5 05      224
 6 06      689
 .....
 > gss_cat$relig %>% fct_anon("X") %>% fct_count()
# A tibble: 16 x 2
   f         n
   <fct> <int>
 1 X01     104
 2 X02    5124
 3 X03     147
 4 X04     689
 5 X05       0
 6 X06      93
 7 X07    3523
 ......
~~~
##### fct_expand: 增加因子水平
~~~
> f <- factor(sample(letters[1:3], 20, replace = TRUE))
> f
 [1] c c c b c a c c c c b c b b a a b a a a
Levels: a b c
> fct_expand(f, "d", "e", "f")
 [1] c c c b c a c c c c b c b b a a b a a a
Levels: a b c d e f
> fct_expand(f, letters[1:6])
 [1] c c c b c a c c c c b c b b a a b a a a
Levels: a b c d e f
~~~

##### fct_drop:删除没有用到的因子水平

~~~
> f <- factor(c("a", "b"), levels = c("a", "b", "c"))
> f
[1] a b
Levels: a b c
> fct_drop(f)
[1] a b
Levels: a b
~~~

