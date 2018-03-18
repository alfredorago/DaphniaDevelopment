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
<<<<<<< HEAD
=======
# Currently using only SIRV sequences from spike RNA spike in

echo "Saving output indexes to $ResultDir"
# Check how to use multiple files from kallisto
>>>>>>> 8cb7a8f570edee52eb38059a7235be52a1ea67ee
kallisto index -i $ResultDir/Dmagna_OrsiniSIRV_index.idx ../SourceDatasets/SIRV/SIRV_transcripts.fasta ../SourceDatasets/Orsini2006_transcriptome/FromLuisa/Dmagna_total_transcripts.fasta
