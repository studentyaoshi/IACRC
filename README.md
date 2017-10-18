# Interaction Analyses within Chromatin Regulatory Circuitry (IACRC)

# Introduction

Genome-wide association studies (GWASs) is an effective strategy to identify susceptibility loci for human complex diseases. However, missing heritability is still a big problem. Here we developed a pipeline named interaction analyses within chromatin regulatory circuitry (`IACRC`), to identify genetic variants impacting complex traits. `IACRC` would automatically selected chromatin regulatory circuits regions with Hi-C datasets, enhancer data, and super enhancer regions. SNP × SNP interaction analyses were then performed in regions within chromatin regulatory circuits.

# License

This software is distributed under the terms of GPL 2.0

# Source

https://github.com/studentyaoshi/IACRC

# Contact

## Author

Shan-Shan Dong, Shi Yao, Yan Guo, Tie-Lin Yang </br>
Key Laboratory of Biomedical Information Engineering of Ministry of Education, School of Life Science and Technology, Xi'an Jiaotong University, Xi'an, Shaanxi Province, 710049, P. R. China </br>
yangtielin@mail.xjtu.edu.cn

## Maintainer

Shan-Shan Dong and Shi Yao </br>
You can contact dongss@xjtu.edu.cn or studentyaoshi@stu.xjtu.edu.cn when you have any questions, suggestions, comments, etc. Please describe in details, and attach your command line and log messages if possible.

# Requiremnets

