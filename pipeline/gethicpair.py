import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
for i in a:
	all=i.strip().split('\t')
	if all[-1]=='1':
		b.write('\t'.join([all[0],all[1],all[2],all[3],all[4],all[5]])+'\n')
a.close()
b.close()
