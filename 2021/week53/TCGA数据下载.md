## 1 简单介绍一下TCGA
TCGA全称是** The Cancer Genome Atlas**。
是由National Cancer Institute ( NCI, 美国国家癌症研究所) 和  National Human Genome Research Institute (NHGRI, 国家人类基因组研究所) 合作建立的癌症研究项目，通过收集整理癌症相关的各种组学数据，提供了一个大型的，免费的癌症研究参考**数据库**（网址：[https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga](https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga)）。
TCGA涵盖了基因组，转录组，表观遗传，蛋白组等各个组学数据，提供了一个全方位，多维度的数据。 
![](https://gitee.com/KKAres/pictures/raw/master/png/1628666055977-4200bf16-e94b-4cda-b771-f84734e02720.png)


## 2 TCGA数据下载
### 2.1 工具介绍
官方提供了对应的下载工具`Genomic Data Commons Datga Portal`,  简称`GDC`。（网址：[https://portal.gdc.cancer.gov/](https://portal.gdc.cancer.gov/)）
除了官方提供的GDC之外当然还有其他第三方下载工具，如图：
![](https://gitee.com/KKAres/pictures/raw/master/png/1628671133048-2036d640-606e-4530-ae06-483fcc7aaaea.png)

- **GDC**

官方是GDC Data Transfer Tool Client，简称gdc-client，需要提前下载最新版软件。一手最新的数据。

- **TCGAbiolinks**

类似于gdc-client，很强大，但需要理解其中不同数据的下载步骤。

   - gdcRNAtools

基于TCGAbiolinks开发，更简洁
基于gdc-client下载并简化整理。

- **RTCGA**

数据库式的R包
2015年停止更新，适合训练。

- **Xena**

UCSC Xena 浏览器，最适合人类，只需要点点点==


### 2.2 数据下载
#### 2.2.1 官方的gdc-client
2.2.1.1 下载文件简介
今天举例下载的数据文件如下：我们需要下载的数据分为三块：网页的Manifest清单，组学数据（以**RNA-seq数据**为例，counts数据和对应样本信息的json文件），以及病人临床信息的xml文件。
![](https://gitee.com/KKAres/pictures/raw/master/png/1628819890394-7356274d-d564-4f77-bebc-e070924f3a6b.png)
来源：生信技能树




*其中不同数据中的样品数量会产生差异，这是因为:

![](https://gitee.com/KKAres/pictures/raw/master/png/1628820190426-0df1b419-67b3-44a8-9ab0-291552157f21.png)
来源：生信技能树


2.2.1.2 下载操作及部分代码演示
先从官网（[https://gdc.cancer.gov/access-data/gdc-data-transfer-tool](https://gdc.cancer.gov/access-data/gdc-data-transfer-tool)）下载gdc-client.exe放置于工作目录下。
** 1. 从网页选择数据，下载manifest文件**
数据存放网站：[https://portal.gdc.cancer.gov/](https://portal.gdc.cancer.gov/)
在Repository勾选自己需要的case和file类型。以CHOL为例：case-Project选择TCGA-CHOL。
这里依次需要下载的Manifest文件是：case相关的RNA-seq的counts文件清单和clinical xml 文件清单。
将manifest文件放在工作目录下。

![](https://gitee.com/KKAres/pictures/raw/master/png/1628821457909-f20864af-9f38-4b7e-bab4-53af2a7a699b.png)
**2.使用gdc-client工具下载**

```r
options(stringsAsFactors = F)
library(stringr)
cancer_type="TCGA-CHOL"
if(!dir.exists("clinical"))dir.create("clinical")
if(!dir.exists("expdata"))dir.create("expdata")
dir()
#下面两行命令在terminal完成
#./gdc-client download -m gdc_manifest.TCGA-CHOL.clinical.2021-08-13.txt -d clinical
#./gdc-client download -m ggdc_manifest.TCGA-CHOL.expdata.2021-08-13.txt -d expdata

length(dir("./clinical/"))
length(dir("./expdata/"))
```
可以看到，下载的文件是按样本名存放的，我们需要得到的是表格，需要将他们批量读入R语言并整理成如下形式：
![](https://gitee.com/KKAres/pictures/raw/master/png/1628822956786-d13ab9dc-bbf3-40ff-9d8f-3f1d19256566.png)


![](https://gitee.com/KKAres/pictures/raw/master/png/1628823163873-81099961-2975-46bd-aaa1-3c46b45fa51d.png)
**整理所有表达矩阵的时候会发现没有列名（样本名ID）**，这里就需要下载具有文件名（单个表达数据的文件名）与**样本ID（如下图TCGA barcode）**一一对应的文件：**cart-json文件**。
![](https://gitee.com/KKAres/pictures/raw/master/png/1628826203114-fd107ffd-13ea-40c0-81d2-960ce376bb7d.png)
同样从网页进入下载操作，将metadata json文件放入工作目录。
![](https://gitee.com/KKAres/pictures/raw/master/png/1628826075626-1e726e17-882e-401d-b9b0-b470cf23d7fa.png)




#### 2.2.2 TCGAbiolinks
主要是两部分数据的获取：临床数据和表达矩阵。
```r
rm(list = ls())
cancer_type="TCGA-CHOL"
library(TCGAbiolinks)

clinical <- GDCquery_clinic(project = cancer_type, 
                            type = "clinical")
clinical[1:4,1:4]
#>   submitter_id NA.  tumor_grade ajcc_pathologic_m
#> 1 TCGA-4G-AAZT  NA not reported                M0
#> 2 TCGA-ZH-A8Y2  NA not reported                M0
#> 3 TCGA-W5-AA2J  NA not reported                M0
#> 4 TCGA-W5-AA31  NA not reported                M0

dim(clinical)
#> [1]  51 158
#有些列全是NA，去掉。
tmp = apply(clinical, 2, function(x){all(is.na(x)|x=="")})
clinical = clinical[,!tmp]
query <- GDCquery(project = cancer_type, 
                  data.category = "Transcriptome Profiling", 
                  data.type = "Gene Expression Quantification", 
                  workflow.type = "HTSeq - Counts")  ###与网页选择相同
if(!dir.exists("GDCdata")) GDCdownload(query, method = "api", files.per.chunk = 50)

expdat <- GDCprepare(query = query)
#> 
|                                                    |  0%                      
|=                                                   |2.222222% ~6 s remaining  
|==                                                  |4.444444% ~5 s remaining  
|===                                                 |6.666667% ~5 s remaining  
|====                                                |8.888889% ~4 s remaining  
|=====                                               |11.11111% ~4 s remaining  
|======                                              |13.33333% ~4 s remaining  
|========                                            |15.55556% ~4 s remaining  
|=========                                           |17.77778% ~4 s remaining  
|==========                                          | 20% ~4 s remaining       
|===========                                         |22.22222% ~4 s remaining  
|============                                        |24.44444% ~3 s remaining  
|=============                                       |26.66667% ~3 s remaining  
|===============                                     |28.88889% ~3 s remaining  
|================                                    |31.11111% ~3 s remaining  
|=================                                   |33.33333% ~3 s remaining  
|==================                                  |35.55556% ~4 s remaining  
|===================                                 |37.77778% ~3 s remaining  
|====================                                | 40% ~3 s remaining       
|=====================                               |42.22222% ~3 s remaining  
|=======================                             |44.44444% ~3 s remaining  
|========================                            |46.66667% ~3 s remaining  
|=========================                           |48.88889% ~3 s remaining  
|==========================                          |51.11111% ~2 s remaining  
|===========================                         |53.33333% ~2 s remaining  
|============================                        |55.55556% ~2 s remaining  
|==============================                      |57.77778% ~2 s remaining  
|===============================                     | 60% ~2 s remaining       
|================================                    |62.22222% ~2 s remaining  
|=================================                   |64.44444% ~2 s remaining  
|==================================                  |66.66667% ~2 s remaining  
|===================================                 |68.88889% ~1 s remaining  
|====================================                |71.11111% ~1 s remaining  
|======================================              |73.33333% ~1 s remaining  
|=======================================             |75.55556% ~1 s remaining  
|========================================            |77.77778% ~1 s remaining  
|=========================================           | 80% ~1 s remaining       
|==========================================          |82.22222% ~1 s remaining  
|===========================================         |84.44444% ~1 s remaining  
|=============================================       |86.66667% ~1 s remaining  
|==============================================      |88.88889% ~1 s remaining  
|===============================================     |91.11111% ~0 s remaining  
|================================================    |93.33333% ~0 s remaining  
|=================================================   |95.55556% ~0 s remaining  
|==================================================  |97.77778% ~0 s remaining  
|====================================================|100% ~0 s remaining       
|====================================================|100%                      Completed after 5 s

library(SummarizedExperiment)

exp = assay(expdat)
exp[1:3,1:3]
#>                 TCGA-4G-AAZT-01A-11R-A41I-07 TCGA-W5-AA2R-01A-11R-A41I-07
#> ENSG00000000003                         7542                         4802
#> ENSG00000000005                            0                            1
#> ENSG00000000419                         1121                         1198
#>                 TCGA-W5-AA34-01A-11R-A41I-07
#> ENSG00000000003                         8150
#> ENSG00000000005                            0
#> ENSG00000000419                         1770
```
#### 2.2.3 GDCRNATools
```r
library(GDCRNATools)
project <- "TCGA-CHOL"
rnadir <- paste(project, 'RNAseq', sep='/')

clinicaldir <- paste(project, 'Clinical', sep='/')
gdcRNADownload(project.id     = project, 
               data.type      = 'RNAseq', 
               write.manifest = FALSE,
               method         = 'gdc-client',
               directory      = rnadir)
gdcClinicalDownload(project.id     = project, 
                    write.manifest = FALSE,
                    method         = 'gdc-client',
                    directory      = clinicaldir)
#2.临床信息解析----
metaMatrix.RNA <- gdcParseMetadata(project.id = project,
                                   data.type  = 'RNAseq', 
                                   write.meta = FALSE)
metaMatrix.RNA <- gdcFilterDuplicate(metaMatrix.RNA)
metaMatrix.RNA <- gdcFilterSampleType(metaMatrix.RNA)
dim(metaMatrix.RNA)
#> [1] 45 15

clinicalDa <- gdcClinicalMerge(path = clinicaldir, 
                               key.info = TRUE)
clinicalDa[1:2,1:5]
#>              age_at_initial_pathologic_diagnosis              ethnicity gender
#> TCGA-W5-AA2Q                                  68 NOT HISPANIC OR LATINO   MALE
#> TCGA-W5-AA2O                                  57 NOT HISPANIC OR LATINO   MALE
#>               race clinical_stage
#> TCGA-W5-AA2Q WHITE             NA
#> TCGA-W5-AA2O WHITE             NA

#3.count矩阵----
rnaCounts <- gdcRNAMerge(metadata  = metaMatrix.RNA, 
                         path      = rnadir,
                         organized = FALSE,
                         data.type = 'RNAseq')

dim(rnaCounts)
#> [1] 60483    45
```
#### 2.2.4 RTCGA包
```r
library(RTCGA.rnaseq)
library(RTCGA.clinical)
ls("package:RTCGA.rnaseq")
#>  [1] "ACC.rnaseq"      "BLCA.rnaseq"     "BRCA.rnaseq"     "CESC.rnaseq"    
#>  [5] "CHOL.rnaseq"     "COAD.rnaseq"     "COADREAD.rnaseq" "DLBC.rnaseq"    
#>  [9] "ESCA.rnaseq"     "GBM.rnaseq"      "GBMLGG.rnaseq"   "HNSC.rnaseq"    
#> [13] "KICH.rnaseq"     "KIPAN.rnaseq"    "KIRC.rnaseq"     "KIRP.rnaseq"    
#> [17] "LAML.rnaseq"     "LGG.rnaseq"      "LIHC.rnaseq"     "LUAD.rnaseq"    
#> [21] "LUSC.rnaseq"     "OV.rnaseq"       "PAAD.rnaseq"     "PCPG.rnaseq"    
#> [25] "PRAD.rnaseq"     "READ.rnaseq"     "SARC.rnaseq"     "SKCM.rnaseq"    
#> [29] "STAD.rnaseq"     "STES.rnaseq"     "TGCT.rnaseq"     "THCA.rnaseq"    
#> [33] "THYM.rnaseq"     "UCEC.rnaseq"     "UCS.rnaseq"      "UVM.rnaseq"
ls("package:RTCGA.clinical")
#>  [1] "ACC.clinical"      "BLCA.clinical"     "BRCA.clinical"    
#>  [4] "CESC.clinical"     "CHOL.clinical"     "COAD.clinical"    
#>  [7] "COADREAD.clinical" "DLBC.clinical"     "ESCA.clinical"    
#> [10] "FPPP.clinical"     "GBM.clinical"      "GBMLGG.clinical"  
#> [13] "HNSC.clinical"     "KICH.clinical"     "KIPAN.clinical"   
#> [16] "KIRC.clinical"     "KIRP.clinical"     "LAML.clinical"    
#> [19] "LGG.clinical"      "LIHC.clinical"     "LUAD.clinical"    
#> [22] "LUSC.clinical"     "MESO.clinical"     "OV.clinical"      
#> [25] "PAAD.clinical"     "PCPG.clinical"     "PRAD.clinical"    
#> [28] "READ.clinical"     "SARC.clinical"     "SKCM.clinical"    
#> [31] "STAD.clinical"     "STES.clinical"     "TGCT.clinical"    
#> [34] "THCA.clinical"     "THYM.clinical"     "UCEC.clinical"    
#> [37] "UCS.clinical"      "UVM.clinical"

#表达矩阵
exp2 = t(CHOL.rnaseq)
exp2[1:4,1:4]
#>                     [,1]                          
#> bcr_patient_barcode "TCGA-3X-AAV9-01A-72R-A41I-07"
#> ?|100130426         "0.0000"                      
#> ?|100133144         " 2.2265"                     
#> ?|100134869         "21.7256"                     
#>                     [,2]                          
#> bcr_patient_barcode "TCGA-3X-AAVA-01A-11R-A41I-07"
#> ?|100130426         "0.0000"                      
#> ?|100133144         " 4.0766"                     
#> ?|100134869         "22.2241"                     
#>                     [,3]                          
#> bcr_patient_barcode "TCGA-3X-AAVB-01A-31R-A41I-07"
#> ?|100130426         "0.0000"                      
#> ?|100133144         " 1.4149"                     
#> ?|100134869         " 4.4196"                     
#>                     [,4]                          
#> bcr_patient_barcode "TCGA-3X-AAVC-01A-21R-A41I-07"
#> ?|100130426         "0.0000"                      
#> ?|100133144         " 0.0000"                     
#> ?|100134869         " 3.8152"
dim(exp2)
#> [1] 20532    45
clinical2 = CHOL.clinical
#去除临床信息里全是NA的列
tmp = apply(clinical2, 2, function(x){all(is.na(x)|x=="")})
clinical2 = clinical2[,!tmp]
```
#### 2.2.5 xena整理好的数据
通过网页 [http://xena.ucsc.edu/](http://xena.ucsc.edu/)下载。
```r
exp3 = read.table("HiSeqV2",header = T,row.names = 1,check.names = F)
exp3 = as.matrix(exp3)
clinical3 = data.table::fread("CHOL_clinicalMatrix")
dim(exp3)
#> [1] 20530    45

exp3[1:4,1:4]
#>           TCGA-4G-AAZT-01 TCGA-W5-AA2R-11 TCGA-W5-AA36-01 TCGA-W5-AA2U-01
#> ARHGEF10L         10.1826         11.2568         10.6879         10.4950
#> HIF3A              5.5601          4.6809          1.4479          4.5270
#> RNF10             11.6858         11.9161         12.1831         10.8378
#> RNF11             10.6041         11.1185          9.3851         10.6367
clinical3[1:4,1:4]
#>           sampleID    _INTEGRATION     _PATIENT                      _cohort
#> 1: TCGA-3X-AAV9-01 TCGA-3X-AAV9-01 TCGA-3X-AAV9 TCGA Bile Duct Cancer (CHOL)
#> 2: TCGA-3X-AAVA-01 TCGA-3X-AAVA-01 TCGA-3X-AAVA TCGA Bile Duct Cancer (CHOL)
#> 3: TCGA-3X-AAVB-01 TCGA-3X-AAVB-01 TCGA-3X-AAVB TCGA Bile Duct Cancer (CHOL)
#> 4: TCGA-3X-AAVC-01 TCGA-3X-AAVC-01 TCGA-3X-AAVC TCGA Bile Duct Cancer (CHOL)
```


- Reference：

[https://cloud.tencent.com/developer/article/1556779](https://cloud.tencent.com/developer/article/1556779)
[https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga/history](https://www.cancer.gov/about-nci/organization/ccg/research/structural-genomics/tcga/history)
生信技能树

