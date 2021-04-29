
### rename samples 
bcftools reheader

### annotate rsid  
ftp://ftp.ensembl.org/pub/data_files/mus_musculus/GRCm38/variation_genotype/
mgp.v3.snps.sorted.rsIDdbSNPv137.vcf.gz 
mgp.v3.indels.sorted.rsIDdbSNPv137.vcf.gz

bcftools annotate -a chr19.mgp.v3.snp.indels.rsIDdbSNPv137.bed.gz  -c CHROM,FROM,TO,ID -o chr19.renamed.rsIDdbSNPv137 /home/enzac/data/chr19data/data/chr19.renamed.vcf.gz
