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
kallisto index -i $ResultDir/Dmagna_OrsiniSIRV_index.idx ../SourceDatasets/SIRV/SIRV_transcripts.fasta ../SourceDatasets/Orsini2006_transcriptome/FromLuisa/Dmagna_total_transcripts.fasta
