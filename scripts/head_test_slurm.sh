#!/bin/bash
#SBATCH --job-name=head_test # job name (shows up in the queue)
#SBATCH --time=01:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1

# Setting WD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Read variable
echo $filename_input

mkdir -p outputs/$filename_input
