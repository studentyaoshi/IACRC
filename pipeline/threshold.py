import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[1]+sys.argv[2],'wt')
b.write(a.readline())
for i in a:
	pp=float(sys.argv[2])#*100
	try:
		p=float(i.strip().split('\t')[-1])
		if p<=pp:
			b.write(i)
	except:
		n=0
a.close()
b.close()
