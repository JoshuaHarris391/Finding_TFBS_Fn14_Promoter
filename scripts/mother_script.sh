# Stop script if there is an error
set -e
# Setting WD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Removing slurm outputs
rm *.out
# Removing current outputs folder
rm -R outputs
# Getting filenames
filenames=$(ls ../test_data/*_1.fastq.gz)
SRA_REF=$(basename -s _1.fastq.gz $filenames)
# Defining Data folder
DATA=../test_data
# Running quality control
for filename_input in ${SRA_REF[*]}; do
  echo "== Running QC on $filename_input =="
  JOB_1=$(sbatch --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/quality_control.sh)
done

# Running alignment
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  JOB_2=$(sbatch --dependency=afterany:$JOB_1 --export=SRA_REF=$filename_input,DATA=$DATA --parsable scripts/bwa_alignment.sh)
done

echo "== END OF HEAD SCRIPT=="
