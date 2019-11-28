# Lowest Relative score is MA0477.1
low_rel_df <-export_df[order(export_df$REL_SCORE), c("FULL_TF_ID", "REL_SCORE")] %>% as.data.frame()
print(low_rel_df[1, ])

# Calculating Pvalue
unlist(TFBSTools::pvalues(output_ref[paste(low_rel_df[1, 1])], type = "TFMPvalue")) %>% print()
