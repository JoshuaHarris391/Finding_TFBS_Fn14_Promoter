#!/bin/bash
#SBATCH --job-name=Index_hg19 # job name (shows up in the queue)
#SBATCH --time=5:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=2000 # Memory in MB
#SBATCH --cpus-per-task=2

srun cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
srun bash scripts/bwa_variant_calling.sh
