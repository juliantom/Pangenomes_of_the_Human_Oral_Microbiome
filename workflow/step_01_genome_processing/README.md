# 🧬 Genome Processing Workflow

This workflow retrieves, prepares, and annotates genomes for downstream pangenome construction. It consists of **two integrated steps**:

1. **Genome retrieval and standardization**  
2. **Contigs database creation and functional annotation**

All processing is fully reproducible and tied to the software and database versions documented in [`VERSIONS.md`](../VERSIONS.md).  
All genomes and HOMD reference files were obtained on **August 19, 2025**.

***

## 🔍 Overview of the Workflow

### Step 1 — Genome Retrieval and Standardization

**Objective:**
Download reference genomes from HOMD/NCBI and create a consistent, cleaned genome ID set for downstream analysis.

**Key Actions:**
- Fetch HOMD genome metadata and NCBI assemblies
- Generate a standardized list of genome IDs
- Identify missing genomes and document them
> ⚠️ NCBI GenBank is a live database — some genomes might be removed or upgraded

**Outputs:**
- Raw GenBank genomic FASTA files: `01_download_genomes/02_genomic_files/`
- Verified genome ID lists:
  - Genome IDs `98_data/genome_ids-8174.txt`
  - Missing genome information: `missing_genomes.txt`

***

### Step 2 — Contigs Database Creation and Functional Annotation

**Objective:**
Convert raw genome FASTA files into **anvi’o contigs databases** `contigs.DB` with functional annotations, making them ready for pangenome construction.

**Key Actions:**  
- Reformat genome FASTA files
- Generate per-genome anvi’o `contigs.DB`
- Annotate with NCBI COGs, KEGG KO, Pfam, and CAZymes
- Compress FASTA files for efficient storage

**Outputs:**
- Reformatted FASTA files: `02_individual_contigs_db/02_reformat_fasta/`
- Individual `contigs.DB` with annotations: `02_individual_contigs_db/04_contigs_db/`
- Reports linking reformat edit to FASTA headers: `02_individual_contigs_db/03_report/`
- Compressed fasta files (`.gz`) in both original and reformatted directories

***

## 📂 Inputs

- **HOMD genome metadata:** [HOMD ftp Site](https://www.homd.org//ftp/genomes/NCBI/V11.02/)
- **Assembly accession list (generated):** `01_download_genomes/assembly_accession_list.txt`
- **Scripts and Snakemake workflow:**
  - `step_01_genome_processing/Snakefile`
  - `step_01_genome_processing/s-02_individual_contigs_db-snakemake_wf-2025_08_19.sh`

***

## 🖥️ Reproducibility & Debugging

- All logs are stored in `.snakemake` and `02_individual_contigs_db/00_logs/`
- Missing genomes are rare; verify `missing_genomes_info.txt`
- Database and software versions are controlled via [`VERSIONS.md`](../VERSIONS.md)
- For step-by-step code execution, see [`CODE.md`](./CODE.md)
- Monitor workflow progress in real time:
```bash

© 2026 Julian Torres-Morales — see [LICENSE](../../LICENSE)  
