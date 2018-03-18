#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# Quantify transcripts (testing one folder only)
kallisto quant --index=$ResultDir/Dmagna_OrsiniSIRV_index.idx --output-dir=$ResultDir/Kallisto/F58 --threads=4 --plaintext ../SourceDatasets/Alfredo_full_data/160922_D00255_0272_BHWLLTBCXX/Project_KT_Alfredo/SampleF58/*.fastq.gz
