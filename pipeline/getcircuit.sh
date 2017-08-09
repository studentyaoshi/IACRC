echo You can contact yangtielin@mail.xjtu.edu.cn when you have any questions, suggestions, comments, etc. Please describe in details, and attach your command line and log messages if possible.
echo ''
echo Please change the names in your/local/path/original/files to your local file names first
echo ''

echo Reading in files
gene_position=`grep GENE_POSITION ../original/files|awk -F ' ' '{print$2}'`
hicfile=`grep HIC ../original/files|awk -F ' ' '{print$2}'`
hmm_enhancer=`grep HMM_ENHANCER ../original/files|awk -F ' ' '{print$2}'`
gene_enhancer=`grep GENE_ENHANCER ../original/files|awk -F ' ' '{print$2}'`
super_enhancer=`grep SUPER_ENHANCER ../original/files|awk -F ' ' '{print$2}'`
echo ''

echo Creating files
mkdir ../result
cd ../result
mkdir allcircuit
mkdir circuit1
mkdir circuit2
mkdir circuit3
mkdir gene
mkdir ld
mkdir ../result/circuit1_2
cd ../pipeline
echo ''

echo Get chromatin regulatory circuitry A
echo Please wait ...
echo This step can be long, plz try smaller file first ...
cat ../original/${gene_position}|while read line
do 
	gene=`echo $line|awk '{print$1}'`
	chr=`echo $line|awk '{print$2}'`
	sta=`echo $line|awk '{print$3}'`
	end=`echo $line|awk '{print$4}'`
	genename=${gene}_${chr}_${sta}_${end}
	let stag=$sta-1000
	let endg=$end+1000
	chrn=`echo $chr|awk -F 'r' '{print$2}'`
	echo -e $chrn'\t'$stag'\t'$end'\t'$gene > ../result/gene/$genename

#echo Interaction region aa: enhancer-gene
	python circuit1.py $chr $stag $endg $genename ../original/$hicfile ../result/circuit1/
	bedtools intersect -a ../result/circuit1/$genename -b ../original/$hmm_enhancer > ../result/circuit1/${genename}.hmm
	sort ../result/circuit1/${genename}.hmm|uniq > ../result/circuit1/${genename}.enhancer
	bedtools intersect -a ../result/circuit1/${genename}.enhancer -b ../original/$hmm_enhancer -wo > ../result/circuit1/${genename}.hmm2
	python ../pipeline/change_anno.py ../result/circuit1/${genename}.enhancer ../result/circuit1/${genename}.circuit1
	rm ../result/circuit1/${genename} ../result/circuit1/${genename}.hmm ../result/circuit1/${genename}.enhancer ../result/circuit1/${genename}.hmm2

#echo ======interaction region ba: enhancer-gene======
	python ../pipeline/circuit2.py $chr $stag $endg $gene $genename ../original/$gene_enhancer

#echo ======interaction region ca: enhancer-gene======
	python circuit3.py $chr $sta $end $genename ../original/$super_enhancer

#echo ======combine enhancer-gene aa,ba,ca======
	cat ../result/circuit1/${genename}.circuit1 ../result/circuit2/${genename}.circuit2 ../result/circuit3/${genename}.circuit3 > ../result/allcircuit/${genename}.circuits
done
echo ''

echo Chromatin regulatory circuitry B
echo Please wait ...
echo This step can be long, plz try smaller file first ...
cut -f 1-3 ../original/$hicfile > ../result/circuit1_2/hic.former
cut -f 4-6 ../original/$hicfile > ../result/circuit1_2/hic.later
bedtools intersect -a ../result/circuit1_2/hic.former -b ../original/${hmm_enhancer} -c > ../result/circuit1_2/hic.former.enhancer
bedtools intersect -a ../result/circuit1_2/hic.later -b ../original/${hmm_enhancer} -c > ../result/circuit1_2/hic.later.enhancer
rm ../result/circuit1_2/hic.former ../result/circuit1_2/hic.later
cut -f 4 ../result/circuit1_2/hic.former.enhancer > ../result/circuit1_2/hic.former.enhancer.anno
cut -f 4 ../result/circuit1_2/hic.later.enhancer > ../result/circuit1_2/hic.later.enhancer.anno
rm ../result/circuit1_2/hic.former.enhancer ../result/circuit1_2/hic.later.enhancer
paste ../result/circuit1_2/hic.former.enhancer.anno ../result/circuit1_2/hic.later.enhancer.anno > ../result/circuit1_2/hic.anno
rm ../result/circuit1_2/hic.former.enhancer.anno ../result/circuit1_2/hic.later.enhancer.anno
python getenhancer.py ../result/circuit1_2/hic.anno
rm ../result/circuit1_2/hic.anno
paste ../original/$hicfile ../result/circuit1_2/hic.anno.1 > ../result/circuit1_2/hic.anno.add1
rm ../result/circuit1_2/hic.anno.1
python gethicpair.py ../result/circuit1_2/hic.anno.add1 ../result/circuit1_2/hicpair.enhancer
rm ../result/circuit1_2/hic.anno.add1
mkdir ../result/circuit1_2/hicpair
cat ../result/circuit1_2/hicpair.enhancer|while read line
do
	chr1=`echo "$line"|awk -F'\t' '{print$1}'`
	start1=`echo "$line"|awk -F'\t' '{print$2}'`
	end1=`echo "$line"|awk -F'\t' '{print$3}'`
	chr2=`echo "$line"|awk -F'\t' '{print$4}'`
	start2=`echo "$line"|awk -F'\t' '{print$5}'`
	end2=`echo "$line"|awk -F'\t' '{print$6}'`
	name=${chr1}_${start1}_${end1}_${chr2}_${start2}_${end2}
	echo -e ${chr1}'\t'${start1}'\t'${end1} > ../result/circuit1_2/hicpair/${name}_1
	echo -e ${chr2}'\t'${start2}'\t'${end2} > ../result/circuit1_2/hicpair/${name}_2
	bedtools intersect -a ../result/circuit1_2/hicpair/${name}_1 -b ../original/$hmm_enhancer > ../result/circuit1_2/hicpair/${name}_1.pairs
	bedtools intersect -a ../result/circuit1_2/hicpair/${name}_2 -b ../original/$hmm_enhancer > ../result/circuit1_2/hicpair/${name}_2.pairs
	python changepairs.py ../result/circuit1_2/hicpair/${name}_1.pairs
	python changepairs.py ../result/circuit1_2/hicpair/${name}_2.pairs
	rm ../result/circuit1_2/hicpair/${name}_1 ../result/circuit1_2/hicpair/${name}_2 ../result/circuit1_2/hicpair/${name}_1.pairs ../result/circuit1_2/hicpair/${name}_2.pairs
done
echo ''