#!/bin/bash
#SBATCH --job-name=Mutect_2 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=4

# Setting WD
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Loading GATK module
module purge
module load GATK/3.8-1-Java-1.8.0_172

# Note: This is the command to run GATK
	# java -jar $EBROOTGATK/GenomeAnalysisTK.jar

# Calling variants
java -jar $EBROOTGATK/GenomeAnalysisTK.jar Mutect2 \
																					-R ../data/hg19/hg19.fa \
																					-I sample.bam \
																					--germline-resource af-only-gnomad.vcf.gz \
																					--panel-of-normals pon.vcf.gz \
																					-O single_sample.vcf.gz
