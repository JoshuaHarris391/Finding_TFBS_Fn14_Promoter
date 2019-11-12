# Setting variables
cd /home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter
# Edit download links with: nano download_links.txt
LINKS=$(cat download_links.txt)

# initiating download loop
for i in $LINKS; do
	JOB_DOWNLOAD=$(sbatch --export=DOWNLOAD_LINK=$i --parsable scripts/sbatch_download_fastq.sh)
done

sbatch --dependency=afterany:$JOB_DOWNLOAD scripts/transfer_raw_data_hcs.sh
