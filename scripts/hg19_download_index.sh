#!/bin/bash
#SBATCH --job-name=index_hg19 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=6000 # Memory in MB
#SBATCH --cpus-per-task=4

# Setting modules
module purge
module load "SAMtools/1.9-foss-2018a"
module load "BWA/0.7.17-foss-2018b"
# Setting WD
WORKING_DIR=/Users/joshua_harris/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter
cd $WORKING_DIR
# Downloading hg19 human reference genome
mkdir -p ../data/hg19
cd ../data/hg19
# wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz
# chmod -w *.gz
# gunzip hg19.fa.gz
cd $WORKING_DIR

# Indexing hg19 reference with BWA
echo "Indexing hg19 reference"
# bwa index ../data/hg19/hg19.fa

# Indexing with SAMtools
samtools faidx ../data/hg19/hg19.fa
