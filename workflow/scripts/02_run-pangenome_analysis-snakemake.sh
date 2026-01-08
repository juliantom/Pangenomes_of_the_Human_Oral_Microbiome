#!/bin/bash


# Script to run Snakemake workflow for building pangenomes for oral species
# Date: 2025-05-19
# Author: Julian

# Start timing
SECONDS=0

# Store the current directory
current_dir="$PWD"

# Initialize conda in the shell
eval "$(conda shell.bash hook)"

# Activate the Anvi'o v8 environment
conda activate anvio-8

# Set project ID and working directory path
project_id="15_pangenome_ani_phylogeny_2025_12_08"
path_workdir="/mnt/md0/JULIAN/ANVIO_METAPANGENOMES/20250819_S_HOMDv4_1_anvio_8"

# Navigate to the Snakemake workflow directory
cd "$path_workdir/$project_id" || { echo "Failed to change directory"; exit 1; }

# Generate rulegraph and run Snakemake
snakemake --rulegraph | dot -Tpdf > rulegraph-run.pdf
# Run snakemake with specified resources
snakemake --cores 90 --resources mem_gb=2600 --jobs 200 --keep-going --quiet

# Deactivate the conda environment
conda deactivate

# Return to the original directory
cd "$current_dir" || exit

# Calculate elapsed time
DAYS=$((SECONDS / 86400))
HOURS=$(((SECONDS % 86400) / 3600))
MINUTES=$(((SECONDS % 3600) / 60))
SECONDS_REMAINING=$((SECONDS % 60))

# Format and store the elapsed time
ELAPSED=$(printf "15_pangenome_ani_phylogeny_2025_12_08\t%02d:%02d:%02d:%02d" "$DAYS" "$HOURS" "$MINUTES" "$SECONDS_REMAINING")

# Append the elapsed time to the log file
echo "$ELAPSED" >> "$path_workdir/execution_time.log"

