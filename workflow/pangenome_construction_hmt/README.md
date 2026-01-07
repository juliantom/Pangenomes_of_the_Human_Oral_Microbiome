🧬 Pangenome Analysis Workflow

This workflow automates pangenome construction, ANI calculation, dereplication, phylogenomics, and metabolism estimation for oral microbiome species in HOMDv4.1. It consistes of two mayor steps:
1. First, selection of HMTs with at least 2 genomes (n = 567)
2. Second, execution of the `Snakefile`

All processing is fully reproducible and is linked to the [`genome_processing`](../genome_processing/README.md).

***

## 🔍  **Overview**

### Step 1 - Count genomes per taxa (HMT)

**Objective:**
Identify taxa (HMTs) with at least two genomes (`contigs.DB`).

**Key Actions:**
- Count number of genomes for each HMT
- Subset HMT and genome list if two or more genomes per-HMT are available

**Outputs:**
- Two lists:
  - Taxa with ≥ 2 genomes
  - Taxa with one genome

### Step 2 - Execute Pangenome Workflow

**Objective:**
Performe pangenomic analysis. The Snakemake workflow `Snakefile` steps are divided into multiple rules for optimization. Advance adjustments include the number of threads dynamically set based on number of genomes per taxonomic group (HMT).

**Key Actions**

1. Subset per-HMT genome ID and `contig.DB` path
2. Combine genome storage database `Taxon-GENOMES.DB`
3. Construct pangenomes
4. Estimate Average Nucelotide Identity (ANI) using pyANI (ANIb method)
5. Dereplaicate genomes (based on ANI)
6. Estimate metabolic potential based on KEGG Modules
7. Infer phylogenomic relationships with single-copy core genes and 1000 bootstraping support

**Outputs:**
Generated files are written to `results/Taxon_ID` folder.
- Genome Storage database: `Taxon-GENOMES.DB`
- Pangenome database: `dir_pan/Taxon-PAN.DB`
- ANI tables and dendrograms: `dir_ani/ANI_percentage_identity.txt` and `dir_ani/ANI_percentage_identity.newick`
- Dereplciation clusters: `dir_dereplication/derep_950/CLUSTER_REPORT.txt`
- Metabolic potential: `dir_metabolism/Taxon-modules.txt`
- Phylogenomic tree: `dir_phylogenomics/Taxon-tree.nwk`

***

## **Requirements**
All programs should be installed available when during Anvi'o environment setup. Yet, it is always advisable to run a test with one or a few taxa.
- **Conda Environment:** anvio-8  
- **Software:** Anvi'o v8, Python 3.10.15, IQ-TREE2, Trimal, BLAST+, pyANI  
- **Databases:** CAZymes v13, KEGG 2023-09-22, COG20, Pfam v37.2, GTDB v214  
- **Snakemake:** Required for workflow orchestration  
