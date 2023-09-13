## Files necessary to complete the script
#hg38.fa : Genome used for alignment purpose
#Homo_sapiens.GRCh38.84.chr_complete_annotation.txt : Gene annotations used for quantification purpose (extract from GTF using R script)
#DE_genes_list_total.txt : Differentially expressed genes for whcih promoter to be extracted

## Prepare gene annotation file (necessary to obtain chromosomal lcoations of the gene)
## R script (Start)
#gtf <- rtracklayer::import('/grid/beyaz/home/subhash/projects/endometrium_proj/bulk/annotation/Homo_sapiens.GRCh38.84.chr.gtf')
gtf <- rtracklayer::import('https://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.chr.gtf.gz')
gtf_df=as.data.frame(gtf)
gtf_df_gene=subset(gtf_df,gtf_df$type=="gene")


xanot <- gtf_df_gene[,c("gene_id","gene_name","gene_biotype","seqnames","start","end","strand")]
colnames(xanot)[4] <- "chromosome"
colnames(xanot)[1] <- "Geneid"

write.table(xanot, "./annotation/Homo_sapiens.GRCh38.84.chr_complete_annotation.txt", sep="\t", quote=F, row.names=F)
## R script (END)
## Please run 2.extract_promoters.sh after this script
