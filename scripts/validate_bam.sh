#!/bin/bash
#SBATCH --job-name=Validate_BAM # job name (shows up in the queue)
#SBATCH --time=10:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=1

# Setting WD
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Loading GATK module
module purge
module load Java/1.10.0_1

# Defining GATK GATK_PATH
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
# Running Validate Sam File
java -jar $GATK_PATH ValidateSamFile -I outputs/alignments/bam/chr16/SRR8652105_pass.chr16.aligned.sorted.bam -MODE VERBOSE
