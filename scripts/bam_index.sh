#!/bin/bash
#SBATCH --job-name=bam_index # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=2000 # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --output=slurm_%x_%j.out

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Defining SRA ref temp
# SRA_REF='SRR8652105'

# Set wd
set -e
cd $OUTPUT_DATA
module purge
module load 'SAMtools'

# Removing Sorted bam file
rm outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam

# Indexing bam files
echo "[UPDATE] indexing bam files"
samtools index -@ 8 outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam
echo "[UPDATE] indexed ${SRA_REF}.aligned.sorted.bam"
