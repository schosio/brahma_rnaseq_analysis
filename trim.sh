#!/bin/bash

for infile in *R1.fastq.gz
	do
	echo $infile
	outfile=$( echo $infile | sed 's/.fastq.gz/_trim.fastq.gz/')
	name=$(echo $infile | awk -F"_R." '{print $infile}')
	echo $outfile
	echo $name
	echo "java -jar /home/chaos/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -version -threads 40 -phred33 -trimlog $outfile\trimLogFile.log -summary $outfile\statsSummaryFile.txt $name ${name}_PE2.fastq.gz $outfile ILLUMINACLIP:universal_adaptor.fa:2:40:15 AVGQUAL:24"
    	java -jar /home/chaos/softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -version -threads 40 -phred33 -trimlog $outfile\trimLogFile.log -summary $outfile\statsSummaryFile.txt $name ${name}_PE2.fastq.gz $outfile ILLUMINACLIP:universal_adaptor.fa:2:40:15 AVGQUAL:24
	done
