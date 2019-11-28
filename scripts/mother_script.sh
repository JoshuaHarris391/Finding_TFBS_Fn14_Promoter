#!/bin/bash
#SBATCH --job-name=JRA_5_Mother # job name (shows up in the queue)
#SBATCH --time=1:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# Stop script if there is an error
set -e

# Setting Directory variables
SCRIPT_REF=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/scripts
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Setting WD
mkdir -p $OUTPUT_DATA
cd $OUTPUT_DATA


# Removing current outputs folder
rm -R outputs

# # Downloading and indexing GRCh37
# JOB_0=$(sbatch --parsable scripts/GRCh37_download_index.sh)

# Defining Data folder
DATA=../test_full_data/

# Getting filenames
filenames=$(ls $DATA/*_1.fastq.gz)
SRA_REF=$(basename -s _1.fastq.gz $filenames)

# Running quality control
for filename_input in ${SRA_REF[*]}; do
  echo "== Running QC on $filename_input =="
	# Use dependancy if running GRCh37 download
  # JOB_QC=$(sbatch --dependency=afterany:$JOB_0 --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/quality_control.sh)
	JOB_QC=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/quality_control.sh)
done

# Running alignment
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  JOB_BWA=$(sbatch --dependency=afterany:$JOB_QC --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/bwa_alignment.sh)
	# JOB_BWA=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/bwa_alignment.sh)
done

# Running markduplicates
for filename_input in ${SRA_REF[*]}; do
  echo "== Running MarkDuplicates on $filename_input =="
  JOB_MD=$(sbatch --dependency=afterany:$JOB_BWA --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/mark_duplicates.sh)
	# JOB_MD=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/mark_duplicates.sh)
done

# Running index bam files
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  JOB_BAM_I=$(sbatch --dependency=afterany:$JOB_MD --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/bam_index.sh)
	# JOB_BAM_I=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/bam_index.sh)
done

# Running base recalibration
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  JOB_RECAL=$(sbatch --dependency=afterany:$JOB_BAM_I --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/base_recalibration.sh)
	# JOB_RECAL=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/base_recalibration.sh)
done

# Running Mutect2
for filename_input in ${SRA_REF[*]}; do
  echo "== Mutect2 on $filename_input =="
  JOB_MUT=$(sbatch --dependency=afterany:$JOB_RECAL --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/Variant_Calling.sh)
	# JOB_MUT=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable $SCRIPT_REF/Variant_Calling.sh)
done

# moving slurm outputs to Directory
mkdir -p slurm_outputs
mv *.out slurm_outputs/

echo "== END OF HEAD SCRIPT=="

exit
