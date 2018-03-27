### SIRV report

# load libraries
library(ggplot2)
library(reshape2)
library(plyr)
library(stringr)

# Load datasets
tpm = read.csv(file = "../Results/20180322/Read_compiler/tpmTable.csv", 
               header = T, row.names = 1)
metadata = read.csv(file = "../Results/20180322/Metadata_compiler/sample_metadata.csv", 
                    header = T, row.names = 1)
SIRV_annot = read.csv(file = "../SourceDatasets/Sample_Metadata/SIRV_annotation_fromLexogen.csv", 
                      header = T, row.names = 1)
SIRV_annot$geneID = str_extract(string = row.names(SIRV_annot), pattern = "SIRV.?")

# Subset only to SIRV transcripts
tpm = tpm[grep(pattern = "SIRV", x = row.names(tpm)),]
tpm$transcriptID = as.factor(row.names(tpm))

# Reshape to flat data format
SIRVdata = melt(tpm)
names(SIRVdata) = c("transcriptID", "sampleID", "tpm")  

# Add sample metadata
SIRVdata = merge(SIRVdata, metadata, 
                 by.x = "sampleID", by.y = "row.names",
                 all.x = T, all.y = F)

# Annotate SIRV concentration
SIRV_conc = SIRV_annot[,c("E1_fmol.ul", "E2_fmol.ul")]
SIRV_conc$transcriptID = row.names(SIRV_conc)
SIRV_conc = melt(SIRV_conc, id.vars = "transcriptID")
names(SIRV_conc) = c("transcriptID", "sirv", "conc")
SIRV_conc$sirv = as.factor(str_extract(string = SIRV_conc$sirv, pattern = "^[:alnum:]*"))
merge(x = SIRVdata, y = SIRV_conc, 
      by = c("transcriptID", "sirv"), 
      all.x = T, all.y = T)

# Check format
head(SIRVdata)

### Check read counts for zero abundance SIRVs (True Negatives)
head(SIRV_annot)

ggplot()


### Check minimal concentration of detected SIRVs (Detection Threshold)


### Plot variance vs mean SIRV expression within treatment (quatitative threshold)