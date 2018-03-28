### Convert h5 files into tsv 

# Clean workspace and print date
rm(list=ls())
date()

# Load libraries
library(tximport)
library(stringr)

# Set output path
outdir = file.path("../Results", format(Sys.Date(), format = "%Y%m%d"), "tximport")
dir.create(outdir, recursive = T)

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

### Import sample annotation and subset to sequenced samples
sampleData = read.csv('../Results/20180322/Metadata_compiler/sample_metadata.csv', 
                  header = T, row.names = 1)
sampleData = sampleData[which(row.names(sampleData)%in%str_extract(string = files, pattern = '[A-Z][0-9]{2}')),]
sampleData$stage = as.factor(sampleData$stage) 

### Import counts and convert to integers for DESeq analyses
txTranscript = tximport(files = files, type = 'kallisto', tx2gene = IDtable, 
                        abundanceCol = 'tpm', lengthCol = 'length', 
                        txOut = T)
deseqTranscript = DESeqDataSetFromTximport(txi = txTranscript, 
                                           colData = sampleData, 
                                           design = ~ stage + treatment + stage:treatment + sirv)
### Save for further analyses
write.csv(x = counts(deseqTranscript), file = file.path(outdir, 'DESeq_transcript_counts.csv'))