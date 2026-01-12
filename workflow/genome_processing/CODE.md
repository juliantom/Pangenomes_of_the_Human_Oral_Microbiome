# 🧬 Genome Processing Code — Step 1

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

✅ **Start small:** run a single genome, confirm resource usage, then scale up

***

## 📘 Overview

This file contains all commands and scripts used to prepare genomes for pangenome analysis.
It combines genome retrieval, cleaning, contigs database creation, and functional annotation in a single workflow.

All processing is tied to `../VERSIONS.md` for software and database versions.

Keep this file for reproducibility, troubleshooting, or re-running the workflow.

***

## 📘 Code

### 🖥️ 1️⃣ Prepare Working Directories and HOMD Metadata
```bash
####################
# Prepare working directory
####################

# Create and change to working directory
mkdir -p my_work_dir && cd my_work_dir

# Create project subdirectories
mkdir -p 01_download_genomes/{01_ncbi_set,02_genomic_files} 97_nohup 98_data 99_scripts


####################
# Process HOMD metadata file
####################

# Download metadata for every genome in HOMD
wget https://www.homd.org//ftp/genomes/NCBI/V11.02/GCA_ID_info.csv \
          -O 98_data/01_homd_v11_02-GCA_ID_info.csv


####################
# Generate genome IDs
####################

# CRITICAL:
# - IDs must contain ONLY alphanumeric characters and underscores
# - These IDs propagate into filenames, contigs DBs, and pangenomes
#
# Required columns:
#   HMT number | Genus | Species | Strain ID | GenBank Assembly Accession
#
# Expected ID format:
#   HMT_000_Genus_Species_str_STRAIN_id_GCA_XXXXXX.X

cat 98_data/01_homd_v11_02-GCA_ID_info.csv \
          | awk -F',' 'NR>2{print $2,$3,$4"_str_"$5"_id_"$1}' \
          | sed -e 's/"//g' \
          | sed -e 's/sp\._/sp_/' \
          | sed -e 's/sp\. /sp_/' \
          | sed 's/[^a-zA-Z0-9_]/_/g' \
          > 98_data/genome_ids-8177.txt


####################
# SAFETY GUARD — TEST MODE (INTENTIONAL)
####################

# IMPORTANT:
# This grep-based subset is a *deliberate safety mechanism*.
#
# Rationale:
# - Full HOMD run = >8,000 genomes
# - Accidental execution would trigger a multi-day HPC job
# - Abiotrophia is small (2 HMTs × ~5 genomes = ~10 genomes)
#
# Default behavior:
#   → ONLY Abiotrophia genomes are enabled
#
# To run the FULL dataset:
#   → Comment out the grep line
#   → Uncomment the full copy command below

grep 'Abiotro' 98_data/genome_ids-8177.txt \
  > 98_data/genome_ids-abiotrophia.txt

# ACTIVE (safe default: ~10 genomes)
cp 98_data/genome_ids-abiotrophia.txt 98_data/genome_ids.txt

# FULL RUN (DANGEROUS — >8,000 genomes)
# cp 98_data/genome_ids-8177.txt 98_data/genome_ids.txt


####################
# Create assembly accession list
####################

# Extract GenBank assembly accessions
# Convert second underscore to dot (GCA_XXXXXX.X format)
cat 98_data/genome_ids.txt \
          | awk -F'_id_' '{print $NF}' \
          | sed -e 's/_/\./2' \
          > 98_data/02-assembly_id_list-2025_08_19.txt

# Copy list to download directory
cp 98_data/02-assembly_id_list-2025_08_19.txt \
   01_download_genomes/assembly_accession_list.txt

```

