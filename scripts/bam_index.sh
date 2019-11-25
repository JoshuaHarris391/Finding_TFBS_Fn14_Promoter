#!/bin/bash
#SBATCH --job-name=BWA_Align # job name (shows up in the queue)
#SBATCH --time=72:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=40000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out

# Indexing bam files
echo "[UPDATE] indexing bam files"
samtools index --threads 8 outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam
echo "[UPDATE] indexed ${SRA_REF}.aligned.sorted.bam"
