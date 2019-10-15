#' ---
#' title: "JRA_5 | Mapping TFBS to Fn14 promoter"
#' author: "Joshua Harris"
#' date: "2019_07_24"
#' ---
#' 
#' ## Description
#' - TFBS will be mapped on the Fn14 promoter region from the hg19 reference genome as well as various 
#' breast cancer cell lines
#' - The UCSC genome browser was used to obtain 2kb of sequence upstream of the TSS of Fn14 in 
#' the human reference genome as well as the 5'UTR (chr16:3068313-3070398)
#' - Pileup files obtained from the [SRA run browser](https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR8652107) 
#'were downloaded for the corresponding Fn14 region described above (chr16:3068313-3070398)
#' - SRR8652107 = MDAMB231 WGS
#' - The predicted TFBS for the cell line sequences well be compared to the predicted sites on the human reference genome.
#' - Changes in TFBS may provide insight into changes in Fn14 transcriptional regulation
#' - TFBS that are different between cell line and reference will be further analysed for causative mutations.
#' 


#' ## Loading and installing Packages
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("TFBSTools")

# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("JASPAR2018")
library('TFBSTools')
library('JASPAR2018')
library('tidyverse')

#' ## Creating JASPAR Library
suppressMessages(library(JASPAR2018))
opts <- list()
opts[["species"]] <- 9606
PFMatrixList <- getMatrixSet(JASPAR2018, opts)
PFMatrixList %>% summary() 
#' - PFMatrixList contains PFMatrix files for each TF, these will need to be converted to PWM

#' ## Converting PFM files to PWM
pwmList <- PFMatrixList %>% toPWM()

#' # Scanning Sequences for PWM pattern
library(Biostrings)
library(seqinr)
# Loading Reference sequence
Fn14_pro_refseq <- readDNAStringSet("Sequences/Reference/Fn14_2kb_up_5utr.fa")
Fn14_pro_refseq <- Fn14_pro_refseq %>% paste()
Fn14_pro_refseq <- DNAString(Fn14_pro_refseq)

# Checking TFBS in reference sequence
output_df_ref <- searchSeq(pwmList, Fn14_pro_refseq, seqname="Hg19_Fn14_2kb_upstrem_promoter",
                           min.score="60%", strand="*") %>% 
                                            writeGFF3() %>% 
                                            data.frame()
