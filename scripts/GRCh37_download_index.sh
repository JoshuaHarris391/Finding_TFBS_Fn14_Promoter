#!/bin/bash
#SBATCH --job-name=download_index_GRCh37 # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=8000 # Memory in MB
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
mkdir -p ../data/GRCh37
cd ../data/GRCh37
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/human_g1k_v37_decoy.fasta.gz
chmod -w *.gz
# gunzip hg19.fa.gz
cd $WORKING_DIR

# Indexing hg19 reference with BWA
echo "Indexing GRCh37 reference"
bwa index -a bwtsw ../data/GRCh37/human_g1k_v37_decoy.fasta.gz

# Indexing with SAMtools
samtools faidx ../data/GRCh37/human_g1k_v37_decoy.fasta.gz

# Creating Fasta sequence directory file
java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary R=../data/GRCh37/human_g1k_v37_decoy.fasta.gz O=../data/GRCh37/human_g1k_v37_decoy.dict
