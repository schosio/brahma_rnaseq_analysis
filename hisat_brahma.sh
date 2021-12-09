#!/bin/bash

#threads = processors that will be used in process
threads=40
#idx = location of reference genome index
idx=/home/chaos/draic_data_analysis/hisat_index/hg38
#splicefile = location of gtf annotation file
splicefile=/home/chaos/draic_data_analysis/annotation_file/gencode.v38.splice.txt

#loop for hisat2

for i in *R1_paired.fastq.gz
do
  	date
	name=$(echo $i | awk -F"_R." '{print $1}')
        R1_pair=${name}_R1_paired.fastq.gz
	R2_pair=${name}_R2_paired.fastq.gz
        #display the command used
        echo  "hisat2 -p $threads -x $idx --known-splicesite-infile $splicefile $i | samtools view -bS - | samtools sort -n - -o $name.sorted.bam"
        #options for hisat: -p is for threads used, --known-splicesite-infile is for splice site file
        #options for samtools: view is for file conversion, -bS is for .bam as output and .sam as input
        #options for samtools: sort is for sorting, -n is sorting by name, -o is for output
        hisat2 -p $threads -x $idx --known-splicesite-infile $splicefile -1 $R1_pair -2 $R2_pair | samtools view -@ 40 -bS - | samtools sort -@ 40 -n - -o $name.sorted.bam
done

for j in *.sorted.bam
do
  	    date
	      name1=$(echo $j | awk -F".sorted." '{print $1}')
        echo $name1
        echo "samtools fixmate -m $j - | samtools sort - | samtools markdup -rs - $name1.rmPCRdup.bam"
        #options for samtools: fixmate is for fix mate information, markdup is for marking duplicates       
        samtools fixmate -@ 40 -m $j - | samtools sort -@ 40 - | samtools markdup -@ 40 -rs - $name1.rmPCRdup.bam
done

for u in *.rmPCRdup.bam
do
  	date
    #options for samtools: index is for indexing the bam file, -b is to generate .bai index
	  samtools index -@ 40 -b $u
  
done


#annotation = location of annotation file
annotation=/home/chaos/draic_data_analysis/annotation_file/gencode.v38.annotation.gtf
#dir = output location of ballgown table files
dir=/home/chaos/BRAHMA/raw_fastq


for i in *rmPCRdup.bam
do
  	date
        name=$(echo $i | awk -F".rmPCRdup" '{print $1}')
        echo $name
        echo "stringtie $i -G ${annotation} -o $name.annotation.gtf -p 40 -b ${dir} -A $name.gene_abund.out"
        #options for stringtie: -G is for annotation file, -o is for output gtf file, -p is or threads, -b is for location of ballown table files
        #options for stringtie: -A is for output of gene abundance file
        stringtie $i -G ${annotation} -o $name.annotation.gtf -p 40 -b ${dir} -A $name.gene_abund.out
done


annotation=/home/chaos/draic_data_analysis/annotation_file/gencode.v38.annotation.gtf
#out_file = name of merged tf file
out_file=brahma_data_merge_annotation.gtf

for i in *annotation.gtf
do
  	stringtie --merge -G $annotation -m 200 -o $out_file $i
done 

#STEP 8 comparing the information in merged gtf from stringtie and annotation file

#merge_gtf = location of merged gtf file created in STEP 7
merge_gtf=/home/chaos/draic_data_analysis/draic_data_fastq_files/driac_data_merge_annotation.gtf
