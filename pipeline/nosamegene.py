import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
for i in a:
	snp1,snp2=i.strip().split(',')
	if snp1[0]=='r' and snp2[0]=='r' and snp1!=snp2:
		b.write(i)
a.close()
b.close()
