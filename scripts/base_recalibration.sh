#!/bin/bash
#SBATCH --job-name=base_recalibration # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=8000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out

# # Defining SRA ref temp
SRA_REF='SRR8652105_pass'

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Set wd
set -e
cd $OUTPUT_DATA

# Loading modules
module purge
module load Java/1.10.0_1

# Defining GATK GATK_PATH
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar

# Creating recalibration table
java -jar $GATK_PATH BaseRecalibrator -R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta \
																						--input outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam \
																						--known-sites /resource/bundles/broad_bundle_b37_v2.5/1000G_phase1.indels.b37.vcf \
																						--known-sites /resource/bundles/broad_bundle_b37_v2.5/dbsnp_137.b37.vcf \
																						--output outputs/alignments/bam/${SRA_REF}_recal_1.table
# Creating recalibrated bams
java -jar $GATK_PATH ApplyBQSR 	-R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta \
																-I outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam \
																--bqsr-recal-file outputs/alignments/bam/${SRA_REF}_recal_1.table \
																-O outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.recal.bam


# Creating second recalibration table
java -jar $GATK_PATH BaseRecalibrator -R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta \
																						--input outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam \
																						--known-sites /resource/bundles/broad_bundle_b37_v2.5/1000G_phase1.indels.b37.vcf \
																						--known-sites /resource/bundles/broad_bundle_b37_v2.5/dbsnp_137.b37.vcf \
																						-bqsr outputs/alignments/bam/${SRA_REF}_recal_1.table \
																						--output outputs/alignments/bam/${SRA_REF}_recal_2.table

# Creating report
java -jar $GATK_PATH AnalyzeCovariates \
		-before outputs/alignments/bam/${SRA_REF}_recal_1.table \
		-after outputs/alignments/bam/${SRA_REF}_recal_2.table \
		-plots ${SRA_REF}_AnalyzeCovariates.pdf
