# Pangenomes of the Human Oral Microbiome

**An open, accessible pangenomic resource for exploring genomic diversity in the human oral microbiome—online and offline.**

*This resource treats pangenomes as reusable, community-facing biological objects.*

This repository provides **standardized workflows** and **direct access to hundreds of pre-computed pangenomes** spanning the majority of known oral microbial diversity. Its primary contribution is **democratization**: lowering technical and computational barriers so that pangenomes can be explored, reused, and extended by the broader research community.

---

## Quick Start (30 seconds)

**Explore online (no installation):**
1. Open the HOMD Anvi’o Portal [HOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes).
2. Find a Human Microbial Taxon (HMT) or use the search bar.
3. Visualize pangenomes by clicking 'Open Anvi'o' to launch anvi-display-pan interactive mode or 'Open SVG' for a static image.

**Explore offline (full control):**
1. Open the HOMD Anvi’o Portal [HOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes).
2. Find a Human Microbial Taxon (HMT) or use the search bar.
3. Download the corresponding Anvi’o pangenome database by clicking the 'Download' botton.
4. Activate anvio (v8) environment
5. Display pangenome
   ```bash
   anvi-display-pan -g ${taxon_id}-GENOMES.db -p dir_pan/${taxon_id}-PAN.db
   ```

---

## Start Here

- **Explore immediately (no installation):** visit the interactive website to browse pangenomes, gene clusters, and metabolic annotations.
- **Reuse and extend pangenomes:** download Anvi’o databases for local inspection, modification, or integration with new genomes.
- **Reproduce or adapt the workflows:** use the Snakemake pipelines provided in this repository.

This structure is intentional: users can move seamlessly from exploration → reuse → reproduction.

---

## Access the Resource

### 🌐 Interactive Website (No Installation Required)

