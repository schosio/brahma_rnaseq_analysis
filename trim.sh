#!/bin/bash

for infile in *R1.fastq.gz
	do
	echo $infile
	name=$(echo $infile | awk -F"_R." '{print $1}')
	R1_paired=${name}_R1_paired.fastq.gz
	R1_unpaired=${name}_R1_unpaired.fastq.gz
	R2_paired=${name}_R2_paired.fastq.gz
	R2_unpaired=${name}_R2_unpaired.fastq.gz
	echo "java -jar /home/chaos/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -version -threads 40 -phred33 -trimlog ${name}_trimLogFile.log -summary ${name}_statsSummaryFile.txt $infile ${name}_R2.fastq.gz $R1_paired $R1_unpaired $R2_paired $R2_unpaired ILLUMINACLIP:universal_adaptor.fa:2:40:15 LEADING:28 TRAILING:28 AVGQUAL:28 MINLEN:100"
	java -jar /home/chaos/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -version -threads 40 -phred33 -trimlog ${name}_trimLogFile.log -summary ${name}_statsSummaryFile.txt $infile ${name}_R2.fastq.gz $R1_paired $R1_unpaired $R2_paired $R2_unpaired ILLUMINACLIP:universal_adaptor.fa:2:40:15 LEADING:28 TRAILING:28 AVGQUAL:28 MINLEN:100
done
