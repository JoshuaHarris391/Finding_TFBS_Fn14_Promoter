#!/bin/bash
#SBATCH --job-name=Array_Test # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=array_%A_%a.out
#SBATCH --array=1-4


echo running echo script
job_echo=$(sbatch --array=1-4 scripts/array_test_slave_echo.sh)
echo running sen script
job_sen=$(sbatch --array=1-4 --dependency=aftercorr:$job_echo scripts/array_test_slave_sentence.sh)
