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
> - ✅ **Start small:** run a single genome, confirm resource usage, then scale up

***

This file contains all commands and scripts used to prepare genomes for pangenome analysis.
It combines genome retrieval, cleaning, contigs database creation, and functional annotation in a single workflow.

All processing is tied to VERSIONS.md
 for software and database versions.
Keep this file for reproducibility, troubleshooting, or re-running the workflow.

### 🖥️ 1️⃣ Prepare Working Directories and HOMD Metadata
```
####################
# Prepare working directory
####################

# Create and change to working directory
mkdir my_work_dir && my_work_dir

# Create project subdirectories
mkdir -p 01_download_genomes/{01_ncbi_set,02_genomic_files} 97_nohup 98_data 99_scripts

####################
# Process HOMD metadata file
####################

# Download metadata for every genome in HOMD
wget https://www.homd.org//ftp/genomes/NCBI/V11.02/GCA_ID_info.csv \
          -O 98_data/01_homd_v11_02-GCA_ID_info.csv

# Generate genome IDs
# CRITICAL: only alphanumeric characters and underscores
# Columns needed: HMT number, Genus, Species, strain ID, GenBank Assembly Accession
# Expected ID: HMT_000_Genus_Species_str_STRAIN_id_GCA
cat 98_data/01_homd_v11_02-GCA_ID_info.csv \
          | awk -F',' 'NR>2{print $2,$3,$4"_str_"$5"_id_"$1}' \
          | sed -e 's/"//g' \
          | sed -e 's/sp\._/sp_/' \
          | sed -e 's/sp\. /sp_/' \
          | sed 's/[^a-zA-Z0-9_]/_/g' \
          > 98_data/genome_ids-8177.txt

# Create assembly accession list
cat 98_data/genome_ids-8177.txt \
          | awk -F'_id_' '{print $NF}' \
          | sed -e 's/_/\./2' \
          > 98_data/02-assembly_id_list-2025_08_19.txt

# Copy list to download directory
cp 98_data/02-assembly_id_list-2025_08_19.txt 01_download_genomes/assembly_accession_list.txt
```
### 📂 2️⃣ Download Genomes from NCBI
```
####################
# Change to download directory
####################
cd 01_download_genomes/

# Activate Anvi'o environment
conda activate anvio-8

####################
# Install NCBI Datasets
# only needed once and can be installed inside anvi'o
####################

# Choose one option
# conda install conda-forge::ncbi-datasets-cli=18.9.0
# conda install conda-forge::ncbi-datasets-cli

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

# Check number of genomes fetched; note 3 genomes are missing (expected =8177, downloaded = 8174)
ls 01_ncbi_set/ncbi_dataset/data/*/*.fna | wc -l

# Move all genomic FASTA files into a single folder
for fasta_file in 01_ncbi_set/ncbi_dataset/data/*/*.fna; do
  mv $fasta_file 02_genomic_files
done
```
### ⚙️ 3️⃣ Sanity Check and Clean Genome IDs
```
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
    grep "$assembly_id" 98_data/genome_ids-8177.txt >> 98_data/genome_ids-8174.txt
done

# Generate long and short genome ID files
cat 98_data/genome_ids-8174.txt > 98_data/genome_ids-8174-long.txt
sed -i 's/........//' 98_data/genome_ids-8174.txt
```
### 📂 4️⃣ Prepare Contigs DB Working Directory
```
####################
# Create contigs DB workspace
####################
mkdir -p 02_individual_contigs_db/{01_raw_fasta,02_reformat_fasta,03_report,04_contigs_db} 97_nohup

####################
# Copy genome fasta files and rename
####################
dir_ncbi=01_download_genomes/02_genomic_files
dir_assemblies=02_individual_contigs_db/01_raw_fasta

while IFS= read -r genomes_id; do
    gca_id=$(echo $genomes_id | awk -F'_id_' '{print $2}' | sed -e 's/_/./2')
    old_name=$(find $dir_ncbi -maxdepth 1 -name "$gca_id*.fna")
    NEW_NAME=$(echo "$genomes_id" | awk -v new_dir="$dir_assemblies" '{print new_dir"/"$1"-raw.fasta"}' )
    cp $old_name $NEW_NAME
done < 98_data/genome_ids-8174.txt

# Copy genome IDs to contigs DB folder
cp 98_data/genome_ids-8174.txt 02_individual_contigs_db/genome_ids.txt
```
### 📝 5️⃣ Run Snakemake Workflow
Before running, make sure the script `01_prepare-contigs_db-snakemake.sh` is in the working directory `99_scripts/`.<br>
If you cloned the repository, it’s in `/workflow/scripts/` — copy it to the working directory:
```
# Copy script 
cp /path/to/repo/workflow/scripts/01_prepare-contigs_db-snakemake.sh 99_scripts/

####################
# Execute Snakemake workflow: Prepare contigs DB and annotate assemblies
####################
nohup ./99_scripts/01_prepare-contigs_db-snakemake.sh \
     >> 97_nohup/nohup-01_prepare-contigs_db-snakemake.out 2>&1 &
```
### 📂 6️⃣ Compress FASTA Files
```
####################
# Compress fasta files for storage optimization
####################
ls 01_download_genomes/02_genomic_files/*.fna | parallel gzip -9
ls 02_individual_contigs_db/01_raw_fasta/*.fasta | parallel gzip -9
```
© 2026 Julian Torres-Morales — see LICENSE

