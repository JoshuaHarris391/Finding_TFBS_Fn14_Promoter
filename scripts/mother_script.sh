# Stop script if there is an error
set -e

# Setting WD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter

# Removing slurm outputs
touch tmp.out
rm *.out

# Removing current outputs folder
rm -R outputs

# # Downloading and indexing GRCh37
# JOB_0=$(sbatch --parsable scripts/GRCh37_download_index.sh)

# Getting filenames
filenames=$(ls ../test_data/*_1.fastq.gz)
SRA_REF=$(basename -s _1.fastq.gz $filenames)

# Defining Data folder
DATA=../test_data

# Running quality control
for filename_input in ${SRA_REF[*]}; do
  echo "== Running QC on $filename_input =="
	# Use dependancy if running GRCh37 download
  # JOB_1=$(sbatch --dependency=afterany:$JOB_0 --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/quality_control.sh)
	JOB_1=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/quality_control.sh)
done

# Running alignment
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  # JOB_2=$(sbatch --dependency=afterany:$JOB_1 --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/bwa_alignment.sh)
	JOB_2=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/bwa_alignment.sh)
done

# Running Mutect2
# for filename_input in ${SRA_REF[*]}; do
#   echo "== Mutect2 on $filename_input =="
#   JOB_3=$(sbatch --dependency=afterany:$JOB_2 --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/Variant_Calling.sh)
# done

echo "== END OF HEAD SCRIPT=="
