# 🔢 Software and Database Versions

Version tracking is essential for reproducibility. All versions below correspond to the initial public release.

All genomes and HOMD reference files were obtained on August 19, 2025.

***

## Core software

- **Anvi’o**: v8 (*marie*; stable)
- **Python**: 3.10.15
- **Snakemake**: 7.32
- **Conda environment**: `anvio-8`

### Anvi’o internal database versions

- Profile database............: 38
- Contigs database............: 21
- Pan database................: 16
- Genome data storage.........: 7
- Auxiliary data storage......: 2
- Structure database..........: 2
- Metabolic modules database..: 4
- tRNA-seq database...........: 2

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

### SCG taxonomy (GTDB)
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

- All database versions were fixed at the time of pangenome generation
- Paths to local installation are omitted (set by the environment/user)
- Versions are checked by Anvi'o programs (pangenome step)
