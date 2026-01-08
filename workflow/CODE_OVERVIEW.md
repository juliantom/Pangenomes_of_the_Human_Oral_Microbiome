# 🛠️ Code Overview

The **workflows** in this repository are implemented using **Snakemake** and are organized into two modular pipelines:
- **Genome processing**
- **Pangenome construction**

Each pipeline can run independently to allows for reproducibility and maintenance.

***

## 🧬 Genome Processing Workflow

**Location:** `workflow/genome_processing/`

This workflow:
- Retrieves genome assemblies
- Generates anvi’o contigs databases
- Performs gene calling
- Adds functional annotations

**Key output:** An anvi’o contigs database for each genome.

***

## 🧩 Pangenome Construction Workflow

**Location:** `workflow/pangenome_construction/`

This workflow:
- Groups genomes by taxon using a genome-to-group mapping file
- Constructs taxon-specific pangenomes
- Estimates Average Nucleotide Identity (ANI)
- Builds phylogenomic trees
- Assesses metabolic completeness

Each taxon group is processed independently to ensure scalability and biological interpretability.

***

## 🔗 Workflow Orchestration

The two workflows are designed to be chained seamlessly, with the output of the genome processing workflow serving as input to pangenome construction.

All parameters controlling execution, resource usage, and thresholds are defined in per-workflow configuration files.

