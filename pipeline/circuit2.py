import sys
chr=sys.argv[1]
start=sys.argv[2]
end=sys.argv[3]
gene=sys.argv[4]
genename=sys.argv[5]
a=open(sys.argv[6],'rt')
b=open('../result/circuit2/'+genename+'.circuit2','wt')
n=0
for i in a:
	if i.strip().split('\t')[0]==gene:
		w1=i.strip().split('r')[1].split(':')[0]
		w2=i.strip().split(':')[1].split('-')[0]
		w3=i.strip().split('-')[1]
		n=n+1
		w4='circuit2_'+str(n)
		b.write('\t'.join([w1,w2,w3,w4])+'\n')
a.close()
b.close()
