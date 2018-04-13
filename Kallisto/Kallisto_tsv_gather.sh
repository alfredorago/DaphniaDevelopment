#!/bin/sh
## Rename sample count tables with sample name and move them to the same folder

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto"
mkdir -p $ResultDir
mkdir -p $ResultDir/tsv
echo "Results directory set to $ResultDir/tsv"

# For every subdirectory of results copy content and rename as that directory
for subdir in $(echo $ResultDir/*|grep '[A-Z][0-9]')
do
  echo ${subdir}
  FileName=$(echo ${subdir}|grep -o '...$')
  cp ${subdir}/abundance.tsv $ResultDir/tsv/$FileName.tsv
done
