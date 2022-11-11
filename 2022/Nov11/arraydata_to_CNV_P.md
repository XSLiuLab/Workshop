# 芯片数据到拷贝数

    目前CNV测序主要分基因芯片、全基因组测序、全外显子测序三种，本次介绍芯片数据提取CNV流程。

## 一 芯片测序

CNV的芯片检测技术又称为染色体的微阵列分析技术（Chromosomal Microarray Analysis，CMA技术），**基本原理**是用大量的涵盖染色体重要片段的DNA探针，固定于固相支持物上然后与标记的样品分子杂交，通过对杂交信号的监测分析获得样品分子的数量和序列信息，目前常用的是比较基因组杂交aCGH以及SNP芯片

### 1.1 比较基因组杂交aCGH

将病人与对照购买的商品化正常男性或女性全基因组分别标记为红色荧光与绿色荧光, 混合后与全基因组DNA芯片进行竞争性杂交。如果病人的拷贝数增多,则红色荧光较多；如果病人拷贝数减少,则绿色荧光较多, 若红绿光均等，则表明待测样品拷贝数正常。

![1668141094149](image/arraydata_to_CNV_P/1668141094149.png)

**局限性：** （1）对于低水平的DNA重复或缺失会漏检；（2）无法检测拷贝数不变的染色体异常，如单亲二体和杂合性缺失；（3）结果假阳性率高，通常需要其他技术验证

### 1.2 SNP6.0 芯片

全称Affymetrix Genome-Wide Human SNP Array 6.0, 基于染色体区域内的SNP分型结果来判断对应的拷贝数的一种生物芯片,基本原理是将探针连接在微珠上，然后将携带探针的微珠随机黏附在芯片上，待测标本DNA和探针进行杂交及单碱基延伸，通过对荧光信号扫描，分析待测标本拷贝数变异及基因型，该平台在分析患者的基因组时不需要正常对照标本。

![1668141165749](image/arraydata_to_CNV_P/1668141165749.png)

测序时扫描设备对芯片进行扫描，得到荧光信号图像文件（DAT文件），系统自带的图形处理软件进行一系列图形处理与识别，从芯片图像中提取数据，得到.CEL文件(存储每个探针的信号值和定位信息的文件)，.CEL文件，使用不同的格式。例如，版本3使用ASCII文本格式，而版本4使用二进制格式。

*注意：.CEL 文件需要相应的.CDF 文件，它是存储在.CEL文件中的原始探测级数据的字典,存储基因芯片探针排布的信息（哪个探针来自哪个探针组）。MATLAB有一个名为affyread的内置函数，可以用来读取Windows版本软件中的.CEL 文件。

*Probe文件：提供探针的序列信息

对于每个SNP位点的两个allel, 分别用A和B来表示，A代表ref allel, B代表alt allel，可以通过比较A/B两种allel对应的荧光信号强度的比值确定CNV，涉及两个统计值

```
Log R ratio:
LRR=Log2(Robserved/Rexpected)
#R代表的是A和B两个allel荧光信号强度的总和，observed是实验样本中实际检测到的数值，exprected是通过算法拟合的值，代表正常样本的检测值。LRR类似aCGH芯片中的Log2 ratio, 表征的是相对正常样本的拷贝数变化情况。该值为0，表示拷贝数没有异常，为二拷贝，大于0， 表示拷贝数增加，小于0，表示拷贝数减少

B allel frequency
BAF=normalized measure of relative signal intensity(B/A)
#BAF取值范围为0-1， 0代表只检测到了A这个allel对应的荧光信号，分型结果为AA, 1代表只检测到了B这个allel的荧光信号，分型结果为BB; 0.5代表A和B两个allel的荧光信号强度相等，分型结果为AB
```

## 2 相关数据库

##### 2.2.1 GEO

snp6.0芯片平台：GPL6801

![1668141209280](image/arraydata_to_CNV_P/1668141209280.png)

.CEL数据

![1668141235322](image/arraydata_to_CNV_P/1668141235322.png)

##### 2.2.2 [ArrayExpress](https://www.ebi.ac.uk/biostudies/arrayexpress)

