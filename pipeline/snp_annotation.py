import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
for i in a:
	all=i.strip().split('\t')
	b.write(all[0]+'\t'+all[3]+'\t'+all[3]+'\t'+all[4]+'\t'+all[5]+'\t'+all[1]+'\n')
a.close()
b.close()
