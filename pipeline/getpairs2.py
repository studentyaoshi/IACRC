import sys
a=open(sys.argv[1],'rt')
b=[]
for i in a:
	snp=i.rstrip('\n')
	b.append(snp)
	c=open(sys.argv[1],'rt')
	for w in c:
		snp2=w.rstrip('\n')
		if snp2 not in b:
			print snp+'\t'+snp2
	c.close()
a.close()
