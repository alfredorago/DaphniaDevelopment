#!/bin/sh
## Convert h5 output to read counts and store in single folder

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir="../Results/$(date +"%Y%m%d")/Kallisto/"
mkdir -p $ResultDir
echo "Results directory set to $ResultDir"

# Run h5dump
for sample in ls -d $ResultDir/*/
do
  SampleDir=$ResultDir/h5dump/${sample}/
  mkdir -p $SampleDir
  kallisto h5dump -o=$SampleDir $ResultDir/${sample}/*.h5
done

for subdir in $ResultDir/h5dump/*/
 do mv $subdir/*.txt $subdir.txt
done
