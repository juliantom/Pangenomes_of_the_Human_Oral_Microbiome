# 🛠️ Code Overview

The workflows in this repository are implemented using Snakemake and are organized
into two modular pipelines: genome processing and pangenome construction.

Each pipeline can be executed independently and is configured using declarative
configuration files.

***

## Genome processing workflow

**Location:** `workflow/genome_processing/`

This workflow:
- Retrieves genome assemblies
- Generates anvi’o contigs databases
- Performs gene calling
- Adds functional annotations

**Key output:**  
An anvi’o contigs database for each genome.

***

## Pangenome construction workflow

**Location:** `workflow/pangenome_construction/`

This workflow:
- Groups genomes by taxon using a genome-to-group mapping file
- Constructs taxon-specific pangenomes
- Estimates average nucleotide identity (ANI)
- Builds phylogenetic trees
- Assesses metabolic completeness
- Computes gene-level differentiation metrics

Each taxon group is processed independently to ensure scalability and biological
interpretability.

***

## Workflow orchestration

The two workflows are designed to be chained, with the output of the genome
processing workflow serving as input to pangenome construction.

All parameters controlling execution, resource usage, and thresholds are defined
in per-workflow configuration files.

