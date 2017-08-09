a=open('/home/ys/lib/project/snp_interaction/BMI/weak_ld/circuits/protein.coding.gene.position_noXYM','rt')
gene=[]
for i in a:
	gene.append(i.strip().split('\t')[0])
a.close()
dele=[]
a=open('/home/ys/lib/project/snp_interaction/BMI/weak_ld/circuits/protein.coding.gene.position_noXYM.not1','rt')
for i in a:
	dele.append(i.rstrip('\n'))
a.close()
a=open('gene_enhancer_used.txt','rt')
b=open('gene_enhancer_used_nodup.txt','wt')
for i in a:
	ge=i.strip().split('\t')[0]
	if ge in gene and ge not in dele:
		b.write(i)
a.close()
b.close()
