🧬 Pangenome Analysis Workflow

This workflow automates pangenome construction, ANI calculation, dereplication, phylogenomics, and metabolism estimation for oral microbiome species in HOMDv4.1. It consistes of two mayor steps:
1. First, selection of HMTs with at least 2 genomes (n = 567)
2. Second, execution of the `Snakefile`

All processing is fully reproducible and is linked to the [`genome_processing`](../genome_processing/README.md).

***

## **Overview**

1. **Dereplication** – Identify representative genomes for each taxon using ~95% identity thresholds.  
2. **ANI Computation** – Pairwise genome similarity calculated with pyANI (ANIb method).  
3. **Pangenome Construction** – Generate species-level pangenomes independent of functional annotations.  
4. **Dereplication** – Cluster genomes and select central representatives.  
5. **Metabolism Estimation** – Predict genome metabolic potential.  
6. **Phylogenomics** – Extract single-copy core genes and build trees (requires ≥3 genomes).  

***

## **Requirements**

- **Conda Environment:** anvio-8  
- **Software:** Anvi'o v8, Python 3.10.15, IQ-TREE2, Trimal, BLAST+, pyANI  
- **Databases:** CAZymes v13, KEGG 2023-09-22, COG20, Pfam v37.2, GTDB v214  
- **Snakemake:** Required for workflow orchestration  

***

## **Usage**

1. Prepare directories and genome-to-group files.
2. Generate YAML config for Snakemake.
3. Test Snakemake workflow with dry run (`-n`) and generate rule graph.
4. Run full workflow with `snakemake --jobs X --cores Y`.
5. Monitor completion in `99_done/`.
6. Summarize rule completion with `summary_rules-YYYY_MM_DD.txt`.

***

## **Notes**

- Functional annotation is **not required** for pangenome construction; contigs databases may be unannotated.  
- The workflow is robust to partial failures; done flags prevent reprocessing of completed steps.  
- Phylogenomics requires ≥3–4 genomes per species; otherwise, the step is skipped.  

