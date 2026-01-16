# 🧬 Workflow Overview

This repository implements a **two-stage modular workflow** for constructing and analyzing taxon-specific pangenomes of oral microbes. The workflows prioritize transparency, reproducibility, and community utility, allowing each stage to be reused or adapted for new genome collections. A **third stage** describes how to import state files (JSON) containing the visual instructions for anvi’o, along with the corresponding procedure to generate SVG and PDF outputs for download.

***

## Workflow Steps

## 1. Genome Identification and Retrieval

**Purpose:** Establish a curated starting point

- Identify reference genomes in the Human Oral Microbiome Database (HOMD)
- Retrieve assemblies from GenBank

**Why:** A good reference ensures taxonomic consistency, quality, and environmental boundaries of genomes

***

## 2. Genome Processing and Annotation

**Purpose:** Prepare genomes

- Process assemblies with Anvi'o to create contigs databases
- Perform gene calling and add functional annotations

**Output:** One Anvi'o contigs database per genome

**Why:** All genomes are process with the same parameters

***

## 3. Taxon-Based Genome Grouping

**Purpose:** Organize genomes by biologically meaningful taxonomic units, such as Human Microbiome Taxon (HMT) used by HOMD

- Group genomes using a genome-to-taxon mapping file 
- Each taxon is processed independently for scalability

**Why:** Ease to search

***

## 4. Pangenome Construction

**Purpose:** Define core and accessory gene content

- Groups genes based on amino acid similarity into putative homologous gene clusters
- Genereate taxon-specific pangenomes

**Why:** Reveal shared and unique features at the strain level

***

## 5. Comparative Analyses (complementary)

**Purpose:** Add contect and metrics

- Compute Average nucleotide identity (ANI)
- Build phylogenomic trees (with bootstrap support)
- Assess Metabolic completeness

**Why:** Supports evolutionary and functional insights

***

## 6. Visualization and Dissemination (no code)

**Purpose:** Make pangenomes visually engaging

- Interactive visualization via web
- Local exploration
