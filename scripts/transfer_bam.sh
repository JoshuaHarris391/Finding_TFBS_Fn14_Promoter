#!/bin/bash
#SBATCH --job-name=transfer_bam_hcs # job name (shows up in the queue)
#SBATCH --time=48:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# transfering from /scratch to hcs
DEST=/mnt/hcs/dsm-molecularoncology/Josh_Harris_Bioinformatics/JRA_5/outputs/

rsync -vr /scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter/outputs/alignments/bam $DEST