[PLINK](https://www.cog-genomics.org/plink2);</br>
[Python2.7](https://www.python.org/downloads/);</br>
[Bedtools](http://bedtools.readthedocs.io/en/latest/content/installation.html);</br>
[METAL](http://csg.sph.umich.edu/abecasis/metal/download/) if you would like to do meta analysis;</br>
and [R](https://www.r-project.org/) if you would like to include covariates in case/control test.

# Preparation

## Setup floder framework

```
cd /your/local/path/pipeline
```

## Prepare original files
There are five original files you need to prepare before starting calculation, according to the disease you are studing. These files including gene information, Hi-C pairs, enhancer annotation, gene-enhancer information and gene-super enhancer information. The description and data format are as follows.

#### Gene information

Gene information contains four columns divided by tab including the gene name, chromosome, the start and end position of gene without header:

```
OR4F5		chr1	69091	70008
AL627309.1	chr1	134901	139379
OR4F29		chr1	367640	368634
OR4F16		chr1	621059	622053
AL669831.1	chr1	738532	739137
...
```

#### Hi-C pairs

Hi-C pairs contains six columns divided by tab including the chromosome, the start position and the end position of the two regions without header. We downloaded the autosomal interactions in 9 cell lines (NHEK, K562, Islet, IMR90, HUVEC, HMEC, HELA, GM12878, and A549) in /your/local/path/files/hic/ from [4DGenome](http://4dgenome.research.chop.edu/) and some recent papers, [chromatin looping](https://www.ncbi.nlm.nih.gov/pubmed/25497547), [3D Genome Architecture](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4734140/), [long-range promoter](https://www.ncbi.nlm.nih.gov/pubmed/25938943), [cis-regulatory landscape](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4281301/), [Genome Architecture Links](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5123897/) [long-range interactions](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4674669/), and [Hi-C from A549](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE92819).

```
chr1	1050000	1060000	chr1	1180000	1190000
chr1	1585000	1590000	chr1	1645000	1650000
chr1	1710000	1715000	chr1	1835000	1840000
chr1	2120000	2130000	chr1	2310000	2320000
chr1	2130000	2135000	chr1	2515000	2520000
...
```

#### Enhancer annotation

Enhancer annotation is .bed file contains the chromatin states downloaded from [Roadmap](http://egg2.wustl.edu/roadmap/data/byFileType/chromhmmSegmentations/ChmmModels/coreMarks/jointModel/final/). The format of .bed can be found [here](http://www.ensembl.org/info/website/upload/bed.html).

In our paper, we used the chromatin states of GM12878 and '7_Enh' annotation in the forth column as input.

We already downloaded and converted the enhancers in 9 cell lines (NHEK, K562, Islet, IMR90, HUVEC, HMEC, HELA, GM12878, and A549) according to Hi-C pairs in /your/local/path/files/HMM/.
```
chr10	174200	174400	7_Enh	0	.	174200	174400	255,255,0
chr10	175600	176000	7_Enh	0	.	175600	176000	255,255,0
chr10	187400	188400	7_Enh	0	.	187400	188400	255,255,0
chr10	228600	229000	7_Enh	0	.	228600	229000	255,255,0
chr10	264600	265200	7_Enh	0	.	264600	265200	255,255,0
...
```

#### Gene-enhancer
Gene-enhancer contains two columns divided by tab including the gene name and the enhancer region. We used enhancer-gene interactions predicted by [PreSTIGE](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3875850/) and the data can be downloaded [here](http://genetics.case.edu/prestige). We downloaded and converted the gene-enhancer interactions in six cell lines (GM12878, K562, HUVEC, HMEK, NHEK, HELA) for convenience in /your/local/path/files/gene_enhancer/.

```
SLC25A28	chr10:101314742-101317123
SLC25A28	chr10:101359480-101360496
SLC25A28	chr10:101375165-101375877
SLC25A28	chr10:101387579-101391927
COX15		chr10:101409861-101410384
...
```

#### Gene-super enhancer
Gene-super enhancer contains three columns divided by tab including chromsome, the start and the end position of the super enhancer. We used the super enhancer data from [this paper](https://www.ncbi.nlm.nih.gov/pubmed/24119843). We downloaded and converted the super enhancer data in 86 tissues/cell lines in /your/local/path/files/super_enhancer/ which the detail of the tissues/cell lines can be found in /your/local/path/files/super_enhancer/86-Cell.anno.

```
chr1	68148186	68237688
chr2	37850717	37940881
chr3	16099720	16182650
chr4	7804602		7914384
chr5	172284905	172383585
...
```
These five files need to be moved to /your/local/path/original/ after preparation and then you need to change the file names in /your/local/path/original/files accordingly. For example, the following file indicates that the five files are gene_information, GM12878_HIC.bed, E116_enhancer.bed, GM12878_gene_enhancer.txt, obesity.SE.bed.

```
cat /your/local/path/original/files
```

```
GENE_POSITION	gene_information
HIC		GM12878_HIC.bed
HMM_ENHANCER	E116_enhancer.bed
GENE_ENHANCER	GM12878_gene_enhancer.txt
SUPER_ENHANCER	obesity.SE.bed
```

# Start caculating

We have made the analyses being able to run on multiple CPUs. Specify the number of threads (1-20) in /your/local/path/original/files which the program will be running on multiple CPUs.
```
Thread 20
```

## Get circuitry
```
sh getcircuit.sh
```
You now get a folder named /your/local/path/result which contains different types of chromatin regulatory circuitry according to the paper.

Please wait until this job finishes.
This step can be long. So, it is recommend to use smaller files to test this software first.

## Caculate

There are three parameters you need to change in /your/local/path/original/files before caculate, which are Disease_Type, LD_threshold and MAF_threshold. For example:

```
LD_threshold	0.5
MAF_threshold	0.05
```
* Briefly, our pipeline makes a model based on allele dosage for each SNP through R, which fits a linear regression model for continuous phenotypes or logistic regression model for categorical phenotypes in the following equation:

```
	Y ~ β+β1*SNP1+β2*SNP2+β3*SNP1×SNP2+e
	For "two copies" of A allele (minor allele) of SNP2 (SNP2=2), the equation is:
	Y ~ (β+2β2)+(β1+2β3)*SNP1+e
	For "one copy" of A allele of SNP2 (SNP2=1), the equation is:
	Y ~ (β+β2)+(β1+β3)*SNP1+e
	For "zero copy" of A allele of SNP2 (SNP2=0), the equation is:
	Y ~ β+β1*SNP1+e
```

* LD_threshold: a number range from 0 to 1, indicates the threshold of r2 of SNP pairs that need to be excluded from this caculation. Default value is 0.5.
* MAF_threshold: a number range from 0 to 0.5, indicates the threshold of MAF of SNPs that need to be caculated. Default value is 0.05.

	* Note: LD, Linkage disequilibrium; MAF, Minor allele frequency.

```
sh iacrc.sh name genotype phenotype
```

* Name: a character of the name of your data. 
* Genotype: the absolute path of the binary genotype data, including .bed .bim .fam, the format can be found [here](http://zzz.bwh.harvard.edu/plink/data.shtml#bed). 
* Phenotype: </br>
When the Disease_Type is `classified` or `continuous`, the phenotype indicates the absolute path of the phenotype data, which contains three columns, Family ID, Individual ID and Phenotype, the format can be found [here](http://zzz.bwh.harvard.edu/plink/data.shtml#pheno).</br>
When the Disease_Type is `classified_cov`, the phenotype indicates the phenotype with covariates and header divided by tab:

	* Note: the `PHENO` in `classified_cov` is 1/0 rather than 2/1 in [phenotype](http://zzz.bwh.harvard.edu/plink/data.shtml#pheno).

```
IID	PHENO	COV1	COV2	COV3	COV4	COV5	COV6	COV7	COV8
4806	0	2	67	0.0184	0.0019	-0.0006	-0.0112	0.0018	0
4807	0	1	67	0.0203	-0.0003	0.0062	0.0053	0.0004	1
4808	1	1	59	0.0222	-0.0078	0.0012	-0.0180	-0.0038	0
4809	1	1	67	0.0169	-0.0027	-0.0099	-0.0146	0.0001	1
4810	0	2	62	0.0116	-0.0061	-0.0180	0.00076	-0.0042	1
```

You now get the results of `IACRC` in /your/local/path/result/name/name.allepi after this step.

Please wait until this job finishes. This step can be long. So, it is recommend to use smaller files to test this software first.
