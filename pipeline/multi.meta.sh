cat $1|while read line 
do 
	OLD_IFS="$IFS"
	IFS=","
	arr=($line)
	IFS="$OLD_IFS"
	n=''
	for s in ${arr[@]}
	do 
		n=$n'_'$s
	done
	n=`echo "$n"|cut -d '_' -f 2-`
	echo 'MARKER	SNP' > metal.txt
	echo 'ALLELE	A1	A2' >> metal.txt
	echo 'PVAL	P' >> metal.txt
	echo 'EFFECT	BETA' >> metal.txt
	echo 'WEIGHT	N' >> metal.txt
	for s in ${arr[@]}
	do
		echo 'PROCESS	../result/'$s'/'$s'.metal01' >> metal.txt
	done
	echo 'OUTFILE	../result/'$n'_ .tbl' >> metal.txt
	echo 'ANALYZE' >> metal.txt
	metal metal.txt
	rm ../result/${n}_1.tbl.info
	awk '$6<5e-6{print$0}' ../result/${n}_1.tbl > ../result/${n}_1.tbl.5e-6
	cat ../result/${n}_1.tbl.5e-6 >> allmeta.5e-6
done