功能基因组学（Functional Genomics）数据集的主要公共存储库之一，与GEO数据库类似。主要包括Microarray（微阵列芯片）和High-throughput sequencing（高通量测序）数据，也包括甲基化、CHIP-seq和基因分型（genotypping）等数据

```
# 安装 ArrayExpress 包
BiocManager::install("ArrayExpress")
```

## 3 SNP6.0 数据分析流程

搭建TCGA芯片数据拷贝数流程（[Bioinformatics Pipeline: Copy Number Variation Analysis - GDC Docs (cancer.gov)](https://docs.gdc.cancer.gov/Data/Bioinformatics_Pipelines/CNV_Pipeline/)）

![1668141249688](image/arraydata_to_CNV_P/1668141249688.png)

流程：

##### download and release Analysis Power Tools (APT)

用于读取.CEL文件并生成基因簇分型

```
wget https://www.thermofisher.cn/content/dam/LifeTech/Documents/ZIP/apt_2.11.6_linux_64_x86_binaries.zip
unzip apt_2.11.6_linux_64_x86_binaries.zip
#add path
export PATH=/public/home/wangjy10/packages/apt_2.11.6_linux_64_x86_binaries/bin:$PATH
#ask p
chmod +x /public/home/wangjy10/packages/apt_2.11.6_linux_64_x86_binaries/bin/apt-probeset-genotype
chmod +x /public/home/wangjy10/packages/apt_2.11.6_linux_64_x86_binaries/bin/apt-probeset-summarize

```

    installer版本： 它包含了所有必须文件和帮助文档等，执行exe文件通过弹出的指示即可以安装软件。

    binary版本： 它是一个二进制包，里面包括了编译好的可以直接使用的程序，只需要把它解压缩到你想要安装的目录就马上可以使用。

    source版本： 源代码包里面包括了原始的程序代码，需要在你的计算机上编译后才可以产生能运行的程序，所以从源代码安装的时间会比较长。

##### PennCNV

官网：[PennCNV (openbioinformatics.org)](https://penncnv.openbioinformatics.org/en/latest/)

PennCNV is a free software tool for Copy Number Variation (CNV) detection from SNP genotyping arrays，

![1668141272605](image/arraydata_to_CNV_P/1668141272605.png)

*安装需要gcc=4,perl =5.14.2

可用docker

perl 5.14.2 可以通过Perldrew（[Perlbrew](https://perlbrew.pl/)）来安装

```
\wget -O - https://install.perlbrew.pl --no-check-certificate | bash
perlbrew init
```

![1668141315895](image/arraydata_to_CNV_P/1668141315895.png)

```
perlbrew install perl-5.14.2
perlbrew ues perl-5.14.2
...
perlbrew off
```

##### download snp6.0 library file，

    library file注册thermofisher官网账号后下载

    https://www.thermofisher.cn/search/results?query=SNP%206&amp;persona=DocSupport&amp;refinementAction=true&amp;personaClicked=true&amp;resultPage=2&amp;resultsPerPage=15

##### 安装R包ASCAT 与SNPpos.txt, GC

######  github: [VanLoo-lab / ascat](https://github.com/VanLoo-lab/ascat)

```
BiocManager::install(c('GenomicRanges','IRanges')
devtools::install_github('VanLoo-lab/ascat/ASCAT')
```

## 4 process

###### Step 0. Generate the signal intensity data based on raw CEL files by **APT**

    ![1668141336949](image/arraydata_to_CNV_P/1668141336949.png)

###### Substep 1.1 Generate genotyping calls from CEL files

 This step uses the apt-probeset-genotype program in Affymetrix Power Tools (APT) to generate genotyping calls from the raw CEL files using the Birdseed algorithm (for genome-wide 6.0 array) or BRLMM-P (for genome-wide 5.0 array) algorithm. Note that the genotyping calling requires lots of CEL files.

```
cd $workdir/rawdata
ls *.CEL >/public/home/wangjy10/work/Prostate_cnv_db/array_data_raw/GEO/GSE18333/CELfiles.txt
#CELfiles.txt第一行为cel_files

apt-probeset-genotype -c $librarydir/GenomeWideSNP_6.cdf -a birdseed --read-models-birdseed $librarydir/GenomeWideSNP_6.birdseed.models \
--special-snps $librarydir/GenomeWideSNP_6.specialSNPs \
--out-dir $outdir --cel-files $workdir/CELfiles.txt

###
Opening layout file: /public/home/wangjy10/work/Prostate_cnv_db/array_data_raw/CD_GenomeWideSNP_6_rev3/Full/GenomeWideSNP_6/LibFiles/GenomeWideSNP_6.cdf
Reading 1856069 probesets.........................................Done. (0.21 min)
Kept 909622 probesets.
Reading and pre-processing 82 cel files..................................................................................Done. (2.51 min)
Processing 1 chipstream.
Computing sketch normalization for 82 cel datasets..................................................................................Done. (1.08 min)
Applying sketch normalization to 82 cel datasets..................................................................................Done. (2.56 min)
Finalizing 1 chipstream.
Using gender method em-cluster-chrX-het-contrast for genotype calling.
Using inbred covariates none for genotype calling.
Setting analysis info.
Processing probesets.........................................Done. (21.73 min)
Flushing output reporters. Finalizing output.
Run took approximately: 28.88 minutes.
Done running ProbesetGenotypeEngine.
```

###### Subsetp 1.2 Allele-specific signal extraction from CEL files

This step uses the Affymetrix Power Tools software to extract allele-specific signal values from the raw CEL files. Here `allele-specific` refers to the fact that for each SNP, we have a signal measure for the A allele and a separate signal measure for the B allele.

*needed: file hapmap.quant-norm.normalization-target.txt is provided in the PennCNV-Affy package;

```
cd $workdir/rawdata
apt-probeset-summarize --cdf-file $librarydir/GenomeWideSNP_6.cdf \
--analysis quant-norm.sketch=50000,pm-only,med-polish,expr.genotype=true \
--target-sketch $penncnvlibdir/hapmap.quant-norm.normalization-target.txt \
--out-dir $outdir --cel-files $workdir/CELfiles.txt

###
Read 82 cel files from: CELfiles.txt
Running ProbesetSummarizeEngine...
Opening cdf file: GenomeWideSNP_6.cdf
Reading 1856069 probesets.........................................Done. (0.36 min)
Kept 1856069 probesets.
Opening target normalization file: hapmap.quant-norm.normalization-target.txt
Setting analysis info.
Reading and pre-processing 82 cel files..................................................................................Done. (2.08 min)
Processing 1 chipstream.
Computing sketch normalization for 82 cel datasets..................................................................................Done. (3.16 min)
Finalizing 1 chipstream.
Processing Probesets.....................Done. (6.43 min)
Flushing output reporters. Finalizing output.
Done.
Run took approximately: 12.18 minutes.
Done running ProbesetSummarizeEngine.
```

###### Substep 1.3 LRR and BAF calculation

This step use the allele-specific signal intensity measures generated from the last step to calculate the Log R Ratio (LRR) values and the B Allele Frequency (BAF) values for each marker in each individual.(ignore the 1.3 of penncnv)

```
$penncnvlibdir/affy/bin/normalize_affy_geno_cluster.pl $librarydir2/gw6.genocluster $outdir/quant-norm.pm-only.med-polish.expr.summary.txt -locfile $penncnvlibdir/affy/libgw6/affygw6.hg19.pfb -out $outdir/lrr_baf.txt
```

###### Substep 1.4  Generate segment files by ASCAT

```
Rscript /public/home/wangjy10/work/Prostate_cnv_db/array_data_raw/pbs/ascat.R
Loading required package: RColorBrewer
Loading required package: splines
Loading required package: data.table
Loading required package: GenomicRanges
Loading required package: stats4
Loading required package: BiocGenerics

Attaching package: ‘BiocGenerics’

The following objects are masked from ‘package:stats’:

    IQR, mad, sd, var, xtabs

The following objects are masked from ‘package:base’:

    anyDuplicated, aperm, append, as.data.frame, basename, cbind,
    colnames, dirname, do.call, duplicated, eval, evalq, Filter, Find,
    get, grep, grepl, intersect, is.unsorted, lapply, Map, mapply,
    match, mget, order, paste, pmax, pmax.int, pmin, pmin.int,
    Position, rank, rbind, Reduce, rownames, sapply, setdiff, sort,
    table, tapply, union, unique, unsplit, which.max, which.min

Loading required package: S4Vectors

Attaching package: ‘S4Vectors’

The following objects are masked from ‘package:data.table’:

    first, second

The following objects are masked from ‘package:base’:

    expand.grid, I, unname

Loading required package: IRanges

Attaching package: ‘IRanges’

The following object is masked from ‘package:data.table’:

    shift

Loading required package: GenomeInfoDb
Loading required package: parallel
Loading required package: doParallel
Loading required package: foreach
Loading required package: iterators
[1] Reading Tumor LogR data...
[1] Reading Tumor BAF data...
[1] Reading Germline LogR data...
[1] Reading Germline BAF data...
[1] Registering SNP locations...
[1] Splitting genome in distinct chunks...
[1] Warning: no replication timing file given, proceeding with GC correction only!
[1] Sample GSM457726_SH27_T_GenomeWideSNP_6_ (1/1)
GC correlation:  25bp 1.3e-01 ; 50bp 6.5e-02 ; 100bp 3.2e-02 ; 200bp 8.9e-03 ; 500bp 1.1e-02 ; 1000bp 1.5e-02 ; 2000bp 1.0e-02 ; 5000bp 8.5e-05 ; 10000bp 5.4e-03 ; 20000bp 8.1e-03 ; 50000bp 1.0e-02 ; 100000bp 1.2e-02 ; 200000bp 1.3e-02 ; 500000bp 1.4e-02 ; 1M 1.4e-02 ; 2M 1.5e-02 ; 5M 1.4e-02 ; 10M 8.9e-03 ; 
Short window size:  25bp 
Long window size:  500000bp 
Warning message:
In ascat.GCcorrect(ascat.bc, "/public/home/wangjy10/work/Prostate_cnv_db/array_data_raw/CD_GenomeWideSNP_6_rev3/GC_AffySNP6_102015.txt") :
  Please consider using ascat.correctLogR instead of ascat.GCcorrect.
[1] Plotting tumor data
[1] Plotting germline data
[1] Sample GSM457726_SH27_T_GenomeWideSNP_6_ (1/1)
There were 50 or more warnings (use warnings() to see the first 50)
[1] Sample GSM457726_SH27_T_GenomeWideSNP_6_ (1/1)
```

ASCAT

先读入lrr_baf.txt,整理成每个样本的4个文件

```
library(ASCAT)
file.tumor.LogR <- dir(pattern="tumor.LogR")
file.tumor.BAF <- dir(pattern="tumor.BAF")
file.normal.LogR <- dir(pattern="normal.LogR")
file.normal.BAF <- dir(pattern="normal.BAF")
....
```

### output file

![1668141367889](image/arraydata_to_CNV_P/1668141367889.png)

segment file

![1668141399725](image/arraydata_to_CNV_P/1668141399725.png)

### results

ASCAT first determines the ploidy of the tumor cells ψ*~t~* and the fraction of aberrant cells ρ. This procedure evaluates the goodness of fit for a grid of possible values for both parameters (blue, good solution; red, bad solution.

![1668141455216](image/arraydata_to_CNV_P/1668141455216.png)

raw  profile

![1668141470473](image/arraydata_to_CNV_P/1668141470473.png)

ASCAT profile

![1668141484801](image/arraydata_to_CNV_P/1668141484801.png)

![1668141509494](image/arraydata_to_CNV_P/1668141509494.png)

![1668141520889](image/arraydata_to_CNV_P/1668141520889.png)

![1668141530675](image/arraydata_to_CNV_P/1668141530675.png)

## 总结

TCGA  snp6.0拷贝数数据提取流程的搭建，通过APT，PennCNV与ASCAT工具处理芯片数据.CEL文件到segment文件等。

需要注意环境的配置与相关文件的下载

2022年11月11日
