# Week19: Markdown and RMarkdown



### 特性与用途

- 简单
- 结构化-转换
  - Word
  - PDF
  - HTML
  - ...
- 多编辑器支持
  - [Typora](https://typora.io/)
  - [RStudio](https://rstudio.com/)
  - [Jupyter notebook](https://rstudio.com/)
  - [VS Code](https://code.visualstudio.com/)
  - ...

### Markdown 效果（以 Typora 为例）

图片：

![image-20200923214830609](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923214830.png)

标题：

![image-20200923214900003](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923214900.png)

列表：

![image-20200923214924176](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923214924.png)

表格：

![image-20200923214945182](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923214945.png)

代码块：

![image-20200923215012642](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215012.png)

数学公式（LaTex语法）：

![image-20200923215041934](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215041.png)

流程图：

![image-20200923215100346](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215100.png)

行内元素：

![image-20200923215120900](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215120.png)

各种格式转换：

![image-20200923215146498](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215146.png)

### RMarkdown 效果

R 包文档（knitr 和 rmarkdown）：

![image-20200923215621662](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215621.png)



博客与网站（[blogdown](https://bookdown.org/yihui/blogdown/)）：

![image-20200923215240574](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215240.png)



用于重复分析和研究展示：

![image-20200923215647007](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215647.png)



书籍（[bookdown](https://bookdown.org/)）：

![image-20200923215425642](https://gitee.com/ShixiangWang/ImageCollection/raw/master/png/20200923215425.png)



### 基础语法和用法

目前对于两者的介绍网上一大堆，而且本身语法简单，上手很快，这里不会过多介绍。**本文的核心在于让读者了解这些工具以及根据需要去学习和利用它们。**这里主要为初学者提供比较有参考价值的资料：

- [RMarkdown 参考手册](https://rstudio.com/wp-content/uploads/2015/03/rmarkdown-reference.pdf)，这里单纯的 Markdown 语法关注第一页，后续则被 RMarkdown 和其引擎 knitr 所拓展，镜像：<https://www.jianguoyun.com/p/DUV0ewgQ6uuVCBjRtr4D>。
- [RMarkdown 小抄](https://www.rstudio.org/links/r_markdown_cheat_sheet)，打印使用，镜像：<https://www.jianguoyun.com/p/Da0QaqwQ6uuVCBjNtr4D>。
- RStudio 网站介绍：https://rmarkdown.rstudio.com/lesson-1.html。
- yihui 的 [RMarkdown 权威指南](https://bookdown.org/yihui/rmarkdown/)。
- yihui 的 [RMarkdown cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/)。
- yihui 的 [blogdown](https://bookdown.org/yihui/blogdown/)。
- yihui 的 [bookdown](https://bookdown.org/yihui/bookdown/)。

仔细阅读上面的资料，其他资料基本没有学习的必要。

关于 RMarkdown knitr 相关设置，yihui 的文档网站有比较好的解释：<https://yihui.org/knitr/>。

另外有时候文章代码需要格式化，推荐下面两个 R 包

- [formatR](https://github.com/yihui/formatR)
- [styler](https://github.com/r-lib/styler)

注意，在使用 RMarkdown 时，使用 RStudio 提供的 `knit` 按钮是非必须的，我们可以直接通过 R 命令执行这一渲染（格式转换）过程，如 rmarkdown -> html：

```r
rmarkdown::render("week19/example.Rmd", output_format = "html_document")
```

如果是使用 bookdown 写书，则是：

```r
bookdown::render_book("index.Rmd")
```

