echo You can contact yangtielin@mail.xjtu.edu.cn when you have any questions, suggestions, comments, etc. Please describe in details, and attach your command line and log messages if possible.
echo ''
echo Reading in files in
gene_position=`grep GENE_POSITION ../original/files|awk -F ' ' '{print$2}'`
maf=`grep MAF_threshold ../original/files|awk -F ' ' '{print$2}'`
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`
echo ''

echo Creating files
mkdir ../result/${1}
mkdir ../result/${1}/gene
mkdir ../result/${1}/allcircuits
mkdir ../result/${1}/setfile
mkdir ../result/${1}/result
mkdir ../result/${1}/ee
mkdir ../result/${1}/cov
echo ''

echo Start getting interaction within chromatin regulatory circuitry A
echo Please wait ...
echo This step can be long, plz try smaller file first ...

for ((i=1; i<=thread_number; i++))
do cat ../original/a${Numbers[$i]}|while read line
do
	gene=`echo $line|awk '{print$1}'`
	chr=`echo $line|awk '{print$2}'`
	sta=`echo $line|awk '{print$3}'`
	end=`echo $line|awk '{print$4}'`
	genename=${gene}_${chr}_${sta}_${end}
	let stag=$sta-1000
	let endg=$end+1000
	plink --bfile ${2} --maf ${maf} --extract range ../result/gene/$genename --make-bed --out ../result/${1}/gene/$genename
	cut -f 2 ../result/${1}/gene/${genename}.bim > ../result/${1}/gene/${genename}.genesnp
	rm ../result/${1}/gene/${genename}.log ../result/${1}/gene/${genename}.bim ../result/${1}/gene/${genename}.fam ../result/${1}/gene/${genename}.bed
	plink --bfile ${2} --maf ${maf} --extract range ../result/allcircuit/${genename}.circuits --make-bed --out ../result/${1}/allcircuits/${genename}.circuits
	cut -f 2 ../result/${1}/allcircuits/${genename}.circuits.bim > ../result/${1}/allcircuits/${genename}.circuitssnp
	rm ../result/${1}/allcircuits/${genename}.circuits.log ../result/${1}/allcircuits/${genename}.circuits.bim ../result/${1}/allcircuits/${genename}.circuits.bed ../result/${1}/allcircuits/${genename}.circuits.fam
	if [ -s ../result/${1}/gene/${genename}.genesnp ] && [ -s ../result/${1}/allcircuits/${genename}.circuitssnp ]
	then
		python getpairs.py ../result/${1}/gene/${genename}.genesnp ../result/${1}/allcircuits/${genename}.circuitssnp >> ../result/${1}/${1}.pairs.${Numbers[$i]}
	else
		echo no
	fi
	
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit1/${genename}.circuit1 --make-bed --out ../result/${1}/allcircuits/${genename}.circuits1
	cut -f 2 ../result/${1}/allcircuits/${genename}.circuits1.bim > ../result/${1}/allcircuits/${genename}.circuitssnp1
	rm ../result/${1}/allcircuits/${genename}.circuits1.log ../result/${1}/allcircuits/${genename}.circuits1.bim ../result/${1}/allcircuits/${genename}.circuits1.bed ../result/${1}/allcircuits/${genename}.circuits1.fam
	python getpairs2.py ../result/${1}/allcircuits/${genename}.circuitssnp1 >> ../result/${1}/${1}.pairs.${Numbers[$i]}

	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit2/${genename}.circuit2 --make-bed --out ../result/${1}/allcircuits/${genename}.circuits2
	cut -f 2 ../result/${1}/allcircuits/${genename}.circuits2.bim > ../result/${1}/allcircuits/${genename}.circuitssnp2
	rm ../result/${1}/allcircuits/${genename}.circuits2.log ../result/${1}/allcircuits/${genename}.circuits2.bim ../result/${1}/allcircuits/${genename}.circuits2.bed ../result/${1}/allcircuits/${genename}.circuits2.fam
	python getpairs2.py ../result/${1}/allcircuits/${genename}.circuitssnp2 >> ../result/${1}/${1}.pairs.${Numbers[$i]}

	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit3/${genename}.circuit3 --make-bed --out ../result/${1}/allcircuits/${genename}.circuits3
	cut -f 2 ../result/${1}/allcircuits/${genename}.circuits3.bim > ../result/${1}/allcircuits/${genename}.circuitssnp3
	rm ../result/${1}/allcircuits/${genename}.circuits3.log ../result/${1}/allcircuits/${genename}.circuits3.bim ../result/${1}/allcircuits/${genename}.circuits3.bed ../result/${1}/allcircuits/${genename}.circuits3.fam
	python getpairs2.py ../result/${1}/allcircuits/${genename}.circuitssnp3 >> ../result/${1}/${1}.pairs.${Numbers[$i]}
done &
done

echo Start getting interaction within chromatin regulatory circuitry B
echo Please wait ...
echo This step can be long, plz try smaller file first ...

echo ‘’

for ((i=1; i<=thread_number; i++))
do cat ../result/circuit1_2/a${Numbers[$i]}|while read line
do
	chr1=`echo "$line"|awk -F'\t' '{print$1}'`
	start1=`echo "$line"|awk -F'\t' '{print$2}'`
	end1=`echo "$line"|awk -F'\t' '{print$3}'`
	chr2=`echo "$line"|awk -F'\t' '{print$4}'`
	start2=`echo "$line"|awk -F'\t' '{print$5}'`
	end2=`echo "$line"|awk -F'\t' '{print$6}'`
	name=${chr1}_${start1}_${end1}_${chr2}_${start2}_${end2}
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit1_2/hicpair/${name}_1.pairs.change --make-bed --out ../result/${1}/ee/${name}_1
	cut -f 2 ../result/${1}/ee/${name}_1.bim > ../result/${1}/ee/${name}.1snp
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit1_2/hicpair/${name}_2.pairs.change --make-bed --out ../result/${1}/ee/${name}_2
	cut -f 2 ../result/${1}/ee/${name}_2.bim > ../result/${1}/ee/${name}.2snp
	if [ -s ../result/${1}/ee/${name}.1snp ] && [ -s ../result/${1}/ee/${name}.2snp ]
	then
		python getpairs.py ../result/${1}/ee/${name}.1snp ../result/${1}/ee/${name}.2snp >> ../result/${1}/${1}.pairs.${Numbers[$i]}
		rm ../result/${1}/ee/${name}.1snp ../result/${1}/ee/${name}.2snp ../result/${1}/ee/${name}_1.* ../result/${1}/ee/${name}_2.*
	else
		rm ../result/${1}/ee/${name}.1snp ../result/${1}/ee/${name}.2snp ../result/${1}/ee/${name}_1.* ../result/${1}/ee/${name}_2.*
	fi
done &
done

for ((i=1; i<=thread_number; i++))
do cat ../result/${1}/${1}.pairs.${Numbers[$i]} >> ../result/${1}/${1}.pairs
done

sort ../result/${1}/${1}.pairs|uniq > ../result/${1}/${1}.pairs.uniq

echo Start caculating
echo Please wait ...
echo This step can be long, plz try smaller file first ...

row_number=`cat ../result/${1}/${1}.pairs.uniq|wc -l`
let filenumber=${row_number}/${thread_number}+1
split -l ${filenumber} ../result/${1}/${1}.pairs.uniq ../result/${1}/
for ((i=1; i<=thread_number; i++))
do cat ../result/${1}/a${Numbers[$i]}|while read line
do 
	plink -bfile ${2} --snps $line --recodeA --out ../result/${1}/cov/$line
	rm ../result/${1}/cov/${line}.log
	python changeraw.py ${3} ../result/${1}/cov/${line}.raw ../result/${1}/cov/${line}.recode
	covs=`head -1 46149_cov_01pheno.txt|cut -f 3-|sed 's/\t/+/g'`
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

for ((i=1; i<=thread_number; i++))
do cat ../result/${1}/${1}.all.result.${Numbers[$i]} >> ../result/${1}/${1}.all.result
done

python change_covresult.py ../result/${1}/${1}.all.result ../result/${1}/${1}.allepi.change
rm ../result/${1}/${1}.all.result
plink --noweb --bfile ${2} --r2 --ld-window-kb 1000 --ld-window 99999 --ld-window-r2 ${ld} --out ../result/ld/${1}
python nold05.py ../result/ld/${1}.ld ../result/${1}/${1}.allepi.change ../result/${1}/${1}.allepi.change.nold05
rm ../result/${1}/${1}.allepi.change
sort -r ../result/${1}/${1}.allepi.change.nold05|uniq> ../result/${1}/${1}.allepi.uniq
rm ../result/${1}/${1}.allepi.change.nold05
mv ../result/${1}/${1}.allepi.uniq ../result/${1}/${1}.allepi
