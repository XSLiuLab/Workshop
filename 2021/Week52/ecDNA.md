# ecDNA的产生及其检测方法

## ecDNA简介

#### 概念

染色体外DNA（Extrachromosomal DNA，ecDNA）是存在肿瘤细胞中的一种染色体外的环状DNA。

#### 特征

（1）是一种存在于多种肿瘤细胞的染色体外的DNA，正常细胞中不存在；

（2）在细胞有丝分裂中期可被光镜观察到，大小从数百kb到数mb不等，成环状；

（3）含一个或者多个含有功能基因的扩增子（amplicon），并且还有控制转录的调节区域，具有组蛋白，在高级结构上和染色体接近；

（4）可自我复制，缺乏着丝粒，在有丝分裂中随机分配给子细胞。

![图1](https://i.loli.net/2021/08/06/WyLMerdgX59zCo4.png)

#### 产生机制

ecDNA的产生机制尚未明确。

（1）断裂-融合-桥（breakage-fusion-bridge，BFB）循环机制

（2）易位-缺失-扩增（translocation-deletion-amplification）模型

（3）附加体（episome）模型

（4）染色体破碎（chromothripsis）机制

![image-20210806082025363](https://i.loli.net/2021/08/06/tEIwFibz2UhfeXB.png)

##### 断裂-融合-桥循环机制

BFB循环是由双链DNA断裂引起的染色体断裂端融合开始的，随后形成了双中心的后期桥。由于两个着丝粒的存在，桥的断裂被分入有重复的子细胞和有缺失的子细胞。然后，整个BFB循环的过程可以重复，造成额外的重复和删除。根据断裂的位置和大小，可以产生高水平的基因扩增，如ecDNA

##### 易位-缺失-扩增模型

在这个模型中，基因重排发生在易位部位附近。易位断点附近的片段被扩增、保留或删除，从而形成ecDNA。在该模型下观察到MYC和ATBF1以及HMGIC和MDMD2在肿瘤细胞中的共同扩增。

##### 附加体模型

附加体模型是由Wahl和他的同事提出的。他们发现基因扩增可以由小的环状染色体外分子介导，并将这些分子称为“附加体”。他们认为，附加体是由删除包含复制起始点和相邻基因的序列的重组事件产生的，是自主复制的ecDNA的前体。

##### 染色体破碎机制

染色体破碎是一个灾难性的事件，一个或几个染色体被粉碎，形成数十到数百个序列片段。在修复过程中，这些片段可以被随机排序，导致复杂的局部聚集的DNA重排[8]。在某些情况下，片段可以形成ecDNA元件。

### ecDNA作用

#### 促进癌基因表达

#### ecDNA和均染区（HSRs），被认为是癌症中基因扩增的细胞遗传学特征。许多癌基因在肿瘤中被发现在ecDNA和HSRs扩增，包括c-myc和c-Ki-ras等。Deshpande等人开发了AmpliconArchitect工具，使用全基因组测序数据，重构局部扩增区域的精细结构，从而清晰地了解癌基因在ecDNA上的扩增.

![image-20210806082813969](https://i.loli.net/2021/08/06/g8pDAIuSVwelN9q.png)

#### 肿瘤异质性

由于ecDNA无着丝粒，细胞分裂时进行不均匀分配，导致ecDNA数量异质性，Turner等建立了通过染色体内外机制进行扩增的理论模型，证明了癌基因位于ecDNA上时，ecDNA的不均等分离会急剧增强肿瘤异质性；

![image-20210806083043169](https://i.loli.net/2021/08/06/hDuvTnqU1xb3ZYP.png)

#### 耐药性

ecDNA除通过增加肿瘤细胞异质性来增加肿瘤耐药性外，还会通过拷贝数动态变化来调节癌基因的表达，进而逃避针对ecDNA的治疗。![image-20210806083421992](https://i.loli.net/2021/08/06/qBbvtJ2L6GSxdEu.png)

#### 表观遗传的改变

ecDNA能使得癌基因利用增强子增强其转录能力。ecDNA相比线性DNA，核小体结构不紧密，开放性强，能够实现超远距离染色质接触，能够与调控元素产生远距离相互作用。

### ecDNA检测

#### 荧光

![image-20210806081731918](https://i.loli.net/2021/08/06/QzZdfNeSIcAlyYk.png)

#### 电子显微镜

![image-20210806084322368](https://i.loli.net/2021/08/06/kBYbwUnZmRVO8au.png)

#### 测序检测

##### 原理

ecDNA具有高拷贝

![图2](https://i.loli.net/2021/08/06/cvobKUVkgMl9JHx.png)

### 检测工具Amplicon Architect

Amplicon Architect基于三种关键特性来识别ecDNA，包括循环性、高拷贝数和断点的再利用。

#### 过程

![image-20210806092925089](https://i.loli.net/2021/08/06/WAjZvpVonferT54.png)

1、WGS

检测样本的全基因组BAM文件（深度5-7）

2、Interval set determination

除了映射的基因组读取外，还需要一个种子间隔。种子间隔作为AA搜索扩增子中包含的所有连接的基因组间隔的起点。

为了找到一个识别扩增间隔的标准，作者比较了从TCGA下载的匹配肿瘤样本和正常样本的CNV call file，这些样本包括了来自TCGA从Affymetrix6.0数据生成的10494个匹配病例的22376个 CNV call files。

作者统计了{3、4、5、7、10}CN_THRESHOLD中所有正常样本、肿瘤样本中的扩增间隔数，{10kbp、50kbp、100kbp、200kbp和500kbp}的SIZE_THRESHOLD值。在此基础上，我们选择CN_THRESHOLD=5和SIZE_THRESHOLD=100kbp选择种子间隔，结果在正常样本145个间隔，在肿瘤样本12162个间隔，在正常样本中没有相应的扩增。

### Amplicon Architect使用

https://github.com/virajbdeshpande/AmpliconArchitect

#### 安装

有两种方式

1. Docker image: This will automatically pull the latest build including necessary dependencies
2. Github source code

##### Docker image

1、Docker：

- Install docker: `https://docs.docker.com/install/`

2、License for Mosek optimization tool

- Obtain license file `mosek.lic` (`https://www.mosek.com/products/academic-licenses/` or `https://www.mosek.com/try/`)
- `export MOSEKLM_LICENSE_FILE=<Parent directory of mosek.lic> >> ~/.bashrc && source ~/.bashrc`

3、Download AA data repositories and set environment variable AA_DATA_REPO

- `docker pull virajbdeshpande/ampliconarchitect`

##### Github source code

git clone https://github.com/virajbdeshpande/AmpliconArchitect.git

```shell
wget http://download.mosek.com/stable/8.0.0.60/mosektoolslinux64x86.tar.bz2
tar xf mosektoolslinux64x86.tar.bz2
echo Please obtain license from https://www.mosek.com/products/academic-licenses/ or https://www.mosek.com/try/ and place in $PWD/mosek/8/licenses
echo export MOSEKPLATFORM=linux64x86 >> ~/.bashrc
export MOSEKPLATFORM=linux64x86
echo export PATH=$PATH:$PWD/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
echo export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/mosek/8/tools/platform/$MOSEKPLATFORM/bin >> ~/.bashrc
echo export MOSEKLM_LICENSE_FILE=$PWD/mosek/8/licenses >> ~/.bashrc
cd $PWD/mosek/8/tools/platform/linux64x86/python/2/
sudo python2 setup.py install #(--user)
cd -
source ~/.bashrc
```

##### 下载WGS BAM文件以及参考基因组

TCGA的WGS数据可以在这里下载https://isb-cgc.appspot.com/cohorts/filelist/

参考基因组下载

`https://drive.google.com/drive/folders/0ByYcg0axX7udeGFNVWtaUmxrOFk` Available annotations (`$ref`):

- hg19
- GRCh37
- GRCh38 (hg38)

#### Running AmpliconArchitect

#### Input data

1、Coordinate-sorted, indexed BAM file

- Align reads to a reference present in the `data_repo`.
- AA has been tested on `bwa mem` on `hg19` and `GRCh38` reference genomes.
- Recommended depth of coverage for WGS data is 5X-10X.
- Bamfile may be downsampled using `$AA_SRC/downsample.py` or when running AA with the option `--downsample`.

2、BED file with seed intervals:

- One or more intervals per amplicon in the sample

- AA has been tested on seed intervals generated as follows:

  - CNVs from CNV caller ReadDepth (with parameter file `$AA_SRC/src/read_depth_params`), Canvas and CNVkit

  - Select CNVs with copy number > 5x and size > 100kbp (default) and merge adjacent CNVs into a single interval using:

    `python2 $AA_SRC/amplified_intervals.py --bed {read_depth_folder}/output/alts.dat --out {outFileNamePrefix} --bam {BamFileName} --ref {ref}`

### Usage

$AA --bam {input_bam} --bed {bed file} --out {prefix_of_output_files} <optional arguments>

Github源代码中提供了执行脚本$AA，具体路径取决于使用的安装选项

1. Docker image: `AA=AmpliconArchitect/docker/run_aa_docker.sh`
2. Github source: `AA=python2 AmpliconArchitect/src/AmpliconArchitect.py`

##### Required Arguments

| Argument | Type | Description                                                  |
| -------- | ---- | ------------------------------------------------------------ |
| `--bed`  | FILE | Bed file with putative list of amplified intervals           |
| `--bam`  | FILE | Coordinate sorted BAM file with index mapped to provided reference genome |
| `--out`  | PATH | Prefix for output files                                      |

##### Optional Arguments:

| Argument          | Type | Description                                                  |
| ----------------- | ---- | ------------------------------------------------------------ |
| `-h`, `--help`    |      | 显示此帮助信息                                               |
| `-v`, `--version` |      | 显示程序版本                                                 |
| `--sensitivems`   | STR  | Values: [`True`, `False`]. Set `True` only if copy counts are expected to vary by an order of magnitude, e.g. viral integration. Default: `False` |
| `--plotstyle`     | STR  | Values: [`small`, `large`, `all_amplicons`]. `large`: large font, `all_amplicons`: 在单个图中显示大量的间隔，建议在集群模式下显示多个扩增子. Default: `small` |
| `--ref`           | STR  | Values: [`hg19`, `GRCh37`, `GRCh38`, `<CUSTOM>`, `None`]. Reference annotations to use from the AA_DATA_REPO directory. BAM and BED files match these annotations. - `hg19`/`GRCh38` : chr1,, chr2, .. chrM etc - `GRCh37` : '1', '2', .. 'MT' etc - `<CUSTOM>` : User provided annotations in AA_DATA_REPO directory. - `None` : do not use any annotations. AA can tolerate additional chromosomes not stated but accuracy and annotations may be affected. - Default: `hg19` |

### Output description

| File name                      | Description                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `{out}_summary.txt`            | 此文件包括AA检测到的所有扩增子的摘要。                       |
| `{out}_amplicon{id}_graph.txt` | 每个扩增子的文本文件，列出断点图中的边、它们的分类(顺序、不一致、一致、源)和它们的拷贝计数。 |
| `{out}_amplicon{id}_cycle.txt` | 每个扩增子的文本文件，列出简单的周期和它们的拷贝数           |
| `{out}_amplicon{id}.png/pdf`   | 一个PNG/PDF格式的图像文件，显示AA的SV视图。                  |

### Interpreting the output

运行AA后的一个常见问题是，“如何知道这些重构是否代表ecDNA?”

![image-20210806105442628](https://i.loli.net/2021/08/06/qXIZEmjN1xUlWcg.png)



为了帮助回答这个问题，作者单独开发了扩增子分类方法AmpliconClassifier，可以在AA输出上运行，以预测目前存在的聚焦扩增的类型。

## AmpliconClassifier

https://github.com/jluebeck/AmpliconClassifier

#### **Usage**

`amplicon_classifier.py` takes an AA graph file and an AA cycles file as input.

```shell
python amplicon_classifier.py --ref [hg19, GRCh37, or GRCh38] --input [file with list of your amplicons] > classifier_stdout.log
```

#### **Output**

`[output_prefix]_amplicon_classification_profiles.tsv`

| Column name                    | Contents                                                     |
| ------------------------------ | ------------------------------------------------------------ |
| `sample_name`                  | Sample name prefix                                           |
| `amplicon_number`              | AA amplicon index, e.g. `[samplename]_amplicon2`             |
| `amplicon_decomposition_class` | Abstract description of the AA amplicon type. Note that `Cyclic` can refer to either BFB or ecDNA. Please see the following columns for that distinction. |
| `ecDNA+`                       | Prediction about whether the AA amplicon contains ecDNA. Note, an AA amplicon may contain regions surrounding the ecDNA, or multiple linked ecDNA. Either `Positive` or `None detected` |
| `BFB+`                         | Prediction about whether the AA amplicon is the result of a BFB. Either `Positive` or `None detected` |
| `ecDNA_amplicons`              | Predicted number of distinct (non-overlapping) ecDNA which are represented in a single AA amplicon. This estimate is highly experimental. |

`[output_prefix]_gene_list.tsv`

这将报告每个分类扩增子上的基因，以及它所位于的基因组特征(如ecDNA_1, BFB_1等)，以及拷贝数。

### 参考资料

#### 文献

[1] David, A. , et al. "Targeted therapy resistance mediated by dynamic regulation of extrachromosomal mutant EGFR DNA. " Science (New York, N.Y.) (2014).

[2] Deshpande, V. , et al. "Exploring the landscape of focal amplifications in cancer using AmpliconArchitect." Nature Communications 10.1(2019):392.

[3] Kim, H. , et al. "Extrachromosomal DNA is associated with oncogene amplification and poor outcome across multiple cancers." Nature Genetics. 

[4] Decarvalho, A. C. , et al. "Discordant inheritance of chromosomal and extrachromosomal DNA elements contributes to dynamic disease evolution in glioblastoma." Nature Genetics (2018).

[5] Vasan, N. ,  J. Baselga , and  D. M. Hyman . "A view on drug resistance in cancer." Nature 575.7782(2019):299-309.

#### 网站

1、https://www.youtube.com/watch?v=qLsqr63wHhw

2、https://github.com/virajbdeshpande/AmpliconArchitect

3、https://github.com/jluebeck/PrepareAA

4、https://github.com/jluebeck/AmpliconClassifier

5、https://docs.docker.com/engine/install/centos/

6、https://isb-cgc.appspot.com/cohorts/filelist/











