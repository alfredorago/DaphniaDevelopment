## SIRV checks

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

# Add SIRV metadata
SIRVdata = merge(SIRVdata, SIRV_annot, 
                 by.x = "transcriptID", by.y = 'row.names', 
                 all.x = T, all.y = F)

# Add sample metadata
SIRVdata = merge(SIRVdata, metadata, 
                 by.x = "sampleID", by.y = "row.names",
                 all.x = T, all.y = F)
head(SIRVdata)


# Compare expected vs observed SIRVs
# store concentrations of sirvs per mix per transcript
SIRVfmol = unique(SIRVdata[,c("geneID", "transcriptID", "E1_fmol.ul", "E2_fmol.ul")])
names(SIRVfmol) = c('geneID', 'transcriptID', 'E1', 'E2')
SIRVfmol = melt(SIRVfmol)
names(SIRVfmol) = c('geneID', 'transcriptID', 'sirv', 'fmol')
# merge with observed samples
SIRVquant = SIRVdata[,c("geneID", "transcriptID","tpm", "sampleID", "sirv")]
SIRVquant = merge(SIRVquant, SIRVfmol, by = c('geneID', 'transcriptID', 'sirv'), all.x = T, all.y = F)
#SIRVquant$fmol[which(is.na(SIRVquant$fmol))] = 0

ggplot(SIRVquant, mapping = aes(x = fmol, y = tpm)) +
  geom_point(position = 'jitter') + geom_smooth(method = 'lm') + 
  scale_x_log10() + scale_y_log10()

ggplot(SIRVquant[which(SIRVquant$tpm>1),],
       mapping = aes(x = fmol, y = tpm)) +
  geom_point(position = 'jitter') + geom_smooth(method = 'lm') + 
  scale_x_log10() + scale_y_log10() + facet_wrap(~geneID)

# Sum for all genes
# Calculate concentration of each SIRV gene
SIRVfmol_g = ddply(.data = SIRVfmol, .variables = .(sirv, geneID),
                   summarise,
                   fmol_g = sum(fmol, na.rm = T)/18.625) # Denominator from LEXOGEN sheet

# Sum observed transcript counts
SIRVquant_g = ddply(.data = SIRVquant, 
                    .variables = .(geneID, sirv, sampleID),
                    .fun = summarise,
                    tpm_g = sum(tpm))
# merge with expected concentrations
SIRVquant_g = merge(SIRVquant_g, SIRVfmol_g, by = c('geneID', 'sirv'), all.x = T, all.y = F)
# tpm vs concentrations
ggplot(SIRVquant_g, mapping = aes(x = fmol_g, y = tpm_g, col = sirv)) +
  geom_point(position = 'jitter') +  
  scale_x_log10() + scale_y_log10() +
  facet_wrap(~geneID)
# Test fold change detection via boxplots
ggplot(SIRVquant_g, mapping = aes(x = geneID, y = tpm_g, col = sirv)) +
  geom_boxplot(notch = T) +  
  scale_y_log10() 
# Reduce to only 4 replicates per contrast


# Check tpm pairs for each gene within each sirv mix (noise threshold)
E1_pairs = SIRVquant_g[which(SIRVquant_g$sirv=='E1'), c('geneID', 'sampleID', 'tpm_g')]
E1_pairs = dcast(data = E1_pairs, formula = sampleID~geneID)
pairs(log10(E1_pairs[,-1]))

# Compile mean and variance per RNA per sirv mix and plot
MA_data = ddply(SIRVquant[which(is.na(SIRVquant$fmol)==F),], 
                .variables = .(transcriptID), summarise, 
                meanE = mean(log10(tpm)),
                varE = var(log10(tpm)), 
                conc = log10(fmol),
                .progress = 'text')

ggplot(data = MA_data, 
       mapping = aes(x = meanE, y = varE, col = sirv)) + 
  geom_point() + geom_smooth()

ggplot(data = MA_data, 
       mapping = aes(x = meanE, y = varE, col = sirv)) + 
  geom_point() + geom_smooth(method = 'lm') + xlim(c(-1,3.3)) + ylim(c(0,2))


# add MA plots (mean expression vs difference betw treatments)

# Sorted by batch and extraction date
