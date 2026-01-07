# 🧬 Genome Processing Workflow

This workflow retrieves, prepares, and annotates genomes for downstream pangenome construction. It consists of two integrated steps:

1. **Genome retrieval and standardization**  
2. **Contigs database creation and functional annotation**

All processing is fully reproducible and tied to the software and database
versions documented in [`VERSIONS.md`](../VERSIONS.md). All genomes and HOMD
reference files were obtained on **August 19, 2025**.

---

## Overview of the workflow

### Step 1 — Genome retrieval and standardization

- **Objective:** Download reference genomes from HOMD/NCBI and create a
  consistent, cleaned genome ID set for downstream analysis.  
- **Key actions:**
  - Fetch HOMD genome metadata and NCBI assemblies.  
  - Generate a standardized list of genome IDs.  
  - Identify missing genomes and document them.  
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

- HOMD genome metadata: `98_data/01_homd_v11_02-GCA_ID_info.csv`  
- Assembly accession list (generated): `01_download_genomes/assembly_accession_list.txt`  
- Scripts and Snakemake workflow:  
  - `99_scripts/s-02_individual_contigs_db-snakemake_wf-2025_08_19.sh`  
  - `genome_processing/Snakefile`  

---

## Example commands (optional)

```bash
# Activate environment
conda activate anvio-8

# Download dehydrated genome packages from NCBI
datasets download genome accession --inputfile "assembly_accession_list.txt" --assembly-source 'GenBank' --dehydrated

# Rehydrate packages
datasets rehydrate --max-workers 30 --directory 01_ncbi_set

# Standardize fasta filenames
while IFS= read -r genome_id; do
    cp "01_download_genomes/02_genomic_files/${genome_id}.fna" \
       "02_individual_contigs_db/01_raw_fasta/${genome_id}-raw.fasta"
done < 98_data/genome_ids-8174.txt

# Run Snakemake workflow for contigs DB creation and annotation
nohup ./99_scripts/s-02_individual_contigs_db-snakemake_wf-2025_08_19.sh \
    >> 02_individual_contigs_db/97_nohup/nohup-02_individual_contigs_db.out 2>&1 &

# Compress fasta files
ls 01_download_genomes/02_genomic_files/*.fna | parallel gzip -9
ls 02_individual_contigs_db/01_raw_fasta/*.fasta | parallel gzip -9

