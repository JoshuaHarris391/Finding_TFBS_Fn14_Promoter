#!/bin/bash
#SBATCH --job-name=transfer_vcf_hcs # job name (shows up in the queue)
#SBATCH --time=48:00:00 #Walltime (HH:MM:SS)
#SBATCH --mem=1000 # Memory in MB
#SBATCH --cpus-per-task=1
#SBATCH --output=slurm_%x_%j.out

# Setting Directory variables
OUTPUT_DATA=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter
# Defining file with SRA refs
SRA_REF_NAMES_FILE=/home/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter/SRA_Ref_Names.txt

# Creating backup_Zip
for i in {1..4}; do
	#statements
	# Pulling nth line from file and defining SRA variable
	SRA_REF=`sed "${i}q;d" $SRA_REF_NAMES_FILE`

	# defining VCF path
	VCF_PATH=/scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter/outputs/variant_calls/vcf/${SRA_REF}

	# Zipping folder
	zip ${VCF_PATH}/${SRA_REF}_backup.zip ${VCF_PATH}


done



# transfering from /scratch to hcs
DEST=/mnt/hcs/dsm-molecularoncology/Josh_Harris_Bioinformatics/JRA_5/outputs/

rsync -vr /scratch/STUDENT+harjo391/JRA_5/JRA_5_TFBS_Fn14_Promoter/outputs/variant_calls/vcf $DEST
