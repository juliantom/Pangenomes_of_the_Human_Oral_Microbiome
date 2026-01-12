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

# Change to working directory
cd my_work_dir

# Create main folder and 'data' subfolder
dir_first_derep=03_pangenome_analysis
mkdir -p "$dir_first_derep"/data

# Input file generated during genome processing
original_genome_to_hmt="98_data/genome_ids-8174-long.txt"

# -------------------------------
# Step 2: Generate genome-to-group mapping
# -------------------------------
all_genome_to_group_file=$dir_first_derep/data/01-genome_to_tax_group-8174.txt

# Process original genome IDs to create a clean mapping file
# 1) Replace the second underscore with '|' to separate fields
# 2) Swap columns: put HMT first, genome ID second
# 3) Append strain info as an extra field (split on '_str_')
# 4) Format final table: HMT ID, genome ID with '_homd_' prefix
cat "$original_genome_to_hmt" \
    | sed -e 's/_/|/2' \
    | awk 'BEGIN{FS=OFS="|"}{print $2,$1}' \
    | awk -F'_str_' '{print $0 "|" $1}' \
    | awk -F'|' 'BEGIN{OFS="\t"} {print $1, $3 "_homd_" $2}' \
    > "$all_genome_to_group_file"


# -------------------------------
# Step 3: List taxa with ≥2 genomes
# -------------------------------
list_taxon=$dir_first_derep/data/02-list_group.txt

# Count genomes per taxon and select taxa with more than 1 genome
# 1) Take the second column (genome IDs), sort, count duplicates
# 2) Keep only taxa with more than one genome
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \
    | awk '{if($1>1)print $2}' \
    > "$list_taxon"

# List taxa with only one genome (singletons)
list_singleton_taxon=$dir_first_derep/data/02-list_group-only_one_genome.txt
# 1) Count genomes per taxon
# 2) Keep only taxa with exactly one genome
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \
    | awk '{if($1==1)print $2}' \
    > "$list_singleton_taxon"

# -------------------------------
# Step 4: Link genomes to HMT groups
# -------------------------------
# Initialize empty output file
genome_to_group_pass="$dir_first_derep/data/03-group_to_genomes.txt"
: > "$genome_to_group_pass"
# For each taxon with ≥2 genomes, link all genomes to the taxon
# 1) Find all genomes for this taxon
# 2) Add genome ID in a separate column for easier processing
while IFS= read -r group; do
    grep "$group" "$all_genome_to_group_file" \
    | awk -F'_homd_' -v OFS="\t" '{print $0, $2}' \
    >> "$genome_to_group_pass"
done < "$list_taxon"

# -------------------------------
# Step 5: Count genomes per taxon
# -------------------------------
group_count="$dir_first_derep/group_count.txt"

# Count number of genomes per taxon and format output
# 1) Count genome occurrences per taxon
# 2) Format output table with columns: Tax_group, Group_size
# 3) Output table with columns: Tax_group, Group_size
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
dir_first_derep=03_pangenome_analysis

# Switch to the pangenome workflow directory
cd "$dir_first_derep"

# Activate the Anvi'o 8 environment (in case not already active)
conda activate anvio-8

# Check yaml is installed
#conda install -c conda-forge pyyaml

# Select a single taxon for testing (quick run) (MIGHT REMOVE LATER)
cp data/02-list_group.txt list_group.txt
# Optional: limit to a specific taxon or few taxa for testing
#grep "Abiotro" data/02-list_group.txt > list_group.txt

# Copy Snakemake workflow script from GitHub workflow folder to working directory
cp /path/to/repo/workflow/pangenome_construction_hmt/Snakefile .

# Visualize workflow dependencies as a PDF
snakemake --rulegraph | dot -Tpdf > rulegraph-test_1.pdf

# Perform a dry run to verify workflow execution
snakemake --jobs 200 --cores 90 --quiet -n

# Run the workflow on the test taxon
snakemake --jobs 200 --cores 90

# Optional: clean outputs for re-running (Snakemake tracks completed tasks)
# snakemake --cores 90 clean

```

### **4️⃣ Run full Snakemake workflow**
```bash
# Use the full taxon list for processing (MIGHT BE REMOVE LATER)
cp data/02-list_group.txt list_group.txt

# Return to the main working directory
cd ../

# Copy bash script to launch full Snakemake workflow
cp path/to/repo/workflow/scripts/02_run-pangenome_analysis-snakemake.sh 99_scripts

# Make the script executable
chmod +x 99_scripts/02_run-pangenome_analysis-snakemake.sh

# Launch full workflow in the background
nohup ./99_scripts/02_run-pangenome_analysis-snakemake.sh \
    >> 97_nohup/nohup-02_run-pangenome_analysis-snakemake.out 2>&1 &

```

### **5️⃣ Check completion status**
```bash
# Some rules may fail if the number of genomes is too low (phylogenomics requires ≥3–4 genomes)

# Define folder containing Snakemake "done" markers
done_dir="03_pangenome_analysis/99_done"

# -------------------------------
# Step 1: Quick overview of rule completion
# -------------------------------
# List completed rules with counts (rule name and number of finished processes)
# 1) Strip leading path and text before last dash
# 2) Count occurrences of each rule
# 3) Format output as tab-delimited: Rule Finished
# 4) Optional: show only rule names
ls "$done_dir" \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f1

# Same as above but showing only counts
ls "$done_dir" \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f2

```

### **6️⃣ Summarize number of completed rules (tabular summary)**
```bash
# -------------------------------
# SSave summary of completed rules
# -------------------------------
# Save the summary of completed rules to a text file (count per rule - tabular format)
# Expect phylogeny rule to have fewer completions as it requires >4 genomes for bootstrapping and tree building
dir_done="03_pangenome_analysis/99_done"
summary_file="03_pangenome_analysis/summary_rules.txt"

# Step 1: Create header for summary file
printf 'Rule\tCompleted\n' > "$summary_file"

# Step 2: Aggregate completion counts
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

# ✅ Result: 'summary_rules.txt' contains a table of all rule completions
printf 'Summary of completed rules saved to: %s\n' "$summary_file"
```

