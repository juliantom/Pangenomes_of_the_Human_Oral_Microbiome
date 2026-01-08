# 🧬 Pangenome Analysis Workflow

***

⚠️ **WARNING: HIGH RESOURCE USAGE** ⚠️<br>
> This workflow is **computationally intensive** and intended for **high‑performance environments**.
> 
> - Set up on a machine with **112 threads** and **3 TB RAM**
>   - ⏱ Run Time Full Genome Processing (genomes = 8,174): 6 days
>   - ⏱ Run Time Full Pangenomic Analysis (taxa = 567): 3 days
> - **Thread allocation is dynamic**, set per **taxon** and **rule** — adjust to match your system
> - **Snakemake may launch all threads simultaneously if not properly configured**
> - **Adjust thread setting** in `config_group_threads.yaml` as needed
> - ✅ **Start small:** run one taxon, confirm resource usage, then scale

***

This workflow automates **pangenome construction, ANI calculation, dereplication, phylogenomics, and metabolic estimation** for oral microbiome species in HOMDv4.1.-
It consists of two major steps:

1. **Select HMTs with at least 2 genomes** (n = 567)  
2. **Execute the `Snakefile`** for pangenomic analysis  

All processing is fully reproducible and is linked to the [`genome_processing`](../genome_processing/README.md) workflow.

***

## 🔍 Overview

### Step 1 – Count genomes per taxa (HMT)

**Objective:**  
Identify taxa (HMTs) with at least two genomes (`contigs.DB`).

**Key Actions:**  
- Count the number of genomes per HMT  
- Subset the HMT and genome lists for taxa with ≥2 genomes  

**Outputs:**  
- Two lists:  
  - Taxa with ≥2 genomes  
  - Taxa with only one genome  

***

### Step 2 – Execute Pangenome Workflow

**Objective:**  
Perform pangenomic analysis. The Snakemake workflow (`Snakefile`) organizes tasks into multiple rules for optimized execution. Thread allocation is dynamic, based on the number of genomes per HMT (upper limit = 100).

**Key Actions:**  

1. Subset genome IDs and `contigs.DB` paths per HMT  
2. Build the **genome storage database**
3. Construct **pangenomes**  
4. Compute **Average Nucleotide Identity (ANI)** using pyANI (ANIb method)  
5. **Dereplicate genomes** based on ANI thresholds  
6. Estimate **metabolic potential** using KEGG Modules  
7. Infer **phylogenomic relationships** using single-copy core genes with 1000 bootstrap replicates  

**Outputs:**  
All files are saved in `results/Taxon_ID`:

- Genome storage database: `Taxon-GENOMES.DB`  
- Pangenome database: `dir_pan/Taxon-PAN.DB`  
- ANI tables and dendrograms: `dir_ani/ANI_percentage_identity.txt` and `dir_ani/ANI_percentage_identity.newick`  
- Dereplication clusters: `dir_dereplication/derep_950/CLUSTER_REPORT.txt`  
- Metabolic potential: `dir_metabolism/Taxon-modules.txt`  
- Phylogenomic tree: `dir_phylogenomics/Taxon-tree.nwk`  

***

## ✅ Notes

- Functional annotation is **not required** for pangenome construction; `contigs.DB` files may be unannotated.  
- Workflow is **robust and reproducible**; done flags prevent rerunning completed steps.  
- Phylogenomics is skipped for taxa with <3 genomes.  
- All software and databases required are the same as in the [`genome_processing`](../genome_processing/README.md) workflow.  

