# loading Packages
install.packages('foreach')
install.packages('doParallel')

library('foreach')
library('doParallel')

cores=detectCores()
cl <- makeCluster(cores[1]-2) #not to overload your computer
registerDoParallel(cl)

pval_list <- list()
pval_list <- foreach(i=1:30) %dopar% {
        
            #loop contents here
            unlist(TFBSTools::pvalues(output_ref[i], type = "TFMPvalue"))
          }

#stop cluster
stopCluster(cl)
