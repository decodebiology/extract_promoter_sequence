## Please run 1.GTFtoTable.R before this script
## Files necessary to complete the script
#hg38.fa : Genome used for alignment purpose
#Homo_sapiens.GRCh38.84.chr_complete_annotation.txt : Gene annotations used for quantification purpose (extract from GTF using R script)
#DE_genes_list_total.txt : Differentially expressed genes for whcih promoter to be extracted
##2-step-Run: 
#./2.extract_promoters.sh prepare_genome https://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # Ensembl
#OR
#./2.extract_promoters.sh prepare_genome https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_25/GRCh38.primary_assembly.genome.fa.gz # Gencode
#./2.extract_promoters.sh extract protein_coding_Up > sample_output.fasta
###########################################################################
## Bash script (Start)
#!/bin/bash

module load EBModules
module load SAMtools/1.14-GCC-10.3.0

if [ $1 == "prepare_genome" ]
then
	url=$2;
	echo "## Preparing Genome file. This might take a while";
	wget $url -P ./annotation/ -O ./annotation/genome.fa.gz ;
	gzip -d ./annotation/genome.fa.gz ;
	sed -i 's/^>chr/>/g' ./annotation/genome.fa;
fi

if [ $1 == "extract" ]
then
	
	group=$2; #protein_coding_Up OR lncRNA_Up OR protein_coding_Down OR lncRNA_Down (USER INPUT NECESSARY)
	ref="./annotation/genome.fa"; # Genome used for alignment purpose
	anot="./annotation/gene_annotation.txt"; # Gene annotations used for quantification purpose
	DEG="./input/DE_genes_list_total.txt" # Differentially expressed genes for whcih promoter to be extracted
	size=250; # Number of base paires to extend TSS on both sides. This will extend TSS 250 bo upstream and 250 bp downstream (500 bp).


	temp=(`cat $DEG | grep -v "^#" | grep -w $group | cut -f1 > ./input/DE_genes_group.txt`); # Selecting only group of genes of interest (by ENSGxxxx ids)
	sub_group="./input/DE_genes_group.txt";
	COLS=(`grep -w -Ff $sub_group $anot | grep -v "^#" | awk '!x[$0]++' | sed 's/\t/;/g'`); # Selecting complete gene annotations for "lncRNA_Down" genes (by ENSGxxxx ids)
	
	rm ./input/DE_genes_group.txt;
	for i in ${COLS[@]}

	do

		IFS=';' read -ra arr <<< "$i"; 
		gene_id=${arr[0]};
		gene_symbol=${arr[1]};
		gene_type=${arr[2]};
		chromosome=${arr[3]};
		start=${arr[4]};
		end=${arr[5]};
		strand=${arr[6]};
		oname="${gene_symbol}_${gene_id} ${gene_type}"; # ; ${gene_type}; ${chromosome}:${start}-${end}; $strand";
	
		if [ "$strand" == "+" ] 
		then
			pstart=$(($start-$size));
			pend=$(($start+$size));
		fi
		if [ "$strand" == "-" ] 
		then
			pstart=$(($end-$size));
			pend=$(($end+$size));
		fi
		samtools faidx --continue $ref $chromosome:$pstart-$pend | sed "s/>$chromosome:$pstart-$pend/>${oname} chr$chromosome:$pstart-$pend/";

	done
	## Bash script (END)

fi

