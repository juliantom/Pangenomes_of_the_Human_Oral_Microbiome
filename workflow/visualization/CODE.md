# 🧬 Pangenome Analysis Workflow - Step 2

**Created by:** Julian Torres Morales  
**Date:** December 15, 2026  

***
If you are reading this file, you have already generated pangenomes and associated outputs.

***

## 📘 Overview

This document contains all commands and supporting files needed to reproduce the online pangenome visualizations.
You will need:
- Access to a browser
    - Google Chrome
    - chromedriver installed and in path

### **1️⃣ Function to copy curated taxon files**

The function below creates a copy of the full pangenome results, including:
- Pangneomes (**GENOMES.db** and **PAN.db**)
- ANI matrices (matrices and trees)
- Phylogenomic trees (bootstrapp trees only)
- Metabolic reconstructions (metabolic modules summary files)

```bash
# You should be in the main working directory
cd my_work_dir

##################################
#   COPY CURATED TAXON FILES     #
##################################

# Copy full function. This will be used later.

copy_taxon_core_files() {
    local RESULTS_BASE=$1    # e.g. 03_pangenome_analysis/results
    local TAXON_ID=$2        # e.g. Abiotrophia_defectiva_homd_HMT_389
    local DEST_BASE=$3       # e.g. visualization/01_original_data

    local SRC_DIR="${RESULTS_BASE}/${TAXON_ID}"
    local DEST_DIR="${DEST_BASE}/${TAXON_ID}"

    # Skip if destination already exists
    if [ -d "${DEST_DIR}" ]; then
        echo "Skipping ${TAXON_ID}: destination already exists."
        return
    fi

    echo "Processing ${TAXON_ID}"

    # Create destination directories
    mkdir -p \
        "${DEST_DIR}/dir_ani" \
        "${DEST_DIR}/dir_pangenome" \
        "${DEST_DIR}/dir_phylogenomics" \
        "${DEST_DIR}/dir_metabolism"

    # ---- Top-level files ----
    cp "${SRC_DIR}/${TAXON_ID}-GENOMES.db" \
       "${DEST_DIR}/" || echo "Warning: missing GENOMES.db for ${TAXON_ID}"

    cp "${SRC_DIR}/genome-add_info.txt" \
       "${DEST_DIR}/" || echo "Warning: missing genome-add_info.txt for ${TAXON_ID}"

    # ---- ANI ----
    if [ -d "${SRC_DIR}/dir_ani" ]; then
        cp -r "${SRC_DIR}/dir_ani/"* "${DEST_DIR}/dir_ani/"
    else
        echo "Warning: missing dir_ani for ${TAXON_ID}"
    fi

    # ---- Pangenome ----
    cp "${SRC_DIR}/dir_pangenome/${TAXON_ID}-PAN.db" \
       "${DEST_DIR}/dir_pangenome/" \
       || echo "Warning: missing PAN.db for ${TAXON_ID}"

    # ---- Phylogenomics ----
    cp "${SRC_DIR}/dir_phylogenomics/${TAXON_ID}-tree.nwk" \
       "${DEST_DIR}/dir_phylogenomics/" \
       || echo "Warning: missing tree.nwk for ${TAXON_ID}"

    # ---- Metabolism ----
    cp "${SRC_DIR}/dir_metabolism/${TAXON_ID}_modules.txt" \
       "${DEST_DIR}/dir_metabolism/" \
       || echo "Warning: missing modules.txt for ${TAXON_ID}"
}

```
### **2️⃣ Run function to copy files for HMT- and species-level taxa**
```bash
##################################
#     RUN TAXON FILE TRANSFER    #
##################################

# HMT-level pangenome datasets
# This script copies a curated subset of files for each HMT-level taxon
# into a compact, shareable directory structure.

# ------------------------------------------------------------------
# Create HMT taxon list used for iteration
# ------------------------------------------------------------------
# Source list is generated during pangenome/ANI/phylogeny pipeline
# and contains one HMT-level taxon ID per line.
share_folder="visualization"
input_folder="03_pangenome_analysis"
# Create share folder and data subfolder
mkdir -p "${share_folder}/data"

# Make taxon list
cp \
  "${input_folder}/list_group.txt" \
  "${share_folder}/taxon_list_hmt.txt"

# ------------------------------------------------------------------
# Example: copy core files for a single taxon (sanity check)
# ------------------------------------------------------------------
src_folder="${input_folder}/results"
taxon_id="Abiotrophia_defectiva_homd_HMT_389"
dest_folder="${share_folder}/data"

copy_taxon_core_files \
    "${src_folder}" \
    "${taxon_id}" \
    "${dest_folder}"

# ------------------------------------------------------------------
# Batch copy: iterate over all HMT-level taxa
# ------------------------------------------------------------------
# For each taxon ID, copy:
#   - GENOMES.db
#   - genome-add_info.txt
#   - dir_ani (all ANI matrices)
#   - PAN.db
#   - final phylogenomic tree (.nwk)
#   - metabolic module summary
#
# Taxa with an existing destination directory are skipped.
src_folder="${input_folder}/results"
dest_folder="${share_folder}/data"

while read -r taxon_id; do
    copy_taxon_core_files \
        "${src_folder}" \
        "${taxon_id}" \
        "${dest_folder}"
done < "${share_folder}/taxon_list_hmt.txt"

# ------------------------------------------------------------------
# Batch copy: iterate over all Species-level taxa
# ------------------------------------------------------------------
# For each taxon ID, copy:
#   - GENOMES.db
#   - genome-add_info.txt
#   - dir_ani (all ANI matrices)
#   - PAN.db
#   - final phylogenomic tree (.nwk)
#   - metabolic module summary
#
# Taxa with an existing destination directory are skipped.
share_folder="visualization"
input_folder="04_pangenome_analysis_species"

# Make species list
cp \
  "${input_folder}/list_group.txt" \
  "${share_folder}/taxon_list_species.txt"

# Define source and destination folders
src_folder="${input_folder}/results"
dest_folder="${share_folder}/data"

# Iterate over species-level taxa
while read -r taxon_id; do
    copy_taxon_core_files \
        "${src_folder}" \
        "${taxon_id}" \
        "${dest_folder}"
done < "${share_folder}/taxon_list_species.txt"

```


