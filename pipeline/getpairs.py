import sys
a=open(sys.argv[1],'rt')
for i in a:
	snp1=i.rstrip('\n')
	b=open(sys.argv[2],'rt')
	for w in b:
		snp2=w.rstrip('\n')
		print snp1+'\t'+snp2
	b.close()
a.close()
