## Three step run

# Step 1: Prepare gene annotation table from GTF file

`Rscript 1.GTFtoTable.R`

# Step 2: Prepare genome from Ensembl

`./2.extract_promoters.sh prepare_genome`

# Step 3: Extract promoter sequence

`./2.extract_promoters.sh extract protein_coding_Up > sample_output.fasta`

