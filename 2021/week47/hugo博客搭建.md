#### 开篇的问题

- 我为什么没有使用blogdown而是直接用hugo搭建博客？

  issue：https://github.com/pacollins/hugo-future-imperfect-slim/issues/216

- 使用hugo有什么优势？

  1. Hugo渲染快，hugo号称世界上最快的构建网站工具。

     >200篇左右的博文用Hexo 需要10分钟去生成静态网页，而Hugo 只需要10秒。

  2. 能够实时预览。

- 使用hugo的缺点？

  相应的搭建教程及bug修复上不算齐全。

- 什么是Hugo？

  Hugo是由Go语言实现的静态网站生成器。



#### 搭建博客流程

1. 安装Hugo
2. 使用Hugo建博客
3. 设置博客主题
4. 回到blog目录下创建新博文
5. 配置Github repository
6. 设置仓库的GitHub Pages
7. 解析域名
8. 博客改造实现及计划



#### 1. 安装Hugo

- 二进制安装

  到[Hugo Releases](https://github.com/gohugoio/hugo/releases)下载操作系统版本的Hugo二进制文件，无需依赖（不用安装 Go，因为它是编译好的二进制）。

  Mac下直接使用 `Homebrew` 安装：

  ```bash
  brew install hugo
  ```

  部分主题依赖extended version（比如我使用的这个主题），所以检查一下Hugo版本

  ```powershell
  hugo version
  
  Hugo Static Site Generator v0.80.0/extended darwin/amd64 BuildDate: unknown
  ```

- 源码安装
  

#### 2. 使用Hugo建博客

使用Hugo快速**生成站点**，一个站点（site）是一个存储区，它存储了一个网站包含的所有文件。通俗一点的说，一个站点就是一个网站所有内容所存放的文件夹。比如希望生成到`/Users/taozy/blog` 路径，`blog`必须是一个空的文件夹：

```bash
hugo new site /Users/taozy/taozy_blog # 建立了名为taozy_blog的站点名

Congratulations! Your new Hugo site is created in /Users/taozy/taozy_blog.

Just a few more steps and you're ready to go:

1. Download a theme into the same-named folder.
   Choose a theme from https://themes.gohugo.io/ or
   create your own with the "hugo new theme <THEMENAME>" command.
2. Perhaps you want to add some content. You can add single files
   with "hugo new <SECTIONNAME>/<FILENAME>.<FORMAT>".
3. Start the built-in live server via "hugo server".

Visit https://gohugo.io/ for quickstart guide and full documentation.
```

这样就在目录里生成了初始站点：

```bash
cd taozy_blog/
ls

archetypes	content		layouts		themes
config.toml	data		static
```



#### 3. 设置博客主题

从Hugo的官网找到自己喜欢的主题：[Hugo themes](https://themes.gohugo.io/)

我使用了这个主题：hugo-future-imperfect-slim，下面开始设置博客主题

```powershell
cd taozy_blog/themes #blog就是刚才新创建的博客目录，themes是它的子目录

git clone https://github.com/pacollins/hugo-future-imperfect-slim.git 
#点击主题页的download，进入GitHub主页，找到code⬇当中的网址进行clone
#注意主题要下在theme目录下

cp themes/hugo-future-imperfect-slim/exampleSite/config.toml . #使用模板自带的配置文件替换blog目录下的配置文件
```

有的模板没有exampleSite目录，或者是config.toml文件名为其他的名字，不管怎样，用模板目录下的config文件替换blog目录下的config文件即可(Config文件是通用配置文件)。

像主题 [hyde](https://github.com/spf13/hyde)，根据其在github上的安装提示，对blog目录下的config文件首行增加`theme = "hyde"` 即可，无需拷贝模板的config文件。以及主题 [npq-hugo](https://github.com/ahmedsaadxyzz/npq-hugo)，它的模板config文件不在exampleSite目录下，而是`themes/npq-hugo/example-config.toml`。要根据主题的具体提示来操作。



#### 4. 回到blog目录下创建新博文

一定要记得**回到blog目录下**创建新博文。

```powershell
cd ..
hugo new posts/test.md #会在content/post文件夹下创建test.md的文件，可以直接对其进行修改
```

开始可能不会修改，可以根据主题目录中的范例进行模仿，我选择主题的范例文件储存在：

```
taozy_blog/themes/hugo-future-imperfect-slim/exampleSite/content/blog
```

- 进行预览

```powershell
hugo server -D 
Start building sites … 

                   | EN | FR | PL | PT | DE | ES | ZH-CN | ZH-TW | JA | NL  
-------------------+----+----+----+----+----+----+-------+-------+----+-----
  Pages            | 11 |  8 |  8 |  8 |  8 |  8 |     8 |     8 |  8 |  8  
  Paginator pages  |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Non-page files   |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Static files     | 27 | 27 | 27 | 27 | 27 | 27 |    27 |    27 | 27 | 27  
  Processed images |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Aliases          |  3 |  1 |  1 |  1 |  1 |  1 |     1 |     1 |  1 |  1  
  Sitemaps         |  2 |  1 |  1 |  1 |  1 |  1 |     1 |     1 |  1 |  1  
  Cleaned          |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  

Built in 108 ms
Watching for changes in /Volumes/home /github/taozy_blog/{archetypes,content,data,layouts,static,themes}
Watching for config changes in /Volumes/home /github/taozy_blog/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

在浏览器中打开terminal中显示的网址进行预览： `http://localhost:1313/`

你可以使用可以编辑md的工具进行内容修改，我习惯用Rstudio打开它进行更改，而且很棒的是，在编辑的过程中，预览网址上的内容也会实时的变更，很方便进行修改。



#### 5. 配置Github repository

我配置了两个repos，一个用于托管我blog目录下所有的文件，一个用来托管public文件夹用于博客的显示。

1. 第一个repos随意命名

上传blog目录下的文件

1. 第二个repos必须命名为：`your_git_name.github.io`，才能够被当作个人的主页

上传public目录下的文件（注意不是public这个文件夹，而是该文件夹下的所有文件），目前还没有生成public文件，不要着急，继续下面的操作。

在blog目录下执行下面的命令，把theme改成你自己的theme名称，baseUrl换成你自己的github名，执行完会在blog目录下生成一个public目录，将这个目录下的内容上传到`your_git_name.github.io`仓库中

```powershell
hugo  --theme=hugo-future-imperfect-slim --baseUrl="https://taoziyu97.github.io"
Start building sites … 

                   | EN | FR | PL | PT | DE | ES | ZH-CN | ZH-TW | JA | NL  
-------------------+----+----+----+----+----+----+-------+-------+----+-----
  Pages            | 11 |  8 |  8 |  8 |  8 |  8 |     8 |     8 |  8 |  8  
  Paginator pages  |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Non-page files   |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Static files     | 21 | 21 | 21 | 21 | 21 | 21 |    21 |    21 | 21 | 21  
  Processed images |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  
  Aliases          |  3 |  1 |  1 |  1 |  1 |  1 |     1 |     1 |  1 |  1  
  Sitemaps         |  2 |  1 |  1 |  1 |  1 |  1 |     1 |     1 |  1 |  1  
  Cleaned          |  0 |  0 |  0 |  0 |  0 |  0 |     0 |     0 |  0 |  0  

Total in 209 ms
```

> 总结一下hugo-future-imperfect-slim这个主题的缺点
>
> 1. 对于内容没有很好的汇总界面
> 2. 只能一页一页的翻页，不能指定去哪一页
> 3. 搜索内容的时候对中文不友好



#### 6. 设置仓库的GitHub Pages

在仓库主页找到`Setting`，在`Options`中对`Github Pages`进行设置，如果你没有购买域名，那么你就可以在这步直接使用github提供的网址，作为你的博客网页，如果你有自己的域名（比如我从阿里云买了`.cn`的域名，我就将Custom domain设置为自己的域名）

![](https://i.loli.net/2021/06/17/S2MalFyrkWO5xjd.png)

#### 7. 解析域名

Netlify 是一个提供静态资源网络托管的综合平台。参考这个链接内容部署：[Netlify部署静态网页](https://blog.csdn.net/mqdxiaoxiao/article/details/96365253)

将Netlify随机生成的域名，在阿里云中进行解析设置。

![img](https://i.loli.net/2021/04/07/Jcbsi5y2x1D3pRV.png)

Netlify中解析成功。

![img](https://i.loli.net/2021/04/07/7Kv8rfJqTDVCk6w.png)





#### 8. 博客改造实现及计划

- 增加评论功能Valine（已完成）

  Valine是一款快速、简洁且高效的无后端评论系统，支持markdown语法，替换主题配置好的评论是因为不支持匿名，需要输入邮箱比较麻烦。

  1. 配置Leancloud 

  使用Leancloud的后端云服务，这部分详细参考：[hugo博客添加评论系统Valine](https://www.smslit.top/2018/07/08/hugo-valine/)

  2. 更改 **comments.html** 文件

  将整体内容替换成如下代码：

  ```html
  <!-- valine change from origin code-->
    {{- if .Site.Params.valine.enable -}}
    <!-- id 将作为查询条件 -->
    
    <div id="vcomments"></div>
    <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
    <script src='//unpkg.com/valine/dist/Valine.min.js'></script>
  
    <script type="text/javascript">
      new Valine({
          el: '#vcomments' ,
          appId: '{{ .Site.Params.valine.appId }}',
          appKey: '{{ .Site.Params.valine.appKey }}',
          notify: '{{ .Site.Params.valine.notify }}', 
          verify: '{{ .Site.Params.valine.verify }}', 
          avatar:'{{ .Site.Params.valine.avatar }}', 
          placeholder: '{{ .Site.Params.valine.placeholder }}',
          visitor: '{{ .Site.Params.valine.visitor }}'
      });
    </script>
    {{- end -}}
  ```

  3. 引入评论

  `layouts/_default/single.html` 中引入评论，本主题已有配置：

  ```html
    {{ if not ( eq .Params.comments false) }}
      {{ .Render "comments" }}
    {{ end }}
  ```

- 添加博客归档（已完成）

  hugo没有自带的归档设置，需要手动添加。

  1. 在`taozy_blog/layouts/_default/`目录下创建 **archives.html** 文件

  2. 将`taozy_blog/layouts/_default/`目录下的 **single.html** 内容复制进 **archives.html** 文件（single.html的格式就是每篇博文的格式，也可以采用主题的contact.html的格式或者about.html的格式）

  3. 找到**archives.html** 文件中的`{{ .Content }}` 替换为下面的内容:

  ```powershell
  {{ range (.Site.RegularPages.GroupByDate "2006") }}
      <h3>{{ .Key }}</h3>
  
          <ul class="archive-list">
          {{ range (where .Pages "Type" "blog") }}
              <li>
              {{ .PublishDate.Format "2006-01-02" }}
              ->
              <a href="{{ .RelPermalink }}">{{ .Title }}</a>
              </li>
          {{ end }}
      </ul>
  {{ end }}
  ```

  对上述代码进行解读:

  - 归档目录

  Pages "Type" "blog"即归档目录设置为`content/blog/`下的内容，如果去掉blog，引号内留空，就会自动归档根目录下的文件，也就是content目录的文件。

  - 可选归档时间

  .Site.RegularPages.GroupByDate "2006"：按年归档
  .Site.RegularPages.GroupByDate "2006-01"：按年月归档

  4. 在**config.toml**文件[menu]中仿照其他添加以下代码，使得主页上栏显示该分类：

  ```powershell
    [[menu.main]]
      name              = "Archives"
      identifier        = "archives"
      url               = "/archives/"
      pre               = "<i class='fa fa-newspaper'></i>"
      weight            = 6
  ```

  如下：

  ![](https://i.loli.net/2021/06/08/tJwULQMdRqkEh7u.png)

  完成归档页面的建立。

- 博文添加目录（已完成）

  根据`hugo-future-imperfect-slim`主题中issue提到的TOC更改版本，改进后进行配置应用。

  1. 更改 **config.html** 文件

  在[params] 内容下加入以下参数：

  ```html
    toc                   = true # 默认显示toc
    tocWords              = 400 #超过400字显示toc
  ```

  2. 更改 **main.scss** 文件

  添加TableOfContents：
  ```html
  #TableOfContents {
    border: $secondary-border;
    
      ul {
      list-style-type: none;
      padding-inline-start: 1.5em;
    }
  }
  /* ==========================================================================
     Add-Ons
     ========================================================================== */
  
  /* reCaptcha */
  ```

  3. 更改 **single.html** 文件

  在content内容中添加{{ .TableOfContents }}
  ```html
      <div class="content">
        {{ .Render "featured" }}
        {{ .TableOfContents }} #此处添加一行
        {{ .Content }}
      </div>
  ```

- 搜索中文优化，目前速度较慢

- 删除不需要的语言支持，只保留英文和中文



#### 参考资料：

- [浅谈我为什么从 HEXO 迁移到 HUGO](https://sspai.com/post/59904)

- [Hugo中文文档](https://www.gohugo.org/)
- [Hugo评论插件集成之Valine](https://huangzhongde.cn/post/2020-02-20-hugo-comments-plugin-valine/)
- [hugo博客添加评论系统Valine](https://www.smslit.top/2018/07/08/hugo-valine/)

- 关于该主题已有的配置：[给Hugo个人博客添加Valine评论系统](https://blog.shenshilei.site/post/e277/)

- [Valine配置项](https://valine.js.org/configuration.html)

- 配置主要参考：[为hugo添加归档页面](https://xbc.me/how-to-create-an-archives-page-with-hugo/)

- [我为什么要从 Hexo 更换到 Hugo](https://dp2px.com/2019/08/30/go-hugo1/)

- 解读部分主要参考：[Hugo添加归档页面](http://maitianblog.com/hugo-archives.html)

- [hugo官方文档](https://gohugo.io/content-management/toc/#template-example-basic-toc)

- [github issue](https://github.com/pacollins/hugo-future-imperfect-slim/issues/132)

- 可以尝试的其他方法：[HuGo中文章加入目录](http://www.gdhu.pro/post/note/how-to-add-table-of-contents-in-hugo/)

- [Hugo博客侧边导航栏](https://yyqx.online/posts/%E5%8D%9A%E5%AE%A2%E4%BE%A7%E8%BE%B9%E5%AF%BC%E8%88%AA%E6%A0%8F/#step-2--%E4%BF%AE%E6%94%B9singlehtml%E6%96%87%E4%BB%B6)

- [Hugo添加文章目录toc](https://www.ariesme.com/posts/2019/add_toc_for_hugo/)

