#!/bin/bash
#SBATCH --job-name=transfer_raw_data_hcs # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# transfering from /scratch to hcs
rsync -vr /scratch/STUDENT+harjo391/JRA_5 /mnt/hcs/dsm-molecularoncology/Josh_Harris_Bioinformatics/
