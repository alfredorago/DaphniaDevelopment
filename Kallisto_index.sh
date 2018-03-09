#!/bin/sh

# Load required modules
module load GCC/4.9.3-2.25
module load OpenMPI/1.10.2
module load kallisto

# Create dated directory
ResultDir= ./Results/$(Date +"%Y%m%d")/Kallisto
mkdir -p $ResultDir

# Convert fasta files in kallisto indexes
