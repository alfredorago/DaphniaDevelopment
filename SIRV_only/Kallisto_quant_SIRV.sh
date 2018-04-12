#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Store run parmeters
Bootstraps=100
Threads=20

# Create dated directory
ResultDir="../../Results/$(date +"%Y%m%d")/SIRV_only"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# For every sample name (stored in file SampleIDs)
# Read relevant folders in each sequencing run
# Run kallisto quant
# and save in specific folder

while read sample; do
  echo -e "\nProcessing ${sample}"
# Create results directory
  SampleDir=$ResultDir/${sample}
  mkdir -p $SampleDir
  # Find all files which match input sample in BHAM and BGI folders
  BHAM_runs=$(find ../../SourceDatasets/Alfredo_full_data/*/Raw/${sample}/*.fq.gz)
  BGI_runs=$(find ../../SourceDatasets/Alfredo_full_data/*/Project_KT_Alfredo/Sample_${sample}/*.fastq.gz)
# Run Kallisto quant
  kallisto quant --index=$ResultDir/SIRV_only.idx --output-dir=$SampleDir --threads=$Threads -b=Bootstraps $BHAM_runs $BGI_runs
done <../SourceDatasets/Sample_IDs/SampleIDs.txt
