---
title: Shiny基础-1
date: 2021-06-10 19:14:18
tags: 编程
index_img: img/shiny.jpg
---

Shiny app 基础知识 参考：[Mastering Shiny](https://mastering-shiny.org/index.html)

<!-- more -->

`shiny APP`两个关键的组分是`UI`（user interface）和 `server` 函数；`UI` 定义了 app 的外观，而 `server` 则定义了 `app` 是如何工作的；另外 `shiny` 使用了反应式编程，也就是当输入改变的时候会自动更新输出，因此 `shiny app` 的第三个重要组分为响应表达式（reactive expression）

首先需要安装和载入 `shiny` 包：

```R
install.packages("shiny")
library(shiny)
```

创建一个 `shiny app` 最简单的方法是创建一个文件夹，放入一个空文件 `app.R` ，这个文件告诉 `shiny` app 的样式和行为

我们在 `app.R`  中写入一下内容来创建一个最简单的 APP：

```R
library(shiny)

ui <- fluidPage(
  "hello, shiny"
)

server <- function(input, output, session){
  
}

shinyApp(ui, server)
```

UI 定义了和用户相互作用的网页，在这里，这个网页显示 `hello, shiny`；server 函数规定了 app 的行为，这里是空的，因此这个简单的 app 没有做任何事情，最后 `shinyApp(ui, server)` 从UI 和 server 创建并启动了 APP（在 Rstudio 中可以通过新建项目选择 `shiny web application`来创建 app 的框架，也可以在 `app.R` 文件中打入 `shinyapp` 然后按 Shift+Tab 键） 

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny.gif)

有几种方式可以来运行我们的 `shiny app`:

- 点击 **Run App** 按钮：

  <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/屏幕截图 2021-06-08 163242.png" alt="" style="zoom:50%;" />

- 使用快捷键：`Cmd/Ctrl` + `Shift` + `Enter`
- 使用函数 `shiny::runApp()` 参数是 `app.R` 文件的路径

通过上面的方法启动 App 后，就可以得到下面的结果：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608163552620.png" alt="" style="zoom:50%;" />

现在可以向这个 App 的 UI 中添加一些输入和输出（展示 `dataset` 包中的内置数据）：

```R

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)
```

`fluidPage` 是布局函数，控制着页面的基本结构；`selectInput` 是输入控制，用来和用户交互，这里是标签为 `Dataset` 的选择框；`verbatimTextOutput` 和 `tableOutput` 是输出控制，告诉 shiny 在哪里放置渲染后的输出

运行这个 APP 后可以得到：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608170440462.png" alt="" style="zoom:50%;" />

我们只能选取一些值，但是并不能看到输出，因为此时还没有告诉 shiny 如何通过输入得到输出，而这个功能是通过 `server` 函数来实现。

可以定义一个 `server` 函数如下，来得到所选数据的汇总统计和数据的打印：

```R
server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}
```

`output$summary` 和 `output$table` 表示输出的元素（输出 ID），在 UI 中的输出要和这里对应起来（上面 `verbatimTextOutput` 和 `tableOutput` 中的 `summary` 和 `table`）；`render{Type}` 是渲染函数，用来产生特定类型的输出（比如文字，表，图等），渲染函数通常和 UI 中的 `{Type}Output` 函数相对应，这里是 `renderPrint` 和 `verbatimTextOutput` 配对来使用固定宽度的文字展示描述性统计，而`renderTable` 则和 `tableOutput` 配对来展示表格内容。

现在可以再次启动 APP：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny1.gif)

## 基本 UI

UI 的基本元素包括输入和输出，都由特殊的函数来控制，如上面的 `selectInput` ,`verbatimTextOutput` 和 `tableOutput`

### 输入

所有的输入函数的第一个参数都是 `inputId` ，用来连接前端（UI）和后端（server）的，比如 UI 有一个 ID 为 `name` 的输入，那么在 `server` 函数中就可以通过 `input$name` 来获取这个输入（上面的例子中 ID 为 dataset），`inputid` 有两个限制条件：

