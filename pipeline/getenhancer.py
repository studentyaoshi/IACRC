import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[1]+'.1','wt')
for i in a:
	a1,a2=i.strip().split('\t')
	if a1!='0' and a2!='0':
		b.write('1\n')
	else:
		b.write('0\n')
a.close()
b.close()
