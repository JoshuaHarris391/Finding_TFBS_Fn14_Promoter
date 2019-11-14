#!/bin/bash
#SBATCH --job-name=Fastqc_Trim # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=12000 # Memory in MB
#SBATCH --cpus-per-task=4
#SBATCH --output=slurm_%x_%j.out


# Setting working directory
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Purging modules
module purge
# Creating outputs folder
# mkdir -p outputs

####################################
# Conducting Quality Control
####################################

# Loading fastqc
module load FastQC/0.11.5-Java-1.8.0_74
# Running fastqc on all fastq files
mkdir -p outputs/fastqc_untrimmed/$SRA_REF
echo "Running FastQC on untrimmed reads"
fastqc -t 4 $DATA/*.fastq.gz --outdir=outputs/fastqc_untrimmed/$SRA_REF/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/fastqc_untrimmed/$SRA_REF/*.zip ; do
  unzip $FILENAME -d outputs/fastqc_untrimmed/$SRA_REF/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
dir_fastqc_untrimmed=outputs/fastqc_untrimmed/$SRA_REF
mkdir -p $dir_fastqc_untrimmed/fastqc_summary
cat $dir_fastqc_untrimmed/*/summary.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_FAIL.txt


####################################
# Trimming reads
####################################
# Note, FASTQC analysis did not detect any contaminating adaptor sequences
mkdir -p outputs/fastq_trimmed/$SRA_REF
echo "Running Trimmomatic"
# Running trimmomatic
java -jar ~/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 \
              $DATA/${SRA_REF}_1.fastq.gz \
              $DATA/${SRA_REF}_2.fastq.gz \
              outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_1.trimmed.fastq.gz \
              outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_1.untrimmed.fastq.gz \
              outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_2.trimmed.fastq.gz \
              outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_2.untrimmed.fastq.gz \
              SLIDINGWINDOW:4:30

####################################
# Re-running fastqc on trimmed reads
####################################
# Making fastqc trimmed folder
mkdir -p outputs/fastqc_trimmed/$SRA_REF
# Re-running fastqc
echo "Running FastQC on trimmed reads"
fastqc -t 4 outputs/fastq_trimmed/$SRA_REF/*.trimmed.fastq.gz --outdir=outputs/fastqc_trimmed/$SRA_REF/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/fastqc_trimmed/$SRA_REF/*.zip ; do
  unzip $FILENAME -d outputs/fastqc_trimmed/$SRA_REF/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
mkdir -p outputs/fastqc_trimmed/$SRA_REF/fastqc_summary
cat outputs/fastqc_trimmed/$SRA_REF/*/summary.txt > outputs/fastqc_trimmed/$SRA_REF/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN outputs/fastqc_trimmed/$SRA_REF/fastqc_summary/fastqc_summaries.txt > outputs/fastqc_trimmed/$SRA_REF/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL outputs/fastqc_trimmed/$SRA_REF/fastqc_summary/fastqc_summaries.txt > outputs/fastqc_trimmed/$SRA_REF/fastqc_summary/fastqc_summaries_FAIL.txt
