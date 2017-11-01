Numbers=(ZERO a b c d e f g h i j k l m n o p q r s t)
python=`grep Python_path ../original/files|awk -F ' ' '{print$2}'`
thread_number=`grep Thread ../original/files|awk -F ' ' '{print$2}'`

for ((i=1; i<=thread_number; i++))
do cat ../result/${1}/${1}.pairs.${Numbers[$i]} ../result/${1}/${1}.pairs.hic.${Numbers[$i]} >> ../result/${1}/${1}.pairs
done

$python pairs_sort.py ../result/${1}/${1}.pairs ../result/${1}/${1}.pairs.sort

sort ../result/${1}/${1}.pairs.sort|uniq > ../result/${1}/${1}.pairs.uniq

# row_number=`cat ../result/${1}/${1}.pairs.uniq|wc -l`
# let filenumber=${row_number}/${thread_number}+1
# split -l ${filenumber} ../result/${1}/${1}.pairs.uniq ../result/${1}/
