# 🧬 Pangenome Analysis Workflow - Step 2

**Created by:** Julian Torres Morales  
**Date:** December 8, 2025  

***

⚠️ **WARNING: HIGH RESOURCE USAGE** ⚠️<br>
> This workflow is **computationally intensive** and intended for **high‑performance environments**.
> 
> - Optimized for a machine with **112 threads** and **3 TB RAM**
>   - ⏱ Run Time Full Genome Processing Workflow (genomes = 8,174): ~6 days
>   - ⏱ Run Time Full Pangenomic Analysis Workflow (taxa = 567): ~3 days
> 
> - **Thread allocation is static set per rule** — adjust if needed
> - **Control total threads and jobs** in the script: `01_prepare-contigs_db-snakemake.sh`
>  ```bash
>  # High resources
>  snakemake --jobs 100 --cores 100
>  # Reduced resources for testing or smaller runs
>  snakemake --jobs 10 --cores 10
>  ```

✅ **Start small:** run a single taxon, confirm resource usage, then scale up

Taxonomic groups (HMTs) as defined by  HOMD genome table: [HOMD Genome Table](https://www.homd.org/genome/genome_table).  

***

## 📘 Overview

This file contains all commands and scripts used to prepare pangenomes.
It combines parsing genomes.DB per taxon (genome_storage.DB), construction of pangenome, ANI, metabolic completeness, and phylogeny.

All processing is tied to `../VERSIONS.md` for software and database versions.

Keep this file for reproducibility, troubleshooting, or re-running the workflow.

### **1️⃣ Prepare pangenome folder
- Find taxa (HMT) with ≥2 genomes
```bash
# -------------------------------
# Step 1: Create pangenome directory
# -------------------------------

# Change to working directory (same as Step 1 workflow)
cd my_work_dir

# Create main pangenome analysis folder and data subdirectory
# (All intermediate tables are stored in data/)
dir_first_derep=03_pangenome_analysis
mkdir -p "$dir_first_derep"/data

# Input file generated during genome processing (Step 1)
# Contains full-length genome IDs with HMT annotation
original_genome_to_hmt="98_data/genome_ids-8174-long.txt"


# -------------------------------
# Step 2: Generate genome-to-group mapping
# -------------------------------

# Output table:
#   Column 1: HMT (taxonomic group)
#   Column 2: Genome ID (prefixed with '_homd_' for uniqueness)
all_genome_to_group_file="$dir_first_derep/data/01-genome_to_tax_group-8174.txt"

# Processing steps:
# 1) Replace the second underscore with '|' to split HMT from genome ID
# 2) Swap fields so HMT comes first
# 3) Preserve strain information
# 4) Output a clean, tab-delimited mapping table
cat "$original_genome_to_hmt" \
    | sed -e 's/_/|/2' \
    | awk 'BEGIN{FS=OFS="|"}{print $2,$1}' \
    | awk -F'_str_' '{print $0 "|" $1}' \
    | awk -F'|' 'BEGIN{OFS="\t"} {print $1, $3 "_homd_" $2}' \
    > "$all_genome_to_group_file"


# -------------------------------
# Step 3: List taxa (HMT's) with ≥2 genomes
# -------------------------------

# Output file: list of taxa with more than one genome
list_taxon=$dir_first_derep/data/02-list_group.txt

# Count genomes per HMT taxon
# NOTE:
# - sort | uniq -c is executed inside awk via a POSIX pipe
# - This avoids temporary files and scales well to thousands of genomes
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \
    | awk '{if($1>1)print $2}' \
    > "$list_taxon"

# List taxa represented by a single genome (excluded from pangenome construction)
list_singleton_taxon=$dir_first_derep/data/02-list_group-only_one_genome.txt

# 1) Count genomes per taxon
# 2) Keep only taxa with exactly one genome
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \
    | awk '{if($1==1)print $2}' \
    > "$list_singleton_taxon"

# -------------------------------
# Step 4: Link genomes to multi-genome HMT taxa
# -------------------------------

# Output file linking genomes to taxa
genome_to_group_pass="$dir_first_derep/data/03-group_to_genomes.txt"

# Initialize output file (POSIX-safe truncation)
: > "$genome_to_group_pass"

# For each taxon with ≥2 genomes:
# 1) Extract all matching genomes
# 2) Append genome ID as a separate column for downstream Snakemake rules
while IFS= read -r group; do
    grep "$group" "$all_genome_to_group_file" \
    | awk -F'_homd_' -v OFS="\t" '{print $0, $2}' \
    >> "$genome_to_group_pass"
done < "$list_taxon"

# -------------------------------
# Step 5: Count genomes per taxon
# -------------------------------

# Output file: number of genomes per taxon
group_count="$dir_first_derep/group_count.txt"

# Output table (NEEDS these HEADERS):
#   Tax_group   Group_size
awk 'BEGIN{FS=OFS="\t"}{print $2 | "sort | uniq -c"}' "$genome_to_group_pass" \
    | awk -v OFS="\t" 'NR==1{print "Tax_group","Group_size"}{if($1>1)print $2,$1}' \
    > "$group_count"

# -------------------------------
# Step 6: Copy files for workflow input
# -------------------------------
# Full taxon list for workflow
cp "$list_taxon" "$dir_first_derep/list_group.txt"

 # Genome-to-group mapping for workflow
cp "$genome_to_group_pass" "$dir_first_derep/group_to_genomes.txt"

```

### **2️⃣ Copy necessary scripts**
```bash
# Copy YAML generation script from GitHub workflow folder to working directory
cp /path/to/repo/workflow/scripts/02_generate_yaml.py "$dir_first_derep/"

# Run the YAML generation script to prepare workflow configuration
chmod +x "$dir_first_derep/02_generate_yaml.py"
cd "$dir_first_derep"
./02_generate_yaml.py
cd ../
```
### **3️⃣ Test Snakemake workflow**
```bash
####################
# TEST: Run pangenome construction workflow
####################

# Set and enter the pangenome workflow directory
dir_pangenome=03_pangenome_analysis
cd "$dir_pangenome"

# Activate the Anvi'o environment (Anvi'o v8)
conda activate anvio-8

# Ensure required Python dependencies are available
# (PyYAML is required by Snakemake; install once if missing)
# conda install -c conda-forge pyyaml

####################
# Input selection
####################

# Copy the full taxon list into the working directory
cp data/02-list_group.txt list_group.txt

# Optional: restrict to a single taxon or a small subset for testing
# (useful for quick validation runs)
grep "Abiotro" data/02-list_group.txt > list_group.txt

####################
# Workflow setup
####################

# Copy the Snakemake workflow into the working directory
cp /path/to/repo/workflow/pangenome_construction_hmt/Snakefile .

# Visualize workflow dependencies
snakemake --rulegraph | dot -Tpdf > rulegraph_test.pdf

####################
# Workflow execution
####################

# Perform a dry run to validate rules and inputs
snakemake --jobs 200 --cores 90 --quiet -n

# Execute the workflow
snakemake --jobs 200 --cores 90

# Optional: clean generated outputs for a fresh re-run
# (Snakemake tracks completed tasks automatically)
# snakemake --cores 90 clean


```

### **4️⃣ Run full Snakemake workflow**
```bash
####################
# 2️⃣ Full Run (all taxa, production)
####################

# Restore full taxon list for production
cp data/02-list_group.txt list_group.txt

# Return to main working directory
cd ../

# Copy bash script that launches the full Snakemake workflow
cp /path/to/repo/workflow/scripts/02_run-pangenome_analysis-snakemake.sh 99_scripts/

# Make the script executable
chmod +x 99_scripts/02_run-pangenome_analysis-snakemake.sh

# Launch workflow in background with logging
# - All taxa are processed
# - Output and errors are logged to 97_nohup
# - Runs asynchronously on HPC or local machine
nohup ./99_scripts/02_run-pangenome_analysis-snakemake.sh \
    >> 97_nohup/nohup-02_run-pangenome_analysis-snakemake.out 2>&1 &

# ⚠️ WARNING: Full workflow is resource-intensive
# Expected runtime: multiple days for >500 taxa
# Ensure sufficient cores, RAM, and storage before executing

```

### **5️⃣ Check completion status**
```bash
####################
# Check completion status of Snakemake rules
# Note: Some rules (e.g., phylogenomics) may fail if the number of genomes <3–4
####################

# Folder containing Snakemake "done" marker files
done_dir="03_pangenome_analysis/99_done"

####################
# Step 1: Quick overview of completed rules
####################

# List completed rules with counts in a clean table
# - Strip leading path and text before last dash
# - Count occurrences per rule
# - Display as tab-delimited table, formatted with column -t
ls "$done_dir" \
  | sed -e 's/.*-//' \
  | sort \
  | uniq -c \
  | awk -v OFS="\t" '{print $2,$1}' \
  | column -t \
  | awk 'BEGIN{print "Rule\tCompleted"} {print $0}'

```

### **6️⃣ Summarize number of completed rules (tabular summary)**
```bash
####################
# Generate summary of completed rules
# - Safe if directory is empty
# - Outputs aligned table with Rule and Completed columns
# - Saves to summary file
####################

dir_done="03_pangenome_analysis/99_done"
summary_file="03_pangenome_analysis/summary_rules.txt"

# Initialize summary file with header
printf 'Rule\tCompleted\n' > "$summary_file"

# POSIX glob guard:
# If no files exist, "$dir_done/*" expands literally — this avoids errors
# Iterate over all files in the done directory
# 1) Keep only filenames
# 2) Extract rule name from filename (last dash-separated field)
# 3) Sort rule names
# 4) Count how many times each rule completed
# 5) Format as tab-delimited: RuleName  CompletedCount
# 6) Sort by count then rule name
# 7) Append to summary file
set -- "$dir_done"/*
if [ "$1" != "$dir_done/*" ]; then
  printf '%s\n' "$dir_done"/* \
    | sed 's#.*/##' \
    | awk -F'-' '{print $NF}' \
    | sort \
    | uniq -c \
    | awk -v OFS='\t' '{print $2,$1}' \
    | sort -k2,2n -k1,1 \
    >> "$summary_file"
fi

# ✅ Summary saved
printf 'Summary of completed rules saved to: %s\n' "$summary_file"
```

