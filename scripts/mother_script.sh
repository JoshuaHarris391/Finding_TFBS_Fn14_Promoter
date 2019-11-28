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

# Setting WD
mkdir -p $OUTPUT_DATA
cd $OUTPUT_DATA


# Removing current outputs folder
rm -R outputs

# # Downloading and indexing GRCh37
# JOB_0=$(sbatch --parsable scripts/GRCh37_download_index.sh)

# Defining Data folder
DATA=../test_data/

# Defining array number
echo "== Defining array number =="
ARRAY_N=4
echo $ARRAY_N

# Running Array and defining dependancies
echo "== Running Array and defining dependancies =="
cmd="sbatch --array=1-${ARRAY_N} --export=DATA=$DATA --parsable $SCRIPT_REF/quality_control.sh"
JOB_QC=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_QC} --export=DATA=$DATA --parsable $SCRIPT_REF/bwa_alignment.sh"
JOB_BWA=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_BWA} --export=DATA=$DATA --parsable $SCRIPT_REF/mark_duplicates.sh"
JOB_MD=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_MD} --export=DATA=$DATA --parsable $SCRIPT_REF/bam_index.sh"
JOB_INDEX=$(eval $cmd | awk '{print $4}')

cmd="sbatch --array=1-${ARRAY_N} --dependency=aftercorr:${JOB_INDEX} --export=DATA=$DATA --parsable $SCRIPT_REF/base_recalibration.sh"
JOB_RECAL=$(eval $cmd | awk '{print $4}')

sbatch --array=1-${ARRAY_N} --dependency=afterok:${JOB_RECAL} --export=DATA=$DATA --parsable $SCRIPT_REF/Variant_Calling.sh

# moving slurm outputs to Directory
mkdir -p slurm_outputs
mv *.out slurm_outputs/

echo "== END OF MOTHER SCRIPT=="
