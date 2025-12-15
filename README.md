# Pangenomes of the Human Oral Microbiome Database
A reproducible workflow for building and visualizing pangenomes to explore microbial diversity.

## Problem (Biological and Specific)
**Understanding the underlying microbial diversity is a fundamental problem in biology.** Microbes influence nearly every aspect of life: they shape human health and disease, drive biotechnological innovations, and regulate critical environmental processess such as nutrient cycling and climate dynamics.

Pangenomic analysis-the study of how genomes from closlely related taxa compare in terms of gene content and variation-provides insights into how microbial diveristy impacts ecotystems  and vice versa. However, widespread adoption of pangenomis is hindered y several factors:
i) Lack of standarization and reproducibiity of workflows
ii) Computational limitations posed by thousands of genomes
iii) Limited accessibility to intuitive visualization tools (e.g., Anvi'o)
These barriers make it difficult to perform consistent and reproducibile analyses across labs and even within the same lab.

## What This Repository Provides
Here we aimed to **democratized pangenomic analysis** by offering a **systematic and reproducible workflow** for building pangenomes. We used the Human Oral Microbiome Database as reference because:
i) Well-curated and environmentally defined
ii) Actively maintained and funded 
iii) Managed by experts in oral microbiology
HOMD classifies genomes into taxonomic units called Human Oral Taxon (HMT) based on evolutionary markers rather than species names (although they generally match). 

Our workflow leverages Anvi'o to build, visualize, and inspect pangenomes for each HMT. These pangenomes are available both for online and offline visualization and inspection through a dedicated HOMD space, enabling researchers to easily explore and extract information.

## Operational definitions
Disclosure. The term "pangenome" is a biological concept that referes to the complete set of genomic information from all members within a closely related group. However, because microbial populations are dynamic, it is impossible to capture all genomic variation at all time points. Thus, the pangenome represents the best possible approximation given available data.

**Pangenome**: All the genes identified across all available genomes belonging to a given Human Microbiome Taxon (HMT) as defined in HOMD.


## SA
Pangenom refer to [all] the gene content within members of a closely related genomic group. Pangenomic analysis enables us to identify what is shared and what is unique among members of a population at different genomic scales, such as, regions, genes, amino acids, nucelotides, as well as the organization across genomic units.

Disclosure
The pangenome referes to all the genomic information from all members within a closely related group.

Here, we focused on microbial pangenomes,

ContigsDB, Pangenome, Metabolism, ANI, Dereplication
