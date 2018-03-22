## SIRV checks

# load libraries
library(ggplot2)
library(reshape2)

# Load datasets
tpm = read.csv(file = "../Results/20180322/Read_compiler/tpmTable.csv", 
                      header = T, row.names = 1)
metadata = read.csv(file = "../Results/20180322/Metadata_compiler/sample_metadata.csv", 
                    header = T, row.names = 1)

# Subset only to SIRV transcripts
tpm = tpm[grep(pattern = "SIRV", x = row.names(tpm)),]
# Reshape to flat data format
SIRVdata = melt(tpm)
names(SIRVdata) = c("sampleID", "tpm")  
# Add metadata
SIRVdata = merge(SIRVdata, metadata, 
                 by.x = "sampleID", by.y = "row.names",
                 all.x = T, all.y = F)

# Check consistency of SIRV transcripts across samples


# Sorted by batch and extraction date


# Normalize by SIRV