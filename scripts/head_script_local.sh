# Setting WD
WORKING_DIR=/Users/joshua_harris/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter
cd $WORKING_DIR
# Removing slurm outputs
rm *.out
# Removing current outputs folder
rm -R outputs
# Getting filenames
cd $WORKING_DIR/../test_data
SRA_REF=$(find . -name "*_1\.fastq\.gz"  | sed -e 's/\_1\.fastq\.gz$//' | sed -e 's/\.\///')
cd $WORKING_DIR

# Defining Data folder
DATA=../test_data
# Running quality control
for filename_input in ${SRA_REF[*]}; do
  echo "== Running QC on $filename_input =="
  source scripts/quality_control.sh &
done

# Running alignment
for filename_input in ${SRA_REF[*]}; do
  echo "== Running alignment on $filename_input =="
  source scripts/bwa_variant_calling.sh &
done

echo "== END OF HEAD SCRIPT=="
