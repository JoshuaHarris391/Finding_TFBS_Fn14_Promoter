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
library('tidyverse', warn.conflicts = F)

#' ## Creating JASPAR Library
suppressMessages(library(JASPAR2018))
opts <- list()
opts[["species"]] <- 9606
opts[["collection"]] <- "CORE"
# opts[["type"]] <- "ChIP-seq"
PFMatrixList <- getMatrixSet(JASPAR2018, opts)
PFMatrixList %>% summary() 
#' - PFMatrixList contains PFMatrix files for each TF, these will need to be converted to PWM

#' ## Converting PFM files to PWM
pwmList <- PFMatrixList %>% toPWM()
icmList <- PFMatrixList %>% toPWM()
#' # Scanning Sequences for PWM pattern
library(Biostrings)
library(seqinr)
# Loading Reference sequence
Fn14_pro_refseq <- readDNAStringSet("sequences/Fn14_3kb_up_5utr_hg19_ucsc.fasta")
Fn14_pro_refseq <- Fn14_pro_refseq %>% paste()
Fn14_pro_refseq <- DNAString(Fn14_pro_refseq)

# Checking TFBS in reference sequence
output_ref <- searchSeq(pwmList, Fn14_pro_refseq, seqname="Hg19_Fn14_2kb_upstrem_promoter",
                        min.score="80%", strand="*")
output_df_ref <- searchSeq(pwmList, Fn14_pro_refseq, seqname="Hg19_Fn14_2kb_upstrem_promoter",
                           min.score="80%", strand="*") %>% as( "data.frame")

# Making table of IDs
tfbs_ID_table <- table(output_df_ref$ID)
tfbs_ID_table <- tfbs_ID_table[unique(output_df_ref$ID)]

input_id <- names(tfbs_ID_table[1])
t<-PFMatrixList[[input_id]]
as.list(t)
PFMatrixList$MA0025.1 %>% as.character()
attr(PFMatrixList[[1]], "$species")

PFMatrixList@listData
slot(PFMatrixList[[1]], "species")
getSlots(PFMatrixList)

# Adding in relative scores
score_df <- unlist(relScore(output_ref)) %>% as.data.frame()
output_df_ref$relative_score <- score_df[, 1]
# Adding in emperical pvalues
pval_df <- unlist(pvalues(head(output_ref), type = "TFMPvalue")) %>% as.data.frame()
output_df_ref$pval_emperical <- pval_df[, 1]


# Updating chromosmal position details
output_df_ref$chromosome <- 16
output_df_ref$start <- output_df_ref$start + 3067313
output_df_ref$end <- output_df_ref$end + 3067313

# Exporting dataframe 
write.table(output_df_ref, file = 'tfbs_table/Fn14_3kb_up_core_tfbs_df.txt', sep = '\t')
