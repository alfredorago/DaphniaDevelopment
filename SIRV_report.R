### SIRV report

# Clean workspace and print date
rm(list=ls())
date()

# load libraries
library(ggplot2)
library(reshape2)
library(plyr)
library(stringr)
library(DESeq2)

# Load datasets
tpm = read.csv(file = "../Results/20180322/Read_compiler/tpmTable.csv", 
               header = T, row.names = 1)
rpkm = read.csv(file = "../Results/20180322/Read_compiler/countTable.csv",
                header = T, row.names = 1)
counts = read.csv(file = '../Results/20180328/tximport/DESeq_transcript_counts.csv', 
                  header = T, row.names = 1)

metadata = read.csv(file = "../Results/20180322/Metadata_compiler/sample_metadata.csv", 
                    header = T, row.names = 1)
SIRV_annot = read.csv(file = "../SourceDatasets/Sample_Metadata/SIRV_annotation_fromLexogen.csv", 
                      header = T, row.names = 1)

# Subset only to SIRV transcripts
tpm = tpm[grep(pattern = "SIRV", x = row.names(tpm)),]
tpm$transcriptID = as.factor(row.names(tpm))

rpkm = rpkm[grep(pattern = "SIRV", x = row.names(rpkm)),]
rpkm$transcriptID = as.factor(row.names(rpkm))

# Reshape to flat data format and combine in single dataframe
tpm = melt(tpm)
names(tpm) = c("transcriptID", "sampleID", "tpm")  

rpkm = melt(rpkm)
names(rpkm) = c('transcriptID', 'sampleID', 'rpkm')

SIRVdata = merge(tpm, rpkm)

rm(tpm, rpkm)
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
SIRVdata = merge(x = SIRVdata, y = SIRV_conc, 
                 by = c("transcriptID", "sirv"), 
                 all.x = T, all.y = T)

# Store SIRV concentrations for axis labeling
conc_breaks = unique(na.exclude(SIRV_conc$conc))[order(unique(na.exclude(SIRV_conc$conc)))]
conc_breaks = round(x = conc_breaks, digits = 2)

# Check format
head(SIRVdata)

### Check read counts for zero abundance SIRVs (True Negatives)
table(is.na(SIRVdata$conc), SIRVdata$tpm>10)
mosaicplot(table(is.na(SIRVdata$conc)==F, SIRVdata$tpm>10), shade = T)
mosaicplot(table(is.na(SIRVdata$conc)==F, SIRVdata$rpkm>10), shade = T)

ggplot(data = SIRVdata, mapping = aes(x = tpm+1E-2, col = is.na(conc))) +
  geom_density() + 
  scale_x_log10(breaks = c(10^(-3:5)), name = 'TPM + 1E-2') + 
  scale_y_continuous(name = 'Density') +
  scale_color_brewer(type = 'qual', palette = 2, name = 'Absence') +
  facet_grid(sirv~.) +
  geom_vline(xintercept = 6)
## False negative threshold of 6 TPM is sufficient to remove the bulk of false negatives
## E2 shows much greater variance, check for possible batch effects

ggplot(data = SIRVdata, mapping = aes(x = rpkm+1, col = is.na(conc))) +
  geom_density() + 
  scale_x_log10(breaks = c(10^(-3:5)), name = 'RPKM + 1') + 
  scale_y_continuous(name = 'Density') +
  scale_color_brewer(type = 'qual', palette = 2, name = 'Absence') +
  facet_grid(sirv~.) +
  geom_vline(xintercept = 11)


### Check minimal concentration of detected SIRVs (Detection Threshold)
# Using TPMs
ggplot(data = SIRVdata, mapping = aes(x = conc, y = tpm)) +
  geom_violin(na.rm = T, mapping = aes(group=conc), 
              draw_quantiles = c(.05,.5,.95),
              trim = T, scale = 'count') + 
  geom_smooth(method = 'lm', mapping = aes(group=1)) +
  scale_y_log10(limits = c(1E-1,5E3), name = 'TPM') +
  scale_x_log10(breaks = conc_breaks, minor_breaks = NULL, name = 'FemtoMoles per MicroLiter') +
  ggtitle(label = 'TPM vs Spike-in concentrations \nBars indicate 5th and 95th percentiles') +
  geom_hline(yintercept = c(10,50,100,200,400,800))
# Using RPKM
ggplot(data = SIRVdata, mapping = aes(x = conc, y = rpkm)) +
  geom_violin(na.rm = T, mapping = aes(group=conc), 
              draw_quantiles = c(.05,.5,.95),
              trim = T, scale = 'count') + 
  geom_smooth(method = 'lm', mapping = aes(group=1)) +
  scale_y_log10(limits = c(1E-1,5E5), name = 'RPKM') +
  scale_x_log10(breaks = conc_breaks, minor_breaks = NULL, name = 'FemtoMoles per MicroLiter') +
  ggtitle(label = 'RPKM vs Spike-in concentrations \nBars indicate 5th and 95th percentiles') +
  geom_hline(yintercept = c(70, 420, 840, 1680, 3360, 6720))
