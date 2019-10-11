#!/bin/bash
#SBATCH --job-name=Mutect_2 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=4

# Setting WD
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Defining SRA ref temp
SRA_REF='SRR8652105'

# Loading GATK module
module purge
# module load GATK/3.8-1-Java-1.8.0_172
# module load GATK/3.8-0-Java-1.8.0_144
# module load GATK4/4.1.0.0-foss-2018b-Python-3.6.6
module load Java/1.10.0_1

# Note: This is the command to run GATK
	# java -jar $EBROOTGATK/GenomeAnalysisTK.jar

# Calling variants
# java -jar $EBROOTGATK/GenomeAnalysisTK.jar Mutect2 \
# 																					-R "../data/hg19/hg19.fa" \
# 																					-I "outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam" \
# 																					--germline-resource "../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz" \
# 																					-O "outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz"

# gatk-launch --javaOptions "-Xmx4g" Mutect2 \
#  -R ../data/hg19/hg19.fa \
#  -I outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam \
#  -tumor $SRA_REF \
#  --germline_resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz \
#  -O outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz

# Defiing GATK tool path
# GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
java -jar $GATK_PATH Mutect2 -R ../data/hg19/hg19.fa.fai -I outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam --germline-resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz -O outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz

# java -jar $EBROOTGATK/GenomeAnalysisTK.jar Mutect2 -R ../data/hg19/hg19.fa -I outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam --germline-resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz -O outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz


# Concluding notes, This should work, but java seems to not be working
