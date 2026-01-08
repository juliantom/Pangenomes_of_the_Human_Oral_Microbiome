#!/usr/bin/env python3

# ================================
# Generate YAML configuration for Snakemake pangenome workflow
# Each species (taxon) gets a thread allocation based on genome count
# ================================

# ------------------------------
# Standard library imports
# ------------------------------
import os       # For creating directories
import csv      # For reading tab-delimited files
import yaml     # For writing YAML configuration files

# ------------------------------
# Paths to input/output files
# ------------------------------
# List of taxa to include (one taxon per line)
species_file = "98_data/03-list_group.txt"

# Precomputed genome counts per taxon (tab-delimited)
counts_file = "98_data/03-group_count.txt"

# Output YAML configuration for Snakemake
output_file = "config/config_group_threads.yaml"

# ------------------------------
# Read species of interest
# ------------------------------
# Using a set for quick lookup and removing any empty lines
with open(species_file) as f:
    species_set = set(line.strip() for line in f if line.strip())

# Optional debug: show number of species read
# print(f"Loaded {len(species_set)} species from {species_file}")

# ------------------------------
# Read genome counts and assign threads
# ------------------------------
counts = {}
with open(counts_file) as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        species = row["Species"].strip()
        count = int(row["Group_size"])
        
        # Only include species in our list
        if species in species_set:
            # Assign threads dynamically:
            # - Minimum 6 threads
            # - Maximum 100 threads
            # - Otherwise, use the number of genomes as thread count
            threads = min(100, max(6, count))
            counts[species] = threads
            
            # Optional debug: print assignment for first few species
            # print(f"{species}: {count} genomes -> {threads} threads")

# ------------------------------
# Write YAML configuration
# ------------------------------
# Sort species alphabetically for readability
outdata = {"species_threads": dict(sorted(counts.items()))}

# Make config directory if it does not exist
os.makedirs("config", exist_ok=True)

# Write YAML file
with open(output_file, "w") as f:
    yaml.dump(outdata, f, sort_keys=False, default_flow_style=False)

# Confirm success
print(f"Wrote threads config for {len(counts)} species to {output_file}")
