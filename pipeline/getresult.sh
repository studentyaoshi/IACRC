Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)

thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`
ld=`grep LD_threshold ../original/files|awk -F ' ' '{print$2}'`


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

#number=`cat ${3}|wc -l`
#python ../pipeline/for_metal.py /home/ys/lib/project/snp_interaction/BMI/genotype/allbim.frq /home/ys/lib/project/snp_interaction/BMI/genotype/${1}/${1}.frq ../result/${1}/${1} $number
