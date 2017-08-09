import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
n=0
for i in a:
	n=n+1
	b.write(i.rstrip('\n').split('r')[1]+'\t'+'circuit1_'+str(n)+'\n')
a.close()
b.close()
