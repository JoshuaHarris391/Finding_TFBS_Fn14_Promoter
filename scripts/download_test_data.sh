# Set wd
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Download files
mkdir -p ../test_data
# Defining SRA references to Download
declare -a SRA_REF_LIST=("SRR8652107" "SRR8652105" "SRR8670674")

for SRA_REF_VAR in ${SRA_REF_LIST[@]}; do

~/tools/bin/fastq-dump --outdir ../test_data/ \
 --gzip \
 --skip-technical \
    --read-filter pass \
     --dumpbase \
      --split-files \
       --clip \
       -N 10000 \
       -X 110000 \
       $SRA_REF_VAR
done
# check file size
ls -l ../test_data | echo
# make read-only
chmod -w ../test_data/*.gz
