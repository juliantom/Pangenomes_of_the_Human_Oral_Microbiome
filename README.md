# Pangenomes of the Human Oral Microbiome 🦷

**A curated collection of pangenomes for taxa in the Human Oral Microbiome Database**

This repository provides stable, open-access workflow, and direct access to hundreds of pangenomes enabling visualization and exploration of core and accessory gene content across oral microbial taxa- bacteria and archaea.

*This resource treats pangenomes as reusable, community-facing biological objects.*

---

## 🚀 Quick Start

**🌐 Online (I want a sneak peak)**
1. Browse pangenomes interactively through the HOMD Anvi’o Portal [HOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes). No anvi'o installation needed.
2. Select a taxon and inspect core and accessory gene clusters.
3. Use these pangenomes as a reference for comparative analysis.

**💻 Offline (I want full control)**
1. Download Anvi'o-compatible pangenome databases.
2. Load databases locally for maximum exploration.
3. Summarize gene-cluster information and annotation.

---

## What This Resource Contains

- Species-level pangenomes for all taxa represented in HOMD, including both named species and Human Microbial Taxa (HMTs)
- Pangenomes constructed independently for each taxon
- Taxa for which multiple closely related groups exists (HMTs) are treated as separate pangenomes
At present, 12 named species contain multiple distinct taxa, each represented by its own pangenome.

---

## 🧩 Scope and Boundaries

**This resource provides:**
- Systematically constructed taxon-resolved pangenomes for oral bacteria and archaea
- A reference framework for examining genomic variation within taxa (Snakemake + Anvi'o)
- Visual access to core and accessory gene content for over 567 pangenomes

**Specifically, this resource:**
- Claims-driven biological interpretation
- Predictive functional modeling

All content reflects completed analyses within the scope of current funding.

---

## 🧙‍♂️🔮 Pangenome Construction (Overview)

Pangenomes are constructed within Anvi'o platform using a standarized workflow:
- Open reading frames are predicted from genome assemblies
- Genes are clustered into putative homologous gene clusters based on amino-acid similarity
- Clustering parameters optimized at the species level
- Both gene clusters and genomes are hierarchichally clustered to highlight shared gene content and relationship

Detailed methods are provided in Anvi'o.

---

## 🧑‍💻 Reproducing or Extending the Work

This repository includes:
- Two Snakemake workflows implementing the pangenome construction pipeline
- Full analysis code used to generate the distribured pangenomes
For users who wish to reproduce the analysis or construct pangenomes for additional taxa, see:
WORKFLOWS.md - overview of the Snakemake popelines
CODE_OVERVIEW.md - description of scripts and analysis logic
These materials are provided for transparency and reproducibility. Re-running or extending the workflows is optional and not required to use the resource.
---

## 📦 Additional Associated Files

Supplementary supporting data products generated during pangenome construction may be provided, including:
- Average Nucelotide Identity (ANI) matrices
- Phylogenomic reconstructions based on single-copy core genes (from the pangenome)
- Metabolic annotation summary

---


## 📖 Citation

A lot of effort has been made by many parties to make this resource available.
If you use these pangenomes please consider citing the associated announcement, HOMD (?), and Anvi'o (?).

> DOI *Pangenomes of the Human Oral Microbiome.*
> eHOMD
> Anvi'o

---

## License

All content in this repository is released under the GNU General Public License v3.0 (GPL-3.0).

---

## Acknowledgments

🧙‍♀️ **HOMD stewards** — This resource is built on the sustained efforts of the **Human Oral Microbiome Database (HOMD)** team. Their long-term commitment to curation, standardization, and public access makes large-scale, community-facing resources like this possible.

🧙 **Anvi’o developers** — We gratefully acknowledge the **Anvi’o development team** for creating a platform that uniquely balances analytical rigor with intuitive, interactive visualization. Anvi’o’s philosophy and design align naturally with our goal of making pangenomes explorable by everyone.

🪄 **Publicly funded science** — This work reflects the aims of long-term, publicly supported research: to build durable, reusable infrastructure that enables discovery beyond any single study.

---

## 📬 Contact

For questions or issues related to this resource, please open a GitHub issue or contact the maintainers via HOMD.
