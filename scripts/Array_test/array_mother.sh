#!/bin/bash
#SBATCH --job-name=JRA_5_Mother # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# Stop script if there is an error
set -e
# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter
DATA='You_wot_m8'
ARRAY_N=4

# Setting WD
cd $OUTPUT_DATA


# Running Array and defining dependancies
cmd="sbatch --array=1-${ARRAY_N} --export=DATA=$DATA $SCRIPT_REF/array_1.sh"
JOB_QC=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_QC} --export=DATA=$DATA $SCRIPT_REF/array_2.sh"
JOB_BWA=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_BWA} --export=DATA=$DATA $SCRIPT_REF/array_3.sh"
JOB_MD=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_MD} --export=DATA=$DATA $SCRIPT_REF/array_4.sh"
JOB_INDEX=$(eval $cmd | awk '{print $4}')

sbatch --array=1-${ARRAY_N} --dependency=afterok:${JOB_INDEX} --export=DATA=$DATA $SCRIPT_REF/Variant_Calling.sh
