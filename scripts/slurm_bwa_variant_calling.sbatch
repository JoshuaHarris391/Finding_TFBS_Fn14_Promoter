#!/bin/bash
#SBATCH --job-name=BWA_Align # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=8000 # Memory in MB
#SBATCH --cpus-per-task=8

srun echo "running script"
srun bash ~/JRA/JRA_5_TFBS_Fn14_Promoter/scripts/bwa_variant_calling.sh
srun echo "end of script"
