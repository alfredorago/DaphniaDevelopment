#!/bin/sh
### Collect TPM from each sample using Join

ResultDir="../Results/$(date +"%Y%m%d")/CompiledReads"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# Store names of files containing sample data
samples=(ls ../Results/20180319/Kallisto/tsv/*.tsv)

# Calculate number of sample datasets
nSamples=(ls -1 ../Results/20180319/Kallisto/tsv/*.tsv | wc -l)
# Choose which column contains the data
dataCol=4
# Generate indexes of columns of interest across all datasets to be joined
dataCols=(seq 1.$dataCol 1 $nSamples.$dataCol)

# Join all datasets and save as tsv
join ${samples} -o 1.1 $dataCols > $ResultDir/EST_counts.tsv
