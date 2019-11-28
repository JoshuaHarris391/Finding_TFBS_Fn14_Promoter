#!/bin/bash
#SBATCH --job-name=Array_Test # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out


cmd="sbatch --array=1-4 scripts/array_test_slave_echo.sh"
jobecho=$(eval $cmd | awk '{print $4}')
cmd="sbatch --array=1-4 --dependency=aftercorr:${jobecho} scripts/array_test_slave_middle.sh"
jobmiddle=$(eval $cmd | awk '{print $4}')
sbatch --array=1-4 --dependency=afterok:${jobmiddle} scripts/array_test_slave_sentence.sh
