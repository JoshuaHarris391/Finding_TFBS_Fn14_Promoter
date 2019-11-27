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


#' #' ## Loading and installing Packages
#' if (!requireNamespace("BiocManager", quietly = TRUE)){
#'   install.packages("BiocManager", lib = './R_libs')
#' }
#' BiocManager::install(c("TFBSTools", 'JASPAR2018', 'Biostrings', 'seqinr', 'BiocGenerics'), lib = './R_libs')
#' # Installing tidyverse
#' install.packages('tidyverse', lib = './R_libs')

# Defining library location
setwd("/resource/domains/STUDENT/harjo391/JRA/JRA_5_TFBS_Fn14_Promoter")
Lib_loc <- "./R_libs"

library('TFBSTools', lib.loc = Lib_loc)
library('BiocGenerics', lib.loc = Lib_loc)
library('JASPAR2018', lib.loc = Lib_loc)
library('tidyverse', warn.conflicts = F, lib.loc = Lib_loc)

#' ## Creating JASPAR Library
suppressMessages(library(JASPAR2018))
opts <- list()
opts[["species"]] <- 9606
opts[["collection"]] <- "CORE"
# opts[["type"]] <- "ChIP-seq"
PFMatrixList <- getMatrixSet(JASPAR2018, opts)
PFMatrixList %>% summary() 
#' - PFMatrixList contains PFMatrix files for each TF, these will need to be converted to PWM


#' # Loading sql query
JASPAR_Annot_DF <- read.csv(file = "JASPAR_SQL/JASPAR_homo_sapien_TF_annotation.csv", header = T, na.strings = c("", "NA"))
# Converting BASE_ID to character vector
JASPAR_Annot_DF$BASE_ID <- JASPAR_Annot_DF$BASE_ID %>% as.character()

#' ## Converting PFM files to PWM
pwmList <- PFMatrixList %>% toPWM()
icmList <- PFMatrixList %>% toPWM()

#' # Scanning Sequences for PWM pattern
library('Biostrings', lib.loc = Lib_loc)
library('seqinr', lib.loc = Lib_loc)

# Loading Reference sequence
Fn14_pro_refseq <- readDNAStringSet("sequences/Fn14_3kb_up_5utr_hg19_ucsc.fasta")
Fn14_pro_refseq <- Fn14_pro_refseq %>% paste()
Fn14_pro_refseq <- DNAString(Fn14_pro_refseq)

# Checking TFBS in reference sequence
output_ref <- searchSeq(pwmList, Fn14_pro_refseq, seqname="Hg19_Fn14_3kb_upstrem_promoter",
                        min.score="80%", strand="*")
output_df_ref <- searchSeq(pwmList, Fn14_pro_refseq, seqname="Hg19_Fn14_3kb_upstrem_promoter",
                           min.score="80%", strand="*") %>% as( "data.frame")


# Updating chromosmal position details
output_df_ref$chromosome <- 16
output_df_ref$start <- output_df_ref$start + 3067313
output_df_ref$end <- output_df_ref$end + 3067313
# Function to stich together full genomic region
genom_reg <- function(start, end, chromosome){
  x <- paste('chr', chromosome, ':', start, '-', end, sep = '')
  return(x)
}
output_df_ref$location <- genom_reg(output_df_ref$start, output_df_ref$end, output_df_ref$chromosome)
# Adding distance from ATG
output_df_ref$dist_atg_start <- 3070398- output_df_ref$start
output_df_ref$dist_atg_end <- 3070398- output_df_ref$end


# Joining JASPAR annotation df with output_df by ID
output_df_ref$BASE_ID <- gsub('\\.\\d', "", output_df_ref$ID)
output_df_ref_join <- dplyr::left_join(output_df_ref, JASPAR_Annot_DF, by = "BASE_ID")

# Subsetting columns of intrest
exclude_cols <- c("source", 'NAME', 'CLASS')
export_df <- output_df_ref_join[, !(colnames(output_df_ref_join) %in% exclude_cols)]
# Renaming some columns
colnames(export_df)[colnames(export_df) == 'ID.x'] <- "FULL_TF_ID"
colnames(export_df)[colnames(export_df) == 'ID.y']  <- "SAMPLE_ID"
colnames(export_df)[colnames(export_df) == 'TF']  <- "TF_NAME"
colnames(export_df)[colnames(export_df) == 'SOURCE']  <- "EXPERIMENTAL_SOURCE"
# making colnames uppper case
colnames(export_df) <- colnames(export_df) %>% toupper()

# Reordering Cols
col_order <- c("SAMPLE_ID",
               "SEQNAMES",
               "COLLECTION",
               "FEATURE",
               "TAX_ID",
               "BASE_ID",
               "FULL_TF_ID",
               "TF_NAME",
               "SITESEQS",
               "CHROMOSOME",
               "START",
               "END",
               "STRAND",
               "LOCATION",
               "DIST_ATG_START",
               "DIST_ATG_END",
               "FAMILY",
               "CLASS",
               "EXPERIMENTAL_SOURCE",
               "MEDLINE",
               "TYPE",
               "DESCRIPTION",
               "CONSENSUS",
               "COMMENT",
               "ABSSCORE",
               "RELSCORE")
export_df <- export_df[, col_order]

# Renaming some more columns
colnames(export_df)[colnames(export_df) == 'ABSSCORE'] <- "ABS_SCORE"
colnames(export_df)[colnames(export_df) == 'RELSCORE'] <- "REL_SCORE"
colnames(export_df)[colnames(export_df) == 'SEQNAMES'] <- "SEQ_NAMES"
colnames(export_df)[colnames(export_df) == 'SITESEQS'] <- "SITE_SEQS"

# Adding in emperical pvalues
pval_df <- unlist(pvalues(output_ref, type = "TFMPvalue")) %>% as.data.frame()
export_df$PVAL_EMPERICAL <- pval_df[, 1]

# Adding in adjusted pvalue
export_df$ADJUST_PVAL <- p.adjust(export_df$PVAL_EMPERICAL, method = "BH", n = length(export_df$PVAL_EMPERICAL))

# Creating Value Filtered DF
export_df_sig <- export_df[export_df$ADJUST_PVAL < 0.05, ]

# Getting list of unique transcription factors 
unique_tf <- unique(export_df$TF_NAME)[order(unique(export_df$TF_NAME))]
unique_tf_sig <- unique(export_df_sig$TF_NAME)[order(unique(export_df_sig$TF_NAME))]

# Exporting dataframe 
write.csv(export_df, file = 'tfbs_table/Fn14_3kb_up_JASPAR_TFBS.csv')
write.csv(export_df_sig, file = 'tfbs_table/Fn14_3kb_up_JASPAR_TFBS_SIGNIF.csv')

# Exporting lists
write(unique_tf, file = "tfbs_table/Fn14_unique_TF.txt")
write(unique_tf_sig, file = "tfbs_table/Fn14_unique_TF_signif.txt")
