import sys
chr=sys.argv[1]
start=int(sys.argv[2])
end=int(sys.argv[3])
gene=sys.argv[4]
a=open(sys.argv[5],'rt')
b=open(sys.argv[6]+sys.argv[4],'wt')
for i in a:
	all=i.strip().split('\t')
	if chr==all[0] and int(start)>=int(all[1]) and int(start)<=int(all[2]):
		b.write('\t'.join([all[3],all[4],all[5]])+'\n')
	if chr==all[0] and int(end)>=int(all[1]) and int(end)<=int(all[2]):
		b.write('\t'.join([all[3],all[4],all[5]])+'\n')
	if chr==all[3] and int(start)>=int(all[4]) and int(start)<=int(all[5]):
		b.write('\t'.join([all[0],all[1],all[2]])+'\n')
	if chr==all[3] and int(end)>=int(all[4]) and int(end)<=int(all[5]):
		b.write('\t'.join([all[0],all[1],all[2]])+'\n')
a.close()
b.close()
