# Removing folder

# Setting working directory
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Creating outputs folder
mkdir -p outputs
# Defining data folder
DATA=../test_data

####################################
# Conducting Quality Control
####################################

# Loading fastqc
module load FastQC/0.11.5-Java-1.8.0_74
# Running fastqc on all fastq files
mkdir -p outputs/fastqc_untrimmed
echo "Running FastQC on untrimmed reads"
fastqc $DATA/*.fastq.gz --outdir=outputs/fastqc_untrimmed/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/fastqc_untrimmed/*.zip ; do
  unzip $FILENAME -d outputs/fastqc_untrimmed/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
dir_fastqc_untrimmed=outputs/fastqc_untrimmed
mkdir -p $dir_fastqc_untrimmed/fastqc_summary
cat $dir_fastqc_untrimmed/*/summary.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries.txt > $dir_fastqc_untrimmed/fastqc_summary/fastqc_summaries_FAIL.txt


####################################
# Trimming reads
####################################
# Note, FASTQC analysis did not detect any contaminating adaptor sequences
mkdir -p outputs/fastq_trimmed
echo "Running Trimmomatic"
# Loop that runs trimmomatic
for infile in $DATA/*_1.fastq.gz; do
base=$(basename ${infile} _1.fastq.gz)
java -jar ~/tools/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 4 \
              $DATA/${base}_1.fastq.gz \
              $DATA/${base}_2.fastq.gz \
              outputs/fastq_trimmed/${base}_1.trimmed.fastq.gz \
              outputs/fastq_trimmed/${base}_1.untrimmed.fastq.gz \
              outputs/fastq_trimmed/${base}_2.trimmed.fastq.gz \
              outputs/fastq_trimmed/${base}_2.untrimmed.fastq.gz \
              SLIDINGWINDOW:4:20
done

####################################
# Re-running fastqc on trimmed reads
####################################
# Making fastqc trimmed folder
mkdir -p outputs/fastqc_trimmed
# Re-running fastqc
echo "Running FastQC on trimmed reads"
fastqc outputs/fastq_trimmed/*.trimmed.fastq.gz --outdir=outputs/fastqc_trimmed/
# Unziping fastqc files
echo "Unzipping FastQC files"
for FILENAME in outputs/fastqc_trimmed/*.zip ; do
  unzip $FILENAME -d outputs/fastqc_trimmed/
done
# Concatenating Fastqc results
echo "Saving FastQC results"
mkdir -p outputs/fastqc_trimmed/fastqc_summary
cat outputs/fastqc_trimmed/*/summary.txt > outputs/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt
# Filtering for failed Fastqc results
grep WARN outputs/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt > outputs/fastqc_trimmed/fastqc_summary/fastqc_summaries_WARN.txt
grep FAIL outputs/fastqc_trimmed/fastqc_summary/fastqc_summaries.txt > outputs/fastqc_trimmed/fastqc_summary/fastqc_summaries_FAIL.txt
