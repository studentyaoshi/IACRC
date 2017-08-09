import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[1]+'.change','wt')
x=a.readline().strip().split()
b.write('\t'.join([x[1],x[3],x[4],x[6]])+'\n')
for i in a:
	all=i.strip().split()
	if all[0][0]!='C':
		b.write('\t'.join([all[1],all[3],all[4],all[6]])+'\n')
a.close()
b.close()
