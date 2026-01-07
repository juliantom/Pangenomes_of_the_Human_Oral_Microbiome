# 🧬 Workflows

This directory contains the reproducible workflows used to construct and analyze
species-level pangenomes of the human oral microbiome.

The workflows are implemented using **Snakemake** and are organized into two
modular stages: genome processing and pangenome construction. This structure
reflects both the biological logic of the analysis and the goal of producing
reusable, community-facing pangenomes.

***

## 📂 Directory structure

```text
workflow/
├── README.md                  # You are here
├── CODE_OVERVIEW.md           # Technical overview (how the code is organized)
├── VERSIONS.md                # Software and database versions used for this resource
├── WORKFLOWS.md               # Conceptual overview (what happens and why)
│
├── step_01_genome_processing/
│   ├── Snakefile
│   ├── config.yaml
│   └── README.md
│
├── step_02_pangenome_construction/
│   ├── Snakefile
│   ├── config.yaml
│   ├── genome_to_group.tsv
│   └── README.md