- 只能包含字母，数字和下划线（和变量的命名规则类似）
- 必须唯一

大部分输入函数有第二个参数：`label` ，来展示这个输入控件的名字；第三个参数是值 （value）,可以用来设定默认值（不一定会有这个参数），下面是一些常用的输入函数：

1. 文字输入：少量文字可以使用 `textInput()`，密码可以使用 `passwordInput()`，成段的文字可以使用 `textAreaInput()`

   ```R
   ui <- fluidPage(
     textInput("name", "What's your name?"),
     passwordInput("password", "What's your password?"),
     textAreaInput("story", "Tell me about yourself", rows = 3)
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608183050854.png" style="zoom:50%;" />

2. 数字输入：可以使用 `numericInput()` 来创建一个文本框，但是只能输入数字，或者使用 `sliderInput()` 来创建一个滑条（如果提供的 value 是有两个元素的向量，滑条的两端都可以移动）

   ```R
   ui <- fluidPage(
     numericInput("num", "Number one", value = 0, min = 0, max = 100),
     sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
     sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100)
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608183704337.png" alt="" style="zoom:50%;" />

3. 日期输入：使用 `dataInput()` 来输入单个日期或者 `dataRangeInput()` 来输入两个日期，选择日期时是在日历上选择

   ```R
   ui <- fluidPage(
     dateInput("dob", "When were you born?"),
     dateRangeInput("holiday", "When do you want to go on vacation next?")
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608184017084.png" alt="" style="zoom:50%;" />

4. 选择输入：用户必须从我们定义好的选项中选择值，可以使用 `selectInput()` 和 `radioButtons()`

   ```R
   animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")
   
   ui <- fluidPage(
     selectInput("state", "What's your favourite state?", state.name),##state.name是内置的变量
     radioButtons("animal", "What's your favourite animal?", animals)
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608185109736.png" alt="" style="zoom:50%;" />

   `selectInput` 是通过下拉菜单来展示所有可能的值的，可以使用参数 `multiple = TRUE` 来使得用户可以选择多个值；`radioButtons` 除了可以展示所有的值，还可以通过参数 `choiceNames/choiceValues` 来对展示的内容进行编码（也就是展示的值和返回值不一定要一样，只需要对应即可）：

   ```R
   ui <- fluidPage(
     radioButtons("rb", "Choose one:",
       choiceNames = list(
         icon("angry"),
         icon("smile"),
         icon("sad-tear")
       ),
       choiceValues = list("angry", "happy", "sad")
     )
   )
   ##两个list一一对应，choiceNames用来展示，choiceValues用来返回
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608190106186.png" alt="" style="zoom:50%;" />

   `radioButtons` 是不能多选的，可以使用 `checkboxGroupInput()` 来代替：

   ```R
   ui <- fluidPage(
     checkboxGroupInput("animal", "What animals do you like?", animals)
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608190230405.png" alt="" style="zoom:50%;" />

5. 文件上传：使用 `fileInput()` 来载入文件

   ```R
   ui <- fluidPage(
     fileInput("upload", NULL)
   )
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608190451189.png" alt="" style="zoom:50%;" />


### 输出

在 UI 中创建的输出会被 server 函数的返回来填充，像 Input 一样，output 函数的第一个参数也是 ID，这个 output ID 也和 server 函数中是对应的。

每一个前端（UI）的输出函数都和后端（server）的一个渲染函数（render）相对应；一般有3种类型的输出：文字，表格和图：

1. 文字：一般的文字用 `textOutput()` 来输出，代码和控制台的显示可以使用 `verbatimTextOutput()` 来输出

   ```R
   ui <- fluidPage(
     textOutput("text"),
     verbatimTextOutput("code")
   )
   server <- function(input, output, session) {
     output$text <- renderText({ 
       "Hello friend!" 
     })
     output$code <- renderPrint({ 
       summary(1:10) 
     })
   }
   ```

   ![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608213354202.png)

   当 render 函数中有多行代码的时候需要使用花括号（上面的例子是不需要花括号的）；这两个 render 函数有一些区别：`renderText` 将结果合并成一个字符串，和 `textOutput`配对；而 `renderPrint` 则打印结果，就像在控制台看到的一样，和 `verbatimTextOutput` 配对；这两者的区别和 `cat`，`print`函数的区别类似：

   ![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608220708286.png)

2. 表格：有两种方法可以将数据框以表格的形式展示出来

   - `tableOutput` 和 `renderTable` 以静态的方式展示数据，也就是一次性将数据全部展示
   - `dataTableOutput` 和 `renderDataTable` 以动态的方式展示数据

   ```R
   ui <- fluidPage(
     tableOutput("static"),
     dataTableOutput("dynamic")
   )
   server <- function(input, output, session) {
     output$static <- renderTable(head(mtcars))
     output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
   }
   ```

   ![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608221259399.png)

3. 图：使用 `plotOutput` 和 `renderPlot` 来展示 R 图像

   ```R
   ui <- fluidPage(
     plotOutput("plot", width = "400px")
   )
   server <- function(input, output, session) {
     output$plot <- renderPlot(plot(1:5), res = 96)
   }
   ```

   <img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608221435573.png" alt="" style="zoom:50%;" />

# 基础响应

## server函数

server 函数有3个参数：`input` `output` 和 `session` 

### input

input 参数是一个类似列表的对象，含有从 UI 传入的所有数据，每一个数据都有一个唯一的 input ID，我们可以通过 input ID 来获取 input 对象中的数据（`input$ID`）；但是和列表不同，input 是只读的，也就是说如果我们在 server 函数中修改 input 对象就会报错：

```R
library(shiny)
ui <- fluidPage(
  numericInput("count", label = "Number of values", value = 100)
)
server <- function(input, output, session) {
  input$count <- 10  
}

shinyApp(ui, server)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608230047209.png)

另外，只能在响应式的内容中（比如 render 函数和 reactive 函数）才可以读取 input 中的内容，例如，下面的 server 函数就会报错：

```R
server <- function(input, output, session) {
  message("The value of input$count is ", input$count)
}

shinyApp(ui, server)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608230518148.png)

### output

output 和 input 类似，也是一个列表类似的对象，元素的名称由 output ID 来规定，主要的不同就是：output 是发送数据到 UI，而 input 是从 UI 接受数据；output 对象总是和 render 函数一起出现，render函数生成的结果储存到 output 对象元素中；和 input 类似，当将 非 render 返回的内容赋值给 output 或者在 server 函数中更改 output 的内容时会引发报错：

```R
server <- function(input, output, session) {
  output$greeting <- "Hello human"
}
shinyApp(ui, server)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608231735673.png)

