#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# Convert fasta files in kallisto indexes
# Currently using only SIRV sequences from spike RNA spike in

echo "Saving output indexes to $ResultDir"
kallisto index -i $ResultDir/SIRV_index.idx ../SourceDatasets/SIRV/SIRV_transcripts.fasta
