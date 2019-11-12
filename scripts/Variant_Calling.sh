#!/bin/bash
#SBATCH --job-name=Mutect_2 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out

# Setting WD
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Creating directories
mkdir -p  outputs/variant_calls/vcf \
          outputs/variant_calls/bcf

# # Defining SRA ref temp
# SRA_REF='SRR8652105_pass'

# Loading modules
module purge
module load Java/1.10.0_1
module load rtg-core

# Defining GATK GATK_PATH
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
# Running Mutect2
java -jar $GATK_PATH Mutect2 -R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta -I outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam --germline-resource /resource/bundles/gnomAD/vcf/genomes/gnomad.genomes.r2.0.2.sites.vcf.bgz -O outputs/variant_calls/vcf/$SRA_REF.vcf.gz --disable-sequence-dictionary-validation true

# # Decompressing .gz files
# gunzip outputs/variant_calls/vcf/*.gz
# cp outputs/variant_calls/vcf/SRR8652105_pass.vcf.gz.tbi outputs/variant_calls/vcf/SRR8652105_pass.vcf.tbi.gz
# gunzip outputs/variant_calls/vcf/SRR8652105_pass.vcf.tbi.gz
#
# # Filtering VCFs for chr16:3067313-3070398
# rtg vcffilter --input=outputs/variant_calls/vcf/$SRA_REF.vcf --region=sample1:chr16:3067313-chr16:3070398 --output=outputs/variant_calls/vcf/$SRA_REF.filtered.vcf
