# Set wd
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Download files
mkdir -p ../test_data
~/tools/bin/fastq-dump --outdir ../test_data/ \
 --gzip \
 --skip-technical \
    --read-filter pass \
     --dumpbase \
      --split-files \
       --clip \
       -N 10000 \
       -X 110000 \
       SRR8652107
# check file size
ls -l ../test_data | echo
# make read-only
chmod -w ../test_data/*.gz
