#!/bin/bash
#SBATCH --account=def-monti
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=70000M
#SBATCH --time=4-00:00
#SBATCH --mail-user=fraser_franco.maxime@courrier.uqam.ca
#SBATCH --mail-type=ALL

module load StdEnv/2020 gcc/9.3.0
module load r/4.0.2
module load r-bundle-bioconductor/3.12

#export R_LIBS=~/.local/R/$EBVERSIONR/
Rscript --no-save --no-restore 03C_hunting_success_quadratic-model1.R