# 芯片数据分析

**数据分析思路**
![1](https://gitee.com/KKAres/pictures/raw/master/png/2.png)
**分析代码流程**
![2](https://gitee.com/KKAres/pictures/raw/master/png/1.png)

---

1. 安装R包

```r
options("repos"="http://mirrors.ustc.edu.cn/CRAN/")
if(!require("BiocManager")) install.packages("BiocManager",update = F,ask = F)
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc/")

cran_packages <- c('tidyr',
                   'tibble',
                   'dplyr',
                   'stringr',
                   'ggplot2',
                   'ggpubr',
                   'factoextra',
                   'FactoMineR',
                   'devtools') 
Biocductor_packages <- c('GEOquery',
                         'hgu133plus2.db',
                         "KEGG.db",
                         "limma",
                         "impute",
                         "GSEABase",
                         "GSVA",
                         "clusterProfiler",
                         "org.Hs.eg.db",
                         "preprocessCore",
                         "hugene10sttranscriptcluster.db",
                         "enrichplot",
                         "ggplotify")

for (pkg in cran_packages){
  if (! require(pkg,character.only=T) ) {
    install.packages(pkg,ask = F,update = F)
    require(pkg,character.only=T) 
  }
}


for (pkg in Biocductor_packages){
  if (! require(pkg,character.only=T) ) {
    BiocManager::install(pkg,ask = F,update = F)
    require(pkg,character.only=T) 
  }
}

#前面的所有提示和报错都先不要管。主要看这里
for (pkg in c(Biocductor_packages,cran_packages)){
  require(pkg,character.only=T) 
}
#没有error就是成功！

#哪个报错，就回去安装哪个。
#devtools::install_local("./AnnoProbe-master.zip",upgrade = F)#本地安装
#library(AnnoProbe)
```



---

2. 下载数据，提取**表达矩阵**和临床信息

```r
#数据下载
rm(list = ls())     
options(stringsAsFactors = F)
library(GEOquery)
gse = "GSE4107"
eSet <- getGEO(gse, 
               destdir = '.', 
               getGPL = F)
#(1)提取表达矩阵exp
exp <- exprs(eSet[[1]])
exp[1:4,1:4]#根据数据判断是否要log
exp = log2(exp+1)
#(2)提取临床信息
pd <- pData(eSet[[1]])
#(3)调整pd的行名顺序与exp列名完全一致
p = identical(rownames(pd),colnames(exp));p
if(!p) exp = exp[,match(rownames(pd),colnames(exp))]
#(4)提取芯片平台编号
gpl <- eSet[[1]]@annotation
save(gse,pd,exp,gpl,file = "step1output.Rdata")
```

3. 分组信息&探针注释

```r
#1.group_list(实验分组)和ids(芯片注释)，每次都需要改
rm(list = ls())  
load(file = "step1output.Rdata")
library(stringr)
#1.1建立group_list(实验分组)
#第一类，现成的某一列或在某列中包含。
pd$title

#第二类，自己生成
group_list=c(rep("control",times=3),rep("treat",times=3))
group_list

#第三类，ifelse
library(stringr)
group_list=ifelse(str_detect(pd$title,"control"),"control","treat")
#设置参考水平，对照在前，处理在后
group_list = factor(group_list,
                    levels = c("control","treat"))
##level意味着有几个取值
#1.2生成ids(芯片注释)
#方法1 BioconductorR包  
gpl 
#http://www.bio-info-trainee.com/1399.html
if(!require(hgu133plus2.db))BiocManager::install("hgu133plus2.db")
library(hgu133plus2.db)
ls("package:hgu133plus2.db")
ids <- toTable(hgu133plus2SYMBOL)
head(ids)
# 方法2 读取gpl页面的soft文件，按列取子集
# 方法3 官网下载
# 方法4 自主注释 
save(exp,group_list,ids,file = "step2output.Rdata")
```

4. 数据检查-PCA&heatmap

```r
rm(list = ls())  
load(file = "step1output.Rdata")
load(file = "step2output.Rdata")
#输入数据：exp和group_list
#Principal Component Analysis
#http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/112-pca-principal-component-analysis-essentials

dat=as.data.frame(t(exp))
library(FactoMineR)#画主成分分析图需要加载这两个包
library(factoextra) 
# pca的统一操作走起
dat.pca <- PCA(dat, graph = FALSE)
pca_plot <- fviz_pca_ind(dat.pca,
                         geom.ind = "point", # show points only (nbut not "text")
                         col.ind = group_list, # color by groups
                         #palette = c("#00AFBB", "#E7B800"),
                         addEllipses = TRUE, # Concentration ellipses
                         legend.title = "Groups"
)
pca_plot
ggsave(plot = pca_plot,filename = paste0(gse,"PCA.png"))
save(pca_plot,file = "pca_plot.Rdata")

#热图 
cg=names(tail(sort(apply(exp,1,sd)),1000))
n=exp[cg,]

#绘制热图
annotation_col=data.frame(group=group_list)
rownames(annotation_col)=colnames(n) 
library(pheatmap)
pheatmap(n,
         show_colnames =F,
         show_rownames = F,
         annotation_col=annotation_col,
         scale = "row")

dev.off()
```

5. **差异分析**

```r
rm(list = ls()) 
load(file = "step2output.Rdata")
#差异分析，用limma包来做
#需要表达矩阵和group_list，不需要改
library(limma)
design=model.matrix(~group_list)
fit=lmFit(exp,design)
fit=eBayes(fit)
deg=topTable(fit,coef=2,number = Inf)

#为deg数据框添加几列
#1.加probe_id列，把行名变成一列
library(dplyr)
deg <- mutate(deg,probe_id=rownames(deg))
head(deg)
#2.加symbol列，火山图要用
deg <- inner_join(deg,ids,by="probe_id")
head(deg)
#按照symbol列去重复
deg <- deg[!duplicated(deg$symbol),]
#3.加change列,标记上下调基因#设置阈值
logFC_t=2.0
P.Value_t = 0.01
k1 = (deg$P.Value < P.Value_t)&(deg$logFC < -logFC_t)
k2 = (deg$P.Value < P.Value_t)&(deg$logFC > logFC_t)
change = ifelse(k1,"down",ifelse(k2,"up","stable"))
deg <- mutate(deg,change)
#4.加ENTREZID列，用于富集分析（symbol转entrezid，然后inner_join）
library(ggplot2)
library(clusterProfiler)
library(org.Hs.eg.db)
s2e <- bitr(deg$symbol, 
            fromType = "SYMBOL",
            toType = "ENTREZID",
            OrgDb = org.Hs.eg.db)#人类
#其他物种http://bioconductor.org/packages/release/BiocViews.html#___OrgDb
deg <- inner_join(deg,s2e,by=c("symbol"="SYMBOL"))

save(group_list,deg,logFC_t,P.Value_t,file = "step4output.Rdata")
```

6. **可视化**-volcano&heatmap

```r
rm(list = ls()) 
load(file = "step1output.Rdata")
load(file = "step4output.Rdata")
#1.火山图----
library(dplyr)
library(ggplot2)
dat  = deg

p <- ggplot(data = dat, 
            aes(x = logFC, 
                y = -log10(P.Value))) +
  geom_point(alpha=0.4, size=3.5, 
             aes(color=change)) +
  ylab("-log10(Pvalue)")+
  scale_color_manual(values=c("blue", "grey","red"))+
  geom_vline(xintercept=c(-logFC_t,logFC_t),lty=4,col="black",lwd=0.8) +
  geom_hline(yintercept = -log10(P.Value_t),lty=4,col="black",lwd=0.8) +
  theme_bw()
p

#自选基因
if(F){
  for_label <- dat%>% 
    filter(symbol %in% c("TRPM3","SFRP1")) 
}
#p值最小的10个
if(F){
  for_label <- dat %>% head(10)
}
#p值最小的前3下调和前3上调
if(T) {
  x1 = dat %>% 
    filter(change == "up") %>% 
    head(3)
  x2 = dat %>% 
    filter(change == "down") %>% 
    head(3)
  for_label = rbind(x1,x2)
}

volcano_plot <- p +
  geom_point(size = 3, shape = 1, data = for_label) +
  ggrepel::geom_label_repel(
    aes(label = symbol),
    data = for_label,
    color="black"
  )
volcano_plot
ggsave(plot = volcano_plot,filename = paste0(gse,"volcano.png"))

#2.差异基因热图----

load(file = 'step2output.Rdata')
 
if(F){
 #全部差异基因
  cg = deg$probe_id[deg$change !="stable"]
  length(cg)
}else{
  #取前30上调和前30下调
  x=deg$logFC[deg$change !="stable"] 
  names(x)=deg$probe_id[deg$change !="stable"] 
  cg=c(names(head(sort(x),30)),names(tail(sort(x),30)))
  length(cg)
}
n=exp[cg,]
dim(n)

#作热图
library(pheatmap)
annotation_col=data.frame(group=group_list)
rownames(annotation_col)=colnames(n) 
library(ggplotify)
heatmap_plot <- as.ggplot(pheatmap(n,show_colnames =F,
                          show_rownames = F,
                          scale = "row",
                          #cluster_cols = F, 
                          annotation_col=annotation_col)) 
heatmap_plot
ggsave(heatmap_plot,filename = paste0(gse,"heatmap.png"))
load("pca_plot.Rdata")
library(patchwork)
(pca_plot + volcano_plot +heatmap_plot)+ plot_annotation(tag_levels = "A")
```

7. **富集分析**-KEGG、GO

```r
rm(list = ls())  
load(file = 'step4output.Rdata')
#富集分析考验网速，因此保存了Rdata
#以上运行示例数据无需修改，在做自己的数据时请注意把本行之后的load()去掉
library(clusterProfiler)
library(dplyr)
library(ggplot2)
source("kegg_plot_function.R")
#source表示运行整个kegg_plot_function.R脚本，里面是一个function
#以up_kegg和down_kegg为输入数据做图

#1.GO database analysis ----

#(1)输入数据
gene_up = deg[deg$change == 'up','ENTREZID'] 
gene_down = deg[deg$change == 'down','ENTREZID'] 
gene_diff = c(gene_up,gene_down)
gene_all = deg[,'ENTREZID']

#(2)GO分析，分三部分
#以下步骤耗时很长，实际运行时注意把if后面的括号里F改成T
if(F){
  #细胞组分
  ego_CC <- enrichGO(gene = gene_diff,
                     OrgDb= org.Hs.eg.db,
                     ont = "CC",
                     pAdjustMethod = "BH",
                     minGSSize = 1,
                     pvalueCutoff = 0.01,
                     qvalueCutoff = 0.01,
                     readable = TRUE)
  #生物过程
  ego_BP <- enrichGO(gene = gene_diff,
                     OrgDb= org.Hs.eg.db,
                     ont = "BP",
                     pAdjustMethod = "BH",
                     minGSSize = 1,
                     pvalueCutoff = 0.01,
                     qvalueCutoff = 0.01,
                     readable = TRUE)
  #分子功能：
  ego_MF <- enrichGO(gene = gene_diff,
                     OrgDb= org.Hs.eg.db,
                     ont = "MF",
                     pAdjustMethod = "BH",
                     minGSSize = 1,
                     pvalueCutoff = 0.01,
                     qvalueCutoff = 0.01,
                     readable = TRUE)
  save(ego_CC,ego_BP,ego_MF,file = "ego_GSE4107.Rdata")
}
load(file = "ego_GSE4107.Rdata")

#(3)可视化
#条带图
barplot(ego_CC,showCategory=20)
#气泡图
dotplot(ego_CC)
#下面的图需要映射颜色，设置和示例数据一样的geneList
geneList = deg$logFC
names(geneList)=deg$ENTREZID
geneList = sort(geneList,decreasing = T)
#(3)展示top5通路的共同基因，要放大看。
#Gene-Concept Network
cnetplot(ego_CC, categorySize="pvalue", foldChange=geneList,colorEdge = TRUE)
cnetplot(ego_CC, foldChange=geneList, circular = TRUE, colorEdge = TRUE)
#Enrichment Map
emapplot(ego_CC)
#(4)展示通路关系
goplot(ego_CC)
#(5)Heatmap-like functional classification
heatplot(ego_CC,foldChange = geneList)
#太多基因就会糊。可通过调整比例或者减少基因来控制。
pdf("heatplot.pdf",width = 14,height = 5)
heatplot(ego_CC,foldChange = geneList)
dev.off()

## 2.KEGG pathway analysis----
#上调、下调、差异、所有基因
#（1）输入数据
gene_up = deg[deg$change == 'up','ENTREZID'] 
gene_down = deg[deg$change == 'down','ENTREZID'] 
gene_diff = c(gene_up,gene_down)
gene_all = deg[,'ENTREZID']
#（2）对上调/下调/所有差异基因进行富集分析
if(F){
  kk.up <- enrichKEGG(gene         = gene_up,
                      organism     = 'hsa',
                      universe     = gene_all,
                      pvalueCutoff = 0.9,
                      qvalueCutoff = 0.9)
  kk.down <- enrichKEGG(gene         =  gene_down,
                        organism     = 'hsa',
                        universe     = gene_all,
                        pvalueCutoff = 0.9,
                        qvalueCutoff =0.9)
  kk.diff <- enrichKEGG(gene         = gene_diff,
                        organism     = 'hsa',
                        pvalueCutoff = 0.9)
  save(kk.diff,kk.down,kk.up,file = "GSE4107kegg.Rdata")
}
load("GSE42872kegg.Rdata")
#(3)从富集结果中提取出结果数据框
kegg_diff_dt <- kk.diff@result

#(4)按照pvalue筛选通路
#在enrichkegg时没有设置pvaluecutoff，在此处筛选
down_kegg <- kk.down@result %>%
  filter(pvalue<0.05) %>% #筛选行
  mutate(group=-2.0) #新增列

up_kegg <- kk.up@result %>%
  filter(pvalue<0.05) %>%
  mutate(group=2.0)
#(5)可视化
g_kegg <- kegg_plot(up_kegg,down_kegg)
#g_kegg+scale_x_continuous(labels = c(...))

g_kegg
ggsave(g_kegg,filename = 'kegg_up_down.png')

#gsea作kegg富集分析，了解一下----
#(1)查看示例数据
data(geneList, package="DOSE")
#(2)将我们的数据转换成示例数据的格式
geneList=deg$logFC
names(geneList)=deg$ENTREZID
geneList=sort(geneList,decreasing = T)
#(3)富集分析
kk_gse <- gseKEGG(geneList     = geneList,
                  organism     = 'hsa',
                  nPerm        = 1000,
                  minGSSize    = 120,
                  pvalueCutoff = 0.9,
                  verbose      = FALSE)
down_kegg<-kk_gse[kk_gse$pvalue<0.05 & kk_gse$enrichmentScore < 0,];down_kegg$group=-1
up_kegg<-kk_gse[kk_gse$pvalue<0.05 & kk_gse$enrichmentScore > 0,];up_kegg$group=1
#(4)可视化
gsea<-kegg_plot(up_kegg,down_kegg)
ggsave('kegg_up_down_gsea.png')
```

最后，给大家简单介绍一下批次效应，相关处理还请大家自行探索~

![3](https://gitee.com/KKAres/pictures/raw/master/png/3.png)

------

致谢：生信技能书
