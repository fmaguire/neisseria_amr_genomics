
#IDS = ['SAMD00099400', 'SAMD00105892']
IDS, = glob_wildcards("neisseria_assemblies/{id}.contigs.fa.gz")

rule all:
    input:
        expand("annotation/{id}/rgi/{id}_rgi.txt", id=IDS),
        expand("annotation/{id}/prokka/{id}.gbk", id=IDS),
        expand("annotation/compressed/{id}.tar.gz", id=IDS)

rule rgi:
    input:
        "neisseria_assemblies/{id}.contigs.fa.gz"
    output:
        "annotation/{id}/rgi/{id}_rgi.txt"
    params:
        prefix = "annotation/{id}/rgi/{id}_rgi"
    log:
        "annotation/{id}/rgi/rgi.log"
    shell:
        """
        rgi main --clean --num_threads 1 --input_sequence {input} --output {params.prefix} --alignment_tool diamond --input_type contig 2> {log}
        """

rule prokka:
    #container:
    #    "docker://staphb/prokka"
    input:
        "neisseria_assemblies/{id}.contigs.fa.gz"
    output:
        "annotation/{id}/prokka/{id}.gbk"
    params:
        prefix = "annotation/{id}/prokka",
        name = "{id}",
        unzipped = "neisseria_assemblies/{id}.contigs.fa"
    log: 
        "annotation/{id}/prokka/prokka.log"
    shell:
        """
        zcat {input} > {params.unzipped}
        prokka --cpus 1 --force --outdir {params.prefix} --prefix {params.name} --usegenus --genus Neisseria --kingdom Bacteria --gram neg {params.unzipped} 2> {log}
        rm {params.unzipped}
        """


rule compress:
    input:
        "annotation/{id}/prokka/{id}.gbk",
        "annotation/{id}/rgi/{id}_rgi.txt"
    output:
        "annotation/compressed/{id}.tar.gz"
    params:
        prefix = "annotation/{id}"
    shell:
        """
        tar zcf {output} {params.prefix} 
        """
