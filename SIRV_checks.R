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
tpm$transcriptID = row.names(tpm)
# Reshape to flat data format
SIRVdata = melt(tpm)
names(SIRVdata) = c("transcriptID", "sampleID", "tpm")  
# Add metadata
SIRVdata = merge(SIRVdata, metadata, 
                 by.x = "sampleID", by.y = "row.names",
                 all.x = T, all.y = F)

# Check differences between SIRV transcripts across samples
ggplot(data = SIRVdata, aes(x = tpm, col = sirv)) +
  geom_density() + 
  scale_x_log10() + 
  facet_wrap(~transcriptID)

# Check using boxplots
ggplot(data = SIRVdata, aes(y = tpm, x = sirv)) +
  geom_boxplot(notch = T) + 
  scale_y_log10() + 
  facet_wrap(~transcriptID)


# Sorted by batch and extraction date


# Check for significant differences between different SIRV mixes