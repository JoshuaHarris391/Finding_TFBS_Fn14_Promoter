#!/bin/bash
#SBATCH --job-name=Array_Test # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=array_%A_%a.out
#SBATCH --array=SRR8652107,SRR8652105,SRR8670674,SRR1974202

echo ${SLURM_ARRAY_TASK_ID}
