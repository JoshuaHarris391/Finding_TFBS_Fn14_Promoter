#!/bin/bash
#SBATCH --job-name=download_fastq # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=2000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# Setting WD
cd /scratch/STUDENT+harjo391/
mkdir -p JRA_5/raw_data
cd JRA_5/raw_data

# downloading data
wget $DOWNLOAD_LINK
