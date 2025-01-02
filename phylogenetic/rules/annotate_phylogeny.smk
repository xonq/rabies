"""
This part of the workflow creates additonal annotations for the phylogenetic tree.

See Augur's usage docs for these commands for more details.

"""

rule ancestral:
    """Reconstructing ancestral sequences and mutations"""
    input:
        tree = "results/tree.nwk",
        alignment = "results/aligned.fasta"
    output:
        node_data = "results/nt_muts.json"
    log:
        "logs/ancestral.txt",
    benchmark:
        "benchmarks/ancestral.txt"
    params:
        inference = config["ancestral"]["inference"],
        reference = config["files"]["reference"]
    shell:
        """
        augur ancestral \
            --tree {input.tree} \
            --alignment {input.alignment} \
            --output-node-data {output.node_data} \
            --inference {params.inference} \
            --root-sequence {params.reference} \
            2>&1 | tee {log}
        """

rule translate:
    """Translating amino acid sequences"""
    input:
        tree = "results/tree.nwk",
        node_data = "results/nt_muts.json",
        reference = config["files"]["reference"]
    output:
        node_data = "results/aa_muts.json"
    log:
        "logs/translate.txt",
    benchmark:
        "benchmarks/translate.txt"
    shell:
        """
        augur translate \
            --tree {input.tree} \
            --ancestral-sequences {input.node_data} \
            --reference-sequence {input.reference} \
            --output {output.node_data} \
            2>&1 | tee {log}
        """

rule clades:
    input:
        tree = "results/tree.nwk",
        nt_muts = "results/nt_muts.json",
        aa_muts = "results/aa_muts.json",
        clade_defs = config["files"]["clades"]
    output:
        clades = "results/clades.json"
    shell:
        """
        augur clades \
            --tree {input.tree} \
            --mutations {input.nt_muts} {input.aa_muts} \
            --clades {input.clade_defs} \
            --output {output.clades}
        """

rule add_year_metadata:
    input:
        metadata = "data/metadata.tsv",
    params:
        strain_id = config["strain_id_field"],
    output:
        node_data = "results/year.json"
    run:
        from augur.io import read_metadata
        import json
        m = read_metadata(input.metadata, id_columns=[params.strain_id])
        nodes = {name: {'year': date.split('-')[0]} for name,date in zip(m.index, m['date']) if date and not date.startswith('X')}
        with open(output.node_data, 'w') as fh:
            json.dump({"nodes": nodes}, fh)
