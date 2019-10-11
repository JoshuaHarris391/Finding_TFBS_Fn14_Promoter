#!/bin/bash
#SBATCH --job-name=index_hg19 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=4000 # Memory in MB
#SBATCH --cpus-per-task=2

# Setting modules
module purge
module load "SAMtools/1.9-foss-2018a"
module load "BWA/0.7.17-foss-2018b"
module load "picard/2.18.11-Java-1.8.0_162"
# Setting WD
WORKING_DIR=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
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
bwa index -a bwtsw ../data/hg19/hg19.fa

# Indexing with SAMtools
samtools faidx ../data/hg19/hg19.fa

# Creating Fasta sequence directory file
java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=../data/hg19/hg19.fa O=../data/hg19/hg19.dict
