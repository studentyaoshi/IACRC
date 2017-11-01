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
	if float(all[-1]) < float(1-float(sys.argv[5])):
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
hardy={}
for i in a:
	all=i.strip().split()
	snp=all[1]
	if float(all[-1]) > float(sys.argv[9]):
		hardy[snp]='1'
a.close()
a=open(sys.argv[10],'rt')
ld={}
for i in a:
	all=i.strip().split()
	snp1_snp2=all[2]+'_'+all[5]
	snp2_snp1=all[5]+'_'+all[2]
	ld[snp1_snp2]='1'
	ld[snp2_snp1]='1'
a.close()
a=open(sys.argv[11],'rt')
exon={}
for i in a:
	snp=i.rstrip('\n')
	exon[snp]='1'
a.close()
a=open(sys.argv[12],'rt')
b=open(sys.argv[13],'wt')
for i in a:
	snp1,snp2=i.strip().split(',')
	snp1_snp2=snp1+'_'+snp2
	if cr.get(snp1)=='1' and cr.get(snp2)=='1' and maf.get(snp1)='1' and maf.get(snp2)='1' and hardy.get(snp1)='1' and hardy.get(snp2)='1' and ld.get(snp1_snp2)!='1' and exon.get(snp1)!='1' and exon.get(snp2)!='1':
		b.write(i)
a.close()
b.close()