👉**Explore the pangenomes online:*** [HOMD Anvi’o Portal ↗](https://www.homd.org/genome/anvio_pangenomes)

All pangenomes are available for **online interactive visualization** through a dedicated **HOMD Anvi’o server**. Users can explore gene clusters, core and accessory genes, and metabolic annotations directly in a web browser.

> This mode of access is intended to support discovery, education, and hypothesis generation without requiring local computational infrastructure.

### 💻 Offline Access (Full Control)

Fully assembled **Anvi’o databases** for each pangenome are available for download. Users with Anvi’o installed can:

- Inspect and edit pangenomes locally
- Add new genomes or metadata
- Recompute analyses or extend pangenomes

Together, online and offline access ensure both **immediacy** and **long-term reusability**.

---

## Philosophy

🧭 **Democratization without hierarchy** — This resource is grounded in the idea that access to complex genomic analyses should not be limited by computational expertise, infrastructure, or institutional resources. Our goal is not to replace or compete with existing efforts, but to **enable researchers at all levels** to explore, question, and build upon pangenomic data.

🫶 **Accessibility as an enabler** — By providing both interactive online visualization and fully reusable offline databases, we aim to meet users where they are: whether they want to browse, teach, explore, or extend. Accessibility here is not simplification—it is an invitation.

🔁 **Pangenomes as evolving objects** — Pangenomes are not static truths. They change as genome sampling improves, assemblies become more complete, and long-read sequencing technologies (e.g., PacBio and Oxford Nanopore) better resolve complex genomic regions. This resource reflects a *current best representation*, with the expectation that future iterations will be richer and more accurate.

🌱 **Built for growth** — We view these pangenomes as starting points for discovery. Users are encouraged to refine them, add new genomes, and reinterpret patterns as methods and data evolve.

---

## Why This Resource Exists

Microbial genomes are increasingly abundant, yet their biological interpretation remains constrained by how difficult it is to integrate, analyze, and *interactively explore* large genome collections. While pangenomes provide a powerful conceptual framework to address this challenge, most existing studies:

- Are **one-off analyses** tied to a specific publication
- Require **substantial computational resources** to reproduce
- Provide figures, but not **reusable pangenomes**
- Limit exploration to static summaries

As a result, much of the biological signal encoded in gene content variation remains inaccessible.

This repository was built to address that gap by treating **pangenomes as shared research objects**, not just analytical by-products.

---

## What Makes This Work Different

The defining feature of this project is not the introduction of a new method, but the **systematic release of ready-to-use pangenomes at scale**.

Specifically, this resource:

- Provides **567 taxon-resolved pangenomes** built under a single analytical framework
- Makes them **immediately explorable online** and **fully reusable offline**
- Preserves rich annotation, metabolic, and phylogenetic context within each pangenome
- Documents the complete workflows for transparency and reuse

The workflows ensure reproducibility, but the **pangenomes themselves are the primary product**.

---

## What This Resource Is (and Is Not)

**This resource is:**
- A standardized collection of taxon-resolved pangenomes built under a single analytical framework (Snakemake + Anvi'o)
- A reusable genomic infrastructure for exploration, comparative analysis, and teaching
- A snapshot of best-available genomic diversity or oral microbes

**This resource is not:**
- A definitive or final representation of any oral taxon
- A clinical or diagnostic reference
- A substitute for taxonomic revision or species definition
- Static—pangenomes will evolve as new genomes and improved assemblies become available

---

## How to Use This Resource

This resource is designed to support a wide range of biological questions and use cases, including:

- **Exploring gene content diversity** within a given oral taxon
- **Comparing core and accessory genomes** across strains
- **Identifying clade-specific genes** associated with ecological specialization
- **Examining metabolic potential** using KEGG-based annotations
- **Teaching pangenomics** using real, complex microbial data
- **Extending existing pangenomes** by adding new genomes

Users can begin with interactive exploration via the website and transition seamlessly to offline analysis as needed.

---

## Why the Human Oral Microbiome?

This project is built on the foundation of the **Human Oral Microbiome Database (HOMD)**, which provides an exceptional framework for pangenomic analysis:

- A **well-curated**, environment-specific genome collection
- Taxa defined as **Human Microbial Taxa (HMTs)** using evolutionary markers
- Long-term commitment to **public accessibility and community use**

HMTs represent biologically meaningful units that capture fine-scale diversity within the oral cavity, making them particularly well suited for systematic pangenomic analysis.

---

## Scope of the Resource

- **567 pangenomes**, one per oral taxon (HMT)
- **8,100+ bacterial genomes** analyzed
- Uniformly processed using **Anvi’o v8**

Each pangenome integrates gene content, functional annotation, and evolutionary relationships within a consistent analytical framework.

---

## Genome Inclusion and Provenance

Genomes included in this resource originate from the Human Oral Microbiome Database (HOMD) and represent cultured isolates, single-cell genomes (SAGs), metagenome-assembled genomes (MAGs), and long-read assemblies. Pangenomes were constructed for Human Microbial Taxa (HMTs) represented by at least two genomes to enable meaningful assessment of gene presence–absence patterns.

Detailed inclusion criteria and quality control procedures are documented and will be available in a separate paper describing the major update in HOMD. Here, we relied on HOMD for inclusion, exclusion, reorganization (HMTs), and naming of genomes and taxa. While CheckM2 (v1.1.0), GTDB (v2.4.1 r226), completeness of 71 universal bacterial genes (Bacteria 71), and contigs stats suggested a few genomes lacked high-quality, no genome was excluded as they represent rare and challenging clades.

---
## Workflow Overview (Transparency and Reuse)

Two Snakemake workflows underpin this resource and are provided to ensure transparency, reproducibility, and extensibility. Each workflow is accompanied by a **condensed DAG** that mirrors the biological logic of the analysis rather than low-level implementation details.

The DAGs are intended as conceptual maps—showing how genomes move from raw sequence to annotated pangenomes—while full details remain encoded in the Snakemake rules.

### Workflow 1: Genome Processing and Annotation (per genome)

- Standardizes genomic FASTA files
- Generates `contigs.db`
- Annotates genomes with:
  - HMMs (rRNAs and universal bacterial marker genes; Bacteria_71)
  - tRNAs (tRNAscan-SE)
  - KEGG Orthologs (KOs)
  - COG20
  - PFAMs
  - CAZymes

### Workflow 2: Pangenome Construction (per HMT)

- Assigns genomes to HMTs using HOMD metadata
- Generates Anvi’o external genome files
- Builds genome storage databases
- Constructs pangenomes
- Computes Average Nucleotide Identity (ANI)
- Estimates KEGG-based metabolic potential
- Identifies single-copy core genes (SCGs)
- Reconstructs phylogenies based on SCGs

---

## Operational Definition

**Pangenome**

The complete set of genes identified across all available genomes belonging to a given **Human Microbial Taxon (HMT)** as defined by HOMD.

Pangenomes include both conserved core genes and variable accessory genes that often encode ecological specialization. Each pangenome represents a best-available snapshot based on current genomic sampling.

---

## Cite This Resource

If you use this resource in your research, teaching, or presentations, please cite it as:

> DOI *Pangenomes of the Human Oral Microbiome.*

Each release of this repository is versioned and archived to preserve reproducibility. A persistent identifier (DOI) will be added as the resource evolves.

---

## License

This repository is released under the GNU General Public License v3.0 (GPL-3.0).

All workflows and code are freely available for reuse and modification under the terms of this license. Please cite the resource when reusing data, workflows, or derived analyses.

---

## Acknowledgments

🧙‍♀️ **HOMD stewards** — This resource is built on the sustained efforts of the **Human Oral Microbiome Database (HOMD)** team. Their long-term commitment to curation, standardization, and public access makes large-scale, community-facing resources like this possible.

🧙 **Anvi’o developers** — We gratefully acknowledge the **Anvi’o development team** for creating a platform that uniquely balances analytical rigor with intuitive, interactive visualization. Anvi’o’s philosophy and design align naturally with our goal of making pangenomes explorable by everyone.

🪄 **Publicly funded science** — This work reflects the aims of long-term, publicly supported research: to build durable, reusable infrastructure that enables discovery beyond any single study.

---

## Governance, Updates, and Longevity

🔮 **Update cycle** — Pangenomes will be revisited and updated approximately **every two years**, in step with major releases of the Human Oral Microbiome Database (HOMD).

🧩 **Versioning** — Each release will be versioned and archived to preserve reproducibility while allowing the resource to grow as new genomes become available.

🧙‍♂️ **Stewardship** — This repository is maintained as a community resource. Contributions, issue reports, and suggestions are welcome and encouraged.

---

## Who This Is For

This repository is intended for microbiologists, computational biologists, educators, trainees, and clinicians who wish to explore oral microbial diversity without the burden of large-scale recomputation.

---

## Key Takeaway

By making hundreds of oral microbial pangenomes **directly accessible**, both online and offline, this project reframes pangenomes as **shared biological infrastructure**—enabling exploration, reuse, and discovery across the community.

*We hope this resource lowers barriers, sparks questions, and grows alongside the community that uses it.*

