# Setting WD
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Making test director
mkdir -p head_test
# Creating a file
filenames=(Josh.txt Brett.txt Sean.txt Liam.txt)
for i in ${filenames[*]}; do
  touch head_test/$i
done

# Running sbatch on script
for filename_input in ${filenames[*]}; do
  sbatch --export=filename_input=$filename_input scripts/head_test_slurm.sh
done

# echo | ls head_test
