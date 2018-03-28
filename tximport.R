### Convert h5 files into tsv 

# Clean workspace and print date
rm(list=ls())
date()
# Load libraries
library(tximport)
library(stringr)

# Set path of data files
files = list.dirs(path = '../Results/20180319/Kallisto/', full.names = F)
files = grep(pattern = '^[A-Z][0-9]{2}$', x = files, value = T)
files = file.path('../Results/20180319/Kallisto', files , 'abundance.h5')

### Create transcript to gene reference table from first sample
tpm = read.table(file = '../Results/20180319/Kallisto/F58/abundance.tsv', header = T, row.names = 1)
IDtable = data.frame(transcriptID = row.names(tpm))
# Create gene names as substrings: SIRV and one numeric & any non t character after the start
IDtable$geneID = sapply(X = IDtable$transcriptID, FUN = function(x) {
  if (grepl(pattern = 'Dapma', x = x)) {
    str_extract(string = x, pattern = '^[^t]*')
  } else if (grepl(pattern = 'SIRV', x = x)) {
    str_extract(string = x, pattern = 'SIRV.?')
  }
}
)

# 
tximport(files = files, files = 'kallisto', tx2gene = IDtable)