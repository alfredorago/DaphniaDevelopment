#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# For every sample name
# from each sequencin run
# extract paired fastq files
# Run kallisto quant
# and save in specific folder

while read sample; do
  echo -e "\nProcessing ${sample}"
  SampleDir=$ResultDir/${sample}
  mkdir -p $SampleDir
  kallisto quant --index=$ResultDir/Dmagna_OrsiniSIRV_index.idx --output-dir=$SampleDir --threads=4 --plaintext ../SourceDatasets/Alfredo_full_data/160922_D00255_0272_BHWLLTBCXX/Project_KT_Alfredo/Sample_${sample}/*.fastq.gz ../SourceDatasets/Alfredo_full_data/161102_D00200_0297_BH573CBCXY/Project_KT_Alfredo/Sample_${sample}/*.fastq.gz
#  kallisto quant -t 4 -b 100 -i Mus_musculus_GRCm38.idx -o results/"${sample}"-aligned --single -l 180 -s 30 "${sample}"
done <../SourceDatasets/Sample_IDs/SampleIDs.txt
