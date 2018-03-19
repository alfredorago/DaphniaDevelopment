#!/bin/sh
## Rename sample count tables with sample name and move them to the same folder

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto/"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

for subdir in $ResultDir/*/
do
  echo ${subdir}
  #cp $subdir/*.tsv $subdir.tsv
done