#!/bin/bash
#SBATCH --job-name=transfer_raw_data_hcs # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=2000 # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --output=slurm_%x_%j.out

# transfering from /scratch to hcs
scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:/scratch/STUDENT+harjo391/JRA_5 /mnt/hcs/dsm-molecularoncology/Josh_Harris_Bioinformatics/