### **3️⃣ Import state (JSON) file**
```bash
# Copy base state JSON file to visualization folder
cp /path/to/repo/workflow/visualization/base_pangenome_with_functions.json visualization/

# Combine HMT and Species taxon lists into a single file (total 579 taxa)
cat visualization/taxon_list_*.txt > visualization/taxon_list_all.txt

# Activate anvi'o environment
conda activate anvio-8

##############################################################
#                IMPORT MY MINIMAL BASE STATE                #
##############################################################
# Double dendrograms with functions as 'default'
for tax_group in $(cat visualization/taxon_list_all.txt); do
    dir_tax="visualization/data/$tax_group"
    pan_db="$dir_tax/dir_pangenome/$tax_group-PAN.db"
    state_name="base_pangenome_with_functions"
    state_file="visualization/$state_name.json"
    dir_state="visualization/data/$tax_group/dir_state"
    mkdir -p "$dir_state"
    cp "$state_file" "$dir_state" &
    anvi-import-state -p "$pan_db" --state "$state_file" --name default &
    anvi-import-state -p "$pan_db" --state "$state_file" --name "$state_name" &
done

# Ensure display has changed (use a random taxon to check)
taxon=Prevotella_histicola_homd_HMT_298
anvi-display-pan -g visualization/data/$taxon/$taxon-GENOMES.db -p visualization/data/$taxon/dir_pangenome/$taxon-PAN.db
```

### **4️⃣ Genome count-based grouping for layout tuning**
```bash
##############################################################
#       Split tax_group by genome count into four groups    #
##############################################################

# Split tax_group by genome count into three groups
# This will help adjust genome height and margin for better visualization

# Create groups files
# Group 1 (n = 505): less than or equal to 25 genomes
# Group 2 (n = 33): between 25 and 50 genomes
# Group 3 (n = 40): between 50 and 100 genomes
# Group 4 (n = 1): above 50 genomes
count_group_1=visualization/group_1.txt
count_group_2=visualization/group_2.txt
count_group_3=visualization/group_3.txt
count_group_4=visualization/group_4.txt
: > "$count_group_1"
: > "$count_group_2"
: > "$count_group_3"
: > "$count_group_4"

# Subset taxa by number of genomes in each taxon
for dir_tax in 03_pangenome_analysis 04_pangenome_analysis_species; do
    tax_count="$dir_tax/group_count.txt"
    awk 'BEGIN{FS=OFS="\t"}NR>1{if ($2 <=25) print $1,$2 | "sort -k2,2nr"}' "$tax_count" | cut -f1 >> "$count_group_1"
    awk 'BEGIN{FS=OFS="\t"}NR>1{if ($2 <=50 && $2 > 25 ) print $1,$2 | "sort -k2,2nr"}' "$tax_count"| cut -f1  >> "$count_group_2"
    awk 'BEGIN{FS=OFS="\t"}NR>1{if ($2 <=100 && $2 > 50 ) print $1,$2 | "sort -k2,2nr"}' "$tax_count"| cut -f1  >> "$count_group_3"
    awk 'BEGIN{FS=OFS="\t"}NR>1{if ($2 > 100) print $1,$2 | "sort -k2,2nr"}' "$tax_count" | cut -f1  >> "$count_group_4"
done

```
### **5️⃣ Manual adjustment of genome height and margin**
```bash
##############################################################
#      Adjust genome height and margin (Manually)            #
##############################################################

# Manually edit state to adjust genomes' height and margin
# Group 1: 180 height 15 margin (No change needed, already in state)
# Group 2:  90 height  7 margin
# Group 3:  45 height  3 margin
# Group 4:  15 height  1 margin

##### Group 2 #####
# Pangenomes = 33
# Launch all pangenomes (7 at a time) Height = 90 and Margin = 7
start_port=8080
count=0
# base_pangenome_with_functions_adjusted_height_margin
for tax_group in $(head -n 35 visualization/group_2.txt | tail -n 7); do
    port=$((start_port + count))
    genome_db="visualization/data/${tax_group}/${tax_group}-GENOMES.db"  # Adjust naming convention as needed
    pan_db="visualization/data/${tax_group}/dir_pangenome/${tax_group}-PAN.db"        # Adjust naming convention as needed
    anvi-display-pan -g "$genome_db" -p "$pan_db" --port-number "$port" &
    count=$((count + 1))
done

# Ensure ports are terminated after use
pkill  -f 'anvi-display-pan'

##### Group 3 #####
# Pangenomes = 38
# Launch all pangenomes (7 at a time) Height = 45 and Margin = 3
start_port=8080
count=0
# base_pangenome_with_functions_adjusted_height_margin
for tax_group in $(head -n 42 visualization/group_3.txt | tail -n 7); do
    port=$((start_port + count))
    genome_db="visualization/data/${tax_group}/${tax_group}-GENOMES.db"  # Adjust naming convention as needed
    pan_db="visualization/data/${tax_group}/dir_pangenome/${tax_group}-PAN.db"        # Adjust naming convention as needed
    anvi-display-pan -g "$genome_db" -p "$pan_db" --port-number "$port" &
    count=$((count + 1))
done

# Ensure ports are terminated after use
pkill  -f 'anvi-display-pan'

##### Group 4 #####
# Pangenomes = 3
# Launch all pangenomes (3 at a time) Height = 15 and Margin = 1
start_port=8080
count=0
# base_pangenome_with_functions_adjusted_height_margin
for tax_group in $(head -n 3 visualization/group_4.txt | tail -n 3); do
    port=$((start_port + count))
    genome_db="visualization/data/${tax_group}/${tax_group}-GENOMES.db"  # Adjust naming convention as needed
    pan_db="visualization/data/${tax_group}/dir_pangenome/${tax_group}-PAN.db"        # Adjust naming convention as needed
    anvi-display-pan -g "$genome_db" -p "$pan_db" --port-number "$port" &
    count=$((count + 1))
done

# Ensure ports are terminated after use
pkill  -f 'anvi-display-pan'

```

