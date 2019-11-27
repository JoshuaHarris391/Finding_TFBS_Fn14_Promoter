#!/bin/bash
#SBATCH --job-name=map_tfbs_R # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=20000 # Memory in MB
#SBATCH --cpus-per-task=2
#SBATCH --output=slurm_%x_%j.out

# Setting wd
HOME=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/
cd $HOME

# Running Rscript
module purge
module load 'R/3.6.0-foss-2019a'

# Running sync
Rscript r_scripts/map_tfbs.R