### 📂 2️⃣(Optional) Install Annotation Databases
```bash
####################
# Change to download directory
####################
cd 01_download_genomes/

# Activate Anvi'o environment
conda activate anvio-8


####################
# Install NCBI Datasets and Annotation DBs
# Versions will match those in the contigs.DB pangenomes.DB
# only needed once
####################

# NCBI Datasets (v18.9.0; probably any recent version will work)
conda install conda-forge::ncbi-datasets-cli=18.9.0

# Setup Cazymes DB (v13)
anvi-setup-cazymes --cazyme-version V13 --reset
# If the above command fails, copy a pre-built CAZyme DB folder content to anvio CAZyme folder
# cp -r path/to/misc/CAZyme/* path/to/anaconda3/envs/anvio-8/lib/python3.10/site-packages/anvio/data/misc/CAZyme/

# Setup InteracDome DB (Pfam:31.0)
anvi-setup-interacdome --reset

# Setup KEGG Data (v13)
anvi-setup-kegg-data --mode all --num-threads 16 --reset --kegg-snapshot v2023-09-22

# Setup NCBI COG DB (COG20)
anvi-setup-ncbi-cogs --cog-version COG20 --num-threads 16 --reset

# Setup Pfam DB (v37.2)
anvi-setup-pfams --pfam-version 37.2 --reset

# Setup GTDB-Tk DB (v214.1)
anvi-setup-scg-taxonomy --num-threads 16 --gtdb-release v214.1 --reset

# Setup tRNA taxonomy DB
anvi-setup-trna-taxonomy --num-threads 16

# Setup ModelSEED DB
anvi-setup-modelseed-database

# Check snakemake installation v7.32.4 (you might need to do some version control of modules)
snakemake --version

```

### 📂 3️⃣ Download Genomes from NCBI
```bash
####################
# Download genomes from NCBI
####################

# Download a dehydrated data package (NCBI datasets v18.9.0)
assembly_list="assembly_accession_list.txt"
datasets download genome accession \
          --inputfile "$assembly_list" \
          --assembly-source 'GenBank' \
          --dehydrated \
          --include genome \
          --filename "01_ncbi_set/HOMDv4_1-ncbi-2025_08_19-dehydrated.zip"

# Unzip package
unzip 01_ncbi_set/HOMDv4_1-ncbi-2025_08_19-dehydrated.zip -d 01_ncbi_set/

# Rehydrate package
datasets rehydrate --max-workers 30 --directory 01_ncbi_set

# Check number of genomes fetched
# Note: 3 genomes are missing from NCBI (expected = 8177, downloaded = 8174)
ls 01_ncbi_set/ncbi_dataset/data/*/*.fna | wc -l

# Move all genomic FASTA files into a single folder
for fasta_file in 01_ncbi_set/ncbi_dataset/data/*/*.fna; do
  mv $fasta_file 02_genomic_files
done
```

### ⚙️ 4️⃣ Sanity Check and Clean Genome IDs
```bash
####################
# Sanity Check
####################

# List of assembly accession numbers downloaded
ls 02_genomic_files/ | awk 'BEGIN{FS=OFS="_"}{print $1,$2}' > downloaded_genomes.txt

# Compare downloaded vs expected genomes to identify missing ones
comm -23 <(sort assembly_accession_list.txt) <(sort downloaded_genomes.txt) > missing_genomes.txt

# Fetch metadata for missing genomes
for i in $(cat missing_genomes.txt); do
  grep "$i" ../98_data/01_homd_v11_02-GCA_ID_info.csv >> missing_genomes_info.txt
done


####################
# Clean genome IDs
####################

# Go back to working folder
cd ../

# Filter genome IDs to only include genomes that were successfully downloaded
for i in $(cat 01_download_genomes/downloaded_genomes.txt); do 
    assembly_id=$( echo "$i" | sed -e 's/\./_/' )
    grep "$assembly_id" 98_data/genome_ids.txt >> 98_data/genome_ids-8174.txt
done

# Generate long and short genome ID files (portable)
cp 98_data/genome_ids-8174.txt 98_data/genome_ids-8174-long.txt

# Remove leading "HMT_<number>_" to generate short genome IDs
# (used for contigs DB and downstream visualization)
sed 's/^HMT_[0-9][0-9]*_//' 98_data/genome_ids-8174.txt \
    > 98_data/genome_ids-8174.tmp && \
    mv 98_data/genome_ids-8174.tmp \
    98_data/genome_ids-8174.txt

```

