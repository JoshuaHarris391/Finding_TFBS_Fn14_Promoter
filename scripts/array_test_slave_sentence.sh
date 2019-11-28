#!/bin/bash
#SBATCH --job-name=echo_sen
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%jarray_%A_%a.out

# Defining file with SRA refs
SRA_REF_NAMES_FILE=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/SRA_Ref_Names.txt
# Pulling nth line from file and defining SRA variable
SRA_REF=`sed "${SLURM_ARRAY_TASK_ID}q;d" $SRA_REF_NAMES_FILE`

scontrol update jobid=$SLURM_JOBID jobname="echo_sra_$SRA_REF"
echo "$SRA_REF is the number gee"
