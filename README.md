# Interaction Analyses within Chromatin Regulatory Circuitry (IACRC)

# Introduction

Genome-wide association studies (GWASs) is an effective strategy to identify susceptibility loci for human complex diseases. However, missing heritability is still a big problem. Here we developed a pipeline named interaction analyses within chromatin regulatory circuitry (IACRC), to identify genetic variants impacting complex traits. IACRC would automatically selected chromatin regulatory circuits regions with Hi-C datasets, enhancer data, and super enhancer regions. SNP × SNP interaction analyses were then performed in regions within chromatin regulatory circuits.

# License

This software is distributed under the terms of GPL 2.0

# Source

https://github.com/studentyaoshi/IACRC

# Contact

You can contact yangtielin@mail.xjtu.edu.cn when you have any questions, suggestions, comments, etc. Please describe in details, and attach your command line and log messages if possible.

# Requiremnets

PLINK, https://www.cog-genomics.org/plink2; Python2.7, https://www.python.org/downloads/; Bedtools, http://bedtools.readthedocs.io/en/latest/content/installation.html; and METAL if you would like to do meta analysis, http://csg.sph.umich.edu/abecasis/metal/download/.

# Preparation

### Setup floder framework

```
cd /your/local/path/pipeline
```

### Prepare original files
There are five original files you need to prepare before starting calculation, according to the disease you are studing. These files including gene information, Hi-C pairs, enhancer annotation, gene-enhancer information and gene-super enhancer information. The description and data format are as follows.

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

##### Gene information

Gene information contains four columns divided by tab including the gene name, chromosome, the start and end position of gene without header:

```
OR4F5		chr1	69091	70008
AL627309.1	chr1	134901	139379
OR4F29		chr1	367640	368634
OR4F16		chr1	621059	622053
AL669831.1	chr1	738532	739137
...
```

##### Hi-C pairs

Hi-C pairs contains six columns divided by tab including the chromosome, the start position and the end position of the two regions without  header:

```
chr1	1050000	1060000	chr1	1180000	1190000
chr1	1585000	1590000	chr1	1645000	1650000
chr1	1710000	1715000	chr1	1835000	1840000
chr1	2120000	2130000	chr1	2310000	2320000
chr1	2130000	2135000	chr1	2515000	2520000
...
```

##### Enhancer annotation

Enhancer annotation is .bed file contains the chromatin states downloaded from Roadmap, http://egg2.wustl.edu/roadmap/data/byFileType/chromhmmSegmentations/ChmmModels/coreMarks/jointModel/final/. The format of .bed can be found here http://www.ensembl.org/info/website/upload/bed.html.

In our paper, we used the chromatin states of GM12878 and '7_Enh' annotation in the forth column as input.

```
chr10	174200	174400	7_Enh	0	.	174200	174400	255,255,0
chr10	175600	176000	7_Enh	0	.	175600	176000	255,255,0
chr10	187400	188400	7_Enh	0	.	187400	188400	255,255,0
chr10	228600	229000	7_Enh	0	.	228600	229000	255,255,0
chr10	264600	265200	7_Enh	0	.	264600	265200	255,255,0
...
```

##### Gene-enhancer
Gene-enhancer contains two columns divided by tab including the gene name and the enhancer region downloaded from http://genetics.case.edu/prestige which including gene-enhancer information in 13 cell lines.

```
SLC25A28	chr10:101314742-101317123
SLC25A28	chr10:101359480-101360496
SLC25A28	chr10:101375165-101375877
SLC25A28	chr10:101387579-101391927
COX15		chr10:101409861-101410384
...
```

##### Gene-super enhancer
Gene-super enhancer contains three columns divided by tab including chromsome, the start and the end position of the super enhancer.

```
chr1	68148186	68237688
chr2	37850717	37940881
chr3	16099720	16182650
chr4	7804602		7914384
chr5	172284905	172383585
...
```

# Start caculating

### Get circuitry
```
sh getcircuit.sh
```
You now get a folder named /your/local/path/result which contains different types of chromatin regulatory circuitry according to the paper.

Please wait until this job finishes.
This step can be long. So, it is recommend to use smaller files to test this software first.

### Caculate

There are three parameters you need to change in /your/local/path/original/files before caculate, which are Disease_Type, LD_threshold and MAF_threshold. For example:

```
Disease_Type	continuous
LD_threshold	0.5
MAF_threshold	0.05
```

Disease_Type: 'classified', indicates the disease you are studing is case/control test; 'continuous', indicates the disease you are studing is quantitative trait. Default value is 'continuous'.

LD_threshold: a number range from 0 to 1, indicates the threshold of r2 of SNP pairs that exclude this caculation. Default value is 0.5.

MAF_threshold: a number range from 0 to 0.5, indicates the threshold of MAF of SNPs. Default value is 0.05.

Note: LD, Linkage disequilibrium; MAF, Minor allele frequency.

```
sh iacrc.sh name genotype phenotype
```

Name: a character of the name of your data. </br>
Genotype: the absolute path of your binary genotype data, including .bed .bim .fam (http://zzz.bwh.harvard.edu/plink/data.shtml#bed). -></br>
Phenotype: the absolute path of your phenotype, which contains three columns, Family ID, Individual ID and Phenotype (http://zzz.bwh.harvard.edu/plink/data.shtml#pheno).

You now get the results of IACRC in /your/local/path/result/name/name.allepi

Please wait until this job finishes. This step can be long. So, it is recommend to use smaller files to test this software first.
