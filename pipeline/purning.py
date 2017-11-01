import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
a.readline()
for i in a:
	all=i.strip().split()
	if float(all[-1]) < float(sys.argv[3]):
		b.write(all[0]+'\t'+all[1]+'\n')
a.close()
b.close()
a=open(sys.argv[4],'rt')
a.readline()
cr={}
for i in a:
	all=i.strip().split()
	snp=all[1]
	if float(all[-1]) < float(sys.argv[5]):
		cr[snp]='1'
a.close()
a=open(sys.argv[6],'rt')
a.readline()
maf={}
for i in a:
	all=i.strip().split()
	if float(all[-2]) > float(sys.argv[7]):
		maf[snp]='1'
a.close()
a=open(sys.argv[8],'rt')
