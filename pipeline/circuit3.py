import sys
chr=sys.argv[1]
start=sys.argv[2]
end=sys.argv[3]
genename=sys.argv[4]
startall=int(start)-100000
endall=int(end)+100000
a=open(sys.argv[5],'rt')
b=open('../result/circuit3/'+genename+'.circuit3','wt')
n=0
for i in a:
	all=i.strip().split('\t')
	chrsup=all[0]
	startsup=all[1]
	endsup=all[2]
	if chr==chrsup and int(startsup)>=int(startall) and int(startsup)<=int(endall):
		n=n+1
		b.write('\t'.join([all[0].split('r')[1],all[1],all[2],'circuit3_'+str(n)])+'\n')
	if chr==chrsup and int(endsup)>=int(startall) and int(endsup)<=int(endall):
		n=n+1
		b.write('\t'.join([all[0].split('r')[1],all[1],all[2],'circuit3_'+str(n)])+'\n')
a.close()
b.close()
