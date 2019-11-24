#!/bin/bash
#SBATCH --job-name=Mark_Duplicates # job name (shows up in the queue)
#SBATCH --time=72:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=20000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Defining SRA ref temp
SRA_REF='SRR8652105'

# Set wd
set -e
cd $OUTPUT_DATA
module purge

# Marking duplicates
module load picard
# java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam M=outputs/alignments/bam/${SRA_REF}_MarkDuplicates.txt

# Using GATK
module load Java/1.10.0_1
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
java -jar $GATK_PATH MarkDuplicates I=outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam M=outputs/alignments/bam/${SRA_REF}_MarkDuplicates.txt
