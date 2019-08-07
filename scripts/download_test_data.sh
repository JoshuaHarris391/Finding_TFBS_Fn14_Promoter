#!/bin/bash
#SBATCH --job-name=Download_SRA_Test_Data # job name (shows up in the queue)
#SBATCH --time=10:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=END
#SBATCH --mail-user=harjo391@student.otago.ac.nz

# Set wd
# WORKING_DIR=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
WORKING_DIR=/Users/joshua_harris/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter
cd $WORKING_DIR
# Download files
mkdir -p ../test_data
# Defining SRA references to Download
declare -a SRA_REF_LIST=("SRR8652107" "SRR8652105" "SRR8670674")

for SRA_REF_VAR in ${SRA_REF_LIST[@]}; do

~/tools/bin/fastq-dump --outdir ../test_data/ \
 --gzip \
 --skip-technical \
	--read-filter pass \
     --dumpbase \
      --split-3 \
       --clip \
       -N 10000 \
       -X 1010000 \
       $SRA_REF_VAR
done
# check file size
ls -l ../test_data | echo
# make read-only
chmod -w ../test_data/*.gz
