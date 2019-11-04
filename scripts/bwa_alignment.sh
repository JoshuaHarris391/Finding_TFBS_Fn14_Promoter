#!/bin/bash
#SBATCH --job-name=BWA_Align # job name (shows up in the queue)
#SBATCH --time=24:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=10000 # Memory in MB
#SBATCH --cpus-per-task=8
#SBATCH --output="${SRA_REF}BWA_Align.out"

# Set wd
set -e
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
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
# # Indexing hg19 reference
# echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
# bwa index GRCh37/human_g1k_v37_decoy.fasta

echo "[UPDATE] Running BWA mem aligner"

bwa mem -t 8 -P /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta \
        outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_1.trimmed.fastq.gz \
        outputs/fastq_trimmed/$SRA_REF/${SRA_REF}_2.trimmed.fastq.gz > \
        outputs/alignments/sam/${SRA_REF}.aligned.sam
echo "[UPDATE] completed ${SRA_REF} alignment"

#################################
# Convert to Bam
#################################
echo "[UPDATE] converting to bam file"
module load "SAMtools/1.9-foss-2018a"
# Converting to bam
samtools view -S -b outputs/alignments/sam/${SRA_REF}.aligned.sam > \
                    outputs/alignments/bam/${SRA_REF}.aligned.bam
echo "[UPDATE] converted ${SRA_REF} to bam"

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

# Indexing bam files
echo "[UPDATE] indexing bam files"
samtools index outputs/alignments/bam/${SRA_REF}.aligned.sorted.bam
echo "[UPDATE] indexed ${SRA_REF}.aligned.sorted.bam"

# Marking duplicates
module load picard
java -jar $EBROOTPICARD/picard.jar MarkDuplicates I=outputs/alignments/bam/${SRA_REF}_pass.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}_pass.aligned.sorted.bam M=${SRA_REF}_MarkDuplicates.txt

# Defining Read groups
java -jar $EBROOTPICARD/picard.jar AddOrReplaceReadGroups I=outputs/alignments/bam/${SRA_REF}_pass.aligned.sorted.bam O=outputs/alignments/bam/${SRA_REF}_pass.aligned.sorted.bam PU=BARCODE PL=ILLUMINA LB=GROUP RGSM=RGSM


echo "[UPDATE] end of script"
