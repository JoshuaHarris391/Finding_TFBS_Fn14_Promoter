#!/bin/bash
#SBATCH --job-name=Array_Test # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=array_%A_%a.out
#SBATCH --array=1-4


job_echo="sbatch -J echo_sra scripts/array_test_slave_echo.sh"
job_sen="sbatch -J sen_sra --dependency=aftercorr:$job_echo scripts/array_test_daughter.sh"
