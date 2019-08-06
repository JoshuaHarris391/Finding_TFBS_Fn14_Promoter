####################################
# [LOCAL TERMINAL] Run this in local terminal
####################################

# Setting WD
DEST=~/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter

# Pulling Fastqc Files
scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/fastqc_untrimmed $DEST

scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/fastqc_trimmed $DEST

# Pulling BAM files
scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/alignments/bam $DEST