```R
server <- function(input, output, session) {
  message("The greeting is ", output$greeting)
}
shinyApp(ui, server)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210608231820559.png)

## 响应式编程

前面也讲过，响应式编程指的就是输出会随着输入的变化而更新，看一个例子：

```R
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name, "!")
  })
}
```

每次输入不同的字符，输出都会相应的改变：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny2.gif)

上面的 APP 能够工作（每次输入都会有响应的输出，而不是只输出一次）的原因在于：我们的代码并不是告诉 shiny 去创建一个字符并打印到屏幕上，而是告诉 shiny 怎样能够创建一个字符，具体运行的时间由 shiny 决定，这就涉及到命令式编程（imperative）和声明式编程（declarative）的区别：

- 命令式编程就是发出特殊的指令并且立即执行
- 声明式编程就是告诉程序想要什么

在 shiny 中的声明式编程另外的特征就是使得 app 非常的 lazy，也就是说只在需要的时候才运行相应的代码，比如下面的例子（greeting 写成了 greting）：

```R
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greting <- renderText({
    paste0("Hello ", input$name, "!")
  })
}
shinyApp(ui, server)
```

启动 app 并不会报错，但是没有输出：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny3.gif)

这是因为并不需要输出 output 中的 greting，因此 `renderText` 并不会运行

### 响应图

由于 shiny 的惰性机制，shiny中代码的执行并不像一般的 R 脚本一样（从前往后）；因此为了理解代码的执行顺序，我们需要检查响应图（reactive graph），其描述了输入和输出是如何联系到一起的，上面那个简单的 APP 的响应图如下：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/graph-1b.png)

这个图的意思就是当 name 改变的时候，greeting 就会被重新计算，也就是说 greeting 对于 name 有一个**响应依赖**（reactive dependency）

### 执行顺序

在 shiny app 中代码的执行顺序是取决于响应图的，而不是依赖于代码的前后关系，比如我们可以把上面 server 函数中的代码颠倒位置（加上了一个响应表达式，后面会讲）：

```R
server <- function(input, output, session) {
  output$greeting <- renderText(string())
  string <- reactive(paste0("Hello ", input$name, "!"))
}
```

这个 APP 并不会报错，因为他是惰性执行的，需要输出 greeting 就会先找 string，然后再执行string，会有一个沿着响应图的 “流动”。

## 响应表达式

响应表达式是为了减少 shiny app 的计算，提高运行效率；精简 APP 的响应图，从而使得 APP 的可读性增强。响应表达式同时有着输入和输出的特征，一方面像输入一样，我们可以在输出中使用响应表达式的结果，另一方面像输出一样，响应表达式依赖输入来自动更新，下面的图可以有助于理解：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/producers-consumers.png)

将输入和响应表达式称为生产者（producer），将输出和表达式称为消费者（consumer），我们先来创建一个更复杂的 APP 来看使用响应表达式的优点。

现在想要比较两个分布（可视化和 t 检验）（在开发 APP 的时候将计算的代码与 APP 分离比较好）：

```R
library(ggplot2)

