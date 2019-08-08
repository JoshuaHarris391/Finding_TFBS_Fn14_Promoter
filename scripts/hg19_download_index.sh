# Setting WD
WORKING_DIR=/Users/joshua_harris/Dropbox/Research/JRA_Cunliffe_Lab_2019/Experiments/JRA_5/JRA_5_TFBS_Fn14_Promoter
cd $WORKING_DIR
# Downloading hg19 human reference genome
mkdir -p ../data/hg19
cd ../data/hg19
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/bigZips/hg19.fa.gz
chmod -w *.gz
gunzip hg19.fa.gz
cd $WORKING_DIR

# Indexing hg19 reference
echo "Indexing hg19 reference"
# module load "BWA/0.7.17-foss-2018b"
bwa index ../data/hg19/hg19.fa
