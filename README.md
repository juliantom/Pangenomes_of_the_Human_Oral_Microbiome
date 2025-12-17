# Pangenomes of the Human Oral Microbiome
A reproducible workflow for building and visualizing pangenomes to explore microbial diversity.

## Problem (Biological and Specific)
**Understanding the underlying microbial diversity is a fundamental problem in biology.** Microbes influence nearly every aspect of life:
* Shape human health and disease.
* Drive biotechnological innovations.
* Regulate critical environmental processess (e.g., nutrient cycling and climate dynamics).

**Pangenomic analysis**—the study of gene content and variation across closely related taxa—provides insights into how microbial diveristy impacts ecotystems  and vice versa. However, widespread adpotation of pangenomic analysis is hindered by:
* **Lack of standarization, reproducible workflows**.
* **Computational limitations** when analyzing thousands of genomes.
* **Limited accessibility** to intuitive visualization tools.
These barriers make it difficult to perform consistent and reproducibile analyses across labs and even within the same lab.

## What This Repository Provides
This repository aims to **democratized pangenomic analysis** by offering a **systematic and reproducible workflow** for building pangenomes using **Snakemake** and **Anvi'o**.<br>
We used the Human Oral Microbiome Database (HOMD) as reference because:
* It is **well-curated** and **environmentally defined**.
* **Actively maintained** and **funded**.
* **Managed by experts** in oral microbiology.
HOMD classifies genomes into taxonomic units called Human Oral Taxon (HMT) based on evolutionary markers rather than species names (though they generally match with GTDB). 

Our workflow leverages Anvi'o (v8) to build, visualize, and inspect pangenomes for each HMT. These pangenomes are available both for online and offline visualization through a dedicated HOMD site, enabling users to easily explore and extract information.

## Workflow Overview
We generated 567 pangenomes for each oral taxon (HMT) in HOMD, comprising over 8,100 genomes. Two Snakemake workflows are provided:

### Workflow 1: Genome Annotation (per genome)
* Reformats genomic FASTA files
* Creates contigs.db
* Annotates with:
  * HMMs (rRNAs + Bacteria_71 set)
  * KEGG KO
  * COG20
  * PFAMs
  * CAZymes
  * tRNAs (via tRNAscan-SE)

### Workflow 2: Pangenome Construction (per taxon - HMT)
* Links genomes to HMT (based on HOMD)
* Creates anvi'o external file
* Generates a genome storage database
* Builds a pangenome
* Computes ANI
* Estimates KEGG-based metabolism
* Identifies single-copy core genes (SCCGs) from pangenome
* Constructs phylogeny based on SCCGs

## Operational definitions
Disclosure. The term "pangenome" is a biological concept that referes to the complete set of genomic information from all members within a closely related group. However, because microbial populations are dynamic, it is impossible to capture all genomic variation at all time points. Thus, the pangenome represents the best possible approximation given available data.

**Pangenome**: All the genes identified across all available genomes belonging to a given Human Microbiome Taxon (HMT) as defined in HOMD.


## SA
Pangenom refer to [all] the gene content within members of a closely related genomic group. Pangenomic analysis enables us to identify what is shared and what is unique among members of a population at different genomic scales, such as, regions, genes, amino acids, nucelotides, as well as the organization across genomic units.

Disclosure
The pangenome referes to all the genomic information from all members within a closely related group.

Here, we focused on microbial pangenomes,

ContigsDB, Pangenome, Metabolism, ANI, Dereplication
