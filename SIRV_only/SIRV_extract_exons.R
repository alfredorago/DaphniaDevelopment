# Extract exon sequences from SIRV genome
library(Biostrings)
library(GenomicRanges)
library(seqinr)

# Import genome and gff annotation
features <- read.table(file = '../SourceDatasets/RNA_spikein/SIRV_Sequences_151124/SIRV_C_151124a.gtf')
genome <- readDNAStringSet(filepath = '../SourceDatasets/RNA_spikein/SIRV_Sequences_151124/SIRV_151124a.fasta', format = 'fasta')

# Store in GRanges object
exons <- GRanges(seqnames = features$V1, strand = features$V7,
                 ranges = IRanges(start = features$V4, end = features$V5, names = features$V16))

# Extract DNA sequences for each exon
exonseq <- genome[exons]
exonseq
# And save as fasta file
newdir = file.path('../Results', format(Sys.time(), '%Y%m%d'), 'SIRV_extract_exons')
dir.create(newdir, recursive = T)

write.fasta(sequences = as.list(exonseq), names = features$V16, 
            file.out = file.path(newdir, 'SIRV_exons.fasta'))
