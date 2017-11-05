import sys
a=open(sys.argv[1],'rt')
dic={}
for i in a:
	all=i.strip().split('\t')
	snp=all[-1]
	gene=all[1]
	if len(gene.split(','))==1:
		dic[snp]=gene
	else:
		dic[snp]='1'
a.close()
a=open(sys.argv[2],'rt')
b=open(sys.argv[3],'wt')
a.readline()
for i in a:
	snp1,snp2=i.strip().split(',')
#	if dic.get(snp1)==dic.get(snp2) and dic.get(snp1)!='1':
#		n=0
	if snp1[0]=='r' and snp2[0]=='r' and snp1!=snp2:
		b.write(i)
a.close()
b.close()
