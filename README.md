# Neisseria genome data

Identify and download all Neissiera genus genome assemblies from [Blackwell et. al., 2021](https://www.biorxiv.org/content/10.1101/2021.03.02.433662v1.full) 
with N50 > 65kbp and < 1 contamination score.

This results in:

    Neisseria gonorrhoeae      1808
    Neisseria lactamica         900
    Neisseria meningitidis      704
    Neisseria subflava           93
    Neisseria polysaccharea      29
    Neisseria cinerea            15
    Neisseria elongata           13
    Neisseria zoodegmatis         9
    Neisseria sp. KEM232          8
    Neisseria mucosa              6
    Neisseria sicca               3
    Neisseria sp. 10022           1
    Neisseria chenwenguii         1

Then for each of these assemblies annotate them with RGI and Prokka (before compressing results).

## Running

Ensure all dependencies in `env.yaml` are installed (either manually or via `conda env create -f env.yaml`) then execute `get_data.sh`.

This will in turn download the original metadata from figshare, select genomes using `bin/get_assemblies.py`, and then execute `Snakefile` via snakemake to annotate the genomes.

