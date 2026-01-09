#!/bin/bash

# =========================================================
# Script to run Snakemake workflow for contigs database generation
# Date: 2025-06-14
# Author: Julian Torres
# =========================================================

# -------------------------------
# Start timing
# -------------------------------
SECONDS=0   # Bash internal timer to track elapsed time

# -------------------------------
# Store the current working directory
# -------------------------------
current_dir="$PWD"   # Save directory to return after workflow

# -------------------------------
# Initialize Conda in the shell
# -------------------------------
# This ensures the 'conda activate' command works in this script
eval "$(conda shell.bash hook)"

# -------------------------------
# Activate the Anvi'o 8 environment
# -------------------------------
conda activate anvio-8
# Optional debug: echo current environment
# echo "Conda environment active: $(conda info --envs | grep '*')"

# -------------------------------
# Set project ID and workflow directory
# -------------------------------
project_id="02_individual_contigs_db"
# Adjust this path to your actual working directory for the project
# path_workdir="full/path/to/my_work_dir"
path_workdir="$current_dir"

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
# --jobs 100 --cores 100: run up to 100 rules in parallel using 100 CPU cores
# --quiet: suppress extra log output
snakemake --jobs 10 --cores 10 --quiet
# Optional debug: for testing smaller runs, reduce cores and jobs
# snakemake --jobs 10 --cores 10 --quiet -n  # dry run test

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

# Append elapsed time to a log file
# This keeps track of how long each workflow takes
echo "$ELAPSED" >> "$path_workdir/execution_time.log"
# Optional debug: print elapsed time
# echo "Workflow completed in $ELAPSED"
