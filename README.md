## Three step run

#Step 1: Prepare gene annotation table from GTF file

`Rscript 1.GTFtoTable.R ensembl https://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.chr.gtf.gz`
<br><br>
OR
<br><br>
`Rscript 1.GTFtoTable.R gencode https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_25/gencode.v25.basic.annotation.gtf.gz`

#Step 2: Prepare genome from Ensembl

`./2.extract_promoters.sh prepare_genome https://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # Ensembl`
<br><br>
OR
<br><br>
`./2.extract_promoters.sh prepare_genome https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_25/GRCh38.primary_assembly.genome.fa.gz # Gencode`

#Step 3: Extract promoter sequence

`./2.extract_promoters.sh extract protein_coding_Up > sample_output.fasta`

