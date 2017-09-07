echo You can contact yangtielin@mail.xjtu.edu.cn when you have any questions, suggestions, comments, etc. Please describe in details, and attach your command line and log messages if possible.
echo Usage: sh caculate.sh name genotype phenotype
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
echo ''

echo Start caculating interaction within chromatin regulatory circuitry A
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

###   creat set files: enhancer & gene (aa, ba, ca)  ###
	plink --bfile ${2} --maf ${maf} --extract range ../result/gene/$genename --make-bed --out ../result/${1}/gene/$genename
	cut -f 2 ../result/${1}/gene/${genename}.bim > ../result/${1}/gene/${genename}.genesnp
	rm ../result/${1}/gene/${genename}.log ../result/${1}/gene/${genename}.bim ../result/${1}/gene/${genename}.fam ../result/${1}/gene/${genename}.bed
	plink --bfile ${2} --maf ${maf} --extract range ../result/allcircuit/${genename}.circuits --make-bed --out ../result/${1}/allcircuits/${genename}.circuits
	cut -f 2 ../result/${1}/allcircuits/${genename}.circuits.bim > ../result/${1}/allcircuits/${genename}.circuitssnp
	rm ../result/${1}/allcircuits/${genename}.circuits.log ../result/${1}/allcircuits/${genename}.circuits.bim ../result/${1}/allcircuits/${genename}.circuits.bed ../result/${1}/allcircuits/${genename}.circuits.fam
	echo 'GENE' >> ../result/${1}/setfile/${genename}.set
	cat ../result/${1}/gene/${genename}.genesnp >> ../result/${1}/setfile/${genename}.set
	echo 'END' >> ../result/${1}/setfile/${genename}.set
	echo '' >> ../result/${1}/setfile/${genename}.set
	echo 'CIRCUITS' >> ../result/${1}/setfile/${genename}.set
	cat ../result/${1}/allcircuits/${genename}.circuitssnp >> ../result/${1}/setfile/${genename}.set
	echo 'END' >> ../result/${1}/setfile/${genename}.set

###   caculate enhancer & gene   ###
	plink --bfile ${2} --maf ${maf} --pheno ${3} --epistasis --set-test --set ../result/${1}/setfile/${genename}.set --epi1 1 --out ../result/${1}/result/${genename}

###   caculate enhancer-enhancer (ab, bb, cb)  ###
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit1/${genename}.circuit1 --pheno ${3} --epistasis --epi1 1 --out ../result/${1}/result/${genename}.ee1
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit2/${genename}.circuit2 --pheno ${3} --epistasis --epi1 1 --out ../result/${1}/result/${genename}.ee2
	plink --bfile ${2} --maf ${maf} --extract range ../result/circuit3/${genename}.circuit3 --pheno ${3} --epistasis --epi1 1 --out ../result/${1}/result/${genename}.ee3
	rm ../result/${1}/result/${genename}.ee3.log ../result/${1}/result/${genename}.ee2.log ../result/${1}/result/${genename}.ee1.log ../result/${1}/result/${genename}.log ../result/${1}/result/${genename}.epi.cc.summary ../result/${1}/result/${genename}.ee1.epi.cc.summary ../result/${1}/result/${genename}.ee2.epi.cc.summary ../result/${1}/result/${genename}.ee3.epi.cc.summary
done &
done

echo Start caculating interaction within chromatin regulatory circuitry B
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
		echo 'GENE' >> ../result/${1}/ee/${name}.set
		cat ../result/${1}/ee/${name}.1snp >> ../result/${1}/ee/${name}.set
		echo 'END' >> ../result/${1}/ee/${name}.set
		echo '' >> ../result/${1}/ee/${name}.set
		echo 'CIRCUITS' >> ../result/${1}/ee/${name}.set
		cat ../result/${1}/ee/${name}.2snp >> ../result/${1}/ee/${name}.set
		echo 'END' >> ../result/${1}/ee/${name}.set
		rm ../result/${1}/ee/${name}.1snp ../result/${1}/ee/${name}.2snp ../result/${1}/ee/${name}_1.* ../result/${1}/ee/${name}_2.*
	else
		echo no
		rm ../result/${1}/ee/${name}.1snp ../result/${1}/ee/${name}.2snp ../result/${1}/ee/${name}_1.* ../result/${1}/ee/${name}_2.*
	fi
done &
done

ls ../result/${1}/ee|while read line
do 
	name=`echo $line|awk -F'.' '{print$1}'`
	plink --bfile ${2} --maf ${maf} --pheno ${3} --epistasis --set-test --set ../result/${1}/ee/$line --epi1 1 --out ../result/${1}/result/${name}.ee
	rm ../result/${1}/result/${name}.ee.log ../result/${1}/result/${name}.ee.epi.cc.summary
done

echo get result
sh getresult_cla.sh ${1} ${2} 
