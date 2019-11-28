#!/bin/bash
#SBATCH --job-name=test_four
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j_array_%A_%a.out

# CD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Defining file with SRA refs
SRA_REF_NAMES_FILE=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/SRA_Ref_Names.txt
# Pulling nth line from file and defining SRA variable
SRA_REF=`sed "${SLURM_ARRAY_TASK_ID}q;d" $SRA_REF_NAMES_FILE`

mkdir -p array_test/test_four_${SLURM_ARRAY_TASK_ID}/$SRA_REF
touch array_test/test_four_${SLURM_ARRAY_TASK_ID}/${SRA_REF}/${DATA}.txt
