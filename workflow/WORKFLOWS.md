# 🧬 Workflow Overview

This resource implements a **two-stage workflow** for constructing and analyzing taxon-specific level pangenomes of oral microbial taxa. The designed emphasizes transparency, reproducibility, and community utility, ensuring that every step can be traced, validated, and reused.

The process moves from curated genome retrival - from HOMD- to taxon-specific pangenome construction and additional comparative analyses. Each stage is documented and version-controlled to support scientific rigor.

***

## 1. Genome identification and retrieval

**What happens:**  
Reference genomes are identified using the Human Oral Microbiome Database (HOMD).
Genome assemblies are retrieved using standardized datasets to ensure consistent
metadata, versioning, and provenance.

**Why it matters:**  
Using a curated reference database ensures taxonomic consistency and reduces
ambiguity in downstream comparative analyses.

***

## 2. Genome processing and functional annotation

**What happens:**  
Downloaded genome assemblies are processed using anvi’o to generate contigs
databases. This includes gene calling and the addition of functional annotations.

**Why it matters:**  
Standardized contigs databases provide the foundation for pangenome construction
and enable consistent functional comparisons across genomes.

**Output:**  
One anvi’o contigs database per genome.

***

## 3. Taxon-based genome grouping

**What happens:**  
Genomes are grouped into taxon-specific sets using a genome-to-group mapping file.
Each group is processed independently in downstream analyses.

**Why it matters:**  
Constructing pangenomes at the taxon level avoids inappropriate comparisons across
distantly related genomes and enables biologically meaningful interpretations.

***

## 4. Pangenome construction

**What happens:**  
For each taxon group, pangenomes are constructed by clustering homologous genes
across genomes to define core and accessory gene content.

**Why it matters:**  
This step reveals shared genetic features as well as strain-level variation within
oral microbial taxa.

***

## 5. Comparative and evolutionary analyses

**What happens:**  
Within each taxon-specific pangenome, additional analyses are performed, including:
- Average nucleotide identity (ANI) estimation
- Phylogenetic reconstruction
- Metabolic completeness assessment
- Gene-level differentiation analyses

**Why it matters:**  
These analyses provide evolutionary context and functional insight into how oral
microbial taxa diversify and specialize across habitats.

***

## 6. Visualization and dissemination

**What happens:**  
Pangenomes and associated analyses are prepared for interactive visualization and
distribution through web-based platforms.

**Why it matters:**  
Treating pangenomes as reusable biological objects enables community exploration,
hypothesis generation, and reuse in future studies.


