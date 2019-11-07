#!/bin/bash
#SBATCH --job-name=Mutect_2 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out

# Setting WD
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# # Defining SRA ref temp
# SRA_REF='SRR8652105_pass'

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
# 																					-R "../data/GRCh37/human_g1k_v37_decoy.fasta" \
# 																					-I "outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam" \
# 																					--germline-resource "../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz" \
# 																					-O "outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz"

# gatk-launch --javaOptions "-Xmx4g" Mutect2 \
#  -R ../data/GRCh37/human_g1k_v37_decoy.fasta \
#  -I outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam \
#  -tumor $SRA_REF \
#  --germline_resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz \
#  -O outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz


# Defining GATK GATK_PATH
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
# Running Mutect2
# java -jar $GATK_PATH Mutect2 -R ../data/GRCh37/human_g1k_v37_decoy.fasta -I outputs/alignments/bam/${SRA_REF_TMP}_pass.aligned.sorted.bam --germline-resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.vcf.gz -O outputs/variant_calls/vcf/$SRA_REF_TMP.ch16.vcf.gz
java -jar $GATK_PATH Mutect2 -R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta -I outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam --germline-resource /resource/bundles/gnomAD/vcf/genomes/gnomad.genomes.r2.0.2.sites.vcf.bgz -O outputs/variant_calls/vcf/$SRA_REF.vcf.gz --disable-sequence-dictionary-validation true
# java -jar $EBROOTGATK/GenomeAnalysisTK.jar Mutect2 -R ../data/GRCh37/human_g1k_v37_decoy.fasta -I outputs/alignments/bam/chr16/$SRA_REF.chr16.aligned.sorted.bam --germline-resource ../data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz -O outputs/variant_calls/vcf/$SRA_REF.ch16.vcf.gz


# Concluding notes, This should work, but java seems to not be working
