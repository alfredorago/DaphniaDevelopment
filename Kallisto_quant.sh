#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
mkdir -p $ResultDir/F58
echo "Results directory set to $ResultDir"

# For every sample name
# from each sequencin run
# extract paired fastq files
# Run kallisto quant
# and save in specific folder

while read sample; do
  echo -e "\nProcessing ${sample}"
#  kallisto quant -t 4 -b 100 -i Mus_musculus_GRCm38.idx -o results/"${sample}"-aligned --single -l 180 -s 30 "${sample}"
done <../SourceDatasets/Sample_IDs/SampleIDs.txt

# Quantify transcripts (testing one folder only)
#kallisto quant --index=$ResultDir/Dmagna_OrsiniSIRV_index.idx --output-dir=$ResultDir/F58 --threads=4 --plaintext ../SourceDatasets/Alfredo_full_data/160922_D00255_0272_BHWLLTBCXX/Project_KT_Alfredo/Sample_F58/F58_CTGAAGC-ATAGAGG_L002_R1_001.fastq.gz ../SourceDatasets/Alfredo_full_data/160922_D00255_0272_BHWLLTBCXX/Project_KT_Alfredo/Sample_F58/F58_CTGAAGC-ATAGAGG_L002_R2_001.fastq.gz
