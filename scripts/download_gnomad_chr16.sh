#!/bin/bash
#SBATCH --job-name=Download_gnomad_chr16_Index # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=4000 # Memory in MB
#SBATCH --cpus-per-task=2

# Setting wd
set -e
mkdir -p /home/STUDENT/harjo391/JRA/data/gnomad_chr16
cd /home/STUDENT/harjo391/JRA/data/gnomad_chr16


# Downloading data
# wget https://storage.googleapis.com/gnomad-public/release/2.1.1/liftover_grch38/vcf/genomes/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.bgz
wget https://storage.googleapis.com/gnomad-public/release/2.1.1/vcf/genomes/gnomad.genomes.r2.1.1.sites.16.vcf.bgz
# Renaming file extension
mv gnomad.genomes.r2.1.1.sites.16.vcf.bgz gnomad.genomes.r2.1.1.sites.16.vcf.gz

# Loading java
module load Java/1.10.0_1
# Defining GATK path
GATK_PATH=/home/STUDENT/harjo391/tools/GATK/gatk-4.1.3.0/gatk-package-4.1.3.0-local.jar

# Running index command
# java -jar $GATK_PATH IndexFeatureFile -F ./data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.liftover_grch38.vcf.gz
cd /home/STUDENT/harjo391/JRA/
java -jar $GATK_PATH IndexFeatureFile -F ./data/gnomad_chr16/gnomad.genomes.r2.1.1.sites.16.vcf.gz
