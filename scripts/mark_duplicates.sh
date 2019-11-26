#!/bin/bash
#SBATCH --job-name=Mark_Duplicates # job name (shows up in the queue)
#SBATCH --time=15:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=30000 # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --output=slurm_%x_%j.out

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# # Defining SRA ref temp
# SRA_REF='SRR8652105'

# Set wd
set -e
cd $OUTPUT_DATA
module purge

# Marking duplicates
module load picard
java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam M=outputs/alignments/bam/${SRA_REF}_MarkDuplicates.txt
