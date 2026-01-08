# Pangenomes of the Human Oral Microbiome 🦷 🦠

**A curated collection of species-level pangenomes for taxa in the Human Oral Microbiome Database**

This repository provides stable, open-access workflows and direct access to hundreds of pangenomes, enabling visualization and exploration of core and accessory gene content across oral microbial taxa (bacteria and archaea).

*This resource treats pangenomes as reusable, community-facing biological objects.*

***

## 🚀 Quick Start

### 🌐 Online (I want a sneak peek)
1. Browse pangenomes interactively through the HOMD Anvi’o Portal [HOMD Anvi’o Server Portal ↗](https://www.homd.org/genome/anvio_pangenomes)
   - *No Anvi'o installation needed*
2. Select a taxon and inspect core and accessory gene clusters
3. Use these pangenomes as a reference for comparative analysis

### 💻 Offline (I want full control)
1. Download Anvi'o-compatible pangenome databases [HOMD Anvi’o Servern Portal ↗](https://www.homd.org/genome/anvio_pangenomes)
   - *Anvi'o installation required*
2. Load databases locally for deeper exploration
3. Summarize gene-cluster content and functional annotation

***
## 🧬 What This Resource Contains

- Species-level pangenomes for 567 Human Microbial Taxa (HMTs) with ≥2 genomes in HOMD
- 12 additional pangenomes for named species containing multiple taxa (HMTs)
- Total pangenomes: 579
- Genomes included: 8,110 from 8,177 genomes in HOMD

***

## 🧩 Scope and Boundaries

**This resource provides:**
- Visual access to core and accessory gene content across all available pangenomes
- Systematically constructed, taxon-resolved pangenomes for oral bacteria and archaea
- A reference framework for examining genomic variation within taxa (Snakemake + Anvi'o)

**This resource does NOT provide:**
- Claims-driven biological interpretation
- Predictive functional modeling

All content reflects completed analyses within the scope of current funding.

***

## 🔮 Pangenome Construction (Overview)

Pangenomes are constructed within the Anvi’o platform using a standardized workflow. Key steps include:
- Open reading frames (ORFs; hereafter called genes) are predicted from genome assemblies
- Genes are functionally profiled using curated databases (COGs, Pfams, KEGG KOs, etc.)
- Genes are clustered into putative homologous gene clusters based on amino-acid similarity
- Clustering parameters are optimized at the species level
- Gene clusters and genomes are hierarchically organized to highlight shared gene content and strain relationships

Detailed methodological descriptions are provided in the associated Anvi’o documentation and publications.

***

## 🧑‍💻 Reproducing or Extending the Work
*For those who want the full experience — you know who you are*<br>

This repository includes:
- Two Snakemake workflows implementing the pangenome construction pipeline
- Full analysis code used to generate the distributed pangenomes

For users who wish to reproduce analyses or construct pangenomes for additional taxa, see:
- `WORKFLOWS.md` — overview of the Snakemake pipelines
- `CODE_OVERVIEW.md` — description of scripts and analysis logic

These materials are provided for transparency and reproducibility.
Re-running or extending the workflows is optional and not required to use the resource.

***

## 📦 Additional Associated Files

Supplementary data products generated during pangenome construction may be provided, including:
- Average Nucleotide Identity (ANI) matrices
- Phylogenomic reconstructions based on single-copy core genes
- Functional annotation summaries

These files support interpretation of the pangenomes and are not intended as standalone analyses.

***

## 🔧 Data and Software Versions

- **HOMD**: v4.1φ (phi release, includes phage genomes)
- **Anvi’o**: v8

Version information is provided to support reproducibility and temporal context.

***

## 📖 Citation

If you use these pangenomes, please cite the associated resource announcement and acknowledge the data and tools that made this work possible:

- *Pangenomes of the Human Oral Microbiome* (Microbiology Resource Announcement) — DOI: [TBD]
- Expanded Human Oral Microbiome Database (eHOMD)

***

## 🧭 On a Personal Note

If you’re reading this, there’s a decent chance you’re procrastinating. That’s fine — so was I.

This repository exists largely because I wanted to not do something the “right” way the first time. Anvi’o already provides Snakemake workflows that can process genomes and construct pangenomes, and in many situations those workflows would have been more than sufficient. In fact, a much shorter path to the same endpoint.

But I wanted more control over how things ran, to plug in a few tools that weren’t part of the standard workflows at the time, and—if I’m honest—to avoid bothering the Anvi’o developers with feature requests while they were busy doing far more interesting things. I also knew just enough Snakemake to be dangerous, which felt like a good reason to learn it properly rather than pretending I understood it.

So instead of extending upstream code (or opening the appropriate GitHub issue, as a more responsible person might have done), I took the long way around. What came out of that decision is this repository: a working, reproducible pipeline shaped as much by curiosity and stubbornness as by necessity.

In the end, this probably could have been achieved with fewer lines of code inside Anvi’o. That’s okay. Bioinformatics allows many paths to the same result, and sometimes the scenic route is the one where you learn the most.

***

## 🧙 Acknowledgments

🛡️ **HOMD stewards** — This resource builds on the sustained efforts of the **Human Oral Microbiome Database (HOMD)** team. Their long-term commitment to curation, standardization, and public access makes large-scale, community-facing resources possible. For more information, see the [HOMD Website↗](https://www.homd.org).

🧙 **Anvi’o developers** — We gratefully acknowledge the **Anvi’o development team** for creating a platform balancing analytical rigor with intuitive, interactive visualization. For extensive documentation on Anvi'o installation, pangenome construction and usage, see [Anvi'o Pangenomics Website↗](https://anvio.org/learn/pangenomics/).

🪄 **Publicly funded science** — This work reflects the goals of long-term, publicly supported research: building durable, reusable infrastructure that enables discovery beyond any single study.

***

## ⚖️ License

All content in this repository is released under the GNU General Public License v3.0 (GPL-3.0).

***

## 📬 Contact

For questions or issues related to this resource, please contact the maintainers via HOMD.
