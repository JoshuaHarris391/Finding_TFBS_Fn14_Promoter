# Set wd
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
DATA=../test_data

# Creating directories
mkdir -p  outputs/alignments/sam \
          outputs/alignments/bam \
          outputs/variant_calls/vcf \
          outputs/variant_calls/bcf

# Downloading hg19 human reference genome
# mkdir -p ../data/hg19
# cd ../data/hg19
# wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz
# chmod -w *.gz
# gunzip hg19.fa.gz
# cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

#################################
# Alignment BWA
#################################
echo "Begining BWA Alignment"
module load "BWA/0.7.17-foss-2018b"
# # Indexing hg19 reference
# echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
# bwa index hg19/hg19.fa

echo "Running BWA mem aligner"

bwa mem -t 4 -P ../data/hg19/hg19.fa \
        outputs/fastq_trimmed/SRR8652105_pass_1.trimmed.fastq.gz \
        outputs/fastq_trimmed/SRR8652105_pass_2.trimmed.fastq.gz > \
        outputs/alignments/sam/SRR8652105.aligned.sam
echo "finished alignment"
