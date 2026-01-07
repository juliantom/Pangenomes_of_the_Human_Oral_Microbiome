# 🧬 Genome Processing Workflow

This workflow retrieves, prepares, and annotates genomes for downstream pangenome construction. It consists of two integrated steps:

1. **Genome retrieval and standardization**  
2. **Contigs database creation and functional annotation**

All processing is fully reproducible and tied to the software and database versions documented in [`VERSIONS.md`](../VERSIONS.md). All genomes and HOMD reference files were obtained on **August 19, 2025**.

---

## Overview of the workflow

### Step 1 — Genome retrieval and standardization

- **Objective:** Download reference genomes from HOMD/NCBI and create a consistent, cleaned genome ID set for downstream analysis.  
- **Key actions:**
  - Fetch HOMD genome metadata and NCBI assemblies.  
  - Generate a standardized list of genome IDs.  
  - Identify missing genomes and document them. *NCBI GenBank is a live database - some genomes might be removed or upgraded.*
- **Outputs:**
  - Raw genome fasta files: `01_download_genomes/02_genomic_files/`  
  - Verified genome ID lists:  
    - `98_data/genome_ids-8174.txt` (short IDs)  
    - `98_data/genome_ids-8174-long.txt` (full IDs)  
  - Missing genome information: `missing_genomes.txt` and `missing_genomes_info.txt`

### Step 2 — Contigs database creation and functional annotation

- **Objective:** Convert raw genome fasta files into **anvi’o contigs databases**
  with functional annotations, making them ready for pangenome construction.  
- **Key actions:**
  - Reformat genome fasta files and copy them into a standardized workspace.  
  - Generate per-genome anvi’o contigs databases.  
  - Annotate with CAZymes, NCBI COGs, Pfam, and KEGG.  
  - Compress genome fasta files for efficient storage.  
- **Outputs:**
  - Reformatted fasta files: `02_individual_contigs_db/02_reformat_fasta/`  
  - Individual contigs databases: `02_individual_contigs_db/04_contigs_db/`  
  - Reports: `02_individual_contigs_db/03_report/`  
  - Compressed fasta files: `.gz` in original and reformatted directories

---

## Inputs

- HOMD genome metadata: `98_data/01_homd_v11_02-GCA_ID_info.csv` [HOMD Website](https://www.homd.org//ftp/genomes/NCBI/V11.02/)
- Assembly accession list (generated): `01_download_genomes/assembly_accession_list.txt`  
- Scripts and Snakemake workflow:  
  - `99_scripts/s-02_individual_contigs_db-snakemake_wf-2025_08_19.sh`  
  - `genome_processing/Snakefile`  

---

## Code
### Retrieve genomes and create genome IDs

```bash
####################
# Prepare working directory
####################

# Create and change to working directory
mkdir my_work_dir &&  my_work_dir

# Activate environment
conda activate anvio-8

# Create directories
mkdir -p 01_download_genomes/{01_ncbi_set,02_genomic_files} 98_data 99_scripts

####################
# Process HOMD metadata file
####################

# Download metadata for every genome in HOMD
wget https://www.homd.org//ftp/genomes/NCBI/V11.02/GCA_ID_info.csv -O 98_data/01_homd_v11_02-GCA_ID_info.csv

# Generate genome IDs
# Use HMT number, genus and species names, strain ID, and GenBank Assembly Accession number
# Remove none alphanumeric characters for underscore
cat 98_data/01_homd_v11_02-GCA_ID_info.csv \
          | awk -F',' 'NR>2{print $2,$3,$4"_str_"$5"_id_"$1}' \
          | sed -e 's/"//g' \
          | sed -e 's/sp\._/sp_/' \
          | sed -e 's/sp\. /sp_/' \
          | sed 's/[^a-zA-Z0-9_]/_/g' \
          > 98_data/genome_ids-8177.txt

# Create a list of Assemmbly Accession IDs
cat 98_data/genome_ids-8177.txt \
          | awk -F'_id_' '{print $NF}' \
          | sed -e 's/_/\./2' \
          > 98_data/02-assembly_id_list-2025_08_19.txt

# Copy list to download directory
cp 98_data/02-assembly_id_list-2025_08_19.txt 01_download_genomes/assembly_accession_list.txt

# Change to directory where genomes will be downloaded
cd 01_download_genomes/

####################
# Download Genomes using Datasets program from NCBI (v18.9.0)
####################

# Download a dehydrated data package
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

# Check amount of genomes fetched (n=8174); note 3 genomes are missing
ls 01_ncbi_set/ncbi_dataset/data/*/*.fna | wc -l

# Move all genomic files into a single same folder
for fasta_file in 01_ncbi_set/ncbi_dataset/data/*/*.fna; do
  mv $fasta_file 02_genomic_files
done

####################
# Sanity Check
####################

# Make list of assembly accession numbers downloaded
ls 02_genomic_files/ | awk 'BEGIN{FS=OFS="_"}{print $1,$2}' > downloaded_genomes.txt

# Compare lists and find missing genomes
comm -23 <(sort assembly_accession_list.txt) <(sort downloaded_genomes.txt) > missing_genomes.txt

# Get metadata of missing genomes (should not be the sole representative of an HMT; else contact HOMD curators)
for i in $(cat missing_genomes.txt); do
  grep "$i" ../98_data/01_homd_v11_02-GCA_ID_info.csv >> missing_genomes_info.txt
done

# Go back to working folder
cd ../

# Create a new genome ID list with the real genomes obtained
for i in $(cat 01_download_genomes/downloaded_genomes.txt); do 
    assembly_id=$( echo "$i" | sed -e 's/\./_/' )
    grep "$assembly_id" 98_data/genome_ids-8177.txt >> 98_data/genome_ids-8174.txt
done

# Remove first 8 characters from genome ids to make it shorter (remove HMT ID)
cat 98_data/genome_ids-8174.txt > 98_data/genome_ids-8174-long.txt
sed -i 's/........//' 98_data/genome_ids-8174.txt
