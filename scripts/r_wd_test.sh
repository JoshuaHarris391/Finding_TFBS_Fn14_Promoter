#!/bin/bash
#SBATCH --job-name=map_tfbs_R # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# Setting wd
HOME=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/
cd $HOME

# Running Rscript
module purge
module load 'R/3.6.0-foss-2019a'

# Running sync
Rscript scripts/r_wd_test.R