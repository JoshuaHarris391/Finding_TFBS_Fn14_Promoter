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
echo "[UPDATE] Begining BWA Alignment"
module load "BWA/0.7.17-foss-2018b"
# # Indexing hg19 reference
# echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
# bwa index hg19/hg19.fa

echo "[UPDATE] Running BWA mem aligner"

for BWA_FILE in outputs/fastq_trimmed/*_1.trimmed.fastq.gz; do
base=$(basename ${BWA_FILE} _1.trimmed.fastq.gz)
bwa mem -t 4 -P ../data/hg19/hg19.fa \
        outputs/fastq_trimmed/${base}_1.trimmed.fastq.gz \
        outputs/fastq_trimmed/${base}_2.trimmed.fastq.gz > \
        outputs/alignments/sam/${base}.aligned.sam
echo "[UPDATE] completed $base alignment"
done

#################################
# Convert to Bam
#################################
echo "[UPDATE] converting to bam file"
module load 'SAMtools/1.9-foss-2016b'
# Converting to bam
for SAM_FILE in outputs/alignments/sam/*.aligned.sam; do
  base=$(basename ${SAM_FILE} .aligned.sam)
  samtools view -S -b outputs/alignments/sam/$base.aligned.sam > \
                      outputs/alignments/bam/$base.aligned.bam
  echo "[UPDATE] converted $base to bam"
done

# Sorting bam files
echo "[UPDATE] Sorting BAM files"
for BAM_FILE in outputs/alignments/bam/*.aligned.bam; do
  base=$(basename ${BAM_FILE} .aligned.bam)
  samtools sort -o outputs/alignments/bam/$base.aligned.sorted.bam \
                   outputs/alignments/bam/$base.aligned.bam
done


# Creating summary report for sorted bams
mkdir -p outputs/alignments/bam/metrics
for flag_FILE in outputs/alignments/bam/*.aligned.sorted.bam; do
  base=$(basename ${flag_FILE} .aligned.sorted.bam)
  samtools flagstat outputs/alignments/bam/${base}.aligned.sorted.bam > \
                    outputs/alignments/bam/metrics/${base}_bam_summary.txt
  echo "[UPDATE] created flagstat summary for ${base}"
done
# Merging into summary document
cat outputs/alignments/bam/metrics/*.txt > outputs/alignments/bam/summary.txt

# Indexing bam files
echo "[UPDATE] indexing bam files"

for flag_FILE in outputs/alignments/bam/*.aligned.sorted.bam; do
  base=$(basename ${flag_FILE} .aligned.sorted.bam)
  samtools index outputs/alignments/bam/${base}.aligned.sorted.bam
  echo "[UPDATE] indexed ${base}.aligned.sorted.bam"
done

echo "[UPDATE] end of script"
