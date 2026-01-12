#!/usr/bin/env python

# ================================
# Generate YAML configuration for Snakemake workflow
# Each group gets a thread allocation based on its size
# ================================

# ------------------------------
# Standard library imports
# ------------------------------
import os    # For creating directories
import csv   # For reading tab-delimited files
import yaml  # For writing YAML configuration files

# ------------------------------
# Paths to input/output files
# ------------------------------
# List of groups to include (one per line)
group_list_file = "list_group.txt"

# Precomputed counts per group (tab-delimited; headers: Tax_group, Group_size)
counts_file = "group_count.txt"

# Output YAML configuration
output_file = "config_group_threads.yaml"

# ------------------------------
# Read groups of interest
# ------------------------------
# Use a set for quick membership checks and ignore empty lines
with open(group_list_file) as f:
    groups_set = set(line.strip() for line in f if line.strip())

# Optional debug:
# print(f"Loaded {len(groups_set)} groups from {group_list_file}")

# ------------------------------
# Read counts and assign threads
# ------------------------------
group_threads = {}
with open(counts_file) as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        group = row["Tax_group"].strip()   # Column with group name
        count = int(row["Group_size"])     # Column with group size (integer)

        # Only include groups listed in group_list_file
        if group in groups_set:
            # Thread assignment policy:
            # - Minimum 6 threads
            # - Maximum 100 threads
            # - Otherwise, use the group size as the thread count
            threads = min(100, max(6, count))
            group_threads[group] = threads

            # Optional debug for the first few entries:
            # print(f"{group}: {count} -> {threads} threads")

# ------------------------------
# Write YAML configuration
# ------------------------------
# Sort groups alphabetically for readability
outdata = {"group_threads": dict(sorted(group_threads.items()))}

# Ensure output directory exists (no-op if already present)
os.makedirs("config", exist_ok=True)

# Write YAML file
with open(output_file, "w") as f:
    yaml.dump(outdata, f, sort_keys=False, default_flow_style=False)

# ------------------------------
# Confirm success
# ------------------------------
print(f"Wrote threads config for {len(group_threads)} groups to {output_file}")
