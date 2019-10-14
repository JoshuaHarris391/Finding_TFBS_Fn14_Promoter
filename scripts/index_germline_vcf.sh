#!/bin/bash
#SBATCH --job-name=index_gnomad_vcf # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=8000 # Memory in MB
#SBATCH --cpus-per-task=4

# Setting wd
set -e
cd /home/STUDENT/harjo391/JRA/
# Loading java
module load Java/1.10.0_1
# Defining GATK path
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar
# Running index command
java -jar $GATK_PATH IndexFeatureFile -F ./data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.gz