### 📂 5️⃣ Prepare Contigs DB Working Directory
```bash
####################
# Create contigs DB workspace
####################
mkdir -p 02_individual_contigs_db/{01_raw_fasta,02_reformat_fasta,03_report,04_contigs_db} 97_nohup


####################
# Copy genome fasta files and rename
####################
dir_ncbi=01_download_genomes/02_genomic_files
dir_assemblies=02_individual_contigs_db/01_raw_fasta
# Loop through genome IDs and copy/rename files
while IFS= read -r genomes_id; do
    # Extract the portion after "_id_"
    gca_id=$(printf '%s\n' "$genomes_id" | awk -F '_id_' '{print $2}' | sed 's/_/./2')
    # POSIX find: avoid descending into subdirectories using -prune (instead of -maxdepth)
    # If multiple matches exist, take the first deterministically.
    old_name=$(find "$dir_ncbi" -type f -name "${gca_id}*.fna" -prune | head -n 1)
    # Build the new filename (no spaces expected in $genomes_id; still safe)
    new_name="${dir_assemblies}/${genomes_id}-raw.fasta"
    # Only copy if a source was found
    if [ -n "$old_name" ]; then
        cp "$old_name" "$new_name"
    else
        printf 'WARN: source not found for %s (pattern: %s*.fna)\n' "$genomes_id" "$gca_id" >&2
    fi
done < 98_data/genome_ids-8174.txt


# Copy genome IDs to contigs DB folder
cp 98_data/genome_ids-8174.txt 02_individual_contigs_db/genome_ids-full.txt

```

### 📝 6️⃣ Run Snakemake Workflow
Before running, make sure the script `01_prepare-contigs_db-snakemake.sh` is in the working directory `99_scripts/`.<br>
If you cloned the repository, it’s in `/workflow/scripts/` — copy it to the working directory:
```bash
# Copy script and Snakefile
# Script
cp /path/to/repo/workflow/scripts/01_prepare-contigs_db-snakemake.sh 99_scripts/

# Make script executable
chmod +x 99_scripts/01_prepare-contigs_db-snakemake.sh

# Snakefile
cp /path/to/repo/workflow/genome_processing/Snakefile 02_individual_contigs_db


####################
# Execute Snakemake workflow: Prepare contigs DB and annotate assemblies
####################

# Test
cd 02_individual_contigs_db

# Subset genome IDs for testing (e.g., only Abiotrophia)
cp genome_ids-full.txt genome_ids.txt

# Visualize rulegraph (single graph)
snakemake --rulegraph | dot -Tpdf > rulegraph-test-contigs_db.pdf

# Run in dry-run mode to verify
snakemake --cores 90 --jobs 200 --dry-run

# Execute full test run
snakemake --cores 100 --jobs 200

# OPTIONAL: Clean up test outputs
# Never leave this command uncommented! It will delete all outputs.
# snakemake clean --cores 90 --jobs 200

# Run the workflow in background
cp genome_ids-full.txt genome_ids.txt
cd ../
# Execute full workflow in background
nohup ./99_scripts/01_prepare-contigs_db-snakemake.sh \
     >> 97_nohup/nohup-01_prepare-contigs_db-snakemake.out 2>&1 &

```

### 📂 7️⃣ Compress FASTA Files
```bash
####################
# Compress FASTA files for storage optimization
# Scales safely to >8,000 files per directory
# Compatible with macOS (zsh), Ubuntu (bash), and HPC systems
####################

# Tune parallelism explicitly (avoid oversubscription on shared nodes)
N_JOBS=8

# Compress NCBI genome FASTA files
find 01_download_genomes/02_genomic_files \
     -type f -name '*.fna' -print0 \
  | xargs -0 -n 1 -P "$N_JOBS" gzip -9

# Compress raw FASTA files used for contigs DBs
find 02_individual_contigs_db/01_raw_fasta \
     -type f -name '*.fasta' -print0 \
  | xargs -0 -n 1 -P "$N_JOBS" gzip -9


####################
# Optional: GNU parallel (if available)
####################
# Provides simpler syntax; performance is comparable to xargs -P
#
# Install:
#   Ubuntu: sudo apt-get install parallel
#   macOS (Homebrew): brew install parallel

#parallel gzip -9 ::: 01_download_genomes/02_genomic_files/*.fna
#parallel gzip -9 ::: 02_individual_contigs_db/01_raw_fasta/*.fasta

```
***

© 2026 Julian Torres-Morales — see LICENSE
