#sys1:ld file
#sys2:.epistasis
#sys3:.epistasis.nold05
import sys
a=open(sys.argv[1],'rt')
dic={}
for i in a:
	all=i.strip().split()
	snp_snp=all[2]+'_'+all[5]
	snp_snp2=all[5]+'_'+all[2]
	dic[snp_snp]=1
	dic[snp_snp2]=1
a.close()
a=open(sys.argv[2],'rt')
b=open(sys.argv[3],'wt')
for i in a:
	snp=i.strip().split('\t')[0]+'_'+i.strip().split('\t')[1]
	w=dic.get(snp)
	if w==1:
		continue
	else:
		b.write(i)
a.close()
b.close()
