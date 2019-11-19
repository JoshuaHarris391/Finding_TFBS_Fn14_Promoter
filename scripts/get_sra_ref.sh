# Definding input folder
SRA_DATA=/scratch/STUDENT+harjo391/JRA_5/raw_data

# Getting filenames
SRA_REF_NAMES=$(ls $SRA_DATA/*_1.fastq.gz)
SRA_REF_NAMES=$(basename -s _1.fastq.gz $SRA_REF_NAMES)

# Saving to file
echo $SRA_REF_NAMES > /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/SRA_Ref_Names.txt