## **6️⃣ From local: generate SVG, PDF, and PNG files**
4. Generate minimal share folder and SVG, PDF, PNG files
```bash
##############################################################
#        Generate SVG, PDF and PNG files                     #
##############################################################

# This section is executed on a local machine.

# Change to a desired folder (e.g., Desktop)
cd Desktop

# Copy visualization folder (~61 GB) from server to local
scp -r user@ip:/path/to/visualization path/to/local_dir/

# Activate anvi'o environment
conda activate anvio-8

# Save pangenomes as SVG
start_port=8080
file_tax="visualization/taxon_list_all.txt"
batch_size=10
total=$(wc -l < "$file_tax")

for N in $(seq "$total" -"$batch_size" 1); do
    count=0
    echo -e ">>>\n  Running batch with head -n $N | tail -n $batch_size"
    for tax_group in $(head -n "$N" "$file_tax" | tail -n "$batch_size"); do
        port=$((start_port + count))
        genome_db="visualization/data/${tax_group}/${tax_group}-GENOMES.db"
        pan_db="visualization/data/${tax_group}/dir_pangenome/${tax_group}-PAN.db"
        dir_figs="visualization/data/${tax_group}/dir_figs"
        mkdir -p "$dir_figs"
        anvi-display-pan \
            --genomes-storage "$genome_db" \
            --pan-db "$pan_db" \
            --port-number "$port" \
            --state-autoload default \
            --export-svg "$dir_figs/${tax_group}-default.svg" &
        count=$((count + 1))
    done
    # Ensure each batch finishes before the next one starts
    wait
done

# Ensure ports are terminated after use
pkill  -f 'anvi-display-pan'

# Convert SVG to PDF (PNG at 600 dpi is too big and at 300 dpi is low quality)
file_tax="visualization/taxon_list_all.txt"
batch_size=10
total=$(wc -l < "$file_tax")

for N in $(seq "$total" -"$batch_size" 1); do
    echo ">>> Converting SVG → PDF for batch ending at line $N"
    for tax_group in $(head -n "$N" "$file_tax" | tail -n "$batch_size"); do
        genome_db="visualization/data/${tax_group}/${tax_group}-GENOMES.db"
        pan_db="visualization/data/${tax_group}/dir_pangenome/${tax_group}-PAN.db"
        dir_figs="visualization/data/${tax_group}/dir_figs"
        inkscape \
            "$dir_figs/${tax_group}-default.svg" \
            --export-type=pdf \
            --export-filename="$dir_figs/${tax_group}-default.pdf"
        # Optional PNG export
        # inkscape "$dir_figs/${tax_group}-default.svg" --export-type=png --export-filename="$dir_figs/${tax_group}-default.png" --export-dpi=600
    done
done


# ------------------------------------------------------------------
# End of visualization generation workflow
# ------------------------------------------------------------------

# Optional:
# You may now copy the visualization folder back to the server.

```
