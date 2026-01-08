# 🧬 Workflows

This directory contains the reproducible workflows that power the construction and analyzis of species-level pangenomes of the human oral microbiome. These workflows are implemented in **Snakemake** and organized into two modular stages: 
- Genome processing - prepares genomic files into searchable databases with annotations
- Pangenome construction - builds taxon-specific pangenomes and associated metrics

This structure reflects both the biological logic of the analysis and the goal of producing reusable, community-facing pangenomes.

***

## 📂 Directory structure

```text
workflow/
├── README.md                  # Overview of workflows (you are here)
├── CODE_OVERVIEW.md           # Technical overview (how the code is organized)
├── VERSIONS.md                # Software and databases versions used
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
```

***

Each step is self-contained, with its own configuration files and documentation. This modular design ensures scalability, transparency, and reproducibility.

***

## 🔍 Why This Matters

These workflows enable:

- Reproducible pangenome construction for oral taxa
- Community reusability – anyone can extend or adapt the pipeline
- Transparency – every step is documented and version-controlled

For conceptual details, see [`WORKFLOWS.md`](WORKFLOWS.md) For technical implementation, see [`CODE_OVERVIEW.md`](CODE_OVERVIEW.md).
