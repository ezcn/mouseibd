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
mye=read.table(opt$epoch, header=F, sep='\t')
p<- myva %>% mutate(component=1:length(V1)) %>% ggplot(aes(component, V1) )+ geom_bar(stat='identity')   + theme_bw() + labs(y= 'eigenvalues', title= paste ('PCA ', length(myva[,1]) ,  'components -' , opt$out) )
p1<- merge (myve, mye, by='V1' )  %>% ggplot(aes(V3.x, V4.x, color=V5.y, shape=V6.y) )+ geom_point() + 
	labs(x= paste('PC1 - eigenval', round(myva[1,1]/sum(myva), 3 )*100, '%'  ), y=paste('PC2 - eigenval', round(myva[2,1]/sum(myva), 3 ) *100, '%' ), color= 'subpop' , shape='superpop' ) + 
	theme(legend.position="none", legend.title = element_text(size = 10), legend.text = element_text( size = 10))

p2<- merge (myve, mye, by='V1' )  %>% ggplot(aes(V5.x, V6.x, color=V5.y , shape=V6.y) )+ geom_point() + 
	labs(x= paste('PC3 - eigenval', round(myva[3,1]/sum(myva), 3) *100, '%' ), y=paste('PC4 - eigenval', round(myva[4,1]/sum(myva), 3 ) *100,'%' ), color= 'subpop', shape='superpop'  ) + 
	theme(legend.position="top" , legend.title = element_text(size = 7), legend.text = element_text( size = 7)) +
        guides(col = guide_legend(nrow = 5))

mymatrix<-rbind(c(1, 1), c(2, 3))
g<-grid.arrange(p, p1, p2, layout_matrix=mymatrix )


ggsave(paste(opt$out, '.pc.pdf', sep='' ), g , width = 30, height = 20, units = "cm" ) 

