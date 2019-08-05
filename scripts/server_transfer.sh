####################################
# [LOCAL TERMINAL] Run this in local terminal
####################################
# Pulling Fastqc Files
scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/fastqc_untrimmed \
    ~/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter/

scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/fastqc_trimmed \
    ~/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter/

# Pulling BAM files
scp -r STUDENT+harjo391@dsmc0.otago.ac.nz:~/JRA/JRA_5_TFBS_Fn14_Promoter/outputs/alignments/bam \
    ~/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experimentzs/JRA_5/JRA_5_TFBS_Fn14_Promoter/
