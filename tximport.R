### Convert h5 files into tsv 

# Clean workspace and print date
rm(list=ls())
date()
# Load libraries
library(tximport)
library(stringr)

# Load experiment data
metadata = read.csv(file = "../Results/20180322/Metadata_compiler/sample_metadata.csv", header = T, row.names = 1)

# Set path of data files
files = file.path('../Results/20180319/Kallisto', row.names(metadata) , 'abundance.h5')

# Create transcript to gene reference table
tpm = read.table(file = '../Results/20180319/Kallisto/F58/abundance.tsv', header = T, row.names = 1)
IDtable = data.frame(transcriptID = row.names(tpm))
# Create gene names as substrings: SIRV and one numeric & any character before t
sapply(X = IDtable$transcriptID, FUN = function(x) {
  if (grepl(pattern = 'Dapma', x = x)) {
    str_extract(string = x, pattern = '^[^t]*')
  } else next
})

# 
tximport(files = files, files = 'kallisto')