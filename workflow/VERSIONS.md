# 🔢 Software and Database Versions

This file documents the software versions and database snapshots used to generate
the pangenomes distributed in this repository.

These versions correspond to the initial public release of the resource.

## Core software

- **Anvi’o**: v8 (development branch; codename: *marie*)
- **Python**: 3.10.15
- **Snakemake**: 7.32
- **Conda environment**: `anvio-8`

# 🔢 Software and Database Versions

This document records the software versions and database snapshots used to generate
the pangenomes distributed in this repository. These versions correspond to the
initial public release of the resource.

Exact version enforcement is handled within the Snakemake workflows and associated
configuration files.

***

### Anvi’o internal database versions
- Profile database: 38
- Contigs database: 21
- Pan database: 16
- Genome data storage: 7
- Auxiliary data storage: 2
- Structure database: 2
- Metabolic modules database: 4
- tRNA-seq database: 2

***

## Functional annotation databases

### CAZymes
- **Database**: dbCAN
- **Version**: v13
- **Source**: dbCAN HMM database

***

### InteracDome
- **Pfam release**: 31.0  
- **Pfam-A families**: 16,712  
- **Release date**: February 2017  
- **Based on UniProtKB**: 2016_10  

***

### KEGG KOfam and KO modules
- **KEGG build**: 2023-09-22
- **Database archive**: `KEGG_build_2023-09-22_a2b5bde358bb`

***

### NCBI COGs
- **COG version**: COG20

***

## Taxonomy and single-copy gene databases

### SCG taxonomy (ModelSeed / GTDB)
- **GTDB release**: v214.1
- **Anvi’o SCG taxonomy version**: v1

***

### Pfam (SCG taxonomy)
- **Pfam release**: 37.2  
- **Pfam-A families**: 24,076  
- **Release date**: November 2024  
- **Based on UniProtKB**: 2023_05  

***

## Notes on reproducibility

- All database versions listed above were fixed at the time of pangenome generation.
- Paths to locally installed databases are intentionally omitted, as they are
  environment-specific.
- Version enforcement and database selection are implemented within the Snakemake
  workflows and configuration files.
