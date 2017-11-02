IMR=`grep IMR_threshold ../original/files|awk -F ' ' '{print$2}'`
CR=`grep CR_threshold ../original/files|awk -F ' ' '{print$2}'`
MAF=`grep MAF_threshold ../original/files|awk -F ' ' '{print$2}'`
HWE=`grep HWE_threshold ../original/files|awk -F ' ' '{print$2}'`
LD=`grep LD_threshold ../original/files|awk -F ' ' '{print$2}'`
Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`

R=`grep R_path ../original/files|awk -F ' ' '{print$2}'`
python=`grep Python_path ../original/files|awk -F ' ' '{print$2}'`
bedtools=`grep Bedtools_path ../original/files|awk -F ' ' '{print$2}'`
plink=`grep Plink_path ../original/files|awk -F ' ' '{print$2}'`
perl=`grep Perl_path ../original/files|awk -F ' ' '{print$2}'`
annovar=`grep Annovar_path ../original/files|awk -F ' ' '{print$2}'`

$python snp_annotation.py ${2}.bim ${2}.anno.tem
cat ../original/anno.xaa ../original/anno.xab ../original/anno.xac ../original/anno.xad ../original/anno.xae ../original/anno.xaf > ../original/hg19_wgEncodeGencodeBasicV19Mrna.fa
rm ../original/anno.xaa ../original/anno.xab ../original/anno.xac ../original/anno.xad ../original/anno.xae ../original/anno.xaf
$perl ${annovar}/table_annovar.pl ${2}.anno.tem ../original/ -buildver hg19 -out ${2}.ex.out -protocol wgEncodeGencodeBasicV19 -operation g
$python nosamegene.py ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function ../result/${1}/${1}.pairs.uniq ../result/${1}/${1}.pairs.nos
grep exonic ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function |cut -f 8 > ${2}.exon.snp
$plink --bfile ${2} --freq --missing --hardy --out ${2} 
grep ALL ${2}.hwe >${2}.hardy
$plink --bfile ${2} --r2 --ld-window-kb 1000 --ld-window 99999 --ld-window-r2 ${LD} --out ${2}

$python purning.py ${2}.imiss ${2}.keep.fam ${IMR} ${2}.lmiss ${CR} ${2}.frq ${MAF} ${2}.hardy ${HWE} ${2}.ld ${2}.exon.snp ../result/${1}/${1}.pairs.nos ../result/${1}/${1}.pairs.purning

$plink --bfile ${2} --keep ${2}.keep.fam --make-bed --out ${2}.keep

rm ${2}.log ${2}.frq ${2}.hwe ${2}.lmiss ${2}.imiss ${2}.hh ${2}.exon.snp ${2}.keep.fam ${2}.hardy ${2}.exon.snp
rm ${2}.anno.tem ${2}.ex.out.wgEncodeGencodeBasicV19.exonic_variant_function ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function ${2}.ex.out.wgEncodeGencodeBasicV19.log ${2}.ex.out.hg19_multianno.txt

row_number=`cat ../result/${1}/${1}.pairs.purning|wc -l`
let filenumber=${row_number}/${thread_number}+1
split -l ${filenumber} ../result/${1}/${1}.pairs.purning ../result/${1}/
