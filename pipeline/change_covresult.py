import sys
a=open(sys.argv[1],'rt')
b=open(sys.argv[2],'wt')
b.write('SNP1\tSNP2\tOR_INT\tP\n')
for i in a:
	b.write(i.replace('_','\t').replace(' ','\t'))
a.close()
b.close()
