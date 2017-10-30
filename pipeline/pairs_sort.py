import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
for i in a:
	l=[]
	snp1,snp2=i.strip().split(',')
	l.append(snp1)
	l.append(snp2)
	sort=l.sort()
	b.write(sort[0]+','+sort[1]+'\n')
a.close()
b.close()
