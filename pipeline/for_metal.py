#python for_metal.py name name.allepi.uniq number
import sys
a=open(sys.argv[1],'rt')
dic={}
for i in a:
	all=i.strip().split()
	snp=all[1]
	alle=all[2]
	dic[snp]=alle
a.close()
a=open(sys.argv[2],'rt')
dic2={}
for i in a:
	all=i.strip().split()
	snp=all[1]
	alle=all[2]
	dic2[snp]=alle
a.close()
a=open(sys.argv[3]+'.allepi.uniq','rt')
b=open(sys.argv[3]+'.metal','wt')
b.write('SNP\tA1\tA2\tP\tBETA\tN\n')
a.readline()
for i in a:
	s1,s2,beta,p=i.strip().split('\t')
	if dic2.get(s1)==dic.get(s1) and dic2.get(s2)==dic.get(s2):
		b.write(s1+'_'+s2+'\tA\tT\t'+p+'\t'+beta+'\t'+sys.argv[4]+'\n')
	elif dic2.get(s1)!=dic.get(s1) and dic2.get(s2)!=dic.get(s2):
		b.write(s1+'_'+s2+'\tA\tT\t'+p+'\t'+beta+'\t'+sys.argv[4]+'\n')
	else:
		b.write(s1+'_'+s2+'\tT\tA\t'+p+'\t'+beta+'\t'+sys.argv[4]+'\n')
a.close()
b.close()
