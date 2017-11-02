import sys
a=open(sys.argv[2],'rt')
dic={}
all=a.readline().strip().split(' ')
dic[all[1]]='snp1\tsnp2'
for i in a:
	all=i.strip().split(' ')
	dic[all[1]]=all[6]+'\t'+all[7]
a.close()
a=open(sys.argv[1],'rt')
b=open(sys.argv[3],'wt')
for i in a:
	all=i.strip().split('\t')
	try:
		b.write(i.rstrip('\n')+'\t'+dic.get(all[0])+'\n')
	except:
		n=0
a.close()
b.close()
