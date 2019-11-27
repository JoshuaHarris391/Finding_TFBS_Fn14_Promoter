#' ## Loading and installing Packages
if (!requireNamespace("BiocManager", quietly = TRUE)){
  install.packages("BiocManager")
}
BiocManager::install(c("TFBSTools", 'JASPAR2018', 'Biostrings', 'seqinr', 'BiocGenerics'))
# Installing tidyverse
# install.packages('tidyverse', lib = './R_libs')