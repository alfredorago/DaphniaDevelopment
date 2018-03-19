#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Store run parmeters
Bootstraps=10
Threads=4

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# For every sample name (stored in file SampleIDs)
# Read relevant folders in each sequencing run
# Run kallisto quant
# and save in specific folder

while read sample; do
  echo -e "\nProcessing ${sample}"
  SampleDir=$ResultDir/${sample}
  mkdir -p $SampleDir
# Find all BGI files which match input sample and pass to Kallisto quant
  BGI_runs=$(find ../SourceDatasets/Alfredo_full_data/*/${sample}/*.fq.gz)
  kallisto quant --index=$ResultDir/Dmagna_OrsiniSIRV_index.idx --output-dir=$SampleDir --threads=$Threads -b=Bootstraps ../SourceDatasets/Alfredo_full_data/160922_D00255_0272_BHWLLTBCXX/Project_KT_Alfredo/Sample_${sample}/*.fastq.gz ../SourceDatasets/Alfredo_full_data/161102_D00200_0297_BH573CBCXY/Project_KT_Alfredo/Sample_${sample}/*.fastq.gz $BGI_runs
done <../SourceDatasets/Sample_IDs/SampleIDs.txt
