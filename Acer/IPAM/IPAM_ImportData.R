# Project set up
  getwd()
  library(plyr)
  library(dplyr)
  library(reshape2)

# Get all the data in one file
IPAM.data=ldply(list.files(path="IPAM-Raw", pattern=".csv", 
                           full.names=TRUE, recursive = TRUE),
             function(filename) {
      dum=(read.csv(filename, sep = ";", blank.lines.skip=T))
      dum$filename=filename
    return(dum)
})

# Remove unused columns
  IPAM.data[1:4] <- list(NULL)
  IPAM.data$X <-NULL

# Get pics number
  file.picture <- rbind.fill(lapply(strsplit(as.character(IPAM.data$filename), split="/"), 
                                         function(X) data.frame(t(X))))
  colnames(file.picture) <- c("Folder", "Date", "File")
  IPAM.data <- cbind(file.picture[,-1], IPAM.data)
  IPAM.data$filename <-NULL

# Change to long format
  IPAM.data <- na.omit(melt(IPAM.data, id=c("Date","File"),
                            variable.name = "variable.fragment"))

#  Merge with sample information and check for missing data

  fragments<-read.csv("Fragments.csv")
  
  ErrorI<-anti_join(fragments, IPAM.data, by =c("Date", "File", "variable.fragment"))
  ErrorII<-anti_join(IPAM.data, fragments, by =c("Date", "File", "variable.fragment"))
  
  IPAM.data2<-join(fragments, IPAM.data, by =c("Date", "File", "variable.fragment"), type="inner")
  IPAM.data2[6:8] <- list(NULL)

  IPAM.data_long<-reshape(IPAM.data2, idvar = c("Date", "Treatment", "Tank", "Fragment", "Picture"), 
                    timevar = "variable", direction = "wide")
  
# Export the data as a .csv?
  write.csv(IPAM.data_long, file="YII_2017-09-27.csv")

