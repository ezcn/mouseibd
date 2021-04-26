
### rename samples 
bcftools reheader

### annotate rsid  
mm10 dbsnp142 from UCSC  
bcftools annotate -a chr19.mm10.rsid.bed.gz -c CHROM,FROM,TO,ID -o cc chr19.renamed.vcf.gz
