args = commandArgs(TRUE)
filename1 = args[2]
twosnp = args[1]
snps <- strsplit(twosnp,',')
snp1 <- snps[[1]][1]
snp2 <- snps[[1]][2]
input <- read.table(filename1,header=T)
am.data = glm(formula=PHENO~ snp1 + snp2 + snp1 * snp2 + args[4],data=input,family=binomial)
#am.data = glm(formula=PHENOTYPE~ snp1 + snp2 + snp1 * snp2,data=input,family=binomial)
p<-coef(summary(am.data))[,4]
write.table(p,args[3],col.names=F,quote=F)
or<-exp(coef(am.data))
write.table(or,args[3],append=TRUE,col.names=F,quote=F)