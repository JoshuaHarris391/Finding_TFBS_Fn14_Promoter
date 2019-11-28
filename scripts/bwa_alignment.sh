#!/bin/bash
#SBATCH --job-name=BWA_Align # job name (shows up in the queue)
#SBATCH --time=72:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=16000 # Memory in MB
#SBATCH --cpus-per-task=8
#SBATCH --output=slurm_%x_%j_array_%a.out

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Defining file with SRA refs
SRA_REF_NAMES_FILE=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/SRA_Ref_Names.txt
# Pulling nth line from file and defining SRA variable
SRA_REF=`sed "${SLURM_ARRAY_TASK_ID}q;d" $SRA_REF_NAMES_FILE`

# # Defining SRA ref temp
# SRA_REF='SRR8652105'

# Set wd
set -e
cd $OUTPUT_DATA
module purge

# Creating directories
mkdir -p  outputs/alignments/bam/$SRA_REF \
          outputs/variant_calls/vcf/$SRA_REF

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
				samtools view -S -b > outputs/alignments/bam/$SRA_REF/${SRA_REF}.aligned.bam
echo "[UPDATE] completed ${SRA_REF} alignment"

# Removing trimmed fastq files
rm -r outputs/fastq_trimmed/${SRA_REF}

# Sorting bam files
echo "[UPDATE] Sorting BAM files"
samtools sort --threads 16 -o outputs/alignments/bam/$SRA_REF/${SRA_REF}.aligned.sorted.bam \
                 outputs/alignments/bam/$SRA_REF/${SRA_REF}.aligned.bam


# Creating summary report for sorted bams
mkdir -p outputs/alignments/bam/$SRA_REF/metrics
samtools flagstat --threads 16 outputs/alignments/bam/$SRA_REF/${SRA_REF}.aligned.sorted.bam > \
                  outputs/alignments/bam/$SRA_REF/metrics/${SRA_REF}_bam_summary.txt
echo "[UPDATE] created flagstat summary for ${SRA_REF}"

# Merging into summary document
cat outputs/alignments/bam/*/metrics/*.txt > outputs/alignments/summary.txt
echo "[UPDATE] created summary document"

echo "[UPDATE] end of script"
