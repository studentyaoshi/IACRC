import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[1]+'.change','wt')
n=0
for i in a:
	n=n+1
	b.write(i.strip().split('r')[1]+'\t'+str(n)+'\n')
a.close()
b.close()
