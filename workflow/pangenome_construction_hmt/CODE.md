# 🧬 Pangenome Analysis Workflow - Step 2

**Created by:** Julian Torres Morales  
**Date:** December 8, 2025  

***

⚠️ **WARNING: HIGH RESOURCE USAGE** ⚠️<br>
> This workflow is **computationally intensive** and intended for **high‑performance environments**.
>
> - Optimized for a machine with **112 threads** and **3 TB RAM**
>   - ⏱ Estimated Run Time Full Genome Processing Workflow (genomes = 8,174): ~6 days
>   - ⏱ Estimated Run Time Full Pangenomic Analysis Workflow (taxa = 567): ~3 days
> 
> - **Thread allocation is dynamic**, set per **taxon** and **rule** — adjust to match your system
> - Adjust per taxon thread in `config_group_threads.yaml` as needed
> - **Snakemake may launch all threads simultaneously if not properly configured**
> - **Control total threads and jobs** in the script: `02_run-pangenome_analysis-snakemake.sh`
>  ```bash
>  # High resources
>  snakemake --jobs 100 --cores 100
>  # Reduced resources for testing or smaller runs
>  snakemake --jobs 10 --cores 10
>  ```
> - ✅ **Start small:** run a single taxon, confirm resource usage, then scale up

Taxonomic groups (HMTs) as defined by  HOMD genome table: [HOMD Genome Table](https://www.homd.org/genome/genome_table).  

***

## **Workflow Overview**

### **1️⃣ Prepare pangenome folder
- Find taxa (HMT) with ≥2 genomes
```bash
# -------------------------------
# Step 1: Create pangenome directory
# -------------------------------
dir_first_derep=15_pangenome_ani_phylogeny_2025_12_08
mkdir -p "$dir_first_derep"/data   # Create main folder and 'data' subfolder

# Input file generated during genome processing
original_genome_to_hmt="98_data/genome_ids-8174-long.txt"

# -------------------------------
# Step 2: Generate genome-to-group mapping
# -------------------------------
all_genome_to_group_file=$dir_first_derep/data/01-genome_to_tax_group-8174.txt

# Process original genome IDs to create a clean mapping file
cat "$original_genome_to_hmt" \
    | sed -e 's/_/|/2' \                     # Replace the second underscore with '|' to separate fields
    | awk 'BEGIN{FS=OFS="|"}{print $2,$1}' \ # Swap columns: put HMT first, genome ID second
    | awk -F'_str_' '{print $0"|"$1}' \     # Append strain info as an extra field
    | awk -F'|' -v OFS="\t" '{print $1,$3"_homd_"$2}' \  # Format final table: HMT ID, genome ID with "_homd_" prefix
    > "$all_genome_to_group_file"

# -------------------------------
# Step 3: List taxa with ≥2 genomes
# -------------------------------
list_taxon=$dir_first_derep/data/02-list_group.txt

# Count genomes per taxon and select taxa with more than 1 genome
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \  # Take the second column (genome IDs), sort, count duplicates
    | awk '{if($1>1)print $2}' \                                   # Keep only taxa with more than one genome
    > "$list_taxon"

# List taxa with only one genome (singletons)
list_singleton_taxon=$dir_first_derep/data/02-list_group-only_one_genome.txt
awk '{print $2 | "sort | uniq -c"}' "$all_genome_to_group_file" \  # Count genomes per taxon
    | awk '{if($1==1)print $2}' \                                  # Keep only taxa with exactly one genome
    > "$list_singleton_taxon"

# -------------------------------
# Step 4: Link genomes to HMT groups
# -------------------------------
genome_to_group_pass="$dir_first_derep/data/03-group_to_genomes.txt"
> "$genome_to_group_pass"  # Initialize empty output file

# For each taxon with ≥2 genomes, link all genomes to the taxon
while IFS= read -r group; do
    grep "$group" "$all_genome_to_group_file" \                      # Find all genomes for this taxon
    | awk -F'_homd_' -v OFS="\t" '{print $0, $2}' \                # Add genome ID in a separate column for easier processing
    >> "$genome_to_group_pass"
done < "$list_taxon"

# -------------------------------
# Step 5: Count genomes per taxon
# -------------------------------
group_count="$dir_first_derep/group_count.txt"

# Count number of genomes per taxon and format output
awk 'BEGIN{FS=OFS="\t"}{print $2 | "sort | uniq -c"}' "$genome_to_group_pass" \  # Count genome occurrences per taxon
    | awk -v OFS="\t" 'NR==1{print "Species","Group_size"}{if($1>1)print $2,$1}' \
    > "$group_count"  # Output table with columns: Species, Group_size

# -------------------------------
# Step 6: Copy files for workflow input
# -------------------------------
cp "$list_taxon" "$dir_first_derep/list_group-full.txt"      # Full taxon list for workflow
cp "$genome_to_group_pass" "$dir_first_derep/group_to_genomes.txt"  # Genome-to-group mapping for workflow


```

### **2️⃣ Copy necessary scripts**
```bash
# Copy Snakemake YAML generation script from GitHub workflow folder to working directory
cp /path/to/repo/workflow/scripts/02_generate_yaml.py "$dir_first_derep/"

# Run the YAML generation script to prepare workflow configuration
./$dir_first_derep/02_generate_yaml.py

```
### **3️⃣ Test Snakemake workflow**
```bash
# Switch to the pangenome workflow directory
cd $dir_first_derep

# Activate the Anvi'o 8 environment
conda activate anvio-8

# Select a single taxon for testing (quick run)
sort list_group-full.txt | head -n1 > list_group.txt

# Visualize workflow dependencies as a PDF
snakemake --rulegraph | dot -Tpdf > rulegraph-test_1.pdf

# Perform a dry run to verify workflow execution
snakemake --jobs 10 --cores 10 --quiet -n

# Run the workflow on the test taxon
snakemake --jobs 10 --cores 10 --quiet

# Optional: clean outputs for re-running (Snakemake tracks completed tasks)
# snakemake --cores 90 clean

# Return to the main working directory
cd ../


```

### **4️⃣ Run full Snakemake workflow**
```bash
# Use the full taxon list for processing
cp list_group-full.txt list_group.txt

# Launch full workflow in the background
nohup ./99_scripts/s-15_pangenome_ani_phylo-snakemake_wf-2025_12_08.sh \
    >> 97_nohup/nohup-15_pangenome_ani_phylo-snakemake_wf-2025_12_08.out 2>&1 &

```

### **5️⃣ Check completion status**
```bash
# Some rules may fail if the number of genomes is too low (phylogenomics requires ≥3–4 genomes)

# Define folder containing Snakemake "done" markers
done_dir="./15_pangenome_ani_phylogeny_2025_12_08/99_done/"

# -------------------------------
# Step 1: Quick overview of rule completion
# -------------------------------
# List completed rules with counts (rule name and number of finished processes)
ls "$done_dir" \
  | sed -e 's/.*-//' \         # Strip leading path and text before last dash
  | sort | uniq -c \           # Count occurrences of each rule
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f1                     # Optional: show only rule names

ls "$done_dir" \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f2                     # Optional: show only counts

# -------------------------------
# Step 2: Save summary of completed rules
# -------------------------------
ls "$done_dir" \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  > 15_pangenome_ani_phylogeny_2025_12_08/summary_rules.txt


```

### **6️⃣ Summarize number of completed rules (tabular summary)**
```bash
dir_done="15_pangenome_ani_phylogeny_2025_12_08/99_done"
summary_file="15_pangenome_ani_phylogeny_2025_12_08/summary_rules-2025_12_23.txt"

# Step 1: Create header for summary file
printf 'Snakemake_Rule\tCompleted_Processes\n' > "$summary_file"

# Step 2: Aggregate completion counts
# Iterate over all files in the done directory
set -- "$dir_done"/*
if [ "$1" != "$dir_done/*" ]; then
  printf '%s\n' "$dir_done"/* \
    | sed 's#.*/##' \               # Keep only filenames
    | awk -F'-' '{print $NF}' \     # Extract rule name from filename (last dash-separated field)
    | sort \                         # Sort rule names
    | uniq -c \                       # Count how many times each rule completed
    | awk -v OFS='\t' '{print $2,$1}' \ # Format as tab-delimited: RuleName  CompletedCount
    | sort -k2,2n -k1,1 \             # Sort by count then rule name
    >> "$summary_file"                # Append to summary file
fi

# ✅ Result: 'summary_rules-2025_12_23.txt' contains a table of all rule completions

```