# TPM distributions have lower variance
# 0.03 (1/32th) measures as 1/5 and 1/6th in TPM and RPKM respectively
# 0.25 fMol/ul lower detection threshold
# Corresponds to 55 TPM (median)
# Calibration curve censored to detection limit:
ggplot(data = SIRVdata, mapping = aes(x = conc, y = tpm)) +
  geom_violin(na.rm = T, mapping = aes(group=conc), 
              draw_quantiles = c(.05,.5,.95),
              trim = T, scale = 'count') + 
  geom_smooth(method = 'lm', mapping = aes(group=1)) +
  scale_y_continuous(limits = c(1E-1,5E3), trans = 'log10', 
                     name = 'TPM') +
  scale_x_continuous(limits = c(0.15,6), breaks = conc_breaks[-1], trans = 'log10',
                     minor_breaks = NULL, name = 'FemtoMoles per MicroLiter') +
  ggtitle(label = 'TPM vs Spike-in concentrations \nBars indicate 5th and 95th percentiles')



### Plot variance vs mean SIRV expression within treatment (quatitative threshold)
# Use integer pseudocounts
counts = counts[grep(pattern = 'SIRV', x = row.names(counts)),]
# Correct for variance/mean correlation
vst_counts = varianceStabilizingTransformation(object = as.matrix(counts), blind = T)
vst_counts = melt(vst_counts)
names(vst_counts) = c('transcriptID', 'sampleID', 'counts')
# Add sample metadata and SIRV concentration
vst_counts = merge(vst_counts, metadata, 
                   by.x = "sampleID", by.y = "row.names",
                   all.x = T, all.y = F)
vst_counts = merge(x = vst_counts, y = SIRV_conc, 
                   by = c("transcriptID", "sirv"), 
                   all.x = T, all.y = T)
head(vst_counts)

MV = ddply(na.exclude(vst_counts), 
           .variables = .(transcriptID, sirv), summarise, 
           mean = mean(counts, na.rm = T),
           var = var(counts, na.rm = T),
           sd = sd(counts, na.rm = T),
           gsd = sd(log10(counts), na.rm = T),
           n = length(conc),
           conc = conc[1])
# CV calculated with normality assumptions!
MV$cv = (MV$sd/MV$mean) * (1 + 1/(4*MV$n))
# Geometric cv
MV$gcv = sqrt(exp(MV$gsd^2)-1)


ggplot(data = MV, mapping = aes(x = mean, y = cv, col = sirv)) +
  geom_point() + 
  scale_y_continuous() + 
  scale_x_continuous() + 
  geom_smooth(method = 'lm') +
  geom_rug()

ggplot(data = MV, mapping = aes(x = conc, y = cv)) + 
  geom_violin(mapping = aes(group = conc), draw_quantiles = c(.05,.5,.95)) +
  geom_point(position = 'jitter', mapping = aes(col = sirv)) +
  scale_y_continuous(limits = c(5E-3,.5), breaks = c(10^(-3:2)), trans = 'log10') + 
  scale_x_continuous(breaks = conc_breaks, minor_breaks = NULL, trans = 'log10') +
  geom_smooth(mapping = aes(group = 1), method = 'gam') 

ggplot(data = MV, mapping = aes(x = conc, y = var)) + 
  geom_violin(mapping = aes(group = conc), draw_quantiles = c(.05, .5, .95)) +
  geom_point(position = 'jitter', mapping = aes(col = sirv)) +
  scale_y_continuous(limits = c(1E-3,5), trans = 'log10') + 
  scale_x_continuous(breaks = conc_breaks, minor_breaks = NULL, trans = 'log10') +
  geom_smooth(mapping = aes(group = 1), method = 'gam') 

ggplot(data = MV, mapping = aes(x = conc, y = gcv)) + 
  geom_violin(mapping = aes(group = conc), draw_quantiles = c(.05, .5, .95)) +
  geom_point(position = 'jitter', mapping = aes(col = sirv)) +
  scale_y_continuous(limits = c(2E-3,.1), trans = 'log10') + 
  scale_x_continuous(breaks = conc_breaks, minor_breaks = NULL, trans = 'log10') +
  geom_smooth(mapping = aes(group = 1), method = 'gam') 


### CV stable and low for all samples, but lower at conc => .5 
## Only holds for log variance/log mean

## Check why some samples have no spike-ins for some species
# Which samples and which spike-ins?
MV[which(is.nan(MV$varE)),]

# Isolate most concentrated false negative
QC1 = SIRVdata[which(SIRVdata$transcriptID=='SIRV311'),]
ggplot(data = QC1, mapping = aes(x = conc, y = tpm)) + geom_point() + facet_wrap(~sirv)
QC1 = QC1[which(QC1$sirv=='E2'),]
ggplot(data = QC1, mapping = aes(x = RNA_conc, y = tpm)) + geom_point()

# Cross-reference on QC2
QC2 = SIRVdata[which(SIRVdata$transcriptID=='SIRV303'),]
ggplot(data = QC2, mapping = aes(x = conc, y = tpm)) + geom_point() + facet_wrap(~sirv)
QC2 = QC2[which(QC21$sirv=='E2'),]
ggplot(data = QC2, mapping = aes(x = RNA_conc, y = tpm)) + geom_point()

# Do some samples lack the spike-ins? 
QC1$sampleID[which(QC1$tpm==0)]%in%QC2$sampleID[which(QC2$tpm==0)]
QC2$sampleID[which(QC2$tpm==0)]%in%QC1$sampleID[which(QC1$tpm==0)]
# NO
