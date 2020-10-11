#! /bin/bash
# Epicard_ATAC_16-06-2020 project
# created on 16-06-2020 using same script for Epicard_H3K27ac_12-2019 project

#Purpose: map PE ChIPSeq reads of 50 bases on GRCh38 Gencode relese 32

# run the script from 02_Mapping_STAR directory
# path to input and index directories are :
# $1 = path to input fq.gz directory
# $2 = path to outputs

# Usage:
# example of input names and path:../../01_QC/01_QC_FastP/6712_R1_fp.fastq.gz  and ../../01_QC/01_QC_FastP/6712_R2_fp.fastq.gz; all are 001
# example of output names :
# 6712_Aligned.sortedByCoord.out.bam
# 6712_Log.final.out
# 6712_Log.out
# 6712_Log.progress.out
# 6712_Signal.UniqueMultiple.str1.out.wig
# 6712_Signal.UniqueMultiple.str2.out.wig
# 712_Signal.Unique.str1.out.wig
# 6712_Signal.Unique.str2.out.wig
# 6712_SJ.out.tab
# 6712_Unmapped.out.mate1
# 6712_Unmapped.out.mate2

# ../../ZZ_Scripts/run_mapping_ATAC_PE_STAR.sh ../../01_QC/01_QC_FastP . 2> star.log

for id in `ls ../../01_QC/01_QC_FastP/*fp.fastq.gz | cut -d/ -f5 | cut -d_ -f1 | uniq `
do
	echo "mapping sample: ${id}"	
	STAR --runThreadN 16 \
	--genomeDir ~/Ressources_NGS/STAR_r32_index_50 \
	--readFilesIn ${1}/${id}_R1_fp.fastq.gz ${1}/${id}_R2_fp.fastq.gz \
	--readFilesCommand zcat \
	--outFileNamePrefix ${id}_ \
    --outMultimapperOrder Random \
	--outReadsUnmapped Fastx \
    --outSAMtype BAM SortedByCoordinate \
	--outSAMattributes All \
	--outWigType wiggle read1_5p
done

