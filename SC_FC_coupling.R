#set working directory
setwd("~/PhD study_3/Wave 2/SC_FC ")

#loading the packages
packages <- c("tidyverse", "ggplot2","gdata","dplyr","psych","tidyverse","readxl","writexl","plyr")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}
lapply(packages, library, character.only = TRUE)

#read roi.xlsx to add column names to SC and FC data
roi <- read_excel("roi.xlsx")
#listing the FC and SC files
dir1 <- list.files(pattern = "*.xlsx", path = "FC_final/", full.names = TRUE, recursive = FALSE)
dir2 <- list.files(pattern = "*.xlsx", path = "SC_final/", full.names = TRUE, recursive = FALSE)
#combining the path of SC and FC files in one dataframe
#converting list to string
newdfList <- lapply(1:242, function(i){
  df_fc <- read_excel(dir1[i], col_names = FALSE)
  df_sc <- read_excel(dir2[i], col_names = FALSE)
  colnames(df_fc)<-paste(colnames(roi))
  colnames(df_sc)<-paste(colnames(roi))
  df_fc_clean <- df_fc[,!sapply(df_fc, function(col) all(col == 0))]
  df_sc_clean <- df_sc[,!sapply(df_sc, function(col) all(col == 0))]
  df_fc_clean <- df_fc_clean[, intersect(colnames(df_sc_clean), colnames(df_fc_clean))]
  df_fc_sc <- corr.test(df_fc_clean,df_sc_clean,method="spearman", adjust="none")
 
})
