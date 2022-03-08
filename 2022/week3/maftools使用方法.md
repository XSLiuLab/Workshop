# maftools-突变注释文件的可视化

# 1. 什么是MAF？

MAF是Mutation Annotation Formant，突变注释文件的缩写，随着基因组测序技术的发展，这种文件格式被广泛的用于储存体细胞中检测到的突变。像我们经常使用到的TCGA数据库也是使用的这种文件格式来存储突变的。

MAF文件是通过VCF文件产生的，VCF是从测序文件中call出来的突变，有很多工具可以将vcf转变程MAF，比如vcf2maf。

MAF是以制表符来分割的文件，这个文件中有100多列的参数，储存着基因ID，参考图谱，突变位置等信息，这里不再一一介绍了，感兴趣的话可以去这个[链接](https://docs.gdc.cancer.gov/Data/File_Formats/MAF_Format/)看一下。

# 2. maftools是来做什么的呢？

这个工具包是对maf文件进行绘制，分析，注释和可视化的。使用这个工具的话，在MAF中有几个参数是必需的：**Hugo_Symbol, Chromosome, Start_Position, End_Position, Reference_Allele, Tumor_Seq_Allele2, Variant_Classification, Variant_Type and Tumor_Sample_Barcode。**

# 3.使用方法

## 3.1 安装

```r
if (!require("BiocManager"))
    install.packages("BiocManager")
BiocManager::install("maftools")
```

## 3.2 概括

这张图概括了他这个包的一个总体工作流程，简单介绍一下的话就是他通过将MAF转化为自己的MAF object然后进行一系列的分析和可视化的操作。

![Untitled](maftools-%E7%AA%81%2032819/Untitled.png)

## 3.3 部分实操

这个工具很多函数都非常的好可以通过简单的命令快速的产生很多的图，我只选择一部分内容给介绍。

```r
library(maftools)
#--- read file
laml.maf = system.file('extdata', 'tcga_laml.maf.gz', package = 'maftools') 
laml.clin = system.file('extdata', 'tcga_laml_annot.tsv', package = 'maftools') 
laml = read.maf(maf = laml.maf, clinicalData = laml.clin)

laml
getSampleSummary(laml)
getGeneSummary(laml)
getClinicalData(laml)
getFields(laml)

# ---- Visualization
plotmafSummary(maf = laml, rmOutlier = TRUE, addStat = 'median', dashboard = TRUE, titvRaw = FALSE)
oncoplot(maf = laml,top = 30)

laml.titv = titv(maf = laml, plot = FALSE, useSyn = TRUE)
#plot titv summary
plotTiTv(res = laml.titv)

#突变负荷
laml.mutload = tcgaCompare(maf = laml, cohortName = 'Example-LAML', logscale = TRUE, capture_size = 50)

somaticInteractions(maf = laml, top = 25, pvalue = c(0.05, 0.1))

mafSurvival(maf = laml, genes = 'DNMT3A', time = 'days_to_last_followup', 
            Status = 'Overall_Survival_Status', isTCGA = TRUE)
```

上面只是使用的一些默认的参数来绘制图像，还可以通过改变参数来定制自己的图像:

```r
# plotmafSummary
plotmafSummary(maf, file = NULL, rmOutlier = TRUE, dashboard = TRUE,
  titvRaw = TRUE, width = 10, height = 7, addStat = NULL,
  showBarcodes = FALSE, fs = 10, textSize = 2, color = NULL,
  statFontSize = 3, titleSize = c(10, 8), titvColor = NULL, top = 10)

#oncoplot
oncoplot(maf, top = 20, genes = NULL, mutsig = NULL, mutsigQval = 0.1,
  drawRowBar = TRUE, drawColBar = TRUE, clinicalFeatures = NULL,
  annotationDat = NULL, annotationColor = NULL, genesToIgnore = NULL,
  showTumorSampleBarcodes = FALSE, removeNonMutated = TRUE, colors = NULL,
  sortByMutation = FALSE, sortByAnnotation = FALSE,
  annotationOrder = NULL, keepGeneOrder = FALSE, GeneOrderSort = TRUE,
  sampleOrder = NULL, writeMatrix = FALSE, fontSize = 10,
  SampleNamefontSize = 10, titleFontSize = 15, legendFontSize = 12,
  annotationFontSize = 12, annotationTitleFontSize = 12)
```

**如果真实样本处理该怎么做呢？**

```r
library("tidyverse")

risk <- read_delim(risk_file,delim = "\t")  #risk文件路径
risk_low <- risk %>% filter(risk == "low")
risk_high <- risk %>% filter(risk == "high")
#读入risk文件，分为根据label高低两组

maf_file <- file.choose()
maf<-data.table::as.data.table(read.csv(file=maf_file,header=TRUE,
                                        sep='\t',stringsAsFactors=FALSE,comment.char="#"))#maf文件路径
maf$Tumor_Sample_Barcode <- substr(maf$Tumor_Sample_Barcode,1,12)
#这步比较麻烦的，原因是由于maf文件里的tumor_sample_barcode不能对应起来，需要对barcode进行截断

#接下来的内容就是maftools工具里的步骤了
maf = read.maf(maf)#读取
#risk_low
maf_risk_low <- subsetMaf(maf = maf, tsb = risk_low$id)
pdf('risk_low_summary.pdf')
plotmafSummary(maf =maf_risk_low, rmOutlier = TRUE, addStat = 'median')
dev.off()
pdf('risk_low_oncoplot.pdf')
oncoplot(maf = maf_risk_low, top = 20, writeMatrix=T,removeNonMutated = F) #oncoplot
dev.off()
#risk_high
maf_risk_high <- subsetMaf(maf = maf, tsb = risk_high$id)
pdf('risk_high_summary.pdf')
plotmafSummary(maf = maf_risk_high, rmOutlier = TRUE, addStat = 'median')
dev.off()
pdf('risk_high_oncoplot.pdf')
oncoplot(maf = maf_risk_high, top = 20, writeMatrix=T,removeNonMutated = F)
dev.off()
write.mafSummary(maf_risk_low,"~/Xianyu/maf_risk_low.maf")
write.mafSummary(maf_risk_high,"~/Xianyu/maf_risk_high.maf")
```

参考材料：

1.[bioconductor](https://bioconductor.org/packages/release/bioc/vignettes/maftools/inst/doc/maftools.html)
