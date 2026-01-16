
# 🧬 Pangenome Visualization Workflow — Step 3

**Created by:** Julian Torres Morales  
**Date:** December 15, 2025  

***

⚠️ **WARNING: HIGH STORAGE AND I/O USAGE** ⚠️<br>
> This workflow is **storage‑intensive** and intended for systems with **ample disk space and fast I/O**.
>
> - The complete visualization folder is ~**61 GB** (for 579 taxa)
> - Requires repeated **disk access** to `.db`, `.svg`, and `.pdf` files
> - Multiple browser‑based visualization servers (`anvi-display-pan`) may run concurrently (set to 10)
>
> ✅ **Recommendation:**
> - Perform visualization steps on a **server or workstation** when possible
>   - Anvi'o installed locally
>   - Inkscape (v 1.4.2)
> - Transfer results back to the server only after figures are finalized
> - Process taxa in **small batches** to avoid port conflicts and browser overload

***

This workflow uses a pre-built visualization file (state - JSON) to standardize **interactive and static pangenome visualizations**.

It is designed to:
- Apply a **consistent visualization state** across all pangenomes
- (Re-)generate **SVG and PDF files** as those in HOMD-hosted anvio'o portal
- Create a **compact, shareable visualization directory**

This workflow depends on outputs generated in:
- `03_pangenome_analysis` (HMT‑level pangenomes)
- `04_pangenome_analysis_species` (species‑level pangenomes)

***

## 🔍 Overview

### Step 1 – Curate and copy pangenome files

**Objective:**
Create a minimal and consistent directory structure.

**Key Actions:**
- Copy curated files per taxon:
  - Genome storage databases
  - Pangenome databases
  - ANI matrices
  - Phylogenomic trees
  - Metabolic module summaries
- Merge HMT‑ and species‑level taxa into a single visualization folder

**Outputs:**
For each taxon (`Taxon_ID`), a directory is created under `visualization/data/Taxon_ID/` containing:
- `Taxon_ID-GENOMES.db`
- `genome-add_info.txt`
- `dir_ani/`
- `dir_pangenome/Taxon_ID-PAN.db`
- `dir_phylogenomics/Taxon_ID-tree.nwk`
- `dir_metabolism/Taxon_ID_modules.txt`

***

### Step 2 – Import a global visualization state

**Objective:**
Ensure visual consistency across all pangenomes.

**Key Actions:**
- Import a minimal base state (`base_pangenome_with_functions.json`) into every pangenome
- Set the **imported state** as the **default**

***

### Step 3 – Optimize display layout by genome count

**Objective:**
Improve readability of pangenomes with widely varying genome counts.

**Key Actions:**
- Group taxa based on number of genomes:
  - ≤25 genomes
  - 26–50 genomes
  - 51–100 genomes
  - >100 genomes
- Manually adjust genome height and margin for the latter three groups

**Layout settings:**

| Group | Genomes | Height | Margin |
|-----|--------|--------|--------|
| 1 | ≤25 | 180 | 15 |
| 2 | 26–50 | 90 | 7 |  
| 3 | 51–100 | 45 | 3 |
| 4 | >100 | 15 | 1 |

These adjustments ensure that dense pangenomes remain interpretable while preserving comparability across taxa.

***

### Step 4 – Export figures (SVG and PDF)

**Objective:**
Generate static SVG and PDF files.

**Key Actions:**
- Run `anvi-display-pan` to save SVG directly
- Convert SVG → PDF using Inkscape

**Outputs:**
For each taxon:
- `dir_figs/Taxon_ID-default.svg`
- `dir_figs/Taxon_ID-default.pdf`

PNG export is discouraged due to extremely large file sizes at high DPI.

***

## ✅ Notes
