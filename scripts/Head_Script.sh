# Setting WD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Removing current outputs folder
rm -R outputs
# Getting filenames
filenames=$(ls ../test_data/*_1.fastq.gz)
SRA_REF=$(basename -s _1.fastq.gz $filenames)
# Defining Data folder
DATA=../test_data
# Running sbatch on script
for filename_input in ${SRA_REF[*]}; do
  sbatch --export=SRA_REF=$filename_input,DATA=$DATA scripts/quality_control.sh
done
