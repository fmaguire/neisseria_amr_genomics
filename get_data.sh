#!/bin/bash
set -euo pipefail

# all data from https://www.biorxiv.org/content/10.1101/2021.03.02.433662v1.full
mkdir -p original_metadata
wget -O original_metadata/Supplementary_File4_qc_661k.txt.gz https://figshare.com/ndownloader/files/26578601
gunzip original_metadata/Supplementary_File4_qc_661k.txt.gz
wget -O original_metadata/Supplementary_File2_taxid_lineage_661K.txt https://figshare.com/ndownloader/files/26578592
wget -O original_metadata/checklist.chk http://ftp.ebi.ac.uk/pub/databases/ENA2018-bacteria-661k/checklist.chk
wget -O original_metadata/sampleid_assembly_paths.txt http://ftp.ebi.ac.uk/pub/databases/ENA2018-bacteria-661k/sampleid_assembly_paths.txt

python bin/get_assemblies.py

snakemake --cores 11
