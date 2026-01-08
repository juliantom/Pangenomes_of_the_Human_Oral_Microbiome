# 🧬 Pangenome, ANI, Phylogeny, Dereplication, Metabolism Workflow

**Created by:** Julian Torres Morales  
**Date:** December 8, 2025  

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

This script implements the workflow to identify and select representative genomes for each taxon in HOMDv4.1 using ~95% percent identity thresholds. Taxa definitions follow the HOMD genome table: [HOMD Genome Table](https://www.homd.org/genome/genome_table).  

***

## **Workflow Overview**

### **1️⃣ Prepare working folder and run first dereplication**
- Only taxa with ≥2 genomes are considered.
- Snakemake workflow is used to:
  1. Compute pairwise ANI values for genomes.
  2. Cluster genomes based on percent identity thresholds (85–99%).  
- ANI computation uses **pyANI** with the **ANIb** method (BLASTn-based).  
- Genome clustering is performed with a greedy algorithm.  
- A representative genome is selected per cluster based on **centrality** (lowest distance to all other genomes).  

```bash
# Create working directory
dir_first_derep=15_pangenome_ani_phylogeny_2025_12_08
mkdir -p "$dir_first_derep"/data

original_genome_to_hmt="98_data/genome_ids-8174-long.txt"

# Create genome-to-group mapping file
all_genome_to_group_file=$dir_first_derep/data/01-genome_to_tax_group-8174.txt
cat "$original_genome_to_hmt" | sed -e 's/_/|/2' \
  | awk 'BEGIN{FS=OFS="|"}{print $2,$1}' \
  | awk -F'_str_' '{print $0"|"$1}' \
  | awk -F'|' -v OFS="\t" '{print $1,$3"_homd_"$2}' \
  > "$all_genome_to_group_file"

# Create a list of taxa with at least 2 genomes
list_taxon=$dir_first_derep/data/02-list_group.txt
awk '{print $2 | "sort | uniq -c" }' "$all_genome_to_group_file" \
  | awk '{if($1>1)print $2}' > "$list_taxon"

# List of HMTs with only one genome
list_singleton_taxon=$dir_first_derep/data/02-list_group-only_one_genome.txt
awk '{print $2 | "sort | uniq -c" }' "$all_genome_to_group_file" \
  | awk '{if($1==1)print $2}' >  "$list_singleton_taxon"

# Create file linking genomes to HMT groups
genome_to_group_pass="$dir_first_derep/data/03-group_to_genomes.txt"
> "$genome_to_group_pass"
while IFS= read -r group; do
    grep "$group" "$all_genome_to_group_file" \
    | awk -F'_homd_' -v OFS="\t" '{print $0, $2}' \
    >> "$genome_to_group_pass"
done < "$list_taxon"

# Count genomes per species
group_count="$dir_first_derep/group_count.txt"
awk 'BEGIN{FS=OFS="\t"}{print $2 | "sort | uniq -c" }' "$genome_to_group_pass" \
  | awk -v OFS="\t" 'NR==1{print "Species","Group_size"}{if($1>1)print $2,$1}' > "$group_count"

# Copy files for workflow input
cp "$list_taxon" "$dir_first_derep/list_group.txt"
cp "$genome_to_group_pass" "$dir_first_derep/group_to_genomes.txt"

# Generate YAML config for Snakemake
cp 99_scripts/s-03_generate_yaml.py "$dir_first_derep"
./$dir_first_derep/s-03_generate_yaml.py
```
## **2️⃣ Test Snakemake workflow**
```bash
cd $dir_first_derep
conda activate anvio-8

# Generate rulegraph
snakemake --rulegraph | dot -Tpdf > rulegraph-test_1.pdf

# Dry run (test)
snakemake --jobs 48 --cores 48 --quiet -n

# Run workflow
snakemake --jobs 48 --cores 48 --quiet
# Clean outputs (optional)
# snakemake --cores 90 clean
cd ../

```
## **3️⃣ Run full Snakemake workflow for oral species**
```bash
nohup ./99_scripts/s-15_pangenome_ani_phylo-snakemake_wf-2025_12_08.sh \
    >> 97_nohup/nohup-15_pangenome_ani_phylo-snakemake_wf-2025_12_08.out 2>&1 &

```
## **4️⃣ Check completion status**
```bash
Some rules may fail if the number of genomes is too low (phylogenomics requires ≥3–4 genomes).

ls ./15_pangenome_ani_phylogeny_2025_12_08/99_done/ \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f1

ls ./15_pangenome_ani_phylogeny_2025_12_08/99_done/ \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  | cut -f2

ls ./15_pangenome_ani_phylogeny_2025_12_08/99_done/ \
  | sed -e 's/.*-//' \
  | sort | uniq -c \
  | awk -v OFS="\t" 'NR==1{print "Rule","Finished"}{print $2,$1}' \
  > 15_pangenome_ani_phylogeny_2025_12_08/summary_rules.txt
```
## **5️⃣ Summarize number of completed rules**
```bash
dir_done="15_pangenome_ani_phylogeny_2025_12_08/99_done"
summary_file="15_pangenome_ani_phylogeny_2025_12_08/summary_rules-2025_12_23.txt"

printf 'Snakemake_Rule\tCompleted_Processes\n' > "$summary_file"
set -- "$dir_done"/*
if [ "$1" != "$dir_done/*" ]; then
  printf '%s\n' "$dir_done"/* \
    | sed 's#.*/##' \
    | awk -F'-' '{print $NF}' \
    | sort \
    | uniq -c \
    | awk -v OFS='\t' '{print $2,$1}' \
    | sort -k2,2n -k1,1 \
    >> "$summary_file"
fi
```

