# 🧬 Pangenomes of the Human Oral Microbiome

**A curated collection of species-level pangenomes for taxa in the expanded Human Oral Microbiome Database (eHOMD)**

***

This repository provides stable, open-access workflows and direct access to hundreds of pangenomes, enabling visualization and exploration of core and accessory gene content across oral microbial taxa (bacteria and archaea).

*This repository constitutes an ecosystem-wide, taxon-resolved pangenome reference for the human oral microbiome.*

<br>

> **Operational definition**  
> A *pangenome* is defined here as the **complete set of protein-coding and non-coding genes** across all genomes assigned to a taxon in eHOMD, including **core genes** (shared by all or most members) and **accessory genes** (present in some or unique to individual strains).

<br>

*This resource treats pangenomes as reusable, community-facing biological objects.*

***

## 🚀 Quick Start

### 🌐 Online (interactive experience — no installation needed)
1. Browse pangenomes interactively through the **eHOMD Anvi’o Portal**  
   👉 [eHOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes)  
   *No Anvi’o installation required*
2. Select a taxon to view its pangenome
3. Explore and modify interactive visualizations
4. Identify **shared** and **unique** features across strains
5. Use these pangenomes for any purpose you choose

### 💻 Offline (full control)
1. Download Anvi’o-compatible pangenome databases  
   👉 [eHOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes)
2. Install Anvi’o locally  
   👉 [Anvi’o installation ↗](https://anvio.org/install/)
3. Explore and analyze pangenomes locally
4. Perform advanced or customized analyses

***

## 🧬 What This Repository Contains

Code used to generate:
- Species-level pangenomes for **567 species** represented by ≥2 genomes in a single Human Microbial Taxon (HMT) in eHOMD
- **12 additional species pangenomes** that included multiple HMTs representing different genomic clades
- **Total pangenomes:** 579
- **Genomes included:** 8,115 of 8,177 genomes in eHOMD

***

## 🧩 Scope and Boundaries

**This resource provides:**
- Visual access to core and accessory gene content across all available pangenomes
- Systematically constructed, taxon-resolved pangenomes for oral bacteria and archaea
- A reference framework for examining genomic variation within taxa (Snakemake + Anvi’o)

**This resource does NOT provide:**
- Claims-driven biological interpretation
- Predictive functional modeling

All content reflects completed analyses within the scope of current funding.

***

## 🔮 Pangenome Construction (Overview)

Pangenomes are constructed within the **Anvi’o** platform using a standardized workflow.

Key steps include:
- Prediction of open reading frames (ORFs; hereafter referred to as *genes*)
- Functional annotation using curated databases (COGs, Pfams, KEGG KOs, etc.)
  *Gene prediction and annotation are performed uniformily across all genomes to minimize technical sources of variation and maximize comparability*
- Clustering of genes into putative homologous gene clusters based on amino-acid similarity
- Species-level optimization of clustering parameters
- Hierarchical organization of gene clusters and genomes to highlight shared content and strain relationships

Detailed methodological descriptions are provided in the associated Anvi’o documentation and publications.

***

## 🧑‍💻 Reproducing or Extending the Work
*For those who want the full experience — you know who you are* 😉  

This repository includes:
- Full analysis code used to generate the distributed pangenomes
- Two Snakemake workflows to process genomes and construct pangenomes
- Additional scripts designed to execute in **detached mode**

For users wishing to reproduce analyses or construct pangenomes for other taxa:
- [`WORKFLOWS.md` ↗](workflow/WORKFLOWS.md) — overview of the Snakemake pipelines
- [`CODE_OVERVIEW.md` ↗](workflow/CODE_OVERVIEW.md) — description of scripts and analysis logic

These materials are provided for transparency and reproducibility.  
Re-running or extending the workflows is optional and not required to use the resource.

**Just the code?**
- [Genome Processing ↗](workflow/genome_processing/CODE.md)
- [Pangenome Analysis ↗](workflow/pangenome_construction_hmt/CODE.md)

**✅ Tested Environments**
- 🐧 Linux (Ubuntu 24.04.3 LTS)
- 🍎 macOS (Sequoia 15.7.3 Intel(R) Core(TM) i9-9880H CPU @ 2.30GHz)

*This workflow requires a POSIX-compliant shell (bash or zsh).  
It has **not been tested on native Windows or WSL**, but it should work in WSL2 or Docker, as they provide POSIX-compliant environments.*

***

## 📦 Additional Associated Files

Supplementary data products generated during pangenome construction may be provided, including:
- Average Nucleotide Identity (ANI) matrices
- Phylogenomic reconstructions based on single-copy core genes
- Functional annotation summaries

These files support interpretation of the pangenomes and are not intended as standalone analyses. These products are provided to contextualize the pangenomes and facilitate downstream interpretation, but are not intended to constitute independent biological claims.

***

## 🔧 Data and Software Versions

- **eHOMD:** v4.1φ (phi release, includes phage genomes)
  - **Genomic RefSeq:** v11.02
- **Anvi’o:** v8

*Version information provided for reproducibility and temporal context (as of August 19, 2025).*

***

## 📖 Citation

If you use these pangenomes, please cite the associated resource announcement and acknowledge the data and tools that made this work possible:

- Torres-Morales J, Giacomini JJ, Chen T, Voorhis A, Kauffman KM, Dewhirst FE, Borisy GG, Mark Welch JL. Pangenomes of the human oral microbiome. Microbiol Resour Announc. 2026 Jul 9;15(7):e0026126. doi: 10.1128/mra.00261-26. Epub 2026 May 29. PMID: 42212655; PMCID: PMC13348354.

Please also consider citing:
- Expanded Human Oral Microbiome Database (eHOMD)  
  👉 https://doi.org/10.1128/msystems.00187-18
- Anvi’o  
  👉 https://anvio.org/cite/

***

## 🧙 Acknowledgments

🛡️ **eHOMD stewards**  
This resource builds on the sustained efforts of the **expanded Human Oral Microbiome Database (eHOMD)** team. Their long-term commitment to curation, standardization, and public access makes large-scale, community-facing resources possible.  
👉 https://www.homd.org

🧙 **Anvi’o developers**  
We gratefully acknowledge the **Anvi’o development team** for creating a platform that balances analytical rigor with intuitive, interactive visualization.  
👉 https://anvio.org/learn/pangenomics/

🪄 **Publicly funded science**  
This work reflects the goals of long-term, publicly supported research: building durable, reusable infrastructure that enables discovery beyond any single study.

***

## ⚖️ License

All content in this repository is released under the **GNU General Public License v3.0 (GPL-3.0)**.

***

## 📬 Contact

For questions or issues related to this resource, please contact the maintainers via **eHOMD**.
