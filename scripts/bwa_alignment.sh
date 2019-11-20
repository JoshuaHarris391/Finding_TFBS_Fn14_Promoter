#!/bin/bash
#SBATCH --job-name=BWA_Align # job name (shows up in the queue)
#SBATCH --time=72:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=20000 # Memory in MB
#SBATCH --cpus-per-task=8
#SBATCH --output=slurm_%x_%j.out

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Set wd
set -e
cd $OUTPUT_DATA
module purge

# Creating directories
mkdir -p  outputs/alignments/sam \
          outputs/alignments/bam \
          outputs/variant_calls/vcf \
          outputs/variant_calls/bcf

#################################
# Alignment BWA
#################################
echo "[UPDATE] Begining BWA Alignment"
module load "BWA/0.7.17-foss-2018b"
module load 'SAMtools'
# # Indexing hg19 reference
# echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
# bwa index GRCh37/human_g1k_v37_decoy.fasta

echo "[UPDATE] Running BWA mem aligner"
# Running bwa mem aligner
bwa mem -t 8 \
				-R '@RG\tID:group1\tSM:sample1\tPL:illumina\tLB:lib1\tPU:unit1' \
				-P /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta \
        outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_1.trimmed.fastq.gz \
        outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_2.trimmed.fastq.gz | \
				samtools view -S -b > outputs/alignments/bam/${SRA_REF}.aligned.bam
echo "[UPDATE] completed ${SRA_REF} alignment"

# Removing trimmed fastq files
rm -r outputs/fastq_trimmed

# Sorting bam files
echo "[UPDATE] Sorting BAM files"
samtools sort -o outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam \
                 outputs/alignments/bam/${SRA_REF}.aligned.bam


# Creating summary report for sorted bams
mkdir -p outputs/alignments/bam/metrics
samtools flagstat outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam > \
                  outputs/alignments/bam/metrics/${SRA_REF}_bam_summary.txt
echo "[UPDATE] created flagstat summary for ${SRA_REF}"

# Merging into summary document
cat outputs/alignments/bam/metrics/*.txt > outputs/alignments/bam/summary.txt

# Marking duplicates
module load picard
java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam M=outputs/alignments/bam/${SRA_REF}_MarkDuplicates.txt

# Removing Sorted bam file
rm outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam

# Indexing bam files
echo "[UPDATE] indexing bam files"
samtools index outputs/alignments/bam/${SRA_REF}.dedup.aligned.sorted.bam
echo "[UPDATE] indexed ${SRA_REF}.aligned.sorted.bam"

echo "[UPDATE] end of script"
