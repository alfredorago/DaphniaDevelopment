#!/bin/sh
## Job name
#SBATCH -J Kallisto_Dmagna_SIRVonly
## Walltime
#SBATCH -t 2:00:00
## Mail status updates
#SBATCH --mail-user=alfredo.rago@gmail.com
#SBATCH --mail-type=END
## Number of threads used
#SBATCH -N 1
#SBATCH --tasks-per-node=20
# Run index construction and quantification
Kallisto_index.sh
Kallisto_quant.sh
