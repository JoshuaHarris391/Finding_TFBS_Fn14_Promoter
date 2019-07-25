# Setting working directory
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Loading fastqc
module load FastQC/0.11.5-Java-1.8.0_74
# Running fastqc on all fastq files
mkdir -p fastqc_untrimmed
fastqc ../test_data/*.fastq.gz --outdir=fastqc_untrimmed/
