#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/SIRV_only"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# Convert fasta files in kallisto indexes
kallisto index -i $ResultDir/SIRV_only.idx ../Results/20180412/SIRV_extract_exons/SIRV_exons.fasta
