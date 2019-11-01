java -jar $GATK_PATH Mutect2 -R /resource/bundles/broad_bundle_b37_v2.5/human_g1k_v37_decoy.fasta -I test.bam --germline-resource /resource/bundles/gnomAD/vcf/genomes/gnomad.genomes.r2.0.2.sites.vcf.bgz -O out.vcf.gz

# Add -R to bwa mem or use picard AddOrReplaceReadGroups
# - Adds read groups to header of bam file
# MarkDuplicates see if its suggested with GATK4, older versions suggest using this
# Add this to Mutect2,
# --disable-sequence-dictionary-validation true
# Update file paths to absolute, and use /resource/bundles/ stuff

# Run scripts on /scratch
# Store data on HCS, transfer to scratch, run scripts, transfer output back to HCS, delete scratch
# Transfer all samples first
# If using GATK3 module, you need -T before MuTect2 
