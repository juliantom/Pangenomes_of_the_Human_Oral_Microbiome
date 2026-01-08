#!/usr/bin/env python3

# Standard library imports
import os  # For creating directories
import csv  # For reading tab-delimited files
import yaml  # For writing YAML configuration files

# Paths to your input files
species_file = "98_data/03-list_group.txt"
counts_file = "98_data/03-group_count.txt"
output_file = "config/config_group_threads.yaml"

# Read species of interest into a set
with open(species_file) as f:
    species_set = set(line.strip() for line in f if line.strip())

# Read precomputed genome counts
counts = {}
with open(counts_file) as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        species = row["Species"].strip()
        count = int(row["Group_size"])
        if species in species_set:
            threads = min(100, max(6, count))
            counts[species] = threads

# Save as YAML
outdata = {"species_threads": dict(sorted(counts.items()))}
os.makedirs("config", exist_ok=True)
with open(output_file, "w") as f:
    yaml.dump(outdata, f, sort_keys=False, default_flow_style=False)

print(f"Wrote threads config for {len(counts)} species to {output_file}")

