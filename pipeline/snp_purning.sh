IMR=`grep IMR_threshold ../original/files|awk -F ' ' '{print$2}'`
CR=`grep CR_threshold ../original/files|awk -F ' ' '{print$2}'`
MAF=`grep MAF_threshold ../original/files|awk -F ' ' '{print$2}'`
HWE=`grep HWE_threshold ../original/files|awk -F ' ' '{print$2}'`
LD=`grep LD_threshold ../original/files|awk -F ' ' '{print$2}'`
Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`

cut -f 2 ${2}.bim > ${2}.snp
python snp_annotation.py ${2}.bim ${2}.anno.tem
cat ../original/anno.xaa ../original/anno.xab ../original/anno.xac ../original/anno.xad ../original/anno.xae ../original/anno.xaf > ../original/hg19_wgEncodeGencodeBasicV19Mrna.fa
rm ../original/anno.xaa ../original/anno.xab ../original/anno.xac ../original/anno.xad ../original/anno.xae ../original/anno.xaf
perl table_annovar.pl ${2}.anno.tem ../original/ -buildver hg19 -out ${2}.ex.out -protocol wgEncodeGencodeBasicV19 -operation g
python nosamegene.py ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function ../result/${1}/${1}.pairs.uniq ../result/${1}/${1}.pairs.nos
grep exonic ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function |cut -f 8 > ${2}.exon.snp

plink --bfile ${2} --missing --hardy --out ${2}
python purning.py

rm ${2}.log ${2}.hwe ${2}.lmiss ${2}.imiss ${2}.hh ${2}.hardy
rm ${2}.anno.tem ${2}.ex.out.wgEncodeGencodeBasicV19.exonic_variant_function ${2}.ex.out.wgEncodeGencodeBasicV19.variant_function ${2}.ex.out.wgEncodeGencodeBasicV19.log ${2}.ex.out.hg19_multianno.txt

row_number=`cat ../result/${1}/${1}.pairs.uniq|wc -l`
let filenumber=${row_number}/${thread_number}+1
split -l ${filenumber} ../result/${1}/${1}.pairs.uniq ../result/${1}/
