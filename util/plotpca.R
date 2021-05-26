library(tidyverse) 
library(grid)
library(gridExtra )
library(optparse)


#myd.table('chr19.info', header=F )
#bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%AC\t%AF\n' -r chr19 -o chr19.info [relevantvcf] 
#usage Rscript af.R -i chr19.info


option_list = list(make_option(c("-v", "--eigenvectors"), type="character", default=NULL, help="eigenvectorss", metavar="character"), 
		   make_option(c("-e", "--epoch"),  type="character", default=NULL  , help = "epoch file ", metavar="character" ) , 
		  make_option(c( '-a', '--eigenvalues'), type='character', default=NULL, help ='eigenvalues', metavar='character'  ) , 
		 make_option( c('-o', '--out'), type='character', default=NULL, help= 'output name' , metavar= 'character' ))

opt_parser=OptionParser(option_list=option_list)
opt=parse_args(opt_parser)

myve=read.table(opt$eigenvectors, header=F)
myva=read.table(opt$eigenvalues, header=F ) 
mye=read.table(opt$epoch, header=F )
p<- myva %>% mutate(component=1:length(V1)) %>% ggplot(aes(component, V1) )+ geom_bar(stat='identity')   + theme_bw() + labs(y= 'eigenvalue', title= paste ('PCA - first', length(myva[,1]) ,  'components -' , opt$out) )
p1<- merge (myve, mye, by='V1' )  %>% ggplot(aes(V3, V4, color=as.factor(V2.y)) )+ geom_point() + labs(x= paste('PC1 - eigenval', round(myva[1,1]/sum(myva), 1 )*100, '%'  ), y=paste('PC2 - eigenval', round(myva[2,1]/sum(myva), 1 ) *100, '%' ), color= 'Epoch'  )+ scale_color_brewer(palette = "YlOrRd")
p2<- merge (myve, mye, by='V1' )  %>% ggplot(aes(V5, V6, color=as.factor(V2.y)) )+ geom_point() + 
	labs(x= paste('PC3 - eigenval', round(myva[3,1]/sum(myva), 1) *100, '%' ), y=paste('PC4 - eigenval', round(myva[4,1]/sum(myva), 1 ) *100,'%' ), color= 'Epoch'  )+ scale_color_brewer(palette = "YlOrRd")

mymatrix<-rbind(c(1, 1), c(2, 3))
g<-grid.arrange(p, p1, p2, layout_matrix=mymatrix )


ggsave(paste(opt$out, '.pc.pdf', sep='' ), g  ) 

