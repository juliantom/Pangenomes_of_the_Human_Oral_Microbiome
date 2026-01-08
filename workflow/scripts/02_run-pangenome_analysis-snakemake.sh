#!/bin/bash

# =========================================================
# Script to run Snakemake workflow for building pangenomes
# for oral species
# Date: 2025-05-19
# Author: Julian Torres
# =========================================================

# -------------------------------
# Start timing
# -------------------------------
SECONDS=0   # Bash internal timer to track elapsed time of the workflow

# -------------------------------
# Store the current working directory
# -------------------------------
current_dir="$PWD"   # Save directory to return after workflow

# -------------------------------
# Initialize Conda in the shell
# -------------------------------
# This ensures that 'conda activate' works properly in scripts
eval "$(conda shell.bash hook)"

# -------------------------------
# Activate the Anvi'o 8 environment
# -------------------------------
conda activate anvio-8
# Optional debug: print the current environment
# echo "Conda environment active: $(conda info --envs | grep '*')"

# -------------------------------
# Set project ID and workflow directory
# -------------------------------
project_id="03_pangenome_analysis"
# Adjust this path to your working directory for pangenome analysis
path_workdir="my_work_dir"
#path_workdir="$current_dir"

# -------------------------------
# Navigate to the Snakemake workflow directory
# -------------------------------
cd "$path_workdir/$project_id" || { echo "Failed to change directory to $path_workdir/$project_id"; exit 1; }
# Optional debug: confirm current directory
# echo "Running workflow in: $PWD"

# -------------------------------
# Generate workflow rulegraph for visualization
# -------------------------------
# Produces a PDF showing all Snakemake rules and dependencies
snakemake --rulegraph | dot -Tpdf > rulegraph-run.pdf
# Optional debug: check PDF generated
# ls -lh rulegraph-run.pdf

# -------------------------------
# Run Snakemake workflow
# -------------------------------
# --cores 90 : number of CPU cores to use per job
# --jobs 200 : maximum number of simultaneous jobs
# --resources mem_gb=2600 : limit memory usage
# --keep-going : continue workflow even if some rules fail
# --quiet : suppress verbose Snakemake output
snakemake --cores 90 --resources mem_gb=2600 --jobs 200 --keep-going --quiet
# Optional debug: for testing smaller runs, reduce cores and jobs
# snakemake --cores 10 --jobs 10 --quiet -n  # dry run test

# -------------------------------
# Deactivate Conda environment
# -------------------------------
conda deactivate

# -------------------------------
# Return to the original directory
# -------------------------------
cd "$current_dir" || exit
# Optional debug: confirm return
# echo "Returned to directory: $PWD"

# -------------------------------
# Calculate elapsed time
# -------------------------------
DAYS=$((SECONDS / 86400))
HOURS=$(((SECONDS % 86400) / 3600))
MINUTES=$(((SECONDS % 3600) / 60))
SECONDS_REMAINING=$((SECONDS % 60))

# Format elapsed time as: project_id    DD:HH:MM:SS
ELAPSED=$(printf "%s\t%02d:%02d:%02d:%02d" "$project_id" "$DAYS" "$HOURS" "$MINUTES" "$SECONDS_REMAINING")

# Append elapsed time to a log file for tracking runtime of workflows
echo "$ELAPSED" >> "$path_workdir/execution_time.log"
# Optional debug: print elapsed time
# echo "Workflow completed in $ELAPSED"
