#!/bin/bash
#SBATCH --job-name=Fastqc_Trim # job name (shows up in the queue)
#SBATCH --time=05:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=8000 # Memory in MB
#SBATCH --cpus-per-task=4


# Setting working directory
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Purging modules
module purge
# Creating outputs folder
mkdir -p outputs/$SRA_REF

####################################
# Conducting Quality Control
####################################

# Loading fastqc
module load FastQC/0.11.5-Java-1.8.0_74
# Running fastqc on all fastq files
mkdir -p outputs/$SRA_REF/fastqc_untrimmed
echo "Running FastQC on untrimmed reads"
fastqc $DATA/*.fastq.gz --outdir=outputs/$SRA_REF/fastqc_untrimmed/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/$SRA_REF/fastqc_untrimmed/*.zip ; do
  unzip $FILENAME -d outputs/$SRA_REF/fastqc_untrimmed/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
dir_fastqc_untrimmed=outputs/$SRA_REF/fastqc_untrimmed
mkdir -p $dir_fastqc_untrimmed/fastqc_summary
cat $dir_fastqc_untrimmed/*/summary.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_FAIL.txt


####################################
# Trimming reads
####################################
# Note, FASTQC analysis did not detect any contaminating adaptor sequences
mkdir -p outputs/$SRA_REF/fastq_trimmed
echo "Running Trimmomatic"
# Running trimmomatic
java -jar ~/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 \
              $DATA/${SRA_REF}_1.fastq.gz \
              $DATA/${SRA_REF}_2.fastq.gz \
              outputs/$SRA_REF/fastq_trimmed/${SRA_REF}_1.trimmed.fastq.gz \
              outputs/$SRA_REF/fastq_trimmed/${SRA_REF}_1.untrimmed.fastq.gz \
              outputs/$SRA_REF/fastq_trimmed/${SRA_REF}_2.trimmed.fastq.gz \
              outputs/$SRA_REF/fastq_trimmed/${SRA_REF}_2.untrimmed.fastq.gz \
              SLIDINGWINDOW:4:20

####################################
# Re-running fastqc on trimmed reads
####################################
# Making fastqc trimmed folder
mkdir -p outputs/$SRA_REF/fastqc_trimmed
# Re-running fastqc
echo "Running FastQC on trimmed reads"
fastqc outputs/$SRA_REF/fastq_trimmed/*.trimmed.fastq.gz --outdir=outputs/$SRA_REF/fastqc_trimmed/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/$SRA_REF/fastqc_trimmed/*.zip ; do
  unzip $FILENAME -d outputs/$SRA_REF/fastqc_trimmed/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
mkdir -p outputs/$SRA_REF/fastqc_trimmed/fastqc_summary
cat outputs/$SRA_REF/fastqc_trimmed/*/summary.txt > outputs/$SRA_REF/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN outputs/$SRA_REF/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt > outputs/$SRA_REF/fastqc_trimmed/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL outputs/$SRA_REF/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt > outputs/$SRA_REF/fastqc_trimmed/fastqc_summary/fastqc_summaries_FAIL.txt
