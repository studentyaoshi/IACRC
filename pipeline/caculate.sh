Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`

echo Start caculating
echo Please wait ...
echo This step can be long, plz try smaller file first ...

for ((i=1; i<=thread_number; i++))
do cat ../result/$1/a${Numbers[$i]}|while read line
do 
	plink -bfile ${2} --snps $line --recodeA --out ../result/${1}/cov/$line
	rm ../result/${1}/cov/${line}.log
	python changeraw.py ${3} ../result/${1}/cov/${line}.raw ../result/${1}/cov/${line}.recode
	covs=`head -1 ${3}|cut -f 3-|sed 's/\t/+/g'`
	Rscript epistasis.R ${line} ../result/${1}/cov/${line}.recode ../result/${1}/result/${line}.result $covs
	rm ../result/${1}/cov/${line}.raw ../result/${1}/cov/${line}.recode
	snp1=`echo "$line"|awk -F, '{print$1}'`
	snp2=`echo "$line"|awk -F, '{print$2}'`
	echo -n ${snp1}_${snp2} >> ../result/${1}/${1}.all.result.${Numbers[$i]}
	echo -n ' ' >> ../result/${1}/${1}.all.result.${Numbers[$i]}
	echo -n `grep "snp1:snp2" ../result/${1}/result/${line}.result|cut -d ' ' -f 2` >> ../result/${1}/${1}.all.result.${Numbers[$i]}
	echo '' >> ../result/${1}/${1}.all.result.${Numbers[$i]}
done &
done
