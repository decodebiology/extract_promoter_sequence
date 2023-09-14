## Files necessary to complete the script
#hg38.fa : Genome used for alignment purpose
#Homo_sapiens.GRCh38.84.chr_complete_annotation.txt : Gene annotations used for quantification purpose (extract from GTF using R script)
#DE_genes_list_total.txt : Differentially expressed genes for whcih promoter to be extracted
## Run: Rscript 1.GTFtoTable.R ensembl[OR 'gencode'] https://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.chr.gtf.gz
## Prepare gene annotation file (necessary to obtain chromosomal lcoations of the gene)
## R script (Start)

args = commandArgs(trailingOnly=TRUE)
gtf_source = args[1];
url = args[2];

gtf <- rtracklayer::import(paste0(url)) 
gtf_df=as.data.frame(gtf)
gtf_df_gene=subset(gtf_df,gtf_df$type=="gene")

if(gtf_source=="ensembl"){
	xanot <- gtf_df_gene[,c("gene_id","gene_name","gene_biotype","seqnames","start","end","strand")]
}
if(gtf_source=="gencode"){
	xanot <- gtf_df_gene[,c("gene_id","gene_name","gene_type","seqnames","start","end","strand")]
}

colnames(xanot)[4] <- "chromosome"
colnames(xanot)[3] <- "gene_biotype"
colnames(xanot)[1] <- "Geneid"
xanot$chromosome <- gsub("chr","",xanot$chromosome) 
write.table(xanot, "./annotation/gene_annotation.txt", sep="\t", quote=F, row.names=F)
## R script (END)
## Please run 2.extract_promoters.sh after this script
