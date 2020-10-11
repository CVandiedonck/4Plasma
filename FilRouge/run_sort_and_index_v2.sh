#! /bin/bash
# Epicard_ATAC_16-06-2020 project
# created on 18-06-2020 borrowed from same script in Epicard_ChIPSeq_H3K27ac_12-2019 project

#Purpose: sort bam files from Bowtie2 and index both Star and Bowtie2 sorted bams

# run the script from 02_Mapping directory
# path to input and index directories are :
# $1 = path to BOWTIE2 files
# $2 = path to STAR files
# The sorted bam files and .bai files will be in the same directory as the input files

# Usage:
# example of STAR path and files: input=02_Mapping_Bowtie2/5830.bam, outputs=02_Mapping_Bowtie2/5830.sorted.bam and 02_Mapping_Bowtie2/5830.sorted.bam.bai
# example of BOWTIE2 path and files : input=02_Mapping_STAR/5830_Aligned.sortedByCoord.out.bam, output=02_Mapping_STAR/5830_Aligned.sortedByCoord.out.bam.bai
# ../ZZ_Scripts/run_sort_and_index.sh  02_Mapping_Bowtie2 02_Mapping_STAR 2> sorting_indexing.log

# ATTENTION check wteher line 22 the last cut shouldn't be with a _ rather than a . because of _sorted.bam in previous step

echo "-----------------------processing BOWTIE2 mapped samples:----------------------------- "	

for id in `ls ${1}/*.bam | cut -d/ -f2 | cut -d. -f1 `
do
    echo "processing sample: ${id}"	
    samtools sort ${1}/${id}.bam -@ 8 -o ${1}/${id}_sorted.bam
	samtools index ${1}/${id}_sorted.bam -@ 8
    rm ${1}/${id}.bam
done


echo "-----------------------processing STAR mapped samples:----------------------------- "	

for id in `ls ${2}/*sortedByCoord.out.bam | cut -d/ -f2 | cut -d_ -f1 `
do
	echo "processing sample: ${id}"	
    samtools index ${2}/${id}_Aligned.sortedByCoord.out.bam -@8
done



for x in $(ls *.sorted.bam) ; do y=$(echo $x | cut -d. -f1) ; echo -e $x   ${y}_sorted.bam;  done #(to test)
for x in $(ls *.sorted.bam) ; do y=$(echo $x | cut -d. -f1) ; mv $x   ${y}_sorted.bam;  done 