##多边形图
freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- data.frame(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )

  ggplot(df, aes(x, colour = g)) +
    geom_freqpoly(binwidth = binwidth, size = 1) +
    coord_cartesian(xlim = xlim)+
     theme_bw()
}

##t检验
t_test <- function(x1, x2) {
  test <- t.test(x1, x2)
  
  # use sprintf() to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}
```

可以从两个不同的正态分布中抽样，然后比较两个样本分布的差异：

```R
x1 <- rnorm(100, mean = 0, sd = 0.5)
x2 <- rnorm(200, mean = 0.15, sd = 0.9)

freqpoly(x1, x2)
cat(t_test(x1, x2))
```

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/image-20210609223421109.png" alt="" style="zoom: 33%;" />

然后我们就可以写一个 shiny app 来根据用户的输入比较不同的分布。`fluidRow` 表示行布局，这里将页面分成两行，第一行又分成3列（`column`），前两列表示两个分布的参数，第3列表示多边形绘图的参数；然后第二行分成两列，两列的比例是 9:3 第一个比较宽的列用来画图，第二个比较窄的列用来输出 t 检验的内容。

```R
ui <- fluidPage(
  fluidRow(
    column(4, 
           "Distribution 1",
           numericInput("n1", label = "n", value = 1000, min = 1),
           numericInput("mean1", label = "\u03BC", value = 0, step = 0.1),
           numericInput("sd1", label = "\u03C3", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4, 
           "Distribution 2",
           numericInput("n2", label = "n", value = 1000, min = 1),
           numericInput("mean2", label = "\u03BC", value = 0, step = 0.1),
           numericInput("sd2", label = "\u03C3", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4,
           "Frequency polygon",
           numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
           sliderInput("range", label = "range", value = c(-3, 3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  )
)

server <- function(input, output, session) {
  output$hist <- renderPlot({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    t_test(x1, x2)
  })
}

shinyApp(ui, server)
```

启动 APP：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny4.gif)

我们看一下上面的 server 函数中 t 检验的输出函数：

```R
 x1 <- rnorm(input$n1, input$mean1, input$sd1)
 x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
 t_test(x1, x2)
```

我们想象的运行方式应该是：当 n1，mean1 或者 sd1 改变的时候更新 x1，从而更新 t 检验的输出，当 n2，mean2 或者 sd2 改变的时候更新 x2，从而更新 t 检验的输出；但是实际情况是 shiny **将输出当成整体看待**，也就是 n1，mean1 ，sd1，n2，mean2 ，sd2 中有一个改变，需要更新 t 检验的输出时，会重新计算 x1，x2，用响应图来表示就是：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/case-study-1.png" alt="" style="zoom:33%;" />

这就造成了运算的低效以及增加了 APP 的复杂性，另外在这个例子中由于是随机抽样，虽然 x2 没有改变，但是如果我们重新运行 x2 得到的结果也会变化，这不是我们想要的，因此我们需要响应表达式。

我们可以使用响应表达式来简化上面的代码，注意到下面的代码出现了两次（画图和 t 检验）：

```R
x1 <- rnorm(input$n1, input$mean1, input$sd1)
x2 <- rnorm(input$n2, input$mean2, input$sd2)
```

因此可以将这部分代码独立出来作为响应表达式，响应表达式就是将代码放到 `reactive` 中并赋给一个变量，然后我们就可以将这个变量视为函数来调用：

```R
server <- function(input, output, session) {
  x1 <- reactive(rnorm(input$n1, input$mean1, input$sd1))
  x2 <- reactive(rnorm(input$n2, input$mean2, input$sd2))

  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
  }, res = 96)

  output$ttest <- renderText({
    t_test(x1(), x2())
  })
}
```

这样就可以简化响应图：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/case-study-2.png" alt="" style="zoom:33%;" />

这个时候当只有其中一个分布的参数发生改变，比如 n1，mean1 或者 sd1，只会重新计算 x1，从而更新输出 ttest，x2 不会被重新计算，另外之前改变绘图参数时，x1 和 x2 都会被重新计算，而现在则不会出现这种情况，也就是说 x1 和 x2 变成了两个独立的模块，可以实现模块的重用（reuse），提高 APP  的效率。

有些时候我们并不想用户改变了输入之后马上就进行计算，因为有些计算可能比较耗时，耗资源，还有可能参数输入有误，需要检查，因此我们可以为 shiny app 加上一个“启动按钮”，只有点击这个按钮之后才进行计算。

将上面的 app 简化一下，并加入 `actionButton` 来添加按钮：

```R
##一行两列
ui <- fluidPage(
  fluidRow(
    column(3, 
      numericInput("lambda1", label = "lambda1", value = 3),
      numericInput("lambda2", label = "lambda2", value = 5),
      numericInput("n", label = "n", value = 1e4, min = 0),
      actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)
server <- function(input, output, session) {
  x1 <- reactive({
    input$simulate
    rpois(input$n, input$lambda1)
  })
  x2 <- reactive({
    input$simulate
    rpois(input$n, input$lambda2)
  })
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}
```

启动 app：

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny5.gif)



这个 app 产生的响应图如下：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/timing-button.png" alt="" style="zoom:33%;" />

可以看到，虽然我们点击按钮可以更新图，但是更改分布的参数也能更新图，而我们想要的是：更改参数并不更新图，只有在点击按钮之后图才会被更新；也就是说需要用 simulate 的依赖关系取代分布参数的依赖关系，而不是添加一个 simulate 的依赖关系。因此我们可以使用 `eventReactive` ，这个函数有两个参数，第一个参数指定输出的依赖，第二个参数指定计算的内容（多行代码使用花括号括起来），只有依赖改变的时候才会计算该内容：

```R
server <- function(input, output, session) {
  x1 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda1)
  })
  x2 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda2)
  })

  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/shiny6.gif)

这个时候依赖关系就变成了（虚线表示只使用值，实线表示响应依赖关系）：

<img src="https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/img/timing-button-2.png" alt="" style="zoom:33%;" />

---

使用 `reactlog` 包来绘制响应图：

在启动 app 之前运行 `reactlog::reactlog_enable()`，然后启动 APP ，关闭之后再运行`shiny::reactlogShow()` 或者在运行的时候按 `ctrl+F3` 来显示

---

