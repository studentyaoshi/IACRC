IMR=`grep IMR_threshold ../original/files|awk -F ' ' '{print$2}'`
CR=`grep CR_threshold ../original/files|awk -F ' ' '{print$2}'`
MAF=`grep MAF_threshold ../original/files|awk -F ' ' '{print$2}'`
HWE=`grep HWE_threshold ../original/files|awk -F ' ' '{print$2}'`
LD=`grep LD_threshold ../original/files|awk -F ' ' '{print$2}'`
Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`

cut -f 2 ${2}.bim > ${2}.snp

plink --bfile ${2} --missing --hardy --out ${2}
python purning.py

rm ${2}.log ${2}.hwe ${2}.lmiss ${2}.imiss ${2}.hh ${2}.hardy


row_number=`cat ../result/${1}/${1}.pairs.uniq|wc -l`
let filenumber=${row_number}/${thread_number}+1
split -l ${filenumber} ../result/${1}/${1}.pairs.uniq ../result/${1}/
