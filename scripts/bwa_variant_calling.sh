# Set wd
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Creating directories
mkdir -p  outputs/alignments/sam \
          outputs/alignments/bam \
          outputs/variant_calls/vcf \
          outputs/variant_calls/bcf

# Downloading hg19 human reference genome
# mkdir hg19
# cd hg19
# wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz
# chmod -w *.gz
# gunzip hg19.fa.gz
# cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

#################################
# Alignment BWA
#################################
echo "Begining BWA Alignment"
# # Indexing hg19 reference
# echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
# bwa index hg19/hg19.fa

echo "Running BWA mem aligner"

bwa mem data/ref_genome/ecoli_rel606.fasta \
        data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq \
        data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq > \
        results/sam/SRR2584866.aligned.sam
